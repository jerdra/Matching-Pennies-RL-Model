function [ optBeta, minFVal ] = RndMinBnd( objFunc,pBounds,nIter )
%RNDMINBND Multiple random starts, bounded parameter optimization 

%   objFunc:    Objective function to be minimized 
%   param:      parameter vector 
%   pBounds:    Boundary sets for parameters f form [lb1 ub1; lb2 ub2;...]
%               [-Inf Inf] if unconstrained            
%   nIter:      Maximum number of iterations (default = 10) 

if nargin < 4
    nIter = 10; 
end

counter = 1; 

beta = zeros(nIter,size(pBounds,1)); 
fVal = zeros(nIter,1); 

%Optimize the function using bounded function optimization 
for i = 1 : nIter
    
    %Initialize some random starting points
    %Lower bound + some random value scaled by the total bound distance
    iTheta = pBounds(:,1) + rand(size(pBounds,1),1).*(pBounds(:,2)-pBounds(:,1));
    
    %Function minimization 
    [beta(i,:),fVal(i)] = fminsearchbnd(objFunc,iTheta,pBounds(:,1),pBounds(:,2)); 
    
end

%Get the best performing parameter set 
[~,bestInd] = min(fVal); 

%Return best beta set and the best log likelihood 
optBeta = beta(bestInd,:); 
minFVal = min(fVal); 

end

