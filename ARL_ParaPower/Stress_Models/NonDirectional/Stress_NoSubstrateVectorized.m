function [stressx,stressy,stressz] = Stress_NoSubstrateVectorized(Results,t)
% This function calculates the thermal stress based on CTE mismatch for each element in the model.
% This is a quasi 3-D approach that sums the forces in one plane to get the
% final length of all the elelments in that plane. Each plane is taken
% individually capturing intra-planar effects (2-D). The 3-D effects are
% captured by by considering multiple planes in each direction. The
% following planes are used in calculating the final length in each
% direction; x-Direction: y-z plane; y-direction: x-z plane; z-Direction:
% x-y plane.
% Load Temperature Results, Melt Fraction Results and Processing Temp

% 07-08-2020: Trinity added second argument (t), so that this stress model can be
% expanded to the time dimension in Stress_NoSubstrateTrinity.m

time = Results.Model.GlobalTime
Temp=Results.getState('Thermal');
Temp=Temp(:,:,:,t);
Melt=Results.getState('MeltFrac');
Melt=Melt(:,:,:,t);
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
NLz=length(dz);
%NR=length(dy);
%NC=length(dx);

NRx=length(dx);  %Morris switched these
NCy=length(dy);  %to match the substrate based model

% Load Material Numbers for every element in the model
Mats=Results.Model.Model;

% save the data for debugging
if 1
save('debug_mats.mat','Mats')
end

% Trinity 07-08-20
% original: Mats cube with values from 0 to 5 representing materials
% create "table" mapping material number to PPMatSolid (true/false)
% use table to create a mask
% extract materials that are PPMatSolid, replace with true
% assign to ckMat cube

% get the different material numbers in Mats
mat_num = unique(Mats);

% extract nonzero material numbers
zero_mask = (mat_num ~= 0)
lut_mat_num = mat_num(zero_mask)

%initialize lut_solid_mat so that same size as lut_mat_num
lut_solid_mat = logical(zeros(size(lut_mat_num)))

% see if material number is PPMatSolid, if yes --> true
for i = 1:length(lut_mat_num)
    lut_solid_mat(i) = isa(Results.Model.MatLib.GetMatNum(lut_mat_num(i)),'PPMatSolid');
end

% create look-up table (cell array) mapping material number to logical
lut = {lut_mat_num, lut_solid_mat}

% initialize ckMat
mat_size = size(Mats);
ckMatl = logical(zeros(mat_size));

% PPMatSolid materials assigned true
for i = 1:length(lut_mat_num)
    mat_no = lut{1}(i);
    mask = (Mats == mat_no);
    ckMatl(mask) = lut{2}(i);
end

%{
mat_no = Mats(Xi,Yjj,Zk);
youngs_X = EX(mat_no);
poisson_X = nuX(mat_no);
cte_X = cteX(mat_no)
d_Y = dy(Yjj);
d_Z = dz(Zk);
%}

% initialize Young's Modulus cube
% mat_size = size(Mats)
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

save('my_cubes.mat')

cube_nx = (youngs_X ./ (onescube - poisson_X)) .* d_Y .* d_Z;
%cube_d = ((youngs_X ./ (onescube - poisson_X)) .* d_Y .* d_Z) ./ (d_X .* cte_X .* delT + onescube);
cube_dx = ((youngs_X./(onescube-poisson_X)).*d_Y.*d_Z)./(d_X.*(cte_X.*delT+onescube));

% exclude non-Solid or melt materials...
mask_ckMatl_or_Melt = (ckMatl == 0) | (Melt > 0);

% by overwriting with 0
cube_nx(mask_ckMatl_or_Melt) = 0;
cube_dx(mask_ckMatl_or_Melt) = 0;

% sum the planes of the 1st and 3rd dimensions
% https://www.mathworks.com/help/matlab/ref/sum.html
sumnx = sum(cube_nx,[1 3]);
sumdx = sum(cube_dx,[1 3]);

my_Lfx = sumnx ./ sumdx

% Loop over Cols, Rows and Lays to determine the final x, y and z lengths of
% the elements, as a result of the CTE mismatch between the materials in all the layers
% x-direction final length
for Yjj=1:NCy
    sumn=0;
    sumd=0;
    for Zk=1:NLz
        for Xi=1:NRx
            
            % Skip locations that have no material, IBC's, Fluid and
            % non-zero Melt fractions
            if  ckMatl(Xi,Yjj,Zk) == 0 || Melt(Xi,Yjj,Zk) > 0
                sumn=sumn+0;
                sumd=sumd+0;
            else
                if 1
                [Xi Yjj Zk];
                assert(d_X(Xi,Yjj,Zk)==dx(Xi));
                assert(d_Y(Xi,Yjj,Zk)==dy(Yjj));
                assert(d_Z(Xi,Yjj,Zk)==dz(Zk));
                assert(youngs_X(Xi,Yjj,Zk) == EX(Mats(Xi,Yjj,Zk)));
                assert(poisson_X(Xi,Yjj,Zk) == nuX(Mats(Xi,Yjj,Zk)));
                assert(cte_X(Xi,Yjj,Zk) == cteX(Mats(Xi,Yjj,Zk)));
                assert(cube_nx(Xi,Yjj,Zk) == (EX(Mats(Xi,Yjj,Zk))/(1-nuX(Mats(Xi,Yjj,Zk))))*dy(Yjj)*dz(Zk));
                assert(cube_dx(Xi,Yjj,Zk) == ((EX(Mats(Xi,Yjj,Zk))/(1-nuX(Mats(Xi,Yjj,Zk))))*dy(Yjj)*dz(Zk))/(dx(Xi)*(cteX(Mats(Xi,Yjj,Zk))*delT(Xi,Yjj,Zk)+1)));
                end
                
                sumn=sumn+(EX(Mats(Xi,Yjj,Zk))/(1-nuX(Mats(Xi,Yjj,Zk))))*dy(Yjj)*dz(Zk);
                sumd=sumd+((EX(Mats(Xi,Yjj,Zk))/(1-nuX(Mats(Xi,Yjj,Zk))))*dy(Yjj)*dz(Zk))/(dx(Xi)*(cteX(Mats(Xi,Yjj,Zk))*delT(Xi,Yjj,Zk)+1));
            end
        end
    end
    Lfx(Yjj)=sumn/sumd;
end

max_difference_x = max(abs(Lfx-my_Lfx));

clear Xi Yj Zk Xii Yjj Zkk

cube_ny = (youngs_X ./ (onescube - poisson_X)) .* d_X .* d_Z;
cube_dy = ((youngs_X./(onescube-poisson_X)).*d_X.*d_Z)./(d_Y.*(cte_X.*delT+onescube));

cube_ny(mask_ckMatl_or_Melt) = 0;
cube_dy(mask_ckMatl_or_Melt) = 0;

% sum the planes of the 1st and 3rd dimensions
% https://www.mathworks.com/help/matlab/ref/sum.html
sumny = sum(cube_ny,[2 3]);
sumdy = sum(cube_dy,[2 3]);

my_Lfy = sumny ./ sumdy
my_Lfy = my_Lfy'

% y-direction final length
for Xii=1:NRx
    sumn=0;
    sumd=0;
    for Zk=1:NLz
        for Yj=1:NCy
            % Skip locations that have no material, IBC's, Fluid and
            % non-zero Melt fractions
            if  ckMatl(Xii,Yj,Zk) == 0 || Melt(Xii,Yj,Zk) > 0
                sumn=sumn+0;
                sumd=sumd+0;
            else
                sumn=sumn+(EY(Mats(Xii,Yj,Zk))/(1-nuY(Mats(Xii,Yj,Zk))))*dx(Xii)*dz(Zk);
                sumd=sumd+((EY(Mats(Xii,Yj,Zk))/(1-nuY(Mats(Xii,Yj,Zk))))*dx(Xii)*dz(Zk))/(dy(Yj)*(cteY(Mats(Xii,Yj,Zk))*delT(Xii,Yj,Zk)+1));
            end
        end
    end
    Lfy(Xii)=sumn/sumd;
end

max_difference_y = max(abs(Lfy-my_Lfy));

clear Xi Yj Zk Xii Yjj Zkk

cube_nz = (youngs_X ./ (onescube - poisson_X)) .* d_X .* d_Y;
cube_dz = ((youngs_X./(onescube-poisson_X)).*d_X.*d_Y)./(d_Z.*(cte_X.*delT+onescube));

cube_nz(mask_ckMatl_or_Melt) = 0;
cube_dz(mask_ckMatl_or_Melt) = 0;

% sum the planes of the 1st and 3rd dimensions
% https://www.mathworks.com/help/matlab/ref/sum.html
sumnz = sum(cube_nz,[1 2]);
sumdz = sum(cube_dz,[1 2]);

my_Lfz = sumnz ./ sumdz
% my_Lfz = squeeze(squeeze(my_Lfz))
% my_Lfz = my_Lfz'

% z-direction final length
for Zkk=1:NLz
    sumn=0;
    sumd=0;
    for Xi=1:NRx
        for Yj=1:NCy
            % Skip locations that have no material, IBC's, Fluid and
            % non-zero Melt fractions
            if  ckMatl(Xi,Yj,Zkk) == 0 || Melt(Xi,Yj,Zkk) > 0
                sumn=sumn+0;
                sumd=sumd+0;
            else
                sumn=sumn+(EZ(Mats(Xi,Yj,Zkk))/(1-nuZ(Mats(Xi,Yj,Zkk))))*dx(Xi)*dy(Yj);
                sumd=sumd+((EZ(Mats(Xi,Yj,Zkk))/(1-nuZ(Mats(Xi,Yj,Zkk))))*dx(Xi)*dy(Yj))/(dz(Zkk)*(cteZ(Mats(Xi,Yj,Zkk))*delT(Xi,Yj,Zkk)+1));
            end
        end
    end
    Lfz(Zkk)=sumn/sumd;
end

% max_difference_z = max(abs(Lfz-my_Lfz));

clear Xi Yj Zk Xii Yjj Zkk

% make stress cubes
stresscube_x = zeros(mat_size);
stresscube_y = zeros(mat_size);
stresscube_z = zeros(mat_size);
stresscube_x(mask_ckMatl_or_Melt) = NaN;
stresscube_y(mask_ckMatl_or_Melt) = NaN;
stresscube_z(mask_ckMatl_or_Melt) = NaN;

Lfx_cube = repmat(my_Lfx', [1 length(dy) length(dz)]);
Lfy_cube = repmat(my_Lfy, [length(dx) 1 length(dz)]);
Lfz_cube = repmat(my_Lfz, [length(dx) length(dy) 1]);

stresscube_x=(youngs_X./(onescube-poisson_X)).*((Lfx_cube./(d_X.*(cte_X.*delT+onescube)))-onescube);
stresscube_y=(youngs_X./(onescube-poisson_X)).*((Lfy_cube./(d_Y.*(cte_X.*delT+onescube)))-onescube);
stresscube_z=(youngs_X./(onescube-poisson_X)).*((Lfz_cube./(d_Z.*(cte_X.*delT+onescube)))-onescube);

% Loop over all elements to claculate stress due to CTE mismatch for each
% element
for Zkk=1:NLz
    for Xii=1:NRx
        for Yjj=1:NCy
            if  ckMatl(Xii,Yjj,Zkk) == 0 || Melt(Xii,Yjj,Zkk) > 0
                stressx(Xii,Yjj,Zkk,t)=NaN;
                stressy(Xii,Yjj,Zkk,t)=NaN;
                stressz(Xii,Yjj,Zkk,t)=NaN;
            else
                if 1
                    [Xii Yjj Zkk]
                    assert(Lfx_cube(Xii,Yjj,Zkk)==Lfx(Yjj));
                    assert(Lfy_cube(Xii,Yjj,Zkk)==Lfy(Xii));
                    assert(Lfy_cube(Xii,Yjj,Zkk)==Lfz(Zkk));
%                     assert(youngs_X(Xi,Yjj,Zk) == EX(Mats(Xi,Yjj,Zk)));
%                     assert(poisson_X(Xi,Yjj,Zk) == nuX(Mats(Xi,Yjj,Zk)));
%                     assert(cte_X(Xi,Yjj,Zk) == cteX(Mats(Xi,Yjj,Zk)));
%                     assert(cube_nx(Xi,Yjj,Zk) == (EX(Mats(Xi,Yjj,Zk))/(1-nuX(Mats(Xi,Yjj,Zk))))*dy(Yjj)*dz(Zk));
%                     assert(cube_dx(Xi,Yjj,Zk) == ((EX(Mats(Xi,Yjj,Zk))/(1-nuX(Mats(Xi,Yjj,Zk))))*dy(Yjj)*dz(Zk))/(dx(Xi)*(cteX(Mats(Xi,Yjj,Zk))*delT(Xi,Yjj,Zk)+1)));
                end
                stressx(Xii,Yjj,Zkk,t)=(EX(Mats(Xii,Yjj,Zkk))/(1-nuX(Mats(Xii,Yjj,Zkk))))*((Lfx(Yjj)/(dx(Xii)*(cteX(Mats(Xii,Yjj,Zkk))*delT(Xii,Yjj,Zkk)+1)))-1);
                stressy(Xii,Yjj,Zkk,t)=(EY(Mats(Xii,Yjj,Zkk))/(1-nuY(Mats(Xii,Yjj,Zkk))))*((Lfy(Xii)/(dy(Yjj)*(cteY(Mats(Xii,Yjj,Zkk))*delT(Xii,Yjj,Zkk)+1)))-1);
                stressz(Xii,Yjj,Zkk,t)=(EZ(Mats(Xii,Yjj,Zkk))/(1-nuZ(Mats(Xii,Yjj,Zkk))))*((Lfz(Zkk)/(dz(Zkk)*(cteZ(Mats(Xii,Yjj,Zkk))*delT(Xii,Yjj,Zkk)+1)))-1);
            end
        end
    end
end

clear Xi Yj Zk Xii Yjj Zkk


% Stress check, sum forces to be sure they go to zero
SumforceX=0;
SumforceY=0;
SumforceZ=0;

% Trinity 07-07-20
[cubex, cubey, cubez] = meshgrid(dy, dx, dz);

ForceX=stressx.*cubey.*cubez;
ForceY=stressy.*cubex.*cubez;
ForceZ=stressz.*cubey.*cubex;

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


fprintf('Net Force X: %f, Y: %f, Z: %f\n',SumforceX, SumforceY, SumforceZ)
return
