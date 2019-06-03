function reply = ismodel(wcsys)

if isequal(wcsys.Type,'model')
    reply = true;
else
    reply = false;
end