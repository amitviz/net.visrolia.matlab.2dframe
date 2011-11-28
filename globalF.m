function f = globalF(nodes,fn)

f = zeros(size(nodes,1)*3,1);

for i = 1:size(fn,1)
    node = fn(i,1);
    dof = 3*(node-1) + [1 2 3];
    f(dof,1) = fn(i,2:4)';
end

return;