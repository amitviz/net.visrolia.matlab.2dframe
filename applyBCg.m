function [K,F] = applyBCg(nodes,K,F,BCn)

BCg = globalF(nodes,BCn);

ndf = size(F,1);

for n = 1:ndf
    if BCg(n) == 1         % if this dof is constrained
        K(n,:) = 0;        % zero the row
        K(:,n) = 0;        % zero the column
        K(n,n) = 1;        % identity on the diagonal
        F(n) = 0;          % zero the force
    end
end

return;