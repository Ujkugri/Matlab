function W = subsasgn(W,ref,value)

if strcmp(ref(1).type,'.')
    property = ref(1).subs;
    if length(ref) == 1
        W = set(W,property,value);
    else
        propValue = get(W,property);
        newRef = ref(2:end);
        propValue = subsasgn(propValue,newRef,value);
        W = set(W,property,propValue);
    end
   
else
    error('This type of subscript assignment is not supported for wcoptions class.')
end