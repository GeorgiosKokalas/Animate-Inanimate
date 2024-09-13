% Central Function and point of origin for the program
% It is the function that needs to be called to start the experiment and the one that ends with the experiment  
% The program allows the user to insert variables. This happens in 'InsertParams.m' 

function main()
    % INCLUDE TASK IN PATH
    curScript = mfilename('fullpath');
    curDir = curScript(1:end-length(mfilename));
    cd(curDir);
    addpath(genpath(curDir));

    % STARTUP BEFORE STARTING THE TASK
    % Start up the experiment and provide the parameters that will be used in the experiment       
    parameters = Start_Up();
    
    % RUN THE TASK
    Create_Event(parameters.ID, "taskStart")
    Experiment(parameters);
    Create_Event(parameters.ID, "taskStop")
    
    KbStrokeWait();
    sca;  
    
    % SHUT THINGS DOWN
    ShutDown(parameters);
    

    % Remove all the directories from the path
    % rmpath(genpath(cur_dir));
end 