% Function called by: Experiment.m
% Role of function is to run a trial of the experiment
% Input: 
%   - Parameters    (Things to be used for the experiment)
%   - TrialIdx      (Which trial we are on)
% Output : 

function [output, trialEvents] = Run_Trial(Parameters, Word, Answer, Choices, BlockIdx, TrialIdx)
    %% PRE STAGE - Before the timer of the activity starts
    % Create a trial Start event
    load("colors.mat", "color_list");
    fixationTime = unifrnd(Parameters.trial.photoDiodeDurS*2, Parameters.trial.photoDiodeDurS*4);
    [leftChoiceBg, rightChoiceBg] = deal(zeros(1,4));

    trialEvents = Create_Event(Parameters.ID, "trialStart", BlockIdx, TrialIdx);

   
    %% PRESENTATION STAGE
    % FIXATION
    trialEvents = [trialEvents; Create_Event(Parameters.ID, "trialFixationStart", BlockIdx, TrialIdx)];
    
    % 0.1 - With the PhotoDiode
    stage_fixation(Parameters, color_list.white)
    Custom_Wait(Parameters.trial.photoDiodeDurS);

    % 0.2 -Without the Photodiode
    stage_fixation(Parameters, color_list.black)
    Custom_Wait(fixationTime - Parameters.trial.photoDiodeDurS);
    trialEvents = [trialEvents; Create_Event(Parameters.ID, "trialFixationEnd", BlockIdx, TrialIdx)];


    % 1 PRESENTATION
    trialEvents = [trialEvents; Create_Event(Parameters.ID, "trialPresentStart", BlockIdx, TrialIdx)];
    
    % 1.1 - With the PhotoDiode
    stage_presentation(Parameters, Word, color_list.white)
    Custom_Wait(Parameters.trial.photoDiodeDurS);

    % 1.2 -Without the Photodiode
    stage_presentation(Parameters, Word, color_list.black)
    Custom_Wait(Parameters.trial.presentDurS - Parameters.trial.photoDiodeDurS);
    trialEvents = [trialEvents; Create_Event(Parameters.ID, "trialPresentEnd", BlockIdx, TrialIdx)];


    % 2 - CHOICE
    % 2.1 - With the PhotoDiode
    trialEvents = [trialEvents; Create_Event(Parameters.ID, "trialChoiceStart", BlockIdx, TrialIdx)]; 
    startTime = GetSecs();
    [userChoice, responseTime] = stage_choice(Parameters, Choices, color_list.white, Parameters.trial.photoDiodeDurS);

    % 2.2.1 - Present Without the Photodiode
    if isempty(userChoice)
        stage_choice(Parameters, Choices, color_list.black, -1)
        while true
            [keyPressed, keyCode, keyTime] = Check_Keys(Parameters);
            if ~keyPressed; continue; end
            switch keyCode
                case Parameters.keys.Left
                    userChoice = Choices{1};
                    break;
                case Parameters.keys.Right
                    userChoice = Choices{2};
                    break;
                case Parameters.keys.Abort
                    userChoice = 'Abort';
                    break;
            end
        end
        responseTime = keyTime - startTime;
        trialEvents = [trialEvents; Create_Event(Parameters.ID, "trialChoiceEnd", BlockIdx, TrialIdx)];
    else
        trialEvents = [trialEvents; Create_Event(Parameters.ID, "trialChoiceEnd", BlockIdx, TrialIdx)];
        stage_choice(Parameters, Choices, color_list.black, -1);
        Custom_Wait(Parameters.trial.photoDiodeDurS);
    end
    
    % 3 - FEEDBACK
    trialEvents = [trialEvents; Create_Event(Parameters.ID, "trialFeedbackStart", BlockIdx, TrialIdx)];
    
    % Mark the response color
    % Choose the appropriate color
    answerColor = color_list.red;
    if strcmpi(userChoice, Answer); answerColor = color_list.blue; end
    
    % Choose the appropriate choice
    if strcmpi(userChoice, Choices{1}); leftChoiceBg = answerColor; end
    if strcmpi(userChoice, Choices{2}); rightChoiceBg = answerColor; end

    % 3.1 - With the PhotoDiode
    stage_feedback(Parameters, Choices, color_list.white, leftChoiceBg, rightChoiceBg);
    Custom_Wait(Parameters.trial.photoDiodeDurS);

    % 3.2 -Without the Photodiode
    stage_feedback(Parameters, Choices, color_list.black, leftChoiceBg, rightChoiceBg)
    Custom_Wait(Parameters.trial.choiceDurS - Parameters.trial.photoDiodeDurS);
    trialEvents = [trialEvents; Create_Event(Parameters.ID, "trialFeedbackEnd", BlockIdx, TrialIdx)];


    trialEvents = [trialEvents; Create_Event(Parameters.ID, "trialEnd", BlockIdx, TrialIdx)];
    output = struct('fixationTime', fixationTime, 'userChoice', userChoice, 'responseTime', responseTime, ...
                    'correct', strcmpi(userChoice, Answer));    
end

%% HELPER FUNCTIONS
function stage_fixation(Parameters, Color)
    Screen('TextSize', Parameters.screen.window, Parameters.text.size.present);
    DrawFormattedText2('+', 'win', Parameters.screen.window, 'sx', 'center',  'sy', 'center',...
        'xalign', 'center', 'yalign','center', 'baseColor', Parameters.text.color.default);
    Draw_Photodiode(Parameters, Color);
    Flip_Screen(Parameters);
end

function stage_presentation(Parameters, Word, Color)
    Screen('TextSize', Parameters.screen.window, Parameters.text.size.present);
    DrawFormattedText2(Word, 'win', Parameters.screen.window, 'sx', 'center',  'sy', 'center',...
        'xalign', 'center', 'yalign','center', 'baseColor', Parameters.text.color.default);
    Draw_Photodiode(Parameters, Color);
    Flip_Screen(Parameters);
end

function [choice, responseTime] = stage_choice(Parameters, Choices, Color, WaitTime)
    Screen('TextSize', Parameters.screen.window, Parameters.text.size.choices);
    DrawFormattedText2(Choices{1}, 'win', Parameters.screen.window, 'sx', Parameters.screen.pixCenter(1) - 50, ...
        'sy', Parameters.screen.pixHeight - 40, 'xalign', 'right', 'yalign','bottom', ...
        'baseColor', Parameters.text.color.default);
    DrawFormattedText2(Choices{2}, 'win', Parameters.screen.window, 'sx', Parameters.screen.pixCenter(1) + 50, ...
        'sy', Parameters.screen.pixHeight - 40, 'xalign', 'left', 'yalign','bottom', ...
        'baseColor', Parameters.text.color.default);
    Draw_Photodiode(Parameters, Color);
    Flip_Screen(Parameters);

    choice = [];

    startTime = GetSecs();
    responseTime = GetSecs() - startTime;
    while responseTime < WaitTime
        [keyPressed, keyCode, ~] = Check_Keys(Parameters);
        responseTime = GetSecs() - startTime;
        if ~keyPressed; continue; end
        switch keyCode
            case Parameters.keys.Left
                choice = Choices{1};
                return;
            case Parameters.keys.Right
                choice = Choices{2};
                return;
        end
    end
    responseTime = [];
end


function stage_feedback(Parameters, Choices, Color, LeftChoiceBg, RightChoiceBg)
    Screen('TextSize', Parameters.screen.window, Parameters.text.size.choices);
    Screen('TextBackgroundColor', Parameters.screen.window, LeftChoiceBg);
    DrawFormattedText2(Choices{1}, 'win', Parameters.screen.window, 'sx', Parameters.screen.pixCenter(1) - 50, ...
        'sy', Parameters.screen.pixHeight - 40, 'xalign', 'right', 'yalign','bottom', ...
        'baseColor', Parameters.text.color.default);
    Screen('TextBackgroundColor', Parameters.screen.window, RightChoiceBg);
    DrawFormattedText2(Choices{2}, 'win', Parameters.screen.window, 'sx', Parameters.screen.pixCenter(1) + 50, ...
        'sy', Parameters.screen.pixHeight - 40, 'xalign', 'left', 'yalign','bottom', ...
        'baseColor', Parameters.text.color.default);
    Screen('TextBackgroundColor', Parameters.screen.window, zeros(1,4));
    Draw_Photodiode(Parameters, Color);
    Flip_Screen(Parameters);
end

%% CHANGELOG
% Georgios Kokalas - 9th Sept. 2024
%   - Implemented present_stage 1 & 2 helper functions
%   - Partially implemented presentation stage

% Georgios Kokalas - 10th Sept. 2024
%   - Implemented stages 0 through 3 with functional presentation
