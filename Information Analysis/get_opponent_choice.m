function op_choice = get_opponent_choice(choice,outcome)

op_choice = nan(size(choice)); 
op_choice(outcome > 0) = choice(outcome > 0); 
op_choice(outcome == 0) = 3 - choice(outcome == 0); 

end

