tic;
% Bridge model

nodes = [0 0; 1800 3118; 3600 0; 5400 3118; 7200 0; 9000 3118; 10800 0];
elements = [1 2; 1 3; 2 3; 2 4; 3 4; 3 5; 4 5; 4 6; 5 6; 5 7; 6 7];

Ae = ones(size(elements,1),1)*3250;
Ee = ones(size(elements,1),1)*200e9/1e6;
Ie = ones(size(elements,1),1)*879667;

BCn = [1 1 1 0;
       7 0 1 0];

ABCn = [];

Fn = [1 0 -280e3 0;
      3 0 -210e3 0;
      5 0 -280e3 0;
      7 0 -360e3 0];

% Mesh refinement parameter
m = 1;

% Adjust input model to refine the mesh
[nodes,elements,Ae,Ee,Ie] = ...
    meshRefinement(nodes,elements,Ae,Ee,Ie,m);

% Solve the system for displacements and reactions
[u,R] = solve(nodes,elements,Ae,Ee,Ie,Fn,BCn,ABCn);

% Plot the mesh, with displacements
plotmesh(nodes, elements,Ae,Ee,Ie,u)
toc;