function H = choice_entropy(choice,win_size)
%CHOICE_ENTROPY Summary of this function goes here
%   Detailed explanation goes here

%Get all unique triplets from the choice vector
u_choices = unique(choice); 

%Permutations of all unique choices up to length three...? 
sequences = permn(u_choices,3);
seq_count = zeros(length(sequences),1); 

%Implement sliding window
for i = 1 : length(choice)-win_size+1
    
    seq_count = seq_count + ismember(sequences,choice(i:i+win_size-1)','rows');
    
end

% H_biased = sum ( p * log2(p) ) 
H_biased = nansum((seq_count./sum(seq_count)) .* log2(seq_count./sum(seq_count)));

%H = -H_biased + (2^k-1)/(1.3863N) where N is total # of samples
H = -H_biased + ((2^win_size - 1) / (1.3863 * sum(seq_count))); 

end

