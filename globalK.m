function Kg = globalK(nodes,elements,Ae,Ee,Ie)

Kg = SparseMatrix;

for el = 1:size(elements,1)
    L = elementL(nodes,elements,el);
    kel =  elementK(Ae(el),Ee(el),L,Ie(el));
        
    T = elementTransform(nodes,elements,el);
    
    ke = T'*kel*T;
    if all(all(ke == ke'))
        fprintf('Element %2i stiffness matrix is not symmetric\n',el);
    end

    % Scatter
    DOFe = kron((3*(elements(el,:)-1)),ones(1,3)) + kron(ones(1,2),1:3);
    Kg = Kg.append(ke,DOFe);

end


return;