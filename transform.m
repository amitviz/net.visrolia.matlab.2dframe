function t = transform(theta)
% rotation matrix for a  vector rotated about theta ANTICLOCKWISE

t = [cos(theta) sin(theta); -sin(theta) cos(theta)];

return;
