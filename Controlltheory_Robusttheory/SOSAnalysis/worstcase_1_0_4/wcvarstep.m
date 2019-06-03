function [tout,x,y,uout,allData] = wcvarstep(mySystem,tNext,options,myWatcher);
% WCVARSTEP  Utility function used by WORSTCASE.
%
% See also WORSTCASE.

%% Get general options
if ischar(mySystem)
    systemType = 'model';
    warning off
else
    systemType = 'sfunc';
end

if nargout == 5
    saveAllData = true;
else
    saveAllData = false;
end

partialsFunc = get(options,'PartialsFunc');
objective = get(options,'Objective');
perturbation = get(options,'PerturbationSize');
plotProgress = get(options,'PlotProgress');

%% Get ODE solver and options
odeSolver  = get(options,'ODESolver');
odeOptions = get(options,'ODEOptions');

%% Get size of each signal
[nStates,nInputs,nOutputs] = wcgetsizes(mySystem);

%% Create empty placeholders for cosystem data
A = []; B = []; C = []; D = [];

%% Handle initial input vector
u = get(options,'InitialInput');
R = get(options,'R');
if size(u,2) < nInputs
    u = repmat(u,1,nInputs);
end
uNext = u*sqrt(R)/get2norm(u,tNext);
   
%% Main loop
tol = get(options,'Tol');
maxIter = get(options,'MaxIter');
uChange = tol + 1;
iter = 1;
while (uChange > tol)  &&  (iter <= maxIter)
    
%% Simulate the system
    t = tNext;
    u = uNext;
    tSpan = [t(1),t(end)];    
    if isequal(systemType,'model')
        [tForward,x,y] = sim(mySystem,tSpan,[],[t u]);
    else
        [sys,x0] = feval(mySystem,[],[],[],0); % Get initial conditions
        if isequal(odeSolver,@ode45)
            [tForward,x,y] = ode45sfunc(mySystem,tSpan,x0,odeOptions,[t u]);
        elseif isequal(odeSolver,@ode15s)
            [tForward,x,y] = ode15ssfunc(mySystem,tSpan,x0,odeOptions,[t u]);
        else
            error('Invalid ODE solver found in wcoptions object.')
        end
    end
    
%% Store all data for this iteration
    if saveAllData
        allData(iter).time   = tForward;
        allData(iter).input  = u;
        allData(iter).states = x;
        allData(iter).output = y;
    end
    
%% Display current progress & check for termination
    if plotProgress
         switch objective
            case 'L2'
                y2norm = get2norm(y,tForward);
                titleString = ['Sequence of Inputs (',num2str(iter),': |y|_2 = ',num2str(y2norm),')'];
            case 'LInfinity'
                for k = 1:length(t)
                    yTy(k) = y(k,:)*y(k,:)';
                end
                titleString = ['Sequence of Inputs (',num2str(iter),': max(y^Ty) = ',num2str(max(yTy)),')'];
         end
         myWatcher = updatewatch(myWatcher,t,u,titleString);
         if hasterminated(myWatcher)
             break;
         end
    end

%% Reset A,B,C,D if length of tForward has changed
    nPoints = length(tForward);
    if size(A,3) ~= nPoints
        A = zeros(nStates,nStates, nPoints);
        B = zeros(nStates,nOutputs,nPoints);
        C = zeros(nInputs,nStates, nPoints);
        D = zeros(nInputs,nOutputs,nPoints);
    end
    
%% Calculate 'linearized' cosystem at each point in time    
    for j = 1:nPoints

        % Get the linearized system
        thisU = locate(tForward(j),t,u);
        if isempty(partialsFunc)
            % Numerically approximate partials
            linParameters = [ perturbation; tForward(j); 0 ];
            if isequal(systemType,'model')            
                [dfdx,dfdu,dgdx,dgdu] = linmod(mySystem,x(j,:),thisU,linParameters);
            else
                [dfdx,dfdu,dgdx,dgdu] = linsfunc(mySystem,x(j,:),thisU,linParameters);
            end
        else
            % Explicitly calculate partials
            [dfdx,dfdu,dgdx,dgdu] = feval(partialsFunc,tForward(j),x(j,:),thisU);
        end

        % Calculate the cosystem (backward in time)
        jBackward = nPoints-j+1;
        A(1:nStates,1:nStates, jBackward) = dfdx';
        C(1:nInputs,1:nStates, jBackward) = dfdu';
        if strcmpi(objective,'L2')
            B(1:nStates,1:nOutputs,jBackward) = 2*dgdx';
            D(1:nInputs,1:nOutputs,jBackward) = 2*dgdu';
        end

    end

    % Get initial conditions
    if strcmpi(objective,'L2')
        lambda0 = zeros(nStates,1);
    else
        lambda0 = 2*dgdx'*y(end,:)';
    end
    
    
%% Simulate cosystem backward in time
    yInput = flipud(y);
    tFlip = max(tForward) - flipud(tForward);
    iGood = find(diff(tFlip)>0);
    tFlip = tFlip(iGood);
    yInput = yInput(iGood,:);
    cosysInput = [tFlip,yInput];
    tFlipSpan = [tFlip(1),tFlip(end)];
    [tBack,lambda,gamma] = LTVsim(A,B,C,D,tFlipSpan,lambda0,cosysInput,odeSolver,odeOptions);
    
%% Apply alignment conditions
    gammaNorm = get2norm(gamma,tBack);
    if gammaNorm < eps
        % Avoid divide by zero
        uNext = zeros(size(tBack));
    else
        uNext = gamma * sqrt(R) / get2norm(gamma,tBack);
        uNext = flipud(uNext);
        tNext = max(tBack) - flipud(tBack);
    end
    
    uInterp = zeros(length(tNext),nInputs);
    for k = 1:length(tNext)
        uInterp(k,:) = locate(tNext(k),t,u);
    end
    
%% Compare inputs before overwriting
    uChange1 = get2norm(uNext-uInterp,tNext);
    uChange2 = get2norm(uNext+uInterp,tNext);
    uChange = min(uChange1,uChange2);
    iter = iter + 1;
    
end % End while loop


%% Shutdown the watch window's interactive features
if plotProgress
    myWatcher = closewatch( myWatcher );
end

%% Interpolate worstcase input to same time points as output
tout = tForward;
uout = zeros(length(tout),nInputs);
for i=1:length(tout)
    uout(i,:) = locate(tout(i),t,u);
end

warning on