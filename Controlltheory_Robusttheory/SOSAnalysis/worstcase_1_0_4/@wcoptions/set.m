function varargout = set(obj,varargin)

% Get all user 'settable' properties
try
    setProps = pvget(obj,'setProps');
catch
    error('Private get method must have a list of properties that the user can set.  This list is given the property name ''setProps''.')
end

% Verify the number of input arguments
nPairs = length(varargin)/2;
if mod(nPairs,1) ~= 0
    error('Input arguments must be PropertyName/PropertyValue pairs');
elseif nPairs == 0
    setValues = pvget(obj,'setValues');
    for k = 1:length(setProps)
        disp(['        ',setProps{k},setValues{k}])
    end
    return;
end

% Try to set pairs one at a time
for i = 1:2:length(varargin)-1
    
    % Get this pair
    propertyName = varargin{i};
    if ischar(propertyName)
        propertyValue = varargin{i+1};
    else
        error('Property names must be strings')
    end
    
    % Look for a match (ignoring case and incomplete names)
    nChars = length(propertyName);
    matches = strncmpi(propertyName,setProps,nChars);
    
    % Either set matching property or handle error
    if sum(matches) == 1
        obj = pvset(obj,setProps{matches},propertyValue);
    elseif sum(matches) == 0
        error('No such property found')
    elseif sum(matches) > 1
        error('Multiple matches found.  Use a more specific property name.')
    end

end


varargout{1} = obj;