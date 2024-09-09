%% DESCRIPTION
% Startup class. Defines the parameters that will be used throughout the experiment.   
% Meant to be used as a member of the ParameterClass

%% CODE
classdef ParameterClass < handle
    properties
        screen
        text
        trial
        outputDir
        expEvents
        ID
    end

    methods
        function obj = ParameterClass()
            obj.screen = ScreenClass();
            obj.trial = struct;
            obj.text =  struct;
            obj.outputDir;
            obj.expEvents;
            obj.ID = struct;
        end

        function new_event(obj, New_Event)
            obj.expEvents = [obj.expEvents; New_Event];
        end

        function save(obj)
        end
    end
end

%% CHANGELOG
% Georgios Kokalas Summer 2024
%   - Created the file

% Georgios Kokalas 6th Sept. 2024
%   - Adjusted the file for this task
%       - deleted unneeded class members like trial, target, avatar and disbtn
%       - added ID

% Georgios Kokalas 9th Sept. 2024
%   - screen is now a class instead of a struct for more control over its members 
%   - ajdusted naming conventions
%   - Deleted Patient Name as an input to the constructor
%   - obj.outputDir is now defined in Validate_Params.m