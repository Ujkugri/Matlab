function varargout = worstcase(mySystem,tUser,options)
%WORSTCASE  Finds input that maximizes the induced gain of a nonlinear system.
%
%   [T,X,Y,U] = WORSTCASE(SYS,T)  Finds the input that maximizes the
%   induced L2-to-L2 gain of the system by simulating at the time points
%   specified in T. Using this syntax, SYS may be a POLYSYS object, a
%   Simulink model, or an m-file s-function. If SYS is a Simulink model,
%   the time vector T is used, rather than the model's configuration
%   parameters.
%
%   [T,X,Y,U] = WORSTCASE(SYS)  Finds the input that maximizes the induced
%   gain of the system over the time interval specified in the Simulink
%   model SYS.
%     
%   [T,X,Y,U] = WORSTCASE(SYS,T,OPT)  where OPT is a WCOPTIONS object.
%   Maximizes the induced gain based on the options specified by OPT. See
%   WCOPTIONS for a list of available options.
%
%   [T,X,Y,U,OBJ] = WORSTCASE(...)  same as above except the value of the
%   objective achieved by the worstcase input U is returned as OBJ.  If the
%   objective is L2-to-L2, then OBJ is the L2-norm of Y.  If the objective
%   is L2-to-LInfinity, then OBJ is the maximum (over time) of y(t)'*y(t).
%   If the objective is L2-to-Final, OBJ is the value of
%   x(T(end))'*P*x(T(end)), where P is the matrix specified in the COST
%   property of the WCOPTIONS object.  The default value for P is the
%   identity matrix.
%     
%   [T,X,Y,U,OBJ,DATASTRUCT] = WORSTCASE(...)  Same as above except the
%   structure DATASTRUCT contains the time, input, output, and state
%   vectors for each iteration of the power algorithm.  For example,
%   DATASTRUCT(i).input is the input vector associated with the ith
%   iteration.
%
%   This routine is based on the ideas presented in
%
%   J. Tierno, R. Murray, and J. C. Doyle. "An efficient algorithm for
%      performance analysis of nonlinear control systems."  Proc. of the
%      1995 American Control Conf., pp. 2717-2721.
%
%   See also WCOPTIONS.

%% Determine which kind of system the user specified
[mySystem,systemType] = local_getSystemType(mySystem);

%% Handle user-specified time vector
if nargin > 1
    isValidTimeVec = isnumeric(tUser)  &&  (length(tUser) > 1);
    if ~isValidTimeVec
        error('Time vector must be an array of the form T = [T0,TF] or T = [T0,T1,...,TF].');
    end
else
    if systemType == 'model'
        warning off
        [t,x,y] = sim(mySystem);
        warning on
        tUser = [t(1);t(end)];
    else
        error('You must specify a time vector.')
    end
end

%%  Handle user-specified options
if (nargin > 2)  &&  ~isempty(options)
    if isa(options,'wcoptions')
        uncertain = ~isempty(options.UncertainParamRange);
    else
        error('Options must be wcoptions object.')
    end
else
    % Use default options
    uncertain = false;
    options = wcoptions();
end

%% Handle display options
if isequal(options.PlotProgress,'plot')
    myWatcher = watchwindow;
else
    myWatcher = [];
end

%% Use time vector to create initial input vector in options
options = validateInitialInput(options,tUser);

%% Choose which worstcase solver to use
if length(tUser) > 2
    % Fixed step algorithms
    if uncertain
      if isequal(systemType,'polysys')
        error('Uncertain polysys models not supported.')
      else
        wcsolver = @uwcfixstep;
      end
     
    else
        wcsolver = @wcfixstep;
    end
else
  error('Time vector must contain more than two points.')
%     % Variable step algorithms
%     if uncertain
%         error('Uncertain models must have a fully specified time vector')
%     else
%         wcsolver = @wcvarstep;
%     end
end

%% Call worstcase solver with desired number of output arguments
if nargout > 0
    varargout = cell(nargout,1);
    [varargout{:}] = feval(wcsolver,mySystem,tUser(:),options,myWatcher);
else
    feval(wcsolver,mySystem,tUser(:),options,myWatcher);
end




%% Utility function that determines system type
function [mySystem,systemType] = local_getSystemType(mySystem)

if isa(mySystem,'polysys')
    systemType = 'polysys';
    return;
end

% Get function handle
if isa(mySystem,'char')
    fHandle = str2func(mySystem);
elseif isa(mySystem,'function_handle')
    fHandle = mySystem;
else
    error('System must be specified as a function handle or a string corresponding to the name of an m-file or Simulink model.');
end

% Get file extension
functionInfo = functions(fHandle);
splitFilename = regexpi(functionInfo.file,'\w*','match');
if isempty(splitFilename)
    extension = '';
else
    extension = lower(splitFilename{end});
end

% Determine system type from file extension
if isequal(extension,'mdl')
    systemType = 'model';
    mySystem = func2str(fHandle);
elseif isequal(extension,'m')
    systemType = 'sfunc';
    mySystem = fHandle;
else
    error(['No Simulink model or m-file named ',func2str(fHandle),' was found.']);
end
