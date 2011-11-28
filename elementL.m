function Le = elementL(nodes,elements,e)

dy = nodes(elements(e,2),2) - nodes(elements(e,1),2);
dx = nodes(elements(e,2),1) - nodes(elements(e,1),1);

Le = sqrt(dx.^2 + dy.^2);

return;