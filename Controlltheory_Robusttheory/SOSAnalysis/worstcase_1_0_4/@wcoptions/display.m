function display(obj)

getProps = pvget(obj,'getProps');

% Display 'gettable' properties and current values
for k = 1:length(getProps)
    thisProp = getProps{k};
    value = pvget(obj,thisProp);
    if ischar(value)
        if length(value) <= 30
            rhsString = [' = ''',value,''''];
        else
            % String too long to display
            rhsString = [': string'];
        end
    elseif isnumeric(value)
        if isscalar(value) || isempty(value)
            % Display scalars
            rhsString = [' = ',num2str(value)];
        elseif ndims(value) == 2 && size(value,1) == 1 && size(value,2) <= 3
            % Display vectors
            rhsString = [' = [ ',num2str(value),' ]'];
        else
            % Array to big...display size and class only
            className = class(value);
            rhsString = [' = [ ('];
            for idim = 1:ndims(value)
                rhsString = [rhsString,num2str(size(value,idim))];
                if idim < ndims(value)
                    rhsString = [rhsString,' by '];
                end
            end
            rhsString = [rhsString,') ',className,' ]'];
        end
    elseif isa(value,'function_handle')
        rhsString = [' = @',func2str(value)];
    else
        % Just display class for everything else
        className = class(value);
        rhsString = [': ',className];
    end
    % Display this property-value pair
    disp(['        ',thisProp,rhsString])
end