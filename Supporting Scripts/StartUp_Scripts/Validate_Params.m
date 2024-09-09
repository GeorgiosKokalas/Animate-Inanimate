%% DESCRIPTION
% Function called by: InsertParams.m
% Role of function is to validate to validate all inserted parameters by the user. 
% If values are invalid they are updated. More parameters are also added.
% Parameters: 
%   - params (struct that contains all inserted parameters)
% Return Values: None

%% CODE
function Validate_Params(params)
    load('colors.mat','color_list');

    % EVALUATE THE ID
    params.ID = Generate_ID(params.ID);

    % DEFINE THE OUTPUT DIRECTORY
    params.outputDir = fullfile(pwd(),'Output', [params.ID.Name, '_' ,datestr(datetime('now'), 'yyyymmdd-HHMM')]);

    %params.text.size - VALUE EVALUATION
    % Get all the size parameters
    allSizes = fieldnames(params.text.size);
    for sizeIdx = 1:length(allSizes)
        if ~is_nat(params.text.size.(allSizes{sizeIdx}))
            disp(sprinf("Inoperable value provided for params.target.size.%s. Applying default...",allSizes{sizeIdx}));
            params.text.size.(allSizes{sizeIdx}) = 40;
        end
    end

    %params.trial - VALUE EVALUATION
    % Evaluating showIntro
    if ~isscalar(params.trial.showIntro) || ~islogical(params.trial.showIntro)
        disp("Inoperable value provided for params.trial.showIntro. Applying default...");
        params.trial.showIntro = true;
    end

    % Evaluating num
    if ~is_nat(params.trial.num)
        disp("Inoperable value provided for params.trial.num. Applying default...");
        params.trial.num = 0;
    end

    %Evaluating presentDurS
    if ~is_pos(params.trial.presentDurS)
        disp("Inoperable value provided for params.trial.presentDurS. Applying default...");
        params.trial.presentDurS = 1;
    end

    %Evaluating choiceDurS
    if ~is_pos(params.trial.choiceDurS)
        disp("Inoperable value provided for params.trial.choiceDurS. Applying default...");
        params.trial.choiceDurS = 0.4;
    end

    %Evaluating photodiodeDurS
    if ~is_pos(params.trial.photodiodeDurS)
        disp("Inoperable value provided for params.trial.photodiodeDurS. Applying default...");
        params.trial.photodiodeDurS = 0.5;
    end
end



% Custom functions to make the code above more readable
% Checks if a value is a single number
function result = is_num(Input)
    result = isscalar(Input) && is_numeric(Input);
end

% Checks if a value is a positive number
function result = is_pos(Input)
    result = is_num(Input) && Input > 0;
end

%Checks if a value is a natural number (integers > 0)
function result = is_nat(Input)
    %Check if this is a number above 0
    result = is_pos(Input) && round(Input) == Input;
end



%% CHANGELOG
% Georgios Kokalas - Spring/Summer 2024
%   - Created and Adjusted the file

% Georgios Kokalas - 6th Sept. 2024
%   - Deleted checks for unneeded members (e.g. disbtn, avatar, target)

% Georgios Kokalas - 9th Sept. 2024
%   - screen validation is now done within the ScreenClass
%   - changed naming conventions
%   - deleted unneeded helper functions
%   - added ID validation