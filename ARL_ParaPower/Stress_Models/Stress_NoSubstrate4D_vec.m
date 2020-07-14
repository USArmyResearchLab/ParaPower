% 7-13-2020: modified to return 4D cubes by including the 4th time
% dimension
%
function [stressx, stressy, stressz] = Stress_NoSubstrate4D_vec (Results)
% This function calculates the thermal stress based on CTE mismatch for each element in the model.
% This is a quasi 3-D approach that sums the forces in one plane to get the
% final length of all the elelments in that plane. Each plane is taken
% individually capturing intra-planar effects (2-D). The 3-D effects are
% captured by by considering multiple planes in each direction. The
% following planes are used in calculating the final length in each
% direction; x-Direction: y-z plane; y-direction: x-z plane; z-Direction:
% x-y plane.
% Load Temperature Results, Melt Fraction Results and Processing Temp

% 07-08-2020: TC added second argument (t), so that this stress model can be
% expanded to the time dimension in Stress_NoSubstrateTrinity.m

time = Results.Model.GlobalTime
n_time = length(time)

% Load dx, dy, dz values and number of Layers, Rows and Columns
dx = Results.Model.X;
dy = Results.Model.Y;
dz = Results.Model.Z;

ProcT = Results.Model.Tproc;

% Load Material Numbers for every element in the model
Mats = Results.Model.Model;

% Load material properties E, cte, nu
E = Results.Model.MatLib.GetParam('E');
nu = Results.Model.MatLib.GetParam('nu');
cte = Results.Model.MatLib.GetParam('cte');

Temp = Results.getState('Thermal');
Melt = Results.getState('MeltFrac');

delT = Temp - ProcT;

% for iTimeStep = 1:length(time)
%
%     Temp = Results.getState('Thermal');
%     Temp = Temp(:,:,:,iTimeStep);
%     Melt = Results.getState('MeltFrac');
%     Melt = Melt(:,:,:,iTimeStep);

% Calculate the difference between the operating temp and the processing
% temp for thermal stress calc
%delT=Temp-ProcT;

% TC 07-08-20
% original: Mats cube with values from 0 to 5 representing materials
% create "table" mapping material number to PPMatSolid (true/false)
% use table to create a mask
% extract materials that are PPMatSolid, replace with true
% assign to ckMat cube

% get the different material numbers in Mats
mat_num = unique(Mats);

% extract nonzero material numbers
zero_mask = (mat_num ~= 0);
lut_mat_num = mat_num(zero_mask);

% initialize lut_solid_mat, with false, so that same size as lut_mat_num
lut_solid_mat = logical(zeros(size(lut_mat_num)));

% see if material number is PPMatSolid, if yes --> true
for i = 1:length(lut_mat_num)
    lut_solid_mat(i) = isa(Results.Model.MatLib.GetMatNum(lut_mat_num(i)),'PPMatSolid');
end

% create look-up table (cell array) mapping material number to logical
lut = {lut_mat_num, lut_solid_mat};

% initialize ckMat
mat_size = size(Mats);
ckMatl = logical(zeros(mat_size));

% PPMatSolid materials assigned true
for i = 1:length(lut_mat_num)
    mat_no = lut{1}(i);
    mask = (Mats == mat_no);
    ckMatl(mask) = lut{2}(i);
end

% 4D ckMatl
ckMatl_time = repmat(ckMatl, [1 1 1 n_time])

%{
mat_no = Mats(Xi,Yjj,Zk);
youngs_X = EX(mat_no);
poisson_X = nuX(mat_no);
cte_X = cteX(mat_no)
d_Y = dy(Yjj);
d_Z = dz(Zk);
%}

% initialize cubes (Young's Modulus, Poisson's Ratio, CTE)
youngs = zeros(mat_size);
poisson = zeros(mat_size);
cte_mat = zeros(mat_size);
%onescube = ones(mat_size);

% loop through nonzero material numbers
for iTimeStep = 1:length(lut_mat_num)
    mat_no = lut_mat_num(iTimeStep);
    mask = (Mats == mat_no);
    youngs(mask) = E(mat_no);
    poisson(mask) = nu(mat_no);
    cte_mat(mask) = cte(mat_no);
end

youngs_time = repmat(youngs, [1 1 1 n_time])
poisson_time = repmat(poisson, [1 1 1 n_time])
cte_time = repmat(cte_mat, [1 1 1 n_time])

ones_4D = ones(size(ckMatl_time))


% make dx, dy, and dz into 3D cubes

d_X = repmat(dx', [1 length(dy) length(dz) n_time]);
d_Y = repmat(dy, [length(dx) 1 length(dz) n_time]);

d_Z3 = zeros(1,1,length(dz)); % create a 3D matrix to repmat the 3rd dimension
d_Z3(1,1,:) = dz;

d_Z = repmat(d_Z3, [length(dx) length(dy) 1 n_time]);


%% x-direction final length
% cube_nx = (youngs ./ (onescube - poisson)) .* d_Y .* d_Z;
% cube_dx = ((youngs./(onescube-poisson)).*d_Y.*d_Z)./(d_X.*(cte.*delT+onescube));
% 
% % exclude non-Solid or melt materials...
% mask_ckMatl_or_Melt = (ckMatl == 0) | (Melt > 0);
% 
% % by overwriting with 0
% cube_nx(mask_ckMatl_or_Melt) = 0;
% cube_dx(mask_ckMatl_or_Melt) = 0;
% 
% % sum the planes of the 1st and 3rd dimensions
% % https://www.mathworks.com/help/matlab/ref/sum.html
% sumnx = sum(cube_nx,[1 3]);
% sumdx = sum(cube_dx,[1 3]);
% 
% my_Lfx = sumnx ./ sumdx;

matrix_nx = (youngs_time ./ (ones_4D - poisson_time)) .* d_Y .* d_Z;
matrix_dx = ((youngs_time ./ (ones_4D - poisson_time)) .* d_Y .* d_Z)./(d_X.*(cte_time.*delT+ones_4D));

% exclude non-Solid or melt materials...
mask_ckMatl_or_Melt = (ckMatl == 0) | (Melt > 0);

% by overwriting with 0
matrix_nx(mask_ckMatl_or_Melt) = 0;
matrix_dx(mask_ckMatl_or_Melt) = 0;

% sum the planes of the 1st and 3rd dimensions
% https://www.mathworks.com/help/matlab/ref/sum.html
sumnx = sum(matrix_nx,[1 3]);
sumdx = sum(matrix_dx,[1 3]);

my_Lfx = sumnx ./ sumdx;

%% y-direction final length
% cube_ny = (youngs ./ (onescube - poisson)) .* d_X .* d_Z;
% cube_dy = ((youngs./(onescube-poisson)).*d_X.*d_Z)./(d_Y.*(cte.*delT+onescube));
% 
% cube_ny(mask_ckMatl_or_Melt) = 0;
% cube_dy(mask_ckMatl_or_Melt) = 0;
% 
% sum the planes of the 2nd and 3rd dimensions
% https://www.mathworks.com/help/matlab/ref/sum.html
% sumny = sum(cube_ny,[2 3]);
% sumdy = sum(cube_dy,[2 3]);
% 
% my_Lfy = sumny ./ sumdy;
% my_Lfy = my_Lfy';

matrix_ny = (youngs_time ./ (ones_4D - poisson_time)) .* d_X .* d_Z;
matrix_dy = ((youngs_time./(ones_4D-poisson_time)).*d_X.*d_Z)./(d_Y.*(cte_time.*delT+ones_4D));

matrix_ny(mask_ckMatl_or_Melt) = 0;
matrix_dy(mask_ckMatl_or_Melt) = 0;

% sum the planes of the 2nd and 3rd dimensions
% https://www.mathworks.com/help/matlab/ref/sum.html
sumny = sum(matrix_ny,[2 3]);
sumdy = sum(matrix_dy,[2 3]);

my_Lfy = sumny ./ sumdy;

%% z-direction final length

matrix_nz = (youngs_time ./ (ones_4D - poisson_time)) .* d_X .* d_Y;
matrix_dz = ((youngs_time ./(ones_4D - poisson_time)).*d_X.*d_Y)./(d_Z.*(cte_time.*delT+ones_4D));

matrix_nz(mask_ckMatl_or_Melt) = 0;
matrix_dz(mask_ckMatl_or_Melt) = 0;

% sum the planes of the 1st and 2nd dimensions
% https://www.mathworks.com/help/matlab/ref/sum.html
sumnz = sum(matrix_nz,[1 2]);
sumdz = sum(matrix_dz,[1 2]);

my_Lfz = sumnz ./ sumdz;

%% calculate stress
% pre-calculated cubes to be removed out of loops
% Lfx_cube = repmat(my_Lfx, [length(dx) 1 length(dz)]);
% Lfy_cube = repmat(my_Lfy', [1 length(dy) length(dz)]);
% Lfz_cube = repmat(my_Lfz, [length(dx) length(dy) 1]);

% make stress cubes
% stresscube_x(:,:,:,iTimeStep) = zeros(mat_size);
% stresscube_y(:,:,:,iTimeStep) = zeros(mat_size);
% stresscube_z(:,:,:,iTimeStep) = zeros(mat_size);
% 
% % calculate stress cubes
% stresscube_x(:,:,:,iTimeStep) = (youngs./(onescube-poisson)).*((Lfx_cube./(d_X.*(cte.*delT+onescube)))-onescube);
% stresscube_y(:,:,:,iTimeStep) = (youngs./(onescube-poisson)).*((Lfy_cube./(d_Y.*(cte.*delT+onescube)))-onescube);
% stresscube_z(:,:,:,iTimeStep) = (youngs./(onescube-poisson)).*((Lfz_cube./(d_Z.*(cte.*delT+onescube)))-onescube);
% 
% % if ckMat == 0 or Melt > 0, assign NaN
% stresscube_x(mask_ckMatl_or_Melt) = NaN;
% stresscube_y(mask_ckMatl_or_Melt) = NaN;
% stresscube_z(mask_ckMatl_or_Melt) = NaN;

%% To vec

% pre-calculated cubes to be removed out of loops
% 
Lfx_mat = repmat(my_Lfx, [length(dx) 1 length(dz) 1]);
Lfy_mat = repmat(my_Lfy, [1 length(dy) length(dz) 1]);
Lfz_mat = repmat(my_Lfz, [length(dx) length(dy) 1 1]);

% make stress cubes
stressx = zeros(size(ckMatl_time));
stressy = zeros(size(ckMatl_time));
stressz = zeros(size(ckMatl_time));

% calculate stress cubes
stressx = (youngs_time./(ones_4D-poisson_time)).*((Lfx_mat./(d_X.*(cte_mat.*delT+ones_4D)))-ones_4D);
stressy = (youngs_time./(ones_4D-poisson_time)).*((Lfy_mat./(d_Y.*(cte_mat.*delT+ones_4D)))-ones_4D);
stressz = (youngs_time./(ones_4D-poisson_time)).*((Lfz_mat./(d_Z.*(cte_mat.*delT+ones_4D)))-ones_4D);

% if ckMat == 0 or Melt > 0, assign NaN
stressx(mask_ckMatl_or_Melt) = NaN;
stressy(mask_ckMatl_or_Melt) = NaN;
stressz(mask_ckMatl_or_Melt) = NaN;

if 1
save('debug_4D_vec.mat','stressx','stressy','stressz')
end

return

%% Stress check, sum forces to be sure they go to zero
SumforceX=0;
SumforceY=0;
SumforceZ=0;

% TC 07-07-20
[cubex, cubey, cubez] = meshgrid(dy, dx, dz);

ForceX = stressx.*cubey.*cubez;
ForceY = stressy.*cubex.*cubez;
ForceZ = stressz.*cubey.*cubex;

% for Xii=1:NRx
%     for Yjj=1:NCy
%         for Zkk=1:NLz
%             ForceX(Xii,Yjj,Zkk,t)=stressx(Xii,Yjj,Zkk,t)*dy(Yjj)*dz(Zkk);
%             ForceY(Xii,Yjj,Zkk,t)=stressy(Xii,Yjj,Zkk,t)*dx(Xii)*dz(Zkk);
%             ForceZ(Xii,Yjj,Zkk,t)=stressz(Xii,Yjj,Zkk,t)*dy(Yjj)*dx(Xii);
%         end
%     end
% end
% SumforceX=sum(ForceX(~isnan(ForceX)));
% SumforceY=sum(ForceY(~isnan(ForceY)));
% SumforceZ=sum(ForceZ(~isnan(ForceZ)));

%% To Do


%%



fprintf('Net Force X: %f, Y: %f, Z: %f\n',SumforceX, SumforceY, SumforceZ)
% end of iTimeStep loop

return
