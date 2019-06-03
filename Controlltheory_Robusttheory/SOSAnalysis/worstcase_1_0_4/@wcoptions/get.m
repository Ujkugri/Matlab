function varargout = get(obj,varargin)

if length(varargin) == 0
    display(obj);
    return;  % Nothing more to do
end

% Try to get properties one at a time
getProps = pvget(obj,'getProps');
nProps = length(varargin);
for i = 1:nProps
    
    % Get this prop
    propertyName = varargin{i};
    if ~ischar(propertyName)
        error('Property names must be strings')
    end
    
    % Look for a match (ignoring case and incomplete names)
    nChars = length(propertyName);
    matches = strncmpi(propertyName,getProps,nChars);
    
    % Either set matching property or handle error
    if sum(matches) == 1
        varargout{i} = pvget(obj,getProps{matches});
    elseif sum(matches) == 0
        error('No such property found')
    elseif sum(matches) > 1
        error('Multiple matches found.  Use a more specific property name.')
    end

end