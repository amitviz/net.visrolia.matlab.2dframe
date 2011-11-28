function theta = elementtheta(nodes,elements,e)

dy = nodes(elements(e,2),2) - nodes(elements(e,1),2);
dx = nodes(elements(e,2),1) - nodes(elements(e,1),1);

theta = atan2(dy,dx);

return;