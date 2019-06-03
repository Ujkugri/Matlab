% Clearprocess
clc;    % Clear the command window.
clearvars;
close all;  % Close all figures (except those of imtool.)
workspace;  % Make sure the workspace panel is showing.
fontSize = 20;
format compact;
 
% Ask user for a number of steps to take.

prompt = {'Enter the number of steps to take: ','Enter the lenght of the Road: ','Enter the width of the Road: '};
titleBar = 'Enter an integer value';
defaultans = {'20','10','5'};
answer = inputdlg(prompt,titleBar,1,defaultans);

if isempty(answer),return, end% Bail out if they clicked Cancel.
integerstepValue = round(str2double(cell2mat(answer(1))));
integerlenghtValue = round(str2double(cell2mat(answer(2))));
integerwidthValue = round(str2double(cell2mat(answer(3))));
% Check for a valid integer.
if isnan(integerstepValue)
    % They entered a character, symbols, or something else not allowed.
    uiwait(errordlg('Stop being stupid, stupid! I said it had to be an integer.')),return
end
if isnan(integerlenghtValue)
    % They entered a character, symbols, or something else not allowed.
    uiwait(errordlg('Stop being stupid, stupid! I said it had to be an integer.')),return
end
if isnan(integerwidthValue)
    % They entered a character, symbols, or something else not allowed.
    uiwait(errordlg('Stop being stupid, stupid! I said it had to be an integer.')),return
end


numberOfSteps = integerstepValue;
deltax = integerlenghtValue*rand(numberOfSteps);
deltay = integerwidthValue*rand(numberOfSteps);
xy = zeros(numberOfSteps,2);


for step = 2 : numberOfSteps
    
    if xy(step,1) <= (integerlenghtValue-1)
        % Walk in the x direction.
        xy(step, 1) = xy(step, 1) + deltax(step);	
        % Walk in the y direction.
        xy(step, 2) = xy(step, 2) + deltay(step);
    end

    
    if xy(step,1) > (integerlenghtValue-1) && xy(step,2) < ((integerwidthValue/2) +1) && ((integerwidthValue/2) -1) < xy(step,2)     
        % Walk in the x direction.
        xy(step+1, 1) = integerlenghtValue;	
        % Walk in the y direction.
        xy(step+1, 2) = integerwidthValue/2;
    end

    % Now plot the walk so far.
    xCoords = xy(1:step, 1);
    yCoords = xy(1:step, 2);
    plot(xCoords, yCoords, 'bo-.', 'LineWidth', 1);
    hold on;
    textLabel = sprintf('%d', step);
    text(xCoords(end), yCoords(end), textLabel, 'fontSize', fontSize);
    
    if (sum((xy(step,:)-[ integerlenghtValue,integerwidthValue/2 ]).^2) < 1e-3)
        break
    end

end  



% Mark the first point in red.
hold on;
plot(xy(1,1), xy(1,2), 'rs', 'LineWidth', 2, 'MarkerSize', 5);
textLabel = '1';
text(xy(1,1), xy(1,2), textLabel, 'fontSize', fontSize);
grid on;


% Mark the last point in red.
plot(xCoords(end), yCoords(end), 'ms', 'LineWidth', 2, 'MarkerSize', 5);
title('Random Walk', 'FontSize', fontSize);
xlabel('X', 'FontSize', fontSize);
ylabel('Y', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);


% Calculate the distance from the origin.
distanceFromOrigin = hypot(xCoords(end), yCoords(end));
message = sprintf('Done with demo!\nDistance of endpoint from origin = %.3f', distanceFromOrigin);
msgbox(message);