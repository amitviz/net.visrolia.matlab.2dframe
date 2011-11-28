function [nodes_new,elements_new,Ae_new,Ee_new,Ie_new] = ...
    meshRefinement(nodes,elements,Ae,Ee,Ie,n)
% Splits existing elements into m segments for a mesh refinement

% Resize area, modulus and second moment of area vectors
Ae_new = kron(Ae,ones(n,1));
Ee_new = kron(Ee,ones(n,1));
Ie_new = kron(Ie,ones(n,1));

% Natural coordinates for interpolation
xi = -1:(2/n):1;

% Set up matrices for refined mesh
nodes_new = [nodes;zeros(size(elements,1)*(n-1),2)];
n0 = size(nodes,1); % pointer to zeroth node
elements_new = zeros(size(elements,1)*n,2);
e0 = 0; % pointer to zeroth element

for e = 1:size(elements,1) % Iterate through existing elements
    element_nodes = elements(e,:);
    nodal_coordinates = nodes(element_nodes,:)';
    element_coordinates = nodal_coordinates(:);
    
    % Interpolation shape function
    N = coordinate_interp(xi);
    
    % Interpolated coordinates
    element_coordinates_new = N*element_coordinates; % vector form
    element_coordinates_new = [element_coordinates_new(1:2:length(element_coordinates_new)) element_coordinates_new(2:2:length(element_coordinates_new))]; % xy form
    element_coordinates_new = element_coordinates_new(2:size(element_coordinates_new,1)-1,:); % cut off head and tail
    
    nodes_new((n0+1):(n0+n-1),:) = element_coordinates_new;
    
    if n >= 2
        elements_new(e0+1,:) = [element_nodes(1),n0+1];
        elements_new((e0+2):(e0+n-1),:) = [((n0+1):(n0+n-2))' ((n0+2):(n0+n-1))'];
        elements_new(e0+n,:) = [n0+n-1,element_nodes(2)];
    else
        % Special case for n=1 (i.e. don't refine the mesh)
        elements_new(e0+1,:) = [element_nodes(1),element_nodes(2)];
    end
    
    % Increment pointers
    n0 = n0 + n - 1;
    e0 = e0 + n;
end

return;