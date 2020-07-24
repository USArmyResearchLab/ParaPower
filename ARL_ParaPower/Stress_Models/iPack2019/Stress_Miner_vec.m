% added time

function [stresscube_x,stresscube_y,stresscube_z] = Stress_Miner_vec (Results, time)
% This function calculates the thermal stress based on CTE mismatch for each element in the model.
% This is a quasi 3-D approach that sums the forces in one plane to get the
% final length of all the elements in that plane. Each plane is taken
% individually capturing intra-planar effects (2-D). The 3-D effects are
% captured by considering multiple planes in each direction. The
% following planes are used in calculating the final length in each
% direction; x-Direction: y-z plane; y-direction: x-z plane; z-Direction:
% x-y plane.


%% Load Temperature Results, Melt Fraction Results and Processing Temp

Temp4D = Results.getState('Thermal');
Temp = Temp4D(:,:,:,time);

Melt4D = Results.getState('MeltFrac');
Melt = Melt4D(:,:,:,time);

ProcT = Results.Model.Tproc;

% Load material properties E, cte, nu
EX = Results.Model.MatLib.GetParam('E');
nuX = Results.Model.MatLib.GetParam('nu');
cteX = Results.Model.MatLib.GetParam('cte');

% Calculate the difference between the operating temp and the processing
% temp for thermal stress calc
delT = Temp-ProcT;

% Load dx, dy, dz values and number of Layers, Rows and Columns

dx = Results.Model.X;
dy = Results.Model.Y;
dz = Results.Model.Z;

n_dx = length(dx);
n_dy = length(dy);
n_dz = length(dz);

% Load Material Numbers for every element in the model
Mats = Results.Model.Model;

%-------------------



% initialize Young's Modulus cube
mat_size = size(Mats);
youngs_X = zeros(mat_size);
poisson_X = zeros(mat_size);
cte_X = zeros(mat_size);
onescube = ones(mat_size);


% make dx, dy, and dz into 3D cubes

d_X = repmat(dx', [1 length(dy) length(dz)]);
d_Y = repmat(dy, [length(dx) 1 length(dz)]);
d_Z = zeros(1,1,length(dz));
d_Z(1,1,:) = dz;
d_Z = repmat(d_Z, [length(dx) length(dy) 1]);

% for when entire layer is all PCM (or for situations when stress cannot be
% calculated)
LF_ALL_PCM = NaN;

% get the different material numbers in Mats
mat_num = unique(Mats);

% extract nonzero material numbers
zero_mask = (mat_num ~= 0);
lut_mat_num = mat_num(zero_mask);

for i = 1:length(lut_mat_num)
    mat_no = lut_mat_num(i);
    mask = (Mats == mat_no);
    youngs_X(mask) = EX(mat_no);
    poisson_X(mask) = nuX(mat_no);
    cte_X(mask) = cteX(mat_no);
end


% get the different material numbers in Mats
mat_num = unique(Mats);

% extract nonzero material numbers
zero_mask = (mat_num ~= 0);
lut_mat_num = mat_num(zero_mask);

%initialize lut_solid_mat so that same size as lut_mat_num
lut_solid_mat = logical(zeros(size(lut_mat_num)));

% see if material number is PPMatSolid, if yes --> true
for j = 1:length(lut_mat_num)
    MatObj = Results.Model.MatLib.GetMatNum(lut_mat_num(j));
    % TC 07-21-2020 : doesn't work because searching for all objects that
    % are derived from PPMatSolid (this includes PCM). PCMs are
    % treated like PPMatSolid when they haven't melted yet.
    %lut_solid_mat(j) = strcmp(MatObj.Type,'Solid');
    lut_solid_mat(j) = isa(Results.Model.MatLib.GetMatNum(lut_mat_num(j)),'PPMatSolid');
end

% create look-up table (cell array) mapping material number to logical
lut = {lut_mat_num, lut_solid_mat};

% initialize ckMat
mat_size = size(Mats);
ckMatl = logical(zeros(mat_size));

% PPMatSolid materials assigned true
for i = 1:length(lut{1})
    mat_no = lut{1}(i);
    mask = (Mats == mat_no);
    ckMatl(mask) = lut{2}(i);
end

% exclude non-Solid or melt materials...
mask_ckMatl_or_Melt = (ckMatl == 0) | (Melt > 0);

time_lapse(1) = toc;

%% x-direction
tic
cube_nx = (youngs_X ./ (onescube - poisson_X)) .* d_Y .* d_Z;
cube_dx = ((youngs_X./(onescube-poisson_X)).*d_Y.*d_Z)./(d_X.*(cte_X.*delT+onescube));

% by overwriting with 0
cube_nx(mask_ckMatl_or_Melt) = 0;
cube_dx(mask_ckMatl_or_Melt) = 0;

% sum the planes of the 2nd and 3rd dimensions
% https://www.mathworks.com/help/matlab/ref/sum.html
sumnx = sum(cube_nx,[2 3]);
sumdx = sum(cube_dx,[2 3]);

Lfx_vec = sumnx' ./ sumdx';
mask = (sumdx' == 0);
Lfx_vec(mask) = LF_ALL_PCM;
time_lapse(2) = toc;

%% y-direction
tic
cube_ny = (youngs_X ./ (onescube - poisson_X)) .* d_X .* d_Z;
cube_dy = ((youngs_X./(onescube-poisson_X)).*d_X.*d_Z)./(d_Y.*(cte_X.*delT+onescube));

cube_ny(mask_ckMatl_or_Melt) = 0;
cube_dy(mask_ckMatl_or_Melt) = 0;

% sum the planes of the 1st and 3rd dimensions
% https://www.mathworks.com/help/matlab/ref/sum.html
sumny = sum(cube_ny,[1 3]);
sumdy = sum(cube_dy,[1 3]);

% sumny and sumdy are column vectors because of sum(_,[2 3])
Lfy_vec = sumny ./ sumdy;
mask = (sumdy' == 0);
Lfy_vec(mask) = LF_ALL_PCM;
time_lapse(3) = toc;
%% z-direction
tic
cube_nz = (youngs_X ./ (onescube - poisson_X)) .* d_X .* d_Y;
cube_dz = ((youngs_X./(onescube-poisson_X)).*d_X.*d_Y)./(d_Z.*(cte_X.*delT+onescube));

cube_nz(mask_ckMatl_or_Melt) = 0;
cube_dz(mask_ckMatl_or_Melt) = 0;

% sum the planes of the 1st and 3rd dimensions
% https://www.mathworks.com/help/matlab/ref/sum.html
sumnz = squeeze(sum(cube_nz,[1 2]));
sumdz = squeeze(sum(cube_dz,[1 2]));

Lfz_vec = sumnz' ./ sumdz';
mask = (sumdz' == 0);
Lfz_vec(mask) = LF_ALL_PCM;
time_lapse(4) = toc;
%% calculate stress
tic
% pre-calculated cubes to be removed out of loops
Lfx_cube = repmat(Lfx_vec', [1 length(dy) length(dz)]);
Lfy_cube = repmat(Lfy_vec, [length(dx) 1 length(dz)]);
Lfz_vec_mod(1,1,:) = Lfz_vec;
Lfz_cube = repmat(Lfz_vec_mod, [length(dx) length(dy) 1]);

% make stress cubes
stresscube_x = zeros(mat_size);
stresscube_y = zeros(mat_size);
stresscube_z = zeros(mat_size);

stresscube_x = (youngs_X./(onescube-poisson_X)).*((Lfx_cube./(d_X.*(cte_X.*delT+onescube)))-onescube);
stresscube_y = (youngs_X./(onescube-poisson_X)).*((Lfy_cube./(d_Y.*(cte_X.*delT+onescube)))-onescube);
stresscube_z = (youngs_X./(onescube-poisson_X)).*((Lfz_cube./(d_Z.*(cte_X.*delT+onescube)))-onescube);

stresscube_x(mask_ckMatl_or_Melt) = 0;
stresscube_y(mask_ckMatl_or_Melt) = 0;
stresscube_z(mask_ckMatl_or_Melt) = 0;
time_lapse(5) = toc;

time_lapse_Miner_vec = time_lapse;
save('compete.mat','time_lapse_Miner_vec','-append')