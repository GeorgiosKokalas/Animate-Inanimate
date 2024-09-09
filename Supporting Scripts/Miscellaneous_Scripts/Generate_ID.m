%% DESCRITPTION
% Miscelaneous function
% Generates participant ID per the requirements of the experiment.
% Input:
%   - Name: The name of the participant
%   - ExpEnv: The experimental environment
%   - ForceEnv: Be strict or not about methods failing in the envoronment
% Output:
%   - ID: a struct containing information about the participant.

%% CODE
function ID = Generate_ID(Name, ExpEnv, ForceEnv)
    
    % Account for missing variables
    if nargin < 3; ForceEnv = false; end
    if nargin < 2; ExpEnv = 'None'; end
    if nargin < 1; Name = 'TEST'; end

    % Generate an ID based on the experimental environment
    switch char(lower(ExpEnv))
        case 'bcm-emu'
            % BCM-EMU is the environment used by the Baylor College of Medicine (BCM) for their Epilepsy Monitoring Unit (EMU).  
            % For this env, the ID will contain:     
            %   - Name: The name will be overwritten by the EMU logger
            %   - EmuNum: The number allocated to the experiment as a whole by the environment     
            %   - EmuFileName: A file name used by the EMU to refer to the neural data
            %   - ExpEnv: The experimental environment
            %   - ForceEnv: Whether or not to enforce the errors from the experimental environment     
            try
                [emuNum,Name] = getNextLogEntry();
                emuFileName = sprintf('EMU-%04d_subj-%s_task-4MAB_run-%02d',emNum,sub_label,taskRunNum);
                
                % Guide ForceEnv to either true or false
                if isnan(ForceEnv) || ForceEnv == 0
                    ForceEnv = false;
                else
                    ForceEnv = true;
                end

                % Save the ID
                ID = struct('Name', Name, 'EmuNum', emuNum, 'EmuFileName', emuFileName, 'ExpEnv', 'Bcm-Emu', 'ForceEnv', ForceEnv);
            catch ME
                if ForceEnv; rethrow(ME);
                else; fprintf(ME);
                end
            end
        otherwise
            % The default condition uses:
            %   - Name: The name will be overwritten by the EMU logger
            %   - ExpEnv = 'None': The experimental environment set to None.
            %   - ForceEnv = false: Choose not to enforce the errors from the experimental environment     
            ID = struct('Name', Name, 'ExpEnv', 'None', 'ForceEnv', false);
    end
end


%% CHANGELOG
% Georgios Kokalas - 6th Sept. 2024
%   - Created the file