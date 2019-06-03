function value = subsref(opt,S)

if strcmp(S(1).type,'.')
    property = S(1).subs;
    value = get(opt,property);
    if length(S) > 1
        newRef = S(2:end);
        value = subsref(value,newRef);
    end
else
    error('This type of subscript referencing is not supported for wcoptions class.')
end
        