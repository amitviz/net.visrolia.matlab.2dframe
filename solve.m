function [u,R] = solve(nodes,elements,Ae,Ee,Ie,Fn,BCn,ABCn)

Kg = globalK(nodes,elements,Ae,Ee,Ie);
if all(all(Kg == Kg'))
    disp('Global stiffness matrix is not symmetric.');
end

Fg = globalF(nodes,Fn);

[Kb,Fb] = applyBCg(nodes,Kg,Fg,BCn);

[Ks,Fs,T] = applyABCg(nodes,elements,Kb,Fb,ABCn);

us = Ks\Fs;

u = T'*us;
R = Kg*u;

return;