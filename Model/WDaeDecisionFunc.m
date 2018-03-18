function [ choiceLL ] = WDaeDecisionFunc( QD, QC, choice, beta )
%WDAEDECISIONFUNC Daeyoel Lee et al. (2004) decision function 
%   Exponential class decision function (untemperatured softmax) 
%   Using choice modality weight for fits 

%Do chosen option indexing for computing final likelihood
choiceD = choice(:,1); 
choiceC = choice(:,2); 
C_ind = sub2ind(size(QD),(1:size(QD,1))',choiceD); 

%Get choice indices (transform to compute X(R) vector) 
XR = zeros(size(choiceD)); 

%Selector function for when red is left 
XR(choiceD == 1 & choiceC == 1) = 1; %Left choice, also red
XR(choiceD == 2 & choiceC == 2) = 1; %Right choice, green
XR(XR ~= 1) = -1; %Complement of above two (left is not red)

%Compute value
pVec = WGetChoiceProb(QD,QC,XR,beta); 

%Get chosen direction vector
pChosen = pVec(C_ind); 

%Log likelihood vector
choiceLL = log(pChosen); 


end

