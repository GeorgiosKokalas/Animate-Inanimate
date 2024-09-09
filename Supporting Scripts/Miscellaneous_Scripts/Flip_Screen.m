%% DESCRIPTION
% Miscellaneous function
% Function that flips the screen with while trying to be consistent to the framerate       
% Input: 
%   - Pars: Parameters of the experiment
% Output: 
%   - time: When the screen was flipped

%% CODE
function time = Flip_Screen(Pars)
    persistent lastFrameTime frameRate2Secs
    
    % Check if the persistent variables have been instantiated
    if isempty(lastFrameTime);  lastFrameTime  = GetSecs(); end
    if isempty(frameRate2Secs); frameRate2Secs = 1/Pars.screen.framerate; end
    
    % If the flip were to be called to soon, wait a little bit
    frameTimeDiff = GetSecs() - lastFrameTime;
    if frameTimeDiff < frameRate2Secs 
        Custom_Wait(frameRate2Secs - frameTimeDiff)
    end
    
    % Flip the Screen and take the time
    time = Screen('Flip', Pars.screen.screen);
    lastFrameTime = time;
end


%% CHANGELOG
% Georgios Kokalas - 9th Sept. 2024
%   - Created the file
