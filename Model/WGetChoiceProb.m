function [probVec] = WGetChoiceProb( Qd,Qc,XR,beta )
%WGETCHOICEPRO Summary of this function goes here
%   Detailed explanation goes here

%Compute value differences (VL - VR) 
dQ = beta*(Qd(:,1) - Qd(:,2)) + (1 - beta).*XR.*(Qc(:,1) - Qc(:,2)); 

%Compute probability of choosing option 1 
p1 = exp(dQ)./(1 + exp(dQ)); 
p2 = 1 - p1; 

%Probability vector [P(left) P(right)]
probVec = [p1 p2]; 

end

