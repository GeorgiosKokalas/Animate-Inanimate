%% DESCRIPTION
% Startup class. Defines the properties of the screen that will be used throughout the experiment.   
% Meant to be used as a member of the ParameterClass

%% CODE
classdef ScreenClass < handle  
    properties (Access = public)
        window  % Pointer - The pointer to the window handle
    end
    
    properties (SetAccess = private, GetAccess = public)
        % Screen Identifiers
        screen  % Positive Integer - Number of the screen to be used
        
        % Screen presentation parameters
        framerate   % Natural Number - The framerate for the screen in Hz
        bgColor     % RGBA - The RGB value of the screen when nothing is drawn
        
        % Window Dimensions in Pixels
        pixWidth    % Natural Number - The width of the window in Pixels
        pixHeight   % Natural Number - The height of the window in Pixels
        pixDims     % Natural Number - The dimensions of the window in Pixels
        pixCenter   % Natural Number - The center point of the window in Pixels
    end
    
    methods
        % CONSTRUCTOR
        % Input: None
        % Output: 
        %   - The class object
        function obj = ScreenClass()
            % Which screen to use
            obj.screen = max(Screen('Screens')); 
            obj.window = -1;                     % Placeholder

            % Screen presentation parameters
            obj.framerate = 60; 
            obj.bgColor = [100, 100, 100, 255];
            
            % Window Dimensions
            [obj.pixWidth, obj.pixHeight] = Screen('WindowSize', obj.screen);
            obj.pixDims = [obj.pixWidth, obj.pixHeight];
            obj.pixCenter = obj.pixDims/2;         
        end


        % OTHER METHODS
        % change_screen
        % function that changes the used screen to a different one (SHOULD BE CALLED ON STARTUP ONLY)    
        % Input:
        %   - NewScreenNum: which screen we want to change to
        % Output: None
        function change_screen(obj, NewScreenNum)
            % See if we should change the screen in the first place     
            shouldAbort = ~isscalar(NewScreenNum) || ...                % Do not engage if the value is not scalar
                          ~isnumeric(NewScreenNum) || ...               % Do not engage if we don't have a number
                          NewScreenNum > max(Screen('Screens')) || ...  % Do not change the screen number if it is too high
                          NewScreenNum < 0 || ...                       % Do not change the screen number if it is too low
                          NewScreenNum == obj.screen;                   % Do not bother if the screen number doesn't even change

            if shouldAbort
                fprintf("The new screen number is either not indicative of Screens 0-%d or is identical to current screen (%d). Aborting process", ...
                        max(Screen('Screens')), obj.screen);
                return;
            end
            
            % Change the screen and the dimensions
            obj.screen = NewScreenNum;
            [obj.pixWidth, obj.pixHeight] = Screen('WindowSize', obj.screen);
            obj.pixDims = [obj.pixWidth, obj.pixHeight];
            obj.pixCenter = obj.pixDims/2;     
        end
        

        % change_framerate
        % function that changes the framerate (SHOULD BE CALLED ON STARTUP ONLY)    
        % Input:
        %   - NewFrameRate: The new framerate
        % Output: None
        function change_framerate(obj, NewFrameRate)
            % See if we should change the framerate in the first place 
            shouldAbort = ~isscalar(NewFrameRate) || ...     % Do not engage if the value is not scalar
                          ~isnumeric(NewFrameRate) || ...    % Do not engage if we don't have a number
                          NewFrameRate <= 0;                 % Do not engage if the new framerate is too low

            if shouldAbort
                fprintf("The new framerate is not valid. Keeping framerate to %d", obj.framerate);
                return;
            end

            % Change the framerate
            obj.framerate = NewFrameRate;
        end


        % change_bgColor
        % function that changes the background color (SHOULD BE CALLED ON STARTUP ONLY)    
        % Input:
        %   - NewColor: The new background color
        % Output: None
        function change_bgColor(obj, NewColor)
            % See if we should change the framerate in the first place 
            shouldAbort = ~isvector(NewColor) || ...    % Do not engage if the value is not a vector
                          ~isnumeric(NewColor) || ...   % Do not engage if we don't have a number
                          length(NewColor) ~= 4 || ...  % Do not engage if the value doesn't have RGBA format
                          all(NewColor < 0) || ...      % Do not engage if any rgba value is too low
                          all(NewColor > 255);          % Do not engage if any rgba value is too high

            if shouldAbort
                fprintf("The new new color is not valid. Keeping bgColor to [%2d]", obj.bgColor);
                return;
            end

            % Change the framerate
            obj.bgColor = NewColor;
        end
    end
end


%% CHAGNELOG
% Georgios Kokalas 9th Sept. 2024
%   - Created the file
