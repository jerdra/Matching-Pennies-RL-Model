function [ Q ] = DaeEstVal( beta, choice, reward )
%DAEESTVAL Perform value iteration based on Daeyoel Lee et al. (2004)

Q = zeros(size(choice,1),2);
alpha = beta(1); %Decay rate
dR = [beta(2) beta(3)]; %Value update [win loss]

for i = 2 : length(choice)
    
    %Forward values 
    Q(i,:) = Q(i-1,:); 
    
    %Update chosen option value
    Q(i,choice(i-1)) = alpha.*Q(i-1,choice(i-1)) + dR(2-reward(i-1));
    
end



end

