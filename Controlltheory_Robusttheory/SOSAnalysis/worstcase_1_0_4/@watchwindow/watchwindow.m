function W = watchwindow(titleString)
% WATCHWINDOW  Used by WORSTCASE to display current progress.
%       
%   See also WORSTCASE


% Create a figure
W.figure = figure(...
        'WindowStyle','Docked',...              
        'KeyPressFcn',{@LOCAL_keypressfcn},...    
        'Interruptible','off'); 
% Store terminate variable to allow user to quit
% (Changed by keypressfcn)
setappdata(W.figure,'terminate',false);

% Create a set of axes
W.axes = axes('NextPlot','Add');
    xlabel('Time')
    ylabel('Input')

% Create a plot title
if nargin > 0
    W.title = title(titleString);
else
    W.title = title('');
end

% This field stores the most recently plotted line
W.line = [];

% Create an object from this structure
W = class(W,'watchwindow');


function [] = LOCAL_keypressfcn(myFigure,event)
if strncmpi(event.Character,'q',1)  && ishandle(myFigure)
    setappdata(myFigure,'terminate',true);
    disp('Termination requested.  Finishing iteration and closing model...')
    drawnow;
end 
