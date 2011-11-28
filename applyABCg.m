function [Ks,Fs,T] = applyABCg(nodes,elements,Kg,Fg,ABCn)
% Applies aligned boundary conditions

ndof = 3;                      % degrees of freedom per node
totaldof = 3*size(nodes,1);

% Create a null transform matrix (i.e. an Identity matrix)
T = SparseMatrix;
for i = 1:totaldof
    T = T.append(1,i); 
end

% loop through rows of ABCn to construct transform matrix
for i = 1:size(ABCn,1)
    element = ABCn(i,1);        % element number
    lnode = ABCn(i,2);          % local node number
    gnode = elements(element,lnode); % global node number
    theta = elementtheta(nodes,elements,element);   % angle of the element
    t = eye(3);
    t(1:2,1:2) = transform(theta);       % transform matrix for the element angle
    gdof = ndof*(gnode-1) + [1:ndof]; % global degrees of freedom
    T = T.append(t,gdof);           % put it in the appropriate position
    T = T.append(-eye(3),gdof);     % take out the identity bits
end

% modify global force and stifness matrices to local coordinate system at
%   selected nodes - the `starred' matrices
Kg = Kg.toSparse(totaldof);
Fg = Fg.toSparse(totaldof,1);
T = T.toSparse(totaldof);
Fs = T*Fg;
Ks = T*Kg*T';

% loop through rows of ABCn to apply constraints
for i = 1:size(ABCn,1)
    element = ABCn(i,1);        % element number
    lnode = ABCn(i,2);          % local node number
    gnode = elements(element,lnode); % global node number
    gdof0 =  ndof*(gnode-1);
    for d = 1:ndof              % iterate through the dimensions
        if ABCn(i,2+d) == 1
            Ks(gdof0+d,:) = 0;
            Ks(:,gdof0+d) = 0;
            Ks(gdof0+d,gdof0+d) = 1;
            Fs(gdof0+d) = 0;
        end
    end
end

return;