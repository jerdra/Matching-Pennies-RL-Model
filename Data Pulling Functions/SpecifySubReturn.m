function [ filteredMat ] = SpecifySubReturn( dataMat,opt )
%SPECIFYSUBRETURN Summary of this function goes here
%   Detailed explanation goes here

%Some column constants (add in-depth filtering when needed for full
%analysis) 
GAME = 9; 
EOB = 10; 

if (opt)
    dlgBool = true;
    while (dlgBool)
        disp(selSubj);
        userIn = input('Which subject number to extract?');
        
        if (any(ismember(userIn,selSubj)))
            dlgBool = false;
        else
            disp('Subject# does not exist enter valid ID');
        end
    end
    
    %Filtered matrix
    processMat = dataMat(dataMat(:,1) == userIn);
else
    %If a subject is not specified 
    processMat = dataMat;
end

%Filter based on constant conditions
%Clear out non-game conditions and non-eye conditions 
filterCrit = processMat(:,GAME) == 2 & processMat(:,EOB) == 0; 
filteredMat = processMat(filterCrit,:); 

end

