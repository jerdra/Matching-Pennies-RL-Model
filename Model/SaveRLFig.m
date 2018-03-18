function SaveRLFig( T, saveDir )
%SAVERLFIG Summary of this function goes here
%   Save function 

%Naming Type
c_group = {'ll','Ctrl','Prksn','BPD','Yngf','Yngm'}; 

%Meds
c_med = {'Off','Med','None'};

%Eye or button
c_rsp = {'Eye', 'Btn'}; 

%Take figure, format and save
%Get axis 
ax = gca; 

%Set colors
%c = [0 0 0; 0 0 0]; 
%ax.YAxis(1).Color = c(1,:); 
%ax.YAxis(2).Color = c(2,:); 

filename = [num2str(T.SUBJECT) '_' c_group{T.GROUP} '_' c_med{T.MEDS} '_' c_rsp{T.EOB}]; 
saveas(gcf,fullfile(saveDir,filename),'fig'); 
close; 


end

