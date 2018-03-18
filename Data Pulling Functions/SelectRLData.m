function [ choice, reward ] = SelectRLData( dataMat, varargin)

%SELECTRLDATA Summary of this function goes here
%   Opt = 1 ask which subject to use


%Option selector for participant type (add more once full fitting begins)
defaultGroup = 'Young';
validGroups = {'Young', 'Old', 'PD'};
checkGroup = @(x)validatestring(x,validGroups);

%Option for enabling subject selection 
defaultSelect = 0; 
validSelect = [1 0]; 
checkSelect = @(x)any(ismember(x, validSelect)); 

%Initialize the input parser object
p = inputParser;

%Add a required parameter for group selection
addParameter(p,'Group',checkGroup);
addOptional(p,'Select',checkSelect); 

%Parse selection parameters and extract conditional index
parse(p,varargin{:});
groupInd = find(strcmpi(p.Results.Group,validGroups));

%Grab group out of big data set
%Grab unique subject ID with their respective group
subj = unique(dataMat(:,1:2),'rows');

%Filter out the group type needed
selSubj = subj(subj(:,2) == groupInd,1);
groupMat = dataMat(dataMat(:,2) == selSubj,:); 

%Return subject data for specified group of interest
procMat = SpecifySubReturn(groupMat,opt);

%Given the subjects in the data


end

