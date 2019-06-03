function reply = hasterminated(W)

% Get the terminate signal from figure's appdata
if ishandle(W.figure)
    reply = getappdata(W.figure,'terminate');
end