clear;

%parentfolder= '/dir/';
%Load in data
load('bigdata_14-Sep-2017.mat'); 
bigMat = big_data;
%Set save directory
%saveDir = 'C:\Users\Jerrold\Documents\Ashley Project\PDRLFit\Daeyoel Model 2004\RL Fits\Weighted';

%Create a data table to work with and throw out young controls
raw_T = TabRLData(bigMat);
T = raw_T;

%Get opponent choices
d_opp = cellfun(@(x,y) get_opponent_choice(x,y),T.DCHOICE,T.OUTCOME,'un',0);
c_opp = cellfun(@(x,y) get_opponent_choice(x,y),T.CCHOICE,T.OUTCOME,'un',0);

%Get directional choice entropy
d_h = cellfun(@(x) choice_entropy(x,3),T.DCHOICE,'un',0); 

%Get color choice entropies
c_h = cellfun(@(x) choice_entropy(x,3),T.CCHOICE,'un',0); 

%Get choice entropies 
h_d = cellfun(@(x) choice_entropy(x,3), T.DCHOICE, 'un',1); 
h_c = cellfun(@(x) choice_entropy(x,3), T.CCHOICE, 'un',1); 

%Combine opponent and choice vectors to get their entropy values 
d_hopp = cellfun(@(x,y) opp_choice_entropy(x,y,3),T.DCHOICE,d_opp,'un',1); 
c_hopp = cellfun(@(x,y) opp_choice_entropy(x,y,3),T.CCHOICE,c_opp,'un',1);

%Create and output entropy table 
headers = [T.Propert0ies.VariableNames, 'D_ENTROPY', 'C_ENTROPY', 'D_OPP_ENTROPY', 'C_OPP_ENTROPY']; 
T = [T, array2table([h_d, h_c, d_hopp, c_hopp])]; 
T.Properties.VariableNames = headers;

%Get save directory, must be in path 
s = what('Information Analysis'); 
save(fullfile(s.path,'output','Entropy_Table'),'T');




