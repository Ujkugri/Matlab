function [t,x,y,u,allData] = wcseparate(linearSystem,phiFcn,dphiFcn,phiSizes,t,x0,varargin)
%[t,x,y,u,allData] = wcseparate(linearSystem,phiFcn,dphiFcn,phiSizes,t,x0,varargin)

warning('This code depends on the nonlinearity being wrapped around the bottom')

% See if user specified options
if length(varargin) > 0
    if isa(varargin{1},'wcoptions')
        options = varargin{1};
    else
        error('Options must be a wcoptions object')
    end
else
    % Create default options;
    options = wcoptions;
end

% Get relevant options
u = get(options,'InitialInput');
maxIter = get(options,'MaxIter');
objective = get(options,'Objective');
plotProgress = get(options,'PlotProgress');
R = get(options,'R');
tol = get(options,'Tol');
solverRelTol = get(options,'SolverRelTol');
solverAbsTol = get(options,'SolverAbsTol');
solverOptions = odeset('RelTol',solverRelTol,'AbsTol',solverAbsTol);

% Create a watch window
if plotProgress
    myWatcher = watchwindow('');
end

% Unpack linear system
if isa(linearSystem,'ss')  || isstruct(linearSystem)
    A = linearSystem.A;
    B = linearSystem.B;
    C = linearSystem.C;
    D = linearSystem.D;
else
    error('Linear portion of the system must be a ''ss'' or struct with fields A,B,C,D')
end
    
% Partition system matrices to separate nonlinear portion
phiOut = phiSizes(1);
phiIn = phiSizes(2);
B1 = B( :, 1:phiOut );
B2 = B( :, phiOut+1:end );
C1 = C( 1:phiIn, : );
C2 = C( phiIn+1:end, : );
D11 = D( 1:phiIn, 1:phiOut );
D21 = D( phiIn+1:end, 1:phiOut );
D12 = D( 1:phiIn, phiOut+1:end );
D22 = D( phiIn+1:end, phiOut+1:end );
if ~isequal(D22,zeros(size(D22)))
    error('Output of nonlinear portion has direct feedthrough to its input.')
end

% Get sizes of the linear portion
nStates  = size(A,1);
nInputs  = size(B1,2);
nOutputs = size(C1,1);
nPoints  = length(t);

% Preallocate memory for linear cosystem
cosysA = zeros(nStates,nStates, nPoints);
cosysB = zeros(nStates,nOutputs,nPoints);
cosysC = zeros(nInputs,nStates, nPoints);
cosysD = zeros(nInputs,nOutputs,nPoints);

% Generate initial input vector
if ischar(u)
    u = feval(u,nPoints,nInputs);
elseif length(u) ~= nPoints
    error('Initial input vector must be the same length as the time vector')
end    
u = u*sqrt(R)/get2norm(u,t);

uChange = tol+1;
iter = 1;
while (uChange > tol)  &&  (iter <= maxIter)
    
    % Simulate the system (see nested_odefcn below)
    [tForward,x] = ode15s(@nested_odefcn,t,x0,solverOptions);
   
    % Get system outputs and calculate cosystem
    y = zeros(nOutputs,nPoints);
    for i = 1:nPoints
        % Calculate system output
        phiArg = C2*x(i,:)' + D21*u(i,:)';
        thisPhi = feval(phiFcn,phiArg);
        y(:,i) = C1*x(i,:)' + D11*u(i,:)' + D12*thisPhi;
        
        % Calculate partial derivatives
        dphi = feval(dphiFcn,phiArg);
        dfdx = A + B2*dphi*C2;
        dfdu = B1 + B2*dphi*D21;
        dgdx = C1 + D12*dphi*C2;
        dgdu = D11 + D12*dphi*D21;
        
        % Build linearized cosystem backward in time
        iBackward = nPoints-i+1;
        cosysA(1:nStates,1:nStates, iBackward) = dfdx';
        cosysC(1:nInputs,1:nStates, iBackward) = dfdu';
        if strcmpi(objective,'L2')
            cosysB(1:nStates,1:nOutputs,iBackward) = 2*dgdx';
            cosysD(1:nInputs,1:nOutputs,iBackward) = 2*dgdu';
        end
    end
    y = y';
    
    % Get initial conditions
    if strcmpi(objective,'L2')
        lambda0 = zeros(nStates,1);
    else
        lambda0 = 2*dgdx'*y(end,:)';
    end
    
    % Store the data
    allData(iter).time = tForward;
    allData(iter).input = u;
    allData(iter).states = x;
    allData(iter).output = y;
        
    % Display current progress
    if plotProgress
        % Calculate the current value of the 'objective'
        switch objective
            case 'L2'
                y2norm = get2norm(y,tForward); % Calculate objective
                titleString = ['Sequence of Inputs (',num2str(iter),': |y|_2 = ',num2str(y2norm),')'];
            case 'LInfinity'
                for k = 1:length(t)
                    yTy(k) = y(k,:)*y(k,:)';
                end
                titleString = ['Sequence of Inputs (',num2str(iter),': max(y^Ty) = ',num2str(max(yTy)),')'];
            otherwise
                error('Invalid objective')
        end
        % Update watch window with current data
        myWatcher = updatewatch(myWatcher,t,u,titleString);
    end

    % See if user terminated.
    if plotProgress && hasterminated(myWatcher)
        break;
    end
    
    % Simulate cosystem
    [tBack,lambda,gamma] = LTVsim(cosysA,cosysB,cosysC,cosysD,t,lambda0,options,flipud(y),t);
        
    % Apply alignment conditions
    uNext = gamma * sqrt(R) / get2norm(gamma,tBack);
    uNext = flipud(uNext);
    
    % Compare inputs before overwriting
    uChange = get2norm(uNext-u,t);  
    u = uNext;
    iter = iter + 1;
    
end % End while loop

% Shutdown the watch window's interactive features
if plotProgress
    myWatcher = closewatch( myWatcher );
end

    % Nested function called by ode45
    % (has access to wcseparate workspace)
    function dx = nested_odefcn(thisT,thisX)
        thisU = locate(thisT,t,u);
        phiArg = C2*thisX + D21*thisU';
        thisPhi = feval(phiFcn,phiArg);
        dx = A*thisX + B1*thisU' + B2*thisPhi;
    end

end % end wcseparate function