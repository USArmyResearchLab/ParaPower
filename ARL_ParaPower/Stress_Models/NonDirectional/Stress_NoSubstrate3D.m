%% Stress_NoSubstrate3D (calculation of 3D stresses X, Y, and Z)
% Stress_NoSubstrate3D calculates stresses X, Y, and Z at one timestep. The 4th dimension (time) is expanded in
% Stress_NoSubstrate3D_time, which is also where Von Mises stress is
% calculated. Original code written by Dr. Miner exists as
% Stress_NoSubstrate_orig.

%% Input and Output: 
% * Results is PPResults object, time is the timestep at which the stresses
% are being calculated at
% optional VECTORIZED parameter can be added to indicate whether to run vectorized (VECTORIZED = 1) or original sequential
% code
% * stressx, stressy, and stressz are 3D arrays which represent stress X,
% stress Y, and stress Z at the input timestep. 

function [stressx,stressy,stressz] = Stress_NoSubstrate3D (Results, time)
% This function calculates the thermal stress based on CTE mismatch for each element in the model.
% This is a quasi 3-D approach that sums the forces in one plane to get the
% final length of all the elements in that plane. Each plane is taken
% individually capturing intra-planar effects (2-D). The 3-D effects are
% captured by considering multiple planes in each direction. The
% following planes are used in calculating the final length in each
% direction; x-Direction: y-z plane; y-direction: x-z plane; z-Direction:
% x-y plane.

%% TC modifications:
% * Vectorized the original sequential code
% * Changed indices from (y,x,z) to (x,y,z) to match with GUI.
% * Divided code into five main subfunctions: initialization, x-direction length, y-direction
% length, z-direction length, and final stress calculations
% * Created mask LF_ALL_PCM for situations in which stress cannot be calculated


%% Load Temperature Results, Melt Fraction Results and Processing Temp
% Set LF_ALL_PCM for the mask value used when stress cannot be calculated
% e.g. when entire layer is PCM, division by zero
LF_ALL_PCM = NaN;

Temp4D = Results.getState('Thermal');
% problem found in s021_SimpleNonD
% thermal model is 1000, but globaltime is 1001
assert(time<=size(Temp4D,4));
Temp = Temp4D(:,:,:,time);

Melt4D = Results.getState('MeltFrac');
Melt = Melt4D(:,:,:,time);

ProcT = Results.Model.Tproc;

% Load material properties E, cte, nu
EX = Results.Model.MatLib.GetParam('E');
EY = Results.Model.MatLib.GetParam('E');
EZ = Results.Model.MatLib.GetParam('E');
nuX = Results.Model.MatLib.GetParam('nu');
nuY = Results.Model.MatLib.GetParam('nu');
nuZ = Results.Model.MatLib.GetParam('nu');
cteX = Results.Model.MatLib.GetParam('cte');
cteY = Results.Model.MatLib.GetParam('cte');
cteZ = Results.Model.MatLib.GetParam('cte');

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

% if VECTORIZED == 1
    
    % initialize Young's Modulus, Poisson's Ratio, and CTE cubes
    mat_size = size(Mats);
    youngs = zeros(mat_size);
    poisson = zeros(mat_size);
    cte = zeros(mat_size);
    onescube = ones(mat_size);
    
    % expand dx, dy, and dz into 3D cubes
    d_X = repmat(dx', [1 length(dy) length(dz)]);
    d_Y = repmat(dy, [length(dx) 1 length(dz)]);
    d_Z = zeros(1,1,length(dz));
    d_Z(1,1,:) = dz;
    d_Z = repmat(d_Z, [length(dx) length(dy) 1]);
    
    % TC-modified vectorized code
    
    do_init_vec;
    
    ckMatl = do_Matl_vec;
    
    % mask for excluding exclude non-Solid or melt materials when 
    % calculating final lengths
    mask_ckMatl_or_Melt = (ckMatl == 0) | (Melt > 0);
    
    Lfx_vec = do_x_vec;
    
    Lfy_vec = do_y_vec;
    
    Lfz_vec = do_z_vec;
    
    [stressx,stressy,stressz] = do_stress_vec;
    
% else
%     
%     %original Miner code (not vectorized)
%     
%     ckMatl = do_Matl;
%     
%     Lfx = do_x;
%     
%     Lfy = do_y;
%     
%     Lfz = do_z;
%     
%     [stressx,stressy,stressz] = do_stress;
%     
%     do_check;
%     
% end

return

%% Vectorized subfunctions

    function do_init_vec
        % calculate youngs_X, poisson_X, and cte_X
        % get the different material numbers in Mats
        mat_num = unique(Mats);
        
        % extract nonzero material numbers
        zero_mask = (mat_num ~= 0);
        lut_mat_num = mat_num(zero_mask);
        
        for i = 1:length(lut_mat_num)
            mat_no = lut_mat_num(i);
            mask = (Mats == mat_no);
            youngs(mask) = EX(mat_no);
            poisson(mask) = nuX(mat_no);
            cte(mask) = cteX(mat_no);
        end
        
        return
    end

    function ckMatl = do_Matl_vec
        
        lut = do_lut;
        
        % initialize ckMat
        mat_size = size(Mats);
        ckMatl = logical(zeros(mat_size));
        
        % PPMatSolid materials assigned true
        for i = 1:length(lut{1})
            mat_no = lut{1}(i);
            mask = (Mats == mat_no);
            ckMatl(mask) = lut{2}(i);
        end
        
        return
        
        % lut = look-up table matching material number to PPMatSolid
        % logical
        function lut = do_lut
            % get the different material numbers in Mats
            mat_num = unique(Mats);
            
            % extract nonzero material numbers
            zero_mask = (mat_num ~= 0);
            lut_mat_num = mat_num(zero_mask);
            
            %initialize lut_solid_mat so that same size as lut_mat_num
            lut_solid_mat = logical(zeros(size(lut_mat_num)));
            
            % see if material number is derived from PPMatSolid, if yes --> true
            % 07-21-20: this includes PCMs that have not melted yet (which
            % is why cannot compare using material object property "type")
            % lut_solid_mat(j) = strcmp(MatObj.Type,'Solid');
            for j = 1:length(lut_mat_num)
                MatObj = Results.Model.MatLib.GetMatNum(lut_mat_num(j));
                lut_solid_mat(j) = isa(MatObj,'PPMatSolid');
            end
            
            lut = {lut_mat_num, lut_solid_mat};
        end
    end

    function Lfx_vec = do_x_vec
        % x-direction final length
        
        cube_nx = (youngs ./ (onescube - poisson)) .* d_Y .* d_Z;
        cube_dx = ((youngs./(onescube-poisson)).*d_Y.*d_Z)./(d_X.*(cte.*delT+onescube));
        
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
    end

    function Lfy_vec = do_y_vec
        % calculate y-direction final length
        
        cube_ny = (youngs ./ (onescube - poisson)) .* d_X .* d_Z;
        cube_dy = ((youngs./(onescube-poisson)).*d_X.*d_Z)./(d_Y.*(cte.*delT+onescube));
        
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
    end

    function Lfz_vec = do_z_vec
        % calculate z-direction final length
        
        cube_nz = (youngs ./ (onescube - poisson)) .* d_X .* d_Y;
        cube_dz = ((youngs./(onescube-poisson)).*d_X.*d_Y)./(d_Z.*(cte.*delT+onescube));
        
        cube_nz(mask_ckMatl_or_Melt) = 0;
        cube_dz(mask_ckMatl_or_Melt) = 0;
        
        % sum the planes of the 1st and 2nd dimensions
        % https://www.mathworks.com/help/matlab/ref/sum.html
        sumnz = squeeze(sum(cube_nz,[1 2]));
        sumdz = squeeze(sum(cube_dz,[1 2]));
        
        Lfz_vec = sumnz' ./ sumdz';
        mask = (sumdz' == 0);
        Lfz_vec(mask) = LF_ALL_PCM;
    end

    function [stresscube_x,stresscube_y,stresscube_z] = do_stress_vec
        % pre-calculated cubes to be removed out of loops
        Lfx_cube = repmat(Lfx_vec', [1 length(dy) length(dz)]);
        Lfy_cube = repmat(Lfy_vec, [length(dx) 1 length(dz)]);
        Lfz_vec_mod(1,1,:) = Lfz_vec;
        Lfz_cube = repmat(Lfz_vec_mod, [length(dx) length(dy) 1]);
        
        % initialize stress cubes
        stresscube_x = zeros(mat_size);
        stresscube_y = zeros(mat_size);
        stresscube_z = zeros(mat_size);
        
        %%
        %
        % <<iPACK2019_eq3.PNG>>
        %
        % calculate stress
        stresscube_x = (youngs./(onescube-poisson)).*((Lfx_cube./(d_X.*(cte.*delT+onescube)))-onescube);
        stresscube_y = (youngs./(onescube-poisson)).*((Lfy_cube./(d_Y.*(cte.*delT+onescube)))-onescube);
        stresscube_z = (youngs./(onescube-poisson)).*((Lfz_cube./(d_Z.*(cte.*delT+onescube)))-onescube);
        
        % mask non-solids, melting
        stresscube_x(mask_ckMatl_or_Melt) = 0;
        stresscube_y(mask_ckMatl_or_Melt) = 0;
        stresscube_z(mask_ckMatl_or_Melt) = 0;
    end


%% Original Sequential Subfunctions
% Dr. Miner's code, encapsulated by TC into functions. Indices were changed from (y,x,z) to (x,y,z).
% Original code can be found at Stress_NoSubstrate_orig.

    function ckMatl = do_Matl
        % Loop over Cols, Rows and Lays to determine locations that have no
        % material, IBC's, or Fluid
        for i=1:n_dx
            for j=1:n_dy
                for k=1:n_dz
                    if Mats(i,j,k) == 0
                        ckMatl(i,j,k)=false;
                    else
                        MatObj = Results.Model.MatLib.GetMatNum(Mats(i,j,k));
                        ckMatl(i,j,k)=isa(MatObj,'PPMatSolid');
                    end
                end
            end
        end
    end


    function Lfx = do_x
        %Loop over Cols, Rows and Lays to determine the final x, y and z lengths of
        % the elements, as a result of the CTE mismatch between the materials in all the layers
        % x-direction final length
        for ii=1:n_dx
            sumn=0;
            sumd=0;
            for k=1:n_dz
                for j=1:n_dy
                    % Skip locations that have no material, IBC's, Fluid and
                    % non-zero Melt fractions
                    if  ckMatl(ii,j,k) == 0 || Melt(ii,j,k) > 0
                        sumn=sumn+0;
                        sumd=sumd+0;
                    else
                        sumn=sumn+(EX(Mats(ii,j,k))/(1-nuX(Mats(ii,j,k))))*dy(j)*dz(k);
                        sumd=sumd+((EX(Mats(ii,j,k))/(1-nuX(Mats(ii,j,k))))*dy(j)*dz(k))/(dx(ii)*(cteX(Mats(ii,j,k))*delT(ii,j,k)+1));
                    end
                end
            end
            if sumd == 0
                Lfx(ii) = LF_ALL_PCM;
                warning('No layers in x-layer %d support stress calculations',ii)
            else
                Lfx(ii)=sumn/sumd;
            end
        end
    end

    function Lfy = do_y
        % y-direction final length
        for jj=1:n_dy
            sumn=0;
            sumd=0;
            for k=1:n_dz
                for i=1:n_dx
                    % Skip locations that have no material, IBC's, Fluid and
                    % non-zero Melt fractions
                    if  ckMatl(i,jj,k) == 0 || Melt(i,jj,k) > 0
                        sumn=sumn+0;
                        sumd=sumd+0;
                    else
                        sumn=sumn+(EY(Mats(i,jj,k))/(1-nuY(Mats(i,jj,k))))*dx(i)*dz(k);
                        sumd=sumd+((EY(Mats(i,jj,k))/(1-nuY(Mats(i,jj,k))))*dx(i)*dz(k))/(dy(jj)*(cteY(Mats(i,jj,k))*delT(i,jj,k)+1));
                    end
                end
            end
            if sumd == 0
                Lfy(jj) = LF_ALL_PCM;
                warning('No layers in y-layer %d support stress calculations',jj)
            else
                Lfy(jj)=sumn/sumd;
            end
        end
    end

    function Lfz = do_z
        % z-direction final length
        for kk=1:n_dz
            sumn=0;
            sumd=0;
            for i=1:n_dx
                for j=1:n_dy
                    % Skip locations that have no material, IBC's, Fluid and
                    % non-zero Melt fractions
                    if  ckMatl(i,j,kk) == 0 || Melt(i,j,kk) > 0
                        sumn=sumn+0;
                        sumd=sumd+0;
                    else
                        sumn=sumn+(EZ(Mats(i,j,kk))/(1-nuZ(Mats(i,j,kk))))*dx(i)*dy(j);
                        sumd=sumd+((EZ(Mats(i,j,kk))/(1-nuZ(Mats(i,j,kk))))*dx(i)*dy(j))/(dz(kk)*(cteZ(Mats(i,j,kk))*delT(i,j,kk)+1));
                    end
                end
            end
            if sumd == 0
                Lfz(kk) = LF_ALL_PCM;
                warning('No layers in z-layer %d support stress calculations',kk)
            else
                Lfz(kk)=sumn/sumd;
            end
        end
    end

    function [stressx,stressy,stressz] = do_stress
        % rearranged equations to see difference when computations done in
        % different order
        % about 2 e-8 difference max 
        % func1 = @(A,B,C,D,E,F) (A/(1-B))*((C/(D*(E*F+1)))-1);
        % func2 = @(A,B,C,D,E,F) A*((C/(D*(E*F+1)))-1)/(1-B);
        
        % Loop over all elements to claculate stress due to CTE mismatch for each
        % element
        for kk=1:n_dz
            for ii=1:n_dx
                for jj=1:n_dy
                    if  ckMatl(ii,jj,kk) == 0 || Melt(ii,jj,kk) > 0
                        stressx(ii,jj,kk)=0;
                        stressy(ii,jj,kk)=0;
                        stressz(ii,jj,kk)=0;
                    else
                        stressx(ii,jj,kk)=(EX(Mats(ii,jj,kk))/(1-nuX(Mats(ii,jj,kk))))*((Lfx(ii)/(dx(ii)*(cteX(Mats(ii,jj,kk))*delT(ii,jj,kk)+1)))-1);                     
                        stressy(ii,jj,kk)=(EY(Mats(ii,jj,kk))/(1-nuY(Mats(ii,jj,kk))))*((Lfy(jj)/(dy(jj)*(cteY(Mats(ii,jj,kk))*delT(ii,jj,kk)+1)))-1);
                        stressz(ii,jj,kk)=(EZ(Mats(ii,jj,kk))/(1-nuZ(Mats(ii,jj,kk))))*((Lfz(kk)/(dz(kk)*(cteZ(Mats(ii,jj,kk))*delT(ii,jj,kk)+1)))-1);
                    end
                end
            end
        end
    end

    function do_check
        % Stress check, sum forces to be sure they go to zero
        SumforceX=0;
        SumforceY=0;
        SumforceZ=0;
        for ii=1:n_dx
            for jj=1:n_dy
                for kk=1:n_dz
                    ForceX(ii,jj,kk)=stressx(ii,jj,kk)*dy(jj)*dz(kk);
                    SumforceX=SumforceX+ForceX(ii,jj,kk);
                    ForceY(ii,jj,kk)=stressy(ii,jj,kk)*dx(ii)*dz(kk);
                    SumforceY=SumforceY+ForceY(ii,jj,kk);
                    ForceZ(ii,jj,kk)=stressz(ii,jj,kk)*dx(ii)*dy(jj);
                    SumforceZ=SumforceZ+ForceZ(ii,jj,kk);
                end
            end
        end
    end

end

%% Debugging and verification
    function equ = cube_comp (a,b)
        % verification for comparison of vectorized/sequential cubes
        assert(nnz(isnan(a))==0);
        assert(nnz(isnan(b))==0);
        
        % doesn't work below 0.0005
        threshold = 0.0008;
        
        diff = ((a-b).^2).^0.5;
        diff_max = max(diff,[],'all');
        equ = diff_max < threshold;
        return
        
        if 0
            % does not work because of positive and negative values
            threshold = 0.01;
            diff = abs(a-b);
            diff_max = max(diff,[],'all');
            a_max = max(abs(a),[],'all');
            b_max = max(abs(b),[],'all');
            ab_max = max(a_max,b_max);
            diff_max_percent = diff_max / ab_max;
            
            equ = diff_max_percent < threshold;
        end
    end
