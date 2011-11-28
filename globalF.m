function f = globalF(nodes,fn)

f = SparseMatrix;

for i = 1:size(fn,1)
    node = fn(i,1);
    dof = 3*(node-1) + [1 2 3];
    f = f.append(fn(i,2:4)',dof,1);
end

return;