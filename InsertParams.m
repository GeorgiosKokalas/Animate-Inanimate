% Function called by: StartUp.m
% Role of function is to generate all user-inserted parameters 
% This means that any value that can be safely changed by the user should be done here. 
% Input: None 
% Return Values: 
%   - params (struct that contains all inserted parameters)

function params = InsertParams(Patient_Name)
    params = ParameterClass(Patient_Name);
    load('colors.mat','color_list');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % User defined variables below %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % params.screen - Determines the color of the screen the participant will be playing in 
    params.screen.color = color_list.black;      % RGBA - Determines the color of the screen
    
    % Optional parameters, best left untouched.
    params.screen.screen = max(Screen('Screens')); % Select the Screen you want to use.
    params.screen.start_point = [0, 0];            % Vector - Determines the upmost left corner of the screen. [0,0] is the default 
    params.screen.window_height = 0;               % Integer - Determines the Height of the window. 0 will make the program FullScreen 
    params.screen.window_width = 0;                % Integer - Determines the Width of the window. 0 will make the program FullScreen
    
    % Text parameters
    % Text Font Parameters - Determine the font used in the experiment
    params.text.font.default = 'Helvetica';    % String - Determines the type of font used in the experiment

    % Text Size parameters - Determine the size of text in given situations
    params.text.size.default = 40;     % Natural Number - Determines the default text size
    params.text.size.present = 100;    % Natural Number - Determines the text size for the word shown for a full second
    params.text.size.choices = 50;     % Natural Number - Determines the text size for the words Animate/Inanimate
    
    % Trial Parameters
    params.trial.num = 1;                 % Natural Number - Determines the number of trials per block
    params.trial.ShowIntro = true;        % Logical - Determines whether or not the introduction will be shown
    params.trial.PresentDurS = 1;         % Positive Number - Determines for how long the presented word will be visible for
    params.trial.ChoiceDurS = 0.4;        % Positive Number - Determines for how long the presented word will be visible for
    params.trial.photoDiodeDurS = 0.25;   % Positive Number - Determines how long the photodiode will be shown for


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % End of Settings %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ValidateParams(params);
end

