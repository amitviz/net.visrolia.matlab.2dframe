function [u,R] = solve(nodes,elements,Ae,Ee,Ie,Fn,BCn,ABCn)

Kg = globalK(nodes,elements,Ae,Ee,Ie);

Fg = globalF(nodes,Fn);

[Kb,Fb] = applyBCg(nodes,Kg,Fg,BCn);

[Ks,Fs,T] = applyABCg(nodes,elements,Kb,Fb,ABCn);

us = Ks\Fs;

u = T'*us;
Kg = Kg.toSparse;
R = Kg*u;

u = full(u);
R = full(R);
return;