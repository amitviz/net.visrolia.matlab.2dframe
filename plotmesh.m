function plotmesh(nodes,elements,Ae,Ee,Ie,varargin)
% Plots the mesh, optionally including displacements. If displacements are
%   specified, deformation and strains are calculated using the shape functions

nn  = size(nodes,1);        % number of nodes
nel = size(elements,1);     % number of elements

ndf = nn*3;                 % number of degrees of freedom in the solution vector

optargin = size(varargin,2);
switch optargin
    case 0
        % No solution vector has been passed to the function
        u = zeros(ndf,1);
        c = zeros(nel,3); c(:,3) = 1;
        scalefactor = 1;
    case 1
        % Solution vector has been passed to the function
        u = varargin{1};
        c = zeros(nel,3); c(:,3) = 1;
        
        % Automatically determine a suitable scale factor
        if (max(varargin{1}) - min(varargin{1})) ~= 0
            ud = true(ndf,1); ud(3:3:ndf) = false;
            scalefactor = 0.5*min(max(nodes) - min(nodes))/(10^ceil(log10(max(abs(u(ud))))));
            if isnan(scalefactor)
                scalefactor = 1;
            end
            disp(strcat('Scale factor: ',sprintf('%8u',uint16(scalefactor))));
        end
end

% Header for output data
disp('  e  ex_max    M_max     Rx1       Ry1       M1        Rx2       Ry2       M2      ');

% Interpolation resolution
segments = 20;

for e = 1:nel
    T = elementTransform(nodes,elements,e);
    
    % Extract the element solution vector
    element_nodes = elements(e,:);
    ui = zeros(6,1);
    ui(1:3,1) = u(3*(element_nodes(1,1)-1)+[1 2 3]'); % nodal solution
    ui(4:6,1) = u(3*(element_nodes(1,2)-1)+[1 2 3]'); % nodal solution
    
    % Transform to the element coordinate system
    uie = T*ui;
    
    % Element properties
    L = elementL(nodes,elements,e);
    Ke = elementK(Ae(e),Ee(e),L,Ie(e));
    xn = nodes(elements(e,:),:)'; xn = xn(:);
    
    % Shape functions and derivatives
    N = shapefunction(-1:(2/segments):1,L);
    LN = shapefunction(-1:(2/segments):1,L,1); % first derivative of shape functions
    B = shapefunction(-1:(2/segments):1,L,2); % second derivative of shape functions
    J = 2/L; % Jacobian
    
    % mean axial strain
    dudx = J * LN*uie; % dudx and dvdx
    dudx = dudx(1:2:length(dudx)); % first derivative of u wrt x'
    ex_max = max(dudx);
    
    % bending moment/ bending strain
    d2vdx2 = (J^2) * B*uie; % d2udx2 and d2vdx2
    d2vdx2 = d2vdx2(2:2:length(d2vdx2));    % second derivative of v wrt x'
    M_max = Ee(e)*Ie(e)*max(abs(d2vdx2));

    % displacements
    ue = N*uie;
    theta = elementtheta(nodes,elements,e);
    % Transform matrix for all interpolated points on element
    T2 = kron(eye(segments+1),transform(theta));
    u0 = T2'*ue; % interpolated values of vector u [u v +]' in global coordinate system
    
    % Nodal reaction forces on the current element
    Re = Ke*uie;
    fprintf('%3i %9.2e %9.2e %9.2e %9.2e %9.2e %9.2e %9.2e %9.2e\n',e,ex_max,M_max,Re(1),Re(2),Re(3),Re(4),Re(5),Re(6));
   
    Nc = coordinate_interp(-1:(2/segments):1);
    xi = Nc*xn; % Interpolated coordinates
    x = xi(1:2:length(xi));
    y = xi(2:2:length(xi));
    
    % Plot deformed element
    line(x+scalefactor*u0(1:2:length(u0)),y+scalefactor*u0(2:2:length(u0)),'LineWidth',2,'Color',c(e,:));
    hold on;
end

% Plot nodes
plot(nodes(:,1)+scalefactor*u(1:3:ndf),nodes(:,2)+scalefactor*u(2:3:ndf),'ko','MarkerSize',8,'MarkerFaceColor','k');

% Set aspect ratio
daspect([1 1 1]);

return;