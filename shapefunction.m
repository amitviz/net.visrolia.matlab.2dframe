function N = shapefunction(s,L,varargin)
% returns the shape functions for a frame element. s is the parametric
% coordinate between -1 -- +1, L is the element length
% s can be a row vector
% optional argument: derivative (0, 1, 2)

optargin = size(varargin,2);
if optargin == 0
    d = 0;
else
    d = varargin{1};
end


s = s';
n = length(s);  % number of terms

N = zeros(2*n,6);

switch d
    case 0
        N(1:2:(2*n),1) = 0.5*(1-s);
        N(1:2:(2*n),4) = 0.5*(1+s);

        N(2:2:(2*n),2) = 0.5*(1-0.5*s.*(3-s.^2));
        N(2:2:(2*n),5) = 0.5*(1+0.5*s.*(3-s.^2));
        N(2:2:(2*n),3) = (L/8)*(1-s.^2).*(1-s);
        N(2:2:(2*n),6) = -(L/8)*(1-s.^2).*(1+s);
    case 1
        N(1:2:(2*n),1) = -0.5;
        N(1:2:(2*n),4) =  0.5;
        
        N(2:2:(2*n),2) = (3*s.^2)/4 - 3/4;
        N(2:2:(2*n),5) = 3/4 - (3*s.^2)/4;
        N(2:2:(2*n),3) = (L*(s.^2 - 1))/8 + (L*s.*(s - 1))/4;
        %N(2:2:(2*n),6) = (L*(s.^2 - 1))/8 - (L*s.*(s + 1))/4;
        N(2:2:(2*n),6) = (L/8)*(2*s -1 +3*s.^2);
    case 2
        N(2:2:(2*n),2) = (3*s)/2;
        N(2:2:(2*n),5) = -(3*s)/2;
        N(2:2:(2*n),3) = (L*s)/2 + (L*(s - 1))/4;
        %N(2:2:(2*n),6) = (L*s)/2 - (L*(s + 1))/4;
        N(2:2:(2*n),6) = (L/8)*(2 + 6*s);
end

return;