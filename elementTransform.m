function T = elementTransform(nodes,elements,e)

theta = elementtheta(nodes,elements,e);
t = transform(theta);

T = eye(6);

T(1:2,1:2) = t;
T(4:5,4:5) = t;

return;