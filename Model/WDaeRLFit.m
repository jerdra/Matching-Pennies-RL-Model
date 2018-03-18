function [ beta, minFVal ] = WDaeRLFit( Qfunc, choice, reward )
%DAERLFIT Summary of this function goes here
%   RL fitting algorithm completely based off of Daeyoel Lee (2004)


%Initialize decision function
DecFunc = @(beta,choice,reward) WDaeDecisionFunc(Qfunc(beta(2:end),choice(:,1),reward),...
    Qfunc(beta(2:end),choice(:,2),reward),choice,beta(1));

%Compute objective function
ObjFunc = @(param) -sum(DecFunc(param,choice,reward));

%Perform function minimization
% [beta, minFVal] = fminsearch(ObjFunc,[0,0,0]);

%Random Start Bounded Minimization
[beta, minFVal] = RndMinBnd(ObjFunc,[0 1; 0 1; -40 40; -40 40]);

%Grid Search
%Alternative Grid Based Optimization (won't work with combination atm)
% cellBound{2} = [0:1:50]./55;
% cellBound{1} = [0:1:50]./55;
% [beta, minFVal] = GridOptRL(ObjFunc,cellBound);

end

