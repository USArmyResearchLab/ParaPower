    
%Template: Describe what this test case consists of

%Clear the main variables that are passed out from it.
clear Features ExternalConditions Params PottingMaterial Descr
Features.x=[]; Features.y=[]; Features.z=[]; Features.Matl=[]; Features.Q=[]; Features.Matl=''; 
Features.dz=0; Features.dy=0; Features.dz=0;

Desc='Test Case Template';  %Description of the test case

    clear Features ExternalConditions Params PottingMaterial
    
    ExternalConditions.h_Left=0;
    ExternalConditions.h_Right=0;
    ExternalConditions.h_Front=0;
    ExternalConditions.h_Back=0;
    ExternalConditions.h_Top=0;
    ExternalConditions.h_Bottom=0;

    ExternalConditions.Ta_Left=20;
    ExternalConditions.Ta_Right=20;
    ExternalConditions.Ta_Front=20;
    ExternalConditions.Ta_Back=20;
    ExternalConditions.Ta_Top=50;
    ExternalConditions.Ta_Bottom=40;

    ExternalConditions.Tproc=280;

    Params.Tinit     = 30;
    Params.DeltaT    = .2e-2;
    Params.Tsteps    = 20;

    PottingMaterial  = 0;
    
    %rectangular channel with right angle fin unit cell
    cell_w = 0.005;
    w_div = 4;
    cell_h = 0.005;
    h_div = 6;
    ch_w = .004;
    ch_h = .004;
    ch_len = .1;
    ibc_num = 10;
    ibc_div = 2;
    ibc_h = 500;
    ibc_Ta = 20;
    
    MatF=MaterialDatabase('nonmodal');
    Mats=getappdata(MatF,'Materials');
    close(MatF)
    
    cellmat=struct2cell(Mats);
    
    for i=1:ibc_num
        cellmat{1}{end+1}=['ibc_' num2str(i)];
        cellmat{2}{end+1}='IBC';
        for j=3:13
            cellmat{j}(end+1)=NaN;
        end
        cellmat{14}(end+1)=ibc_h;
        cellmat{15}(end+1)=ibc_Ta;
    end
    
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
    Features(2).Matl = 'PureTemp 29';
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
TestCaseModel.Features=Features;
TestCaseModel.Params=Params;
TestCaseModel.PottingMaterial=PottingMaterial;
TestCaseModel.ExternalConditions=ExternalConditions;
TestCaseModel.Desc=Desc;
TestCaseModel.MatLib=cell2struct(cellmat,fieldnames(Mats),1);
