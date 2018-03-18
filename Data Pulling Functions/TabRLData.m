function [ dataTable ] = TabRLData( dataMat )
%TABRLDATA Tabulate RL data using MATLAB's table structure 
%   Returns raw matrix as a table for easier management of data 
%   Table header variables: 
%   SUBJECT, GROUP, MEDS, EOB, SESS, [D-CHOICE], [C-CHOICE], [OUTCOME], [RT] 
%   Filter out control task, only select for strategic task

%% Set up required columns and filtering tools
cSub = 1;
cGroup = 2; 
cSess = 6; 
cMeds = 7; 
cGame = 9; 
cEOB = 10; 
cSet = [cSub, cGroup, cSess, cMeds, cEOB]; 

%Run columns
rDir = 13; 
rCol = 14; 
rRew = 15; 
rRT = 16; 

%Set up an ugly mini-function to handle index selection
SetSelect = @(data,set) logical(prod(data == repmat(set,size(data,1),1),2)); 

%% Set up matrices for table formation 

%Select for strategic task (MP = 2) 
stData = dataMat(dataMat(:,cGame) == 2,:); 

%All unique conditional sets
uniqueRows = unique(stData(:,cSet),'rows'); 

%Create row vector matrix for each run 
for i = 1 : length(uniqueRows)
    
    %Get the indices that match the conditional set 
    specInd = SetSelect(stData(:,cSet),uniqueRows(i,:)); 
    
    %Select indices in which the trials were done correctly 
    %Trials in which choice (1,2) - figure out how to handle these trials,
    %or give user option to choose what to do with them 
    goodInd = ismember(stData(:,rDir),[0,1]);  
    selInd = specInd & goodInd; 
    
    %Get direction choice, color choice, outcomes and RTs
    dirChoice{i} = stData(selInd,rDir)+1; 
    colChoice{i} = stData(selInd,rCol)+1; 
    chOutcome{i} = stData(selInd,rRew) == 1; %0 or 1
    chRT{i} = stData(selInd,rRT); 
    
    %Set conditionals for table 
    sub(i) = uniqueRows(i,1); 
    gr(i) = uniqueRows(i,2); 
    sess(i) = uniqueRows(i,3); 
    meds(i) = uniqueRows(i,4); 
    eob(i) = uniqueRows(i,5); 
         
end

%Initialize  and set up table structure
headers = {'SUBJECT','GROUP','MEDS','EOB','SESS','DCHOICE','CCHOICE',...
    'OUTCOME','RT'}; 
dataTable = table(sub',gr',meds',eob',sess',dirChoice',colChoice',chOutcome',chRT'); 
dataTable.Properties.VariableNames = headers; 

%Fix values to positive
%Meds
dataTable.MEDS(dataTable.MEDS == -1) = 3; %No meds (ctrl)
dataTable.MEDS(dataTable.MEDS == 1) = 2; %Meds (prksn)
dataTable.MEDS(dataTable.MEDS == 0) = 1; %No meds (prksn) 

%EOB 
dataTable.EOB = dataTable.EOB + 1; 

end

