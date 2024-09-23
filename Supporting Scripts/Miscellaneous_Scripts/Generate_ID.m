%% DESCRITPTION
% Miscelaneous function
% Generates participant ID per the requirements of the experiment.
% Input:
%   - ID: the unfinished ID struct
% Output:
%   - ID: a struct containing information about the participant.

%% CODE
function ID = Generate_ID(ID)
    
    % Account for missing variables
    forceEnv = ID.ForceEnv;
    expEnv = ID.ExpEnv;
    name = ID.Name;

    % Generate an ID based on the experimental environment
    switch char(lower(expEnv))
        case 'bcm-emu'
            % BCM-EMU is the environment used by the Baylor College of Medicine (BCM) for their Epilepsy Monitoring Unit (EMU).  
            % For this env, the ID will contain:     
            %   - Name: The name will be overwritten by the EMU logger
            %   - EmuNum: The number allocated to the experiment as a whole by the environment     
            %   - EmuFileName: A file name used by the EMU to refer to the neural data
            %   - ExpEnv: The experimental environment
            %   - ForceEnv: Whether or not to enforce the errors from the experimental environment     
            try
                [emuNum,name] = getNextLogEntry();
                emuFileName = sprintf('EMU-%04d_subj-%s_task-Animate_Inanimate',emuNum,name);
                
                % Guide ForceEnv to either true or false
                if isnan(forceEnv) || forceEnv == 0
                    forceEnv = false;
                else
                    forceEnv = true;
                end

                % Save the ID
                ID = struct('Name', name, 'EmuNum', emuNum, 'EmuFileName', emuFileName, 'ExpEnv', 'Bcm-Emu', 'ForceEnv', forceEnv);
            catch ME
                if forceEnv; rethrow(ME);
                else; fprintf(ME.message);
                end
            end
        otherwise
            % The default condition uses:
            %   - Name: The name will be overwritten by the EMU logger
            %   - ExpEnv = 'None': The experimental environment set to None.
            %   - ForceEnv = false: Choose not to enforce the errors from the experimental environment     
            ID = struct('Name', name, 'ExpEnv', 'None', 'ForceEnv', false);
    end
end


%% CHANGELOG
% Georgios Kokalas - 6th Sept. 2024
%   - Created the file

% Georgios Kokalas - 9th Sept. 2024
%   - Changed Input variables to be members of the ID struct already  