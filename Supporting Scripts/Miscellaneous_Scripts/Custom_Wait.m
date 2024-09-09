%% DESCRIPTION
% Miscellaneous function
% Function that waits for a specific duration of time
% Michael Yoo told me WaitSecs() is not too accurate, so I am making a custom function  
% Input: 
%   - WaitTime: The time to wait for
% Output: None

%% CODE
function Custom_Wait(WaitTime)
    startTime = GetSecs();
    while GetSecs() - startTime < WaitTime; end
end

%% CHANGELOG 
% Georgios Kokalas - 9th Sept. 2024
%   - Created the file

