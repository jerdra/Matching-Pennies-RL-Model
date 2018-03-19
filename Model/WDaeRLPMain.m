%Main running script for setting up fitting procedure
%Ideas to test: stimulus feature weights, temperatured decision function,
%persistence bonus parameter
%Based off of Daeyoel Lee et al. 2004

%REQUIRED PARAMETERS: [SUB_ID, GROUP_ID, CHOICE VECTOR(S), REWARD VECTOR] in matrix file. 
%SEE TabRLData to see how the structure is formatted so you can adapt your data!

clear;
%parentfolder= '';
%Load in data

bigMat = big_data;
%Set save directory
saveDir = '';

%Create a data table to work with and throw out young controls
raw_T = TabRLData(bigMat);
T = raw_T;

%For each conditional set perform fitting and create a parameter matrix for
%appending to set table
for set = 1 : height(T)

    disp(['Processing...  ' num2str(set) ' out of ' num2str(height(T))]);
    curT = T(set,:);

    %Create a value function estimate based on decision choices
    Qfunction = @DaeEstVal;

    %Fit the selected data set, takes in a Q evaluation function, choices and
    %rewards
    [beta(set,:), minFVal(set)] = WDaeRLFit(Qfunction,...
        [curT.DCHOICE{1} curT.CCHOICE{1}],curT.OUTCOME{1});

    %     %Evaluate the current fit
    h = WEvaluateRLFit(beta(set,:),[curT.DCHOICE{1} curT.CCHOICE{1}],curT.OUTCOME{1});
    %
    %     %Save the current figure set
    SaveRLFig(curT,saveDir);

end

%Create new table for appending
headers = {'DECAY', 'REWARDWGT', 'LOSSWGT','CHOICEWGT','LL'};
newT = table(beta(:,2),beta(:,3),beta(:,4),beta(:,1),-minFVal');
newT.Properties.VariableNames = headers;

%Save parameterized table
saveTable = [T newT];
save('WRLPTableDae','saveTable');
