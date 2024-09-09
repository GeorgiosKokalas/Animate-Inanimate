classdef ParameterClass < handle
    properties
        screen
        text
        trial
        output_dir
        exp_events
        ID
    end

    methods
        function obj = ParameterClass(Patient_Name)
            obj.screen = struct;
            obj.trial = struct;
            obj.target = struct;
            obj.avatars = struct;
            obj.text =    struct;
            obj.disbtn = struct;
            obj.output_dir = fullfile(pwd(),'Output', [Patient_Name, '_' ,datestr(datetime('now'), 'yyyymmdd-HHMM')]);
            obj.exp_events
        end

        function NewEvent(obj, New_Event)
            obj.exp_events = [obj.exp_events; New_Event];
        end

        function save(obj)
        end
    end
end