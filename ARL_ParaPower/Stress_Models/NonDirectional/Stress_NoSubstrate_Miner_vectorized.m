% TC debugging 7/17/2020

function [stressx,stressy,stressz]=Stress_NoSubstrate_Miner_factorized(Results, time)
% This function calculates the thermal stress based on CTE mismatch for each element in the model.
% This is a quasi 3-D approach that sums the forces in one plane to get the
% final length of all the elelments in that plane. Each plane is taken
% individually capturing intra-planar effects (2-D). The 3-D effects are
% captured by by considering multiple planes in each direction. The
% following planes are used in calculating the final length in each
% direction; x-Direction: y-z plane; y-direction: x-z plane; z-Direction:
% x-y plane.
% Load Temperature Results, Melt Fraction Results and Processing Temp
Temp=Results.getState('Thermal');
Temp=Temp(:,:,:,time);
Melt=Results.getState('MeltFrac');
Melt=Melt(:,:,:,time);
ProcT=Results.Model.Tproc;
% Load material properties E, cte, nu
EX=Results.Model.MatLib.GetParam('E');
EY=Results.Model.MatLib.GetParam('E');
EZ=Results.Model.MatLib.GetParam('E');
nuX=Results.Model.MatLib.GetParam('nu');
nuY=Results.Model.MatLib.GetParam('nu');
nuZ=Results.Model.MatLib.GetParam('nu');
cteX=Results.Model.MatLib.GetParam('cte');
cteY=Results.Model.MatLib.GetParam('cte');
cteZ=Results.Model.MatLib.GetParam('cte');
% Calculate the difference between the operating temp and the processing
% temp for thermal stress calc
delT=Temp-ProcT;
% Load dx, dy, dz values and number of Layers, Rows and Columns
dx=Results.Model.X;
dy=Results.Model.Y;
dz=Results.Model.Z;
NL=length(dz);
NR=length(dy);
NC=length(dx);
% Load Material Numbers for every element in the model
Mats=Results.Model.Model;

% get the different material numbers in Mats
mat_num = unique(Mats);

% extract nonzero material numbers
zero_mask = (mat_num ~= 0);
lut_mat_num = mat_num(zero_mask);

%initialize lut_solid_mat so that same size as lut_mat_num
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

youngs_X = zeros(mat_size);
poisson_X = zeros(mat_size);
cte_X = zeros(mat_size);
onescube = ones(mat_size);

% loop through nonzero material numbers
for i = 1:length(lut_mat_num)
    mat_no = lut_mat_num(i);
    mask = (Mats == mat_no);
    youngs_X(mask) = EX(mat_no);
    poisson_X(mask) = nuX(mat_no);
    cte_X(mask) = cteX(mat_no);
end

% make dx, dy, and dz into 3D cubes

d_X = repmat(dx', [1 length(dy) length(dz)]);
d_Y = repmat(dy, [length(dx) 1 length(dz)]);
d_Z = zeros(1,1,length(dz));
d_Z(1,1,:) = dz;
d_Z = repmat(d_Z, [length(dx) length(dy) 1]);

cube_nx = (youngs_X ./ (onescube - poisson_X)) .* d_Y .* d_Z;
cube_dx = ((youngs_X./(onescube-poisson_X)).*d_Y.*d_Z)./(d_X.*(cte_X.*delT+onescube));

% exclude non-Solid or melt materials...
mask_ckMatl_or_Melt = (ckMatl == 0) | (Melt > 0);

% by overwriting with 0
cube_nx(mask_ckMatl_or_Melt) = 0;
cube_dx(mask_ckMatl_or_Melt) = 0;

% sum the planes of the 1st and 3rd dimensions
% https://www.mathworks.com/help/matlab/ref/sum.html
sumnx = sum(cube_nx,[2 3]);
sumdx = sum(cube_dx,[2 3]);

my_Lfx = sumnx ./ sumdx;

cube_ny = (youngs_X ./ (onescube - poisson_X)) .* d_X .* d_Z;
cube_dy = ((youngs_X./(onescube-poisson_X)).*d_X.*d_Z)./(d_Y.*(cte_X.*delT+onescube));

cube_ny(mask_ckMatl_or_Melt) = 0;
cube_dy(mask_ckMatl_or_Melt) = 0;

% sum the planes of the 1st and 3rd dimensions
% https://www.mathworks.com/help/matlab/ref/sum.html
sumny = sum(cube_ny,[1 3]);
sumdy = sum(cube_dy,[1 3]);

my_Lfy = sumny ./ sumdy;

cube_nz = (youngs_X ./ (onescube - poisson_X)) .* d_X .* d_Y;
cube_dz = ((youngs_X./(onescube-poisson_X)).*d_X.*d_Y)./(d_Z.*(cte_X.*delT+onescube));

cube_nz(mask_ckMatl_or_Melt) = 0;
cube_dz(mask_ckMatl_or_Melt) = 0;

% sum the planes of the 1st and 3rd dimensions
% https://www.mathworks.com/help/matlab/ref/sum.html
sumnz = sum(cube_nz,[1 2]);
sumdz = sum(cube_dz,[1 2]);

my_Lfz = sumnz ./ sumdz;

% pre-calculated cubes to be removed out of loops
Lfx_cube = repmat(my_Lfx, [1 length(dy) length(dz)]);
Lfy_cube = repmat(my_Lfy, [length(dx) 1 length(dz)]);
Lfz_cube = repmat(my_Lfz, [length(dx) length(dy) 1]);

% make stress cubes
stresscube_x = zeros(mat_size);
stresscube_y = zeros(mat_size);
stresscube_z = zeros(mat_size);

stresscube_x = (youngs_X./(onescube-poisson_X)).*((Lfx_cube./(d_X.*(cte_X.*delT+onescube)))-onescube);
stresscube_y = (youngs_X./(onescube-poisson_X)).*((Lfy_cube./(d_Y.*(cte_X.*delT+onescube)))-onescube);
stresscube_z = (youngs_X./(onescube-poisson_X)).*((Lfz_cube./(d_Z.*(cte_X.*delT+onescube)))-onescube);

stresscube_x(mask_ckMatl_or_Melt) = NaN;
stresscube_y(mask_ckMatl_or_Melt) = NaN;
stresscube_z(mask_ckMatl_or_Melt) = NaN;

% Loop over Cols, Rows and Lays to determine the final x, y and z lengths of
% the elements, as a result of the CTE mismatch between the materials in all the layers
% x-direction final length
for jj=1:NC
    sumn=0;
    sumd=0;
        for k=1:NL
            for i=1:NR
                % Skip locations that have no material, IBC's, Fluid and
                % non-zero Melt fractions
                if  ckMatl(i,jj,k) == 0 || Melt(i,jj,k) > 0
                    sumn=sumn+0;
                    sumd=sumd+0;
                else
                    sumn=sumn+(EX(Mats(i,jj,k))/(1-nuX(Mats(i,jj,k))))*dy(i)*dz(k);
                    sumd=sumd+((EX(Mats(i,jj,k))/(1-nuX(Mats(i,jj,k))))*dy(i)*dz(k))/(dx(jj)*(cteX(Mats(i,jj,k))*delT(i,jj,k)+1));
                end
           end
        end
    Lfx(jj)=sumn/sumd;
end
% y-direction final length
for ii=1:NR
    sumn=0;
    sumd=0;
        for k=1:NL
            for j=1:NC
                % Skip locations that have no material, IBC's, Fluid and
                % non-zero Melt fractions
                if  ckMatl(ii,j,k) == 0 || Melt(ii,j,k) > 0
                    sumn=sumn+0;
                    sumd=sumd+0;
                else
                    sumn=sumn+(EY(Mats(ii,j,k))/(1-nuY(Mats(ii,j,k))))*dx(j)*dz(k);
                    sumd=sumd+((EY(Mats(ii,j,k))/(1-nuY(Mats(ii,j,k))))*dx(j)*dz(k))/(dy(ii)*(cteY(Mats(ii,j,k))*delT(ii,j,k)+1));
                end
            end
        end
    Lfy(ii)=sumn/sumd;
end
% z-direction final length
for kk=1:NL
    sumn=0;
    sumd=0;
        for i=1:NR
            for j=1:NC
                % Skip locations that have no material, IBC's, Fluid and
                % non-zero Melt fractions
                if  ckMatl(i,j,kk) == 0 || Melt(i,j,kk) > 0
                    sumn=sumn+0;
                    sumd=sumd+0;
                else
                    sumn=sumn+(EZ(Mats(i,j,kk))/(1-nuZ(Mats(i,j,kk))))*dx(j)*dy(i);
                    sumd=sumd+((EZ(Mats(i,j,kk))/(1-nuZ(Mats(i,j,kk))))*dx(j)*dy(i))/(dz(kk)*(cteZ(Mats(i,j,kk))*delT(i,j,kk)+1));
                end
            end
        end
    Lfz(kk)=sumn/sumd;
end
% Loop over all elements to claculate stress due to CTE mismatch for each
% element
for kk=1:NL
    for ii=1:NR
        for jj=1:NC
            if  ckMatl(ii,jj,kk) == 0 || Melt(ii,jj,kk) > 0
                stressx(ii,jj,kk)=NaN;
                stressy(ii,jj,kk)=NaN;
                stressz(ii,jj,kk)=NaN;
            else
                stressx(ii,jj,kk)=(EX(Mats(ii,jj,kk))/(1-nuX(Mats(ii,jj,kk))))*((Lfx(jj)/(dx(jj)*(cteX(Mats(ii,jj,kk))*delT(ii,jj,kk)+1)))-1);
                stressy(ii,jj,kk)=(EY(Mats(ii,jj,kk))/(1-nuY(Mats(ii,jj,kk))))*((Lfy(ii)/(dy(ii)*(cteY(Mats(ii,jj,kk))*delT(ii,jj,kk)+1)))-1);
                stressz(ii,jj,kk)=(EZ(Mats(ii,jj,kk))/(1-nuZ(Mats(ii,jj,kk))))*((Lfz(kk)/(dz(kk)*(cteZ(Mats(ii,jj,kk))*delT(ii,jj,kk)+1)))-1);
            end
        end
    end
end
% Stress check, sum forces to be sure they go to zero
SumforceX=0;
SumforceY=0;
SumforceZ=0;
for ii=1:NR
    for jj=1:NC
        for kk=1:NL
            ForceX(ii,jj,kk)=stressx(ii,jj,kk)*dy(ii)*dz(kk);
            SumforceX=SumforceX+ForceX(ii,jj,kk);
            ForceY(ii,jj,kk)=stressy(ii,jj,kk)*dx(jj)*dz(kk);
            SumforceY=SumforceY+ForceY(ii,jj,kk);
            ForceZ(ii,jj,kk)=stressz(ii,jj,kk)*dy(ii)*dx(jj);
            SumforceZ=SumforceZ+ForceZ(ii,jj,kk);
        end
    end
end
1