function [t,xWorst,yWorst,uWorst,lastCost,allData] = wcfixstep(mySystem,t,options,myWatcher)
%WCFIXSTEP  Utility function used by WORSTCASE.
%
%   See also WORSTCASE.

%% Get general options
if ischar(mySystem)
   systemType = 'model';
   warning off
elseif isa(mySystem,'polysys')
   systemType = 'polysys';
else
   systemType = 'sfunc';
end

if nargout == 5
   saveAllData = true;
else
   saveAllData = false;
end

if isequal(systemType,'polysys')
   [fFunc,gFunc,AFunc,BFunc,CFunc,DFunc] = function_handle(mySystem);
   partialsFunc = {AFunc,BFunc,CFunc,DFunc};
else
   partialsFunc = get(options,'PartialsFunc');
end
objective = get(options,'Objective');
perturbation = get(options,'PerturbationSize');
plotProgress = get(options,'PlotProgress');
costMat = get(options,'FinalCostMatrix');

%% Get ODE solver and options
odeSolver  = get(options,'ODESolver');
odeOptions = get(options,'ODEOptions');

%% Get size of each signal
[nStates,nInputs,nOutputs] = wcgetsizes(mySystem);
nPoints = length(t);

%% Preallocate memory for linear cosystem
A = zeros(nStates,nStates, nPoints);
B = zeros(nStates,nOutputs,nPoints);
C = zeros(nInputs,nStates, nPoints);
D = zeros(nInputs,nOutputs,nPoints);

%% Handle initial input vector
u = get(options,'InitialInput');
inputNorm = get(options,'InputL2Norm');
if size(u,2) < nInputs
   u = repmat(u,1,nInputs);
end
uNext = inputNorm * u/get2norm(u,t);

%% Main loop
tol = get(options,'Tol');
maxIter = get(options,'MaxIter');
uChange = tol + 1;
iter = 1;
lastCost = -Inf;
while (uChange > tol)  &&  (iter <= maxIter)
   
   
   %% Simulate the system
   u = uNext;
   if isequal(systemType,'model')
      [tForward,x,y] = sim(mySystem,t,[],[t u]);
   elseif isequal(systemType,'polysys')
      x0 = zeros(nStates,1);
      [tForward,x,y] = sim(mySystem,t,x0,[t u],odeOptions,odeSolver);
   else
      [sys,x0] = feval(mySystem,[],[],[],0); % Get initial conditions
      if isequal(odeSolver,'ode45')
         [tForward,x,y] = ode45sfunc(mySystem,t,x0,odeOptions,[t u]);
      elseif isequal(odeSolver,'ode15s')
         [tForward,x,y] = ode15ssfunc(mySystem,t,x0,odeOptions,[t u]);
      else
         error('This ODE solver is not supported for s-function systems.')
      end
   end
   if tForward(end)<t(end)
      warning('Worstcase:ODEStall',['Worstcase solver was unable to simulate for the entire time horizon.',...
         '  Returning ''worst'' input found so far...']);
      return;
   end
   
   %% Store all data for this iteration
   switch objective
      case 'L2'
         thisCost = get2norm(y,tForward);
      case 'LInfinity'
         for k = 1:length(t)
            yTy(k) = y(k,:)*y(k,:)';
         end
         thisCost = max(yTy);
      case 'Final'
         thisCost = x(end,:)*costMat*x(end,:)';
         interCost = zeros(nPoints,1);
         for k = 1:nPoints
            interCost(k) = x(k,:)*costMat*x(k,:)';
         end
         [maxCost,peakTime] = max(interCost);
         if maxCost > thisCost
            thisCost = maxCost;
            u = [zeros(nPoints-peakTime,nInputs);u(1:peakTime,:)];
            if isequal(systemType,'model')
               [tForward,x,y] = sim(mySystem,t,[],[t u]);
            elseif isequal(systemType,'polysys')
               x0 = zeros(nStates,1);
               [tForward,x,y] = sim(mySystem,t,x0,[t u],odeOptions,odeSolver);
            else
               [sys,x0] = feval(mySystem,[],[],[],0); % Get initial conditions
               if isequal(odeSolver,'ode45')
                  [tForward,x,y] = ode45sfunc(mySystem,t,x0,odeOptions,[t u]);
               elseif isequal(odeSolver,'ode15s')
                  [tForward,x,y] = ode15ssfunc(mySystem,t,x0,odeOptions,[t u]);
               else
                  error('Invalid ODE solver found in wcoptions object.')
               end
            end
         end
   end
   
   if saveAllData
      allData(iter).time   = tForward;
      allData(iter).input  = u;
      allData(iter).states = x;
      allData(iter).output = y;
   end
   
   
   %% Display current progress & check for termination
   if not(isequal(plotProgress,'none'))
      switch objective
         case 'L2'
            costString = ['|y|_2 = ',num2str(thisCost)];
         case 'LInfinity'
            costString = ['max(y^Ty) = ',num2str(thisCost)];
         case 'Final'
            costString = ['x''Px = ',num2str(thisCost)];
      end
      
      if isequal(plotProgress,'text')
         disp(['||u|| = ',num2str(inputNorm),',  Iter = ',num2str(iter),...
            ',  uChange = ',num2str(uChange),',  ',costString]);
      else
         titleString = ['Sequence of Inputs (',num2str(iter),': ',costString];
         myWatcher = updatewatch(myWatcher,t,uNext,titleString);
         if hasterminated(myWatcher)
            break;
         end
      end
   end
   
   %% Calculate 'linearized' cosystem at each point in time
   for j = 1:nPoints
      
      % Get the linearized system
      if isequal(systemType,'polysys')
         dfdx = feval(partialsFunc{1},tForward(j),x(j,:)',u(j,:)');
         dfdu = feval(partialsFunc{2},tForward(j),x(j,:)',u(j,:)');
         dgdx = feval(partialsFunc{3},tForward(j),x(j,:)',u(j,:)');
         dgdu = feval(partialsFunc{4},tForward(j),x(j,:)',u(j,:)');
      elseif isempty(partialsFunc)
         % Numerically approximate partials
         linParameters = [ perturbation; tForward(j); 0 ];
         if isequal(systemType,'model')
            [dfdx,dfdu,dgdx,dgdu] = linmod(mySystem,x(j,:),u(j,:),linParameters);
         else
            [dfdx,dfdu,dgdx,dgdu] = linsfunc(mySystem,x(j,:),u(j,:),linParameters);
         end
      else
         % Explicitly calculate partials
         [dfdx,dfdu,dgdx,dgdu] = feval(partialsFunc,tForward(j),x(j,:),u(j,:));
      end
      
      % Calculate the cosystem (backward in time)
      jBackward = nPoints-j+1;
      A(1:nStates,1:nStates, jBackward) = dfdx';
      C(1:nInputs,1:nStates, jBackward) = dfdu';
      if isequal(objective,'L2')
         B(1:nStates,1:nOutputs,jBackward) = 2*dgdx';
         D(1:nInputs,1:nOutputs,jBackward) = 2*dgdu';
      end
      
   end
   
   %% Get initial conditions
   if isequal(objective,'L2')
      lambda0 = zeros(nStates,1);
   elseif isequal(objective,'Final')
      lambda0 = costMat*x(end,:)';
   else
      lambda0 = 2*dgdx'*y(end,:)';
   end
   
   %% Simulate cosystem backward in time
   if isequal(objective,'Final')
      cosysInput = [t, zeros(size(y)) ];
   else
      cosysInput = [t,flipud(y)];
   end
   [tBack,lambda,gamma] = LTVsim(A,B,C,D,t,lambda0,cosysInput,odeSolver,odeOptions);
   
   %% Apply alignment conditions
   gammaNorm = get2norm(gamma,tBack);
   if gammaNorm < eps
      % Avoid divide by zero
      uNext = zeros(size(gamma));
   else
      uNext = inputNorm * gamma / gammaNorm;
      uNext = flipud(uNext);
   end
   
   %% Make sure that we remember the best iteration.
   if iter == 1 || thisCost > lastCost
      %         disp(['Improved: ',num2str(lastCost),'<',num2str(thisCost)])
      xWorst = x;
      yWorst = y;
      uWorst = u;
      lastCost = thisCost;
   end
   
   %% Compare inputs before overwriting
   
   uChange1 = get2norm(uNext-u,t);
   uChange2 = get2norm(uNext+u,t);  % In case it just flips sign
   uChange = min(uChange1,uChange2);
   iter = iter + 1;
   
end % End while loop



%% Shutdown the watch window's interactive features
if isequal(plotProgress,'plot')
   myWatcher = closewatch( myWatcher );
end

warning on
