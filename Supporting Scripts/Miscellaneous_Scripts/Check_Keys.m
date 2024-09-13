%% DESCRIPTION
% Miscellaneous function
% Function that looks for specific key presses specified within the parameters      
% Input: 
%   - Parameters: Parameters of the experiment
% Output: 
%   - gotKey:   whether or not one of the needed keys was pressed
%   - whichKey: which of the specific keys was pressed
%   - whenKey:  when that key was pressed

%% CODE 
function [gotKey, whichKey, whenKey] = Check_Keys(Parameters)
    persistent allKeys allKeysLength

    gotKey = false;
    [whichKey, whenKey] = deal([]);

    if isempty(allKeys); allKeys = fieldnames(Parameters.keys); end
    if isempty(allKeysLength); allKeysLength = length(allKeys); end

    [keyPressed, keyTime, keyCode] = KbCheck();

    if ~keyPressed; return; end
    
    for keyIdx = 1:allKeysLength
        if keyCode(Parameters.keys.(allKeys{keyIdx}))
            gotKey = true;
            whichKey = Parameters.keys.(allKeys{keyIdx});
            whenKey = keyTime;
            break;
        end
    end
end

%% CHANGELOG
% Georgios Kokalas - 10th Sept. 2024
%   - Created the file