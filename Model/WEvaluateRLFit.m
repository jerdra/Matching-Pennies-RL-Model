function fig = WEvaluateRLFit( param,choice,reward )
%EVALUATERLFIT Summary of this function goes here
%   Sensitivity function for evaluating how strong prediction is at
%   determining choice probabilities onto fitted data 
%   Re-computes best value function and probabilities 

numBin = 10; 

%Estimate the value function 
Qd = DaeEstVal(param(2:end),choice(:,1),reward); 
Qc = DaeEstVal(param(2:end),choice(:,2),reward); 
choiceD = choice(:,1); 
choiceC = choice(:,2); 

%Get XR vector
XR = zeros(size(choiceD)); 
XR(choiceD == 1 & choiceC == 1) = 1; %Left choice, also red
XR(choiceD == 2 & choiceC == 2) = 1; %Right choice, green
XR(XR ~= 1) = -1; %Complement of above two (left is not red)

%Get value difference
QVec = param(1).*(Qd(:,1) - Qd(:,2)) + (1 - param(1)).*XR.*(Qc(:,1) - Qc(:,2));  

%Get model prediction curve for value --> probability transform
predVec = linspace(-ceil(max(abs(QVec))),ceil(max(abs(QVec))),1000); 

%Get bin edges
edges = linspace(-ceil(max(abs(QVec))),ceil(max(abs(QVec))),numBin + 1); 

% Binning predictions 
[N, ~, bin] = histcounts(QVec,edges); %P(R)
centres = diff(edges)./2 + edges(1:end-1); 
%Throwing choice data into bins
for i = 1 : numBin
    %Binned choices
    predBinChoices = choice(bin == i); 
    %Compute probability of being left
    choiceBins(i) = sum(predBinChoices == 1)./length(predBinChoices); 
end


%Transform values into choice probabilities 
predChoice = exp(predVec)./ (1 + exp(predVec)); 

%Plot errthing 
fig = figure; 

%Get trial distributions
% yyaxis right;
% histogram(QVec,numBin,'Normalization','probability','FaceColor',[0.8 0.8 0.8],...
% 'EdgeColor',[0.5 0.5 0.5]); 
% ylabel('Proportion of Trials'); 
% ylim([0 1]); 
% 
% yyaxis left; 
% plot(predVec,predChoice,'k'); hold on; 
% plot(centres,choiceBins,'r.', 'MarkerSize', 14); hold on; 
% xlabel('V_L - V_R'); 
% ylabel('P(L)'); 
% ylim([0 1])

[ax, h1, h2] = plotyy(predVec,predChoice,QVec,numBin,'plot','histogram'); hold on;
h3 = plot(centres,choiceBins,'k.','Color',ax(1).YColor,'MarkerSize',14);
set(h1,'Color',ax(1).YColor);
set(h2,'Normalization','probability','FaceColor',[0.8 0.8 0.8], ...
    'EdgeColor',[0.5 0.5 0.5]);
xlim([min(predVec) max(predVec)])
xlabel('V_L - V_R');
set(ax(1),'YLim',[0 1],'YTick',0:0.1:1);
ax(1).YLabel.String = 'P(L)';
set(ax(2),'YLim',[0 1],'YTick',0:0.1:1, ...
    'YColor',[0.3 0.3 0.3]);
ax(2).YLabel.String = 'Proportion of Trials';
end

