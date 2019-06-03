% Add paths to SOS analysis toolboxes
%

% Add multipoly

cm = computer;

if cm(1) == 'M' ||  cm(1)=='G'
    % Add multipoly
    addpath([pwd '/multipoly']);

    % Add my version of SOSTools
    addpath([pwd '/sosopt']);
    addpath([pwd '/sosopt/Demos']);

    % Add nonlinear analysis code
    addpath(genpath([pwd '/nlanal']));

    % Add polysys
    addpath([pwd '/polysystems_1_0_3'])
    addpath([pwd '/polysystems_1_0_3/demo'])

    % Add worstcase
    addpath([pwd '/worstcase_1_0_4'])
    addpath([pwd '/worstcase_1_0_4/demo'])
elseif cm(1) == 'P'
    % Add multipoly
    addpath([pwd '\multipoly']);

    % Add my version of SOSTools
    addpath([pwd '\sosopt']);
    addpath([pwd '\sosopt\Demos']);

    % Add nonlinear analysis code
    addpath(genpath([pwd '\nlanal']));
    
    % Add polysys
    addpath([pwd '\polysystems_1_0_3'])
    addpath([pwd '\polysystems_1_0_3\demo'])

    % Add worstcase
    addpath([pwd '\worstcase_1_0_4'])
    addpath([pwd '\worstcase_1_0_4\demo'])
end
    

