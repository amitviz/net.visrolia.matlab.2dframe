function [K,F] = applyBCg(nodes,K,F,BCn)

BCg = globalF(nodes,BCn);
BCg = BCg.diet;
ndf = size(nodes,1)*3;

for n = 1:size(BCg.matrix,1)
    %if BCg.matrix(n,1) == 1 % if this dof is constrained
        K.matrix(K.matrix(:,1) == BCg.matrix(n,1),3) = 0; % zero the row
        K.matrix(K.matrix(:,2) == BCg.matrix(n,1),3) = 0; % zero the column
        K = K.append(1,BCg.matrix(n,1)); % identity on the diagonal
        F.matrix(F.matrix(:,1) == BCg.matrix(n,1),3) = 0; % zero the force
    %end
end

return;