function N = coordinate_interp(s)
% Shape functions for linear coordinate interpolation. 
% Natural coordinate -1 <= s <= +1

n = length(s);

N = zeros(2*n,4);

N(1:2:(2*n),1) = (1-s)/2;
N(1:2:(2*n),3) = (1+s)/2;
N(2:2:(2*n),2) = (1-s)/2;
N(2:2:(2*n),4) = (1+s)/2;

return;