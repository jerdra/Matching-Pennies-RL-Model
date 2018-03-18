function H = opp_choice_entropy(choices,choice_opp,win_size)

wordmap = 'abcdefghijklmnopqrstuvwxyz'; 

%Get all unique sequences 
u_choices = unique(choices); 
u_opp_choice = unique(choice_opp) + max(u_choices); 


%All unique sequences
sequences = permn(u_choices,3); 
opp_seq = permn(u_opp_choice,2); 



full_seq = [];

for i = 1 : size(sequences,1) 
    
    full_seq = [full_seq; repmat(sequences(i,:),size(opp_seq,1),1), opp_seq]; 
    
end

%Switch up columns 
inter_seq(:,1:2:size(full_seq,2)) = full_seq(:,1:size(sequences,2)); 
inter_seq(:,2:2:size(full_seq,2)) = full_seq(:,size(sequences,2)+1:end);

%Interleave choices 
inter_vec(1:2:length(choices) + length(choice_opp)) = choices; 
inter_vec(2:2:length(choices) + length(choice_opp)) = choice_opp + max(u_choices); 

%Obtains win_size choices in combination with win_size-1 opponent choices 
seq_count = zeros(size(inter_seq,1),1); 
full_win = 2 * win_size - 1;

for i = 1 : 2 :length(inter_vec) - full_win + 1
    
    seq_count = seq_count + ismember(inter_seq,inter_vec(i:i+full_win-1),'rows');
    
end 

% H_biased = sum ( p * log2(p) ) 
% Nan sum is used since some sequences aren't found log2(0) = -inf, we
% ignore these cases since they really add to the sum either
H_biased = nansum((seq_count./sum(seq_count)) .* log2(seq_count./sum(seq_count)));

%H = -H_biased + (2^k-1)/(1.3863N) where N is total # of samples
H = -H_biased + ((2^win_size - 1) / (1.3863 * sum(seq_count))); 

    
end



