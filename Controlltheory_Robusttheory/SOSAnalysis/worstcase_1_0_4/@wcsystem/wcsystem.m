function wcsys = wcsystem(sys,varargin)

%% Get function handle
if isa(sys,'char')
    fHandle = str2func(sys);
elseif isa(sys,'function_handle')
    fHandle = sys;
else
    error('System must be specified as a function handle or a string corresponding to the name of an m-file or Simulink model.');
end

%% Get file extension
functionInfo = functions(fHandle);
splitFilename = regexpi(functionInfo.file,'\w*','match');
if isempty(splitFilename)
    extension = '';
else
    extension = lower(splitFilename{end});
end

%% Determine system type from file extension & Get system dimensions
if isequal(extension,'mdl')
    systemType = 'model';
    mySystem = func2str(fHandle);
    [sizeInfo,x0] = feval(mySystem);
elseif isequal(extension,'m')
    systemType = 'sfunc';
    mySystem = fHandle;
    [sizeInfo,x0] = feval(mySystem,[],[],[],0);
else
    error(['No Simulink model or m-file named ',func2str(fHandle),' was found.']);
end


%% Create Structure
wcsys.System = mySystem;
wcsys.Type = systemType;
wcsys.PartialsFunc = [];
wcsys.InitialState = x0;
wcsys.NStates  = sizeInfo(1);
wcsys.NOutputs = sizeInfo(3);
wcsys.NInputs  = sizeInfo(4);
wcsys.NUncertain = 0;
wcsys.UncertainParamRange = [];

wcsys = class(wcsys,'wcsystem');


%% Set any specified properties
if length(varargin) > 0
    wcsys = set(wcsys,varargin{:});
end