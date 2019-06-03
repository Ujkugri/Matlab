function options = validateInitialInput(options,t);

if ischar(options.InitialInput)
    % Create the input corresponding to the string
    switch options.InitialInput
        case 'ones'
            u0 = ones(length(t),1);
        case 'rand'
            u0 = rand(length(t),1);
        case 'randn'
            u0 = randn(length(t),1);
        otherwise
            error('InitialInput set to invalid string')
    end
elseif isnumeric(options.InitialInput) && ndims(options.InitialInput) == 2
    % Make sure the input vector and time vector have the same dimensions
    sizeInput = size(options.InitialInput);
    longDim = find(sizeInput == length(t));
    if longDim == 1
        u0 = options.InitialInput;
    elseif longDim == 2
        u0 = options.InitialInput';
    else
        error('InitialInput vector must be the same length at the time vector')
    end
else
    error('Invalid initialInput')
end

% Scale the initial input
u0 = u0 * options.InputL2Norm / get2norm(u0,t);
options.InitialInput = u0;
