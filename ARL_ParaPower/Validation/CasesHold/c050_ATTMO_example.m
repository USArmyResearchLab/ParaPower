    
%Template: Describe what this test case consists of

%Clear the main variables that are passed out from it.
clear Features ExternalConditions Params PottingMaterial Descr
Features.x=[]; Features.y=[]; Features.z=[]; Features.Matl=[]; Features.Q=[]; Features.Matl=''; 
Features.dz=0; Features.dy=0; Features.dz=0;

Desc='ATTMO Model Definition Example';  %Description of the test case

    clear Features ExternalConditions Params PottingMaterial
    
    
    %MatLib=PPMatLib;  %instantiate empty material database object.
    load('DefaultMaterials.mat');
    
    ExternalConditions.h_Xminus=0;
    ExternalConditions.h_Xplus =0;
    ExternalConditions.h_Yminus=0;
    ExternalConditions.h_Yplus =0;
    ExternalConditions.h_Zminus=0;
    ExternalConditions.h_Zplus =0;
    
    ExternalConditions.Ta_Xminus=20;
    ExternalConditions.Ta_Xplus =20;
    ExternalConditions.Ta_Yminus=20;
    ExternalConditions.Ta_Yplus =20;
    ExternalConditions.Ta_Zminus=50;
    ExternalConditions.Ta_Zplus =40;

    ExternalConditions.Tproc=280;

    Params.Tinit     = 30;
    Params.DeltaT    = .2e-2;
    Params.Tsteps    = 20;

    PottingMaterial  = 0;
    
    %rectangular channel with right angle fin unit cell
    cell_w = 0.005;
    w_div = 2;
    cell_h = 0.005;
    h_div = 2;
    ch_w = .004;
    ch_h = .004;
    ch_len = .1;
    ibc_num = 10;
    ibc_div = 1;
    ibc_h = 500;
    ibc_Ta = 20;
        

    
    for i=1:ibc_num
        MatLib.AddMatl(PPMatIBC('name'  , ['ibc_' num2str(i)]  ...
            ,'h_ibc'   , ibc_h...
            ,'t_ibc'     , ibc_Ta...
            )) ;
    end
    
   MatLib.AddMatl(PPMatSCPCM(  'name'  , 'KNH'  ...
                           ,'k_l'   , .2    ...
                           ,'rho_l' , 6093  ...
                           ,'cp_l'  , 397   ...
                           ,'lf'    , 80300 ...
                           ,'tmelt' , 28  ...
                           ,'cte'   , 0     ...
                           ,'E'     , 0     ...
                           ,'nu'    , 0     ...
                           ,'k'     , .2  ...
                           ,'rho'   , 5903  ...
                           ,'cp'    , 340   ...
                           ,'dT_Nucl', 5 ...
                        )) ;
    
    %MoreMats=cell2struct(cellmat,fieldnames(Mats),1);
    
    %Fin structure
    Features(1).x    = [0 cell_w];
    Features(1).y    = [0 ch_len];
    Features(1).z    = [0 cell_h];
    Features(1).dx   = w_div;
    Features(1).dy   = 1;
    Features(1).dz   = h_div;
    Features(1).Matl = 'Cu';
    Features(1).Q    = 0;

    %PCM channel
    Features(2).x    = [cell_w-ch_w cell_w];  %locates in upper right
    Features(2).y    = [0 ch_len];
    Features(2).z    = [cell_h-ch_h cell_h];
    Features(2).dx   = 1;
    Features(2).dy   = 1;
    Features(2).dz   = 1;
    Features(2).Matl = 'KNH';
    Features(2).Q    = 0;  %'0.3*sin(0.25*t)+0.3';
    
    ys=[0 ch_len/ibc_num];
    for i=1:ibc_num
        Features(end+1)=Features(end);    
        Features(end).x    = [0 cell_w];  %locates in upper right
        Features(end).y    = ys;
        ys=ys+ch_len/ibc_num;
        Features(end).z    = [-.001 0];
        Features(end).dx   = 1;
        Features(end).dy   = ibc_div;
        Features(end).dz   = 1;
        Features(end).Matl = ['ibc_' num2str(i)];
        Features(end).Q    = 0;
    
    end
    
   
    %{
    Features(3)=Features(2);
    Features(3).z    = [.01 .01];
    Features(3).dz   = 1;
    Features(3).Matl = 'Cu';
    Features(3).Q    = 0;
    %}

    
%Assemble the above definitions into a single variablel that will be used
%to run the analysis.  This is the only variable that is used from this
%M-file.  
TestCaseModel.Desc=Desc;
TestCaseModel.TCM=PPTCM;
TestCaseModel.TCM.Features=Features;
TestCaseModel.TCM.Params=Params;
TestCaseModel.TCM.PottingMaterial=PottingMaterial;
TestCaseModel.TCM.ExternalConditions=ExternalConditions;
TestCaseModel.TCM.MatLib=MatLib;
TestCaseModel.TCM.VariableList={};
%TestCaseModel.TCM.Version='V3.0';

MI=FormModel(TestCaseModel.TCM);
MI.GlobalTime=[-1,-.01];  %hijinks so that ATTMO can take the first timestep to be at t=0

s1 = sPPT('MI',MI);
[T_out,T_in,PH_out,PH_in]=s1(MI.GlobalTime);
