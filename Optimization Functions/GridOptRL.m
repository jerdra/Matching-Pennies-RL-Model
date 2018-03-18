function [ optBeta, minFVal ] = GridOptRL(objFunc, cellBounds)
%GRIDOPTRL Summary of this function goes here
%   Simple grid base evaluation constrained to bounds 

for i = 1:length(cellBounds{1}) 
    for j = 1 : length(cellBounds{2}) 
        
        fVal(i,j) = objFunc([cellBounds{1}(i),cellBounds{2}(j)]); 
        
    end
end

optBeta = [0,0]; 
minFVal = 0; 

figure;
[x,y] = meshgrid(cellBounds{1},cellBounds{2}); 
surf(x,y,-fVal'); 
shading interp; 
view([0 0 1])
colorbar;


 

end

