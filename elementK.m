function k = elementK(A,E,L,I)
% Direct construction of an element stiffness matrix (in its own coordinate
%   system)

krod = A*E/L;
kbeam = E*I/L^3;

k = zeros(6,6);

k(1,1) = krod;
k(4,4) = krod;
k(1,4) = -krod;
k(4,1) = -krod;
k(2,2) = 12*kbeam;
k(5,5) = 12*kbeam;
k(2,5) = -12*kbeam;
k(5,2) = -12*kbeam;

k(3,[2 6]) = 6*L*kbeam;
k(2,3) = 6*L*kbeam;
k(5,3) = -6*L*kbeam;
k(3,5) = -6*L*kbeam;
k(6,5) = -6*L*kbeam;
k(2,6) = 6*L*kbeam;
k(6,2) = 6*L*kbeam;
k(5,6) = -6*L*kbeam;

k(3,3) = 4*L^2 * kbeam;
k(6,6) = 4*L^2 * kbeam;

k(6,3) = 2*L^2 * kbeam;
k(3,6) = 2*L^2 * kbeam;

return;
