function W = updatewatch(W,t,u,titleString)

% Define constants (RGB colors)
colorGreen  = [0 1 0];
colorBlue   = [0 0 1];

% Make sure this figure is active
figure(W.figure);

% Make sure the X-Limits are correct
if isempty(W.line)
    set(W.axes,'XLim',[t(1),t(end)]);
else
    % Make the previous line green
    set(W.line,'color',colorGreen);
end

% Plot the current input in Blue
W.line = plot(t,u,'color',colorBlue);

% Display the objective in the title
set(W.title,'String',titleString);
drawnow;