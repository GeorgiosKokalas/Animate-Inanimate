%% DESCRIPTION
% Called by Experiment, Introduction, RunTrial and subscripts within those.
% Function that draws the photodiode and stores the time of the drawing for an event.        
% Input: 
%   - Pars   Parameters for the experiment
%   - Color  The color of the photodiode
% Output: 
%   - time   When this happened

%% CODE
function time = Draw_Photodiode(Pars, Color)
    persistent photodiodeRect
    if nargin < 2; Color = repmat(255,1,4); end
    
    if isempty(photodiodeRect)
        photodiodeRect = [0, Pars.screen.pixHeight*(5/6), ...
                        Pars.screen.pixWidth/11, Pars.screen.pixHeight];
    end

    Screen('FillRect', Pars.screen.window,  Color, photodiodeRect);
    time = GetSecs();
end


%% CHANGELOG
% Georgios Kokalas - Summer 2024
%   - Created the file

% Georgios Kokalas - 9th Sept 2024
%   - Added Color Options
%   - made photodiodeRect persistent so it doesn't get constantly redefined   
%   - changed naming conventions