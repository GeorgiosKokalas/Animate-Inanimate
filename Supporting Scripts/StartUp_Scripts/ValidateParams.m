% Function called by: InsertParams.m
% Role of function is to validate to validate all inserted parameters by the user. 
% If values are invalid they are updated. More parameters are also added.
% Parameters: 
%   - params (struct that contains all inserted parameters)
% Return Values: None
function ValidateParams(params)
    load('colors.mat','color_list');
    
    %params.screen extra variables (dependent on user-defined variables)
    params.screen.custom_screen_ = false;         % dependent on start_point, height and width
    params.screen.window = -1;                    % will be used to hold the window (-1 is a placeholder)
    params.screen.center = [0,0];                 % will be used to represent the center of the window
    params.screen.screen_width = 0;               % the width of the screen in which the window will be housed 
    params.screen.screen_height = 0;              % the height of the screen in which the window will be housed 
    params.screen.window_dims = [0,0];            % the dimensions of the window (combines width and height)    

    % params.screen - VALUE EVALUATION
    % Evaluating color
    if ~isrgba(params.screen.color)
        disp("Inoperable value provided for params.screen.color. Applying default...");
        params.screen.color = color_list.grey;
    end
    
    % Evaluating screen (must be within the acceptable range of the available Screens
    if ~isnat(params.screen.screen) || params.screen.screen > max(Screen('Screens'))
        disp("Inoperable value provided for params.screen.screen. Applying default...");
        params.screen.screen = max(Screen('Screens'));
    end

    % change the value of screen_width and screen_height based on the screen
    [params.screen.screen_width, params.screen.screen_height] = Screen('WindowSize', params.screen.screen);
    
    % change the value of custom_screen_ based on the value of start_point 
    dims = [params.screen.screen_width, params.screen.screen_height];
    if ~isloc(params.screen.start_point, dims)
        disp("Inoperable value provided for params.screen.start_point. Applying default...");
        params.screen.start_point = [0, 0];
    end
    
    % change the value of custom_screen_ based on the value of height and width
    make_custom_screen = isnat(params.screen.window_height) && ...        
        isnat(params.screen.window_width) && ...
        params.screen.window_height <= params.screen.screen_height && ...
        params.screen.window_width <= params.screen.screen_width;
    if make_custom_screen   
        disp("Custom Valus provided for Width and Length. Abandoning FullScreen Mode...");
        params.screen.custom_screen_ = true;
    else 
        disp("Assuming FullScreen Mode.");
        [params.screen.window_width, params.screen.window_height] = Screen('WindowSize', params.screen.screen);
    end

    % change the value of params.screen.center, based on screen width and height
    params.screen.center = [params.screen.window_width / 2, params.screen.window_height / 2];

    % change the value of params.screen.window_dims
    params.screen.window_dims = [params.screen.window_width, params.screen.window_height];


    %params.text- VALUE EVALUATION
    % Get all the size parameters
    all_sizes = fieldnames(params.text.size);
    for size_idx = 1:length(all_sizes)
        if ~isnat(params.text.size.(all_sizes{size_idx}))
            disp(sprinf("Inoperable value provided for params.target.size.%s. Applying default...",all_sizes{size_idx}));
            params.text.size.(all_sizes{size_idx}) = 40;
        end
    end

    %params.trial - VALUE EVALUATION
    % Evaluating show_intro
    if ~isscalar(params.trial.show_intro) || ~islogical(params.trial.show_intro)
        disp("Inoperable value provided for params.trial.show_intro. Applying default...");
        params.trial.show_intro = 20;
    end

    % Evaluating num
    if ~isnat(params.trial.num)
        disp("Inoperable value provided for params.trial.num. Applying default...");
        params.trial.num = 0;
    end

    %Evaluating photodiode_dur_s
    if ~isnum(params.trial.photodiode_dur_s) && params.trial.photodiode_dur_s < 0
        disp("Inoperable value provided for params.trial.photodiode_dur_s. Applying default...");
        params.trial.photodiode_dur_s = 0.5;
    end

    % Extra variables for params.trial.cpu_wait_s
    params.trial.cpu_wait_dur = params.trial.cpu_wait_s(2) - params.trial.cpu_wait_s(1);
end




% Custom functions to make the code above more readable
%Checks if a value is a single number
function result = isnum(input)
    result = isscalar(input) && isnumeric(input);
end


%Checks if a value is a whole number (including 0 and positive integers)
function result = iswhole(input)
    % I define naturals as any number equal to or above 0
    result = isnum(input) && input >= 0 && round(input) == input;
end


%Checks if a value is a natural number (integers > 0)
function result = isnat(input)
    %Check if this is a number above 0
    result = isnum(input) && input > 0 && round(input) == input;
end

% Check if a value is composed of numbers
function result = isnumlist(input, Option)
    check_option = exist("Option", "var");
    if check_option
        check_option = check_option && (...
                        strcmpi(char(Option), 'num') || ...
                        strcmpi(char(Option), 'whole') || ...
                        strcmpi(char(Option), 'nat'));
    end
    if ~check_option; Option = 'num'; end

    result = isvector(input);
    try
        for idx = 1:length(input)
            if strcmpi(Option, 'num')
                result = result && isnum(input(idx));
            elseif strcmpi(Option, 'nat')
                result = result && isnat(input(idx));
            elseif strcmpi(Option, 'whole')
                result = result && iswhole(input(idx));
            else
                result = false;
            end
        end
    catch
        result = false;
    end
end

% Checks if a value is a vector pretaining to a specific color
function result = isrgba(input)
    % RGBA values are represented as vectors of 4 elements (numbers)
    result = isvector(input) && numel(input) == 4 && isnumlist(input, 'whole');

    % If this is a vector, check if every element is a whole number no greater than 255 
    if result
        for idx = 1:numel(input)
            if input(idx) > 255; result = false; end
        end
    end
end


function result = isloc(input, Dimensions)
    % Locations are vectors of x and y axes
    result = isvector(input) && numel(input) == 2 && isnumlist(input, 'whole');

    %Check if the values of the x and y axis are within the acceptable value for our screen  
    % [screen_width, screen_height] = Screen('WindowSize', Screen_Number);
    if result
        result = input(1)<Dimensions(1) && input(2)<Dimensions(2);
    end
end