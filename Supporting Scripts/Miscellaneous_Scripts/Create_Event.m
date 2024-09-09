%% DESCRIPTION
% Miscelaneous function that creates an event
% Function creates a Matlab event, and any other event based on the experimental environment    
% Input:
%   - ID: A struct containing information about the participant
%   - EventType: Any other events we should be expecting
%   - varargin: Anything else we may need
% Output:
%   - EventCell: A MATLAB Cell containing the event message and time of event    

%% CODE
function EventCell = Create_Event(ID, EventType, varargin)
    persistent onlineNSP
    
    eventMsg = '';
    switch string(EventType)
        % GENERIC EVENTS
        case "taskStart"
            eventMsg = "Task Start";
        case "taskStop"
            eventMsg = "Task Ended Successfully";
        case "taskPause"
            eventMsg = "Task Paused";
        case "taskResume"
            eventMsg = "Task Resumed";
        case "taskAbort"
            eventMsg = "Task Aborted";

        % TASK SPECIFIC EVENTS


        % ERROR HANDLING
        otherwise
            EventCell = {"Error", GetSecs()};
            fprintf("Event Call %s not recognized. Aborting...", EventType)
            return;
    end
    eventMsg = char(eventMsg);
    
    % Create the return value to be a cell with the event and the current
    try
        EventCell = {eventMsg, GetSecs()};
    catch ME
        disp("Event cell failed to create")
        EventCell = {ME.message, 0};
    end

    % Generate a signal for other experimental Environments
    switch ID.ExpEnv
        case 'Bcm-Emu'
            try
                switch EventType
                    case "taskStart"
                        onlineNSP = TaskComment('start', ID.EmuFileName);
                    case "taskStop"
                        TaskComment('stop', ID.EmuFileName);
                    case "taskAbort"
                        TaskComment('kill', ID.EmuFileName);
                    otherwise
                        for i=1:numel(onlineNSP)
                            cbmex('comment', 16750080, 0, eventMsg,'instance',onlineNSP(i)-1)
                        end
                end
            catch ME
                if ID.ForceEnv; rethrow(ME);
                else; fprintf(ME);
                end
            end
    end
end


%% CHANGELOG
% Georgios Kokalas - 6th Sept. 2024
%   - Created the file
