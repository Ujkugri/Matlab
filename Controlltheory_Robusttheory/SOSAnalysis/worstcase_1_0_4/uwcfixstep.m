function [t,x,y,input,allData] = uwcfixstep(mySystem,t,options,myWatcher)
% UWCFIXSTEP  Utility function used by WORSTCASE for uncertain systems.
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
deltaRange = get(options,'UncertainParamRange');

%% Get ODE solver and options
odeSolver  = get(options,'ODESolver');
odeOptions = get(options,'ODEOptions');

%% Get size of each signal
nDeltas = size(deltaRange,1);
[nStates,nTotalInputs,nOutputs] = wcgetsizes(mySystem);
nInputs = nTotalInputs - nDeltas;
nCostates = nStates + nDeltas;
nPoints = length(t);

%% Preallocate memory for linear cosystem
A = zeros(nCostates,nCostates, nPoints);
B = zeros(nCostates,nOutputs,nPoints);
C = zeros(nInputs,nCostates, nPoints);
D = zeros(nInputs,nOutputs,nPoints);

%% Handle initial inputs
u = get(options,'InitialInput');
R = get(options,'R');
if size(u,2) < nInputs
    u = repmat(u,1,nInputs);
end
uNext = u*sqrt(R)/get2norm(u,t);
deltaNext = sum(deltaRange,2)'/2;

%% Main loop
tol = get(options,'Tol');
maxIter = get(options,'MaxIter');
uChange = tol + 1;
deltaChange = tol+1;
iter = 1;
while (uChange > tol || deltaChange > tol)  &&  (iter <= maxIter)
    
%% Simulate the system
    u = uNext;
    delta = deltaNext;
    input = [ u, repmat(delta,nPoints,1) ];
    if ischar(mySystem)
        [tForward,x,y] = sim(mySystem,t,[],[t input]);
    else
        [sys,x0] = feval(mySystem,[],[],[],0); % Get initial conditions
        if isequal(odeSolver,@ode45)
            [tForward,x,y] = ode45sfunc(mySystem,t,x0,odeOptions,[t input]);
        elseif isequal(odeSolver,@ode15s)
            [tForward,x,y] = ode15ssfunc(mySystem,t,x0,odeOptions,[t input]);
        else
            error('Invalid ODE solver found in wcoptions object.')
        end
    end
    
%% Store the data
    if saveAllData
        allData(iter).time   = tForward;
        allData(iter).input  = input;
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
         myWatcher = updatewatch(myWatcher,t,uNext,titleString);
         if hasterminated(myWatcher)
             break;
         end
    end
    
%% Calculate a 'linearized' version of the cosystem
    for j = 1:nPoints
        
        % Get the linearized system
        if isempty(partialsFunc)
            % Numberically approximate partials
            linParameters = [ perturbation; tForward(j); 0 ];
            if isequal(systemType,'model')
                [dfdx,dfdin,dgdx,dgdin] = linmod(mySystem,x(j,:),input(j,:),linParameters);
            else
                [dfdx,dfdin,dgdx,dgdin] = linsfunc(mySystem,x(j,:),input(j,:),linParameters);
            end
        else
            [dfdx,dfdin,dgdx,dgdin] = feval(partialsFunc,tForward(j),x(j,:),input(j,:));
        end
        
        % Separate disturbance inputs from uncertain inputs
        dfdu = dfdin(1:nStates,1:nInputs);
        dfdd = dfdin(1:nStates,nInputs+1:end);
        dgdu = dgdin(1:nOutputs,1:nInputs);
        dgdd = dgdin(1:nOutputs,nInputs+1:end);

        % Calculate the cosystem (backward in time)
        jBackward = nPoints-j+1;
        A(1:nCostates,1:nCostates,jBackward) = [dfdx',zeros(nStates,nDeltas);...
                                                dfdd',zeros(nDeltas,nDeltas)];
        C(1:nInputs,1:nCostates,jBackward)   = [dfdu',zeros(nInputs,nDeltas)];
        if isequal(objective,'L2')
            B(1:nCostates,1:nOutputs,jBackward) = [2*dgdx';2*dgdd'];
            D(1:nInputs,1:nOutputs,jBackward)   =  2*dgdu';
        end
        
    end
    
    % Get initial conditions
    if isequal(objective,'L2')
        lambda0 = zeros(nStates+nDeltas,1);
    else
        lambda0 = [2*dgdx';2*dgdd']*y(end,:)';
    end
    
%% Simulate cosystem backward in time
    cosysInput = [t,flipud(y)];
    [tBack,lambda,gamma] = LTVsim(A,B,C,D,t,lambda0,cosysInput,odeSolver,odeOptions);
        
%% Apply alignment conditions
    gammaNorm = get2norm(gamma,tBack);
    if gammaNorm < eps
        % Avoid divide by zero
        uNext = zeros(size(gamma));
    else
        uNext = gamma * sqrt(R) / get2norm(gamma,tBack);
        uNext = flipud(uNext);
    end
    lambdaFinal = lambda(end,:);
    chi = delta + lambdaFinal(nStates+1:end);
    deltaNext = max(min(chi,deltaRange(:,2)'),deltaRange(:,1)');
    
%% Compare inputs before overwriting
    uChange1 = get2norm(uNext-u,t);
    uChange2 = get2norm(uNext+u,t); % In case it just flips sign
    uChange = min(uChange1,uChange2);
    deltaChange = sqrt(sum( (deltaNext-delta).^2 ));
    iter = iter + 1;
    
end % End while loop

%% Shutdown the watch window's interactive features
if plotProgress
    myWatcher = closewatch( myWatcher );
end

warning on