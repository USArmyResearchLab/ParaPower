clc
clf

if 1
    clear TestCaseModel
    TestCaseModel.ExternalConditions.h_Left=0;
    TestCaseModel.ExternalConditions.h_Right=0;
    TestCaseModel.ExternalConditions.h_Bottom=0;
    TestCaseModel.ExternalConditions.h_Top=10;
    TestCaseModel.ExternalConditions.h_Front=0;
    TestCaseModel.ExternalConditions.h_Back=0;
    TestCaseModel.ExternalConditions.Ta_Left=0;
    TestCaseModel.ExternalConditions.Ta_Right=0;
    TestCaseModel.ExternalConditions.Ta_Bottom=0;
    TestCaseModel.ExternalConditions.Ta_Top=0;
    TestCaseModel.ExternalConditions.Ta_Front=0;
    TestCaseModel.ExternalConditions.Ta_Back=0;
    TestCaseModel.ExternalConditions.Tproc=0;

    TestCaseModel.Features(1).x  =[0 .01];
    TestCaseModel.Features(end).y=[0 .01];
    TestCaseModel.Features(end).z=[0 .01];
    TestCaseModel.Features(end).Matl='Ga';
    TestCaseModel.Features(end).Q=0;
    TestCaseModel.Features(end).dx=20;
    TestCaseModel.Features(end).dy=20;
    TestCaseModel.Features(end).dz=10;
    TestCaseModel.Features(end).Desc='Encaps';

    TestCaseModel.Features(end+1).x=[0.002 0.008];
    TestCaseModel.Features(end).y  =[0.002 0.008];
    TestCaseModel.Features(end).z  =[0     0];
    TestCaseModel.Features(end).Matl='Al';
    TestCaseModel.Features(end).Q=100;
    TestCaseModel.Features(end).dx=1;
    TestCaseModel.Features(end).dy=1;
    TestCaseModel.Features(end).dz=1;
    TestCaseModel.Features(end).Desc='Heater';

    TestCaseModel.Features(end+1).x=[0.002  0.0055];
    TestCaseModel.Features(end).y  =[0.0045 0.0055];
    TestCaseModel.Features(end).z  =[0      0.011];
    TestCaseModel.Features(end).Matl='Hollow';
    TestCaseModel.Features(end).Q=0;
    TestCaseModel.Features(end).dx=1;
    TestCaseModel.Features(end).dy=1;
    TestCaseModel.Features(end).dz=1;
    TestCaseModel.Features(end).Desc='Hollow';

    TestCaseModel.Params.Tinit=0;
    TestCaseModel.Params.DeltaT=.05;
    TestCaseModel.Params.Tsteps=10;

    TestCaseModel.PottingMaterial=0;
    TestCaseModel.Version='V2.0';

    load DefaultMaterials
    MatLib.AddMatl(PPMatIBC('name','Hollow','T_IBC',0,'h_IBC',5))

    TestCaseModel.MatLib=MatLib;

    MI=FormModel(TestCaseModel);
else
    load('Single_Chip_Encapsulent.ppmodel','-mat', 'TestCaseModel')
    M=TestCaseModel.MatLib.GetMatName('hollow');
    MKeepList=find(~strcmpi(TestCaseModel.MatLib.MatList,'hollow'));
    M.h_ibc=5;
    TestCaseModel.MatLib=TestCaseModel.MatLib(MKeepList);
    TestCaseModel.MatLib.AddMatl(M);
    TestCaseModel.Params.DeltaT=0.05;
    %TestCaseModel.Features(1).Matl='Cu';
    MI=FormModel(TestCaseModel);
end

MIorig=MI;
for I=1:2
    MI=MIorig;        
    InitTime=MI.GlobalTime(1);    %Time at initializatio extracted from MI.GlobalTime
    ComputeTime=MI.GlobalTime(2:end); %extract time to compute states from MI.GlobalTime

    MI.GlobalTime=InitTime;  %Setup initialization
    S1=sPPT('MI',MI); %Initialize object

    if I==1 %Time Estimate
        [Tprnt, T_in, MeltFrac,MeltFrac_in]=S1(ComputeTime);  %Compute states at times in ComputeTime (S1 must be called with 1 arg in 2017b)
        Tprnt   =cat(4, T_in        , Tprnt   );
        MeltFrac=cat(4, MeltFrac_in , MeltFrac);
    elseif (I==2)  %THERE IS CURRENTLY  A PROBLEM WHERE STEP 4 HERE IS NOT THE SAME AS ABOVE
        StepsToEstimate=2;
        tic
        Eest=min(StepsToEstimate,length(ComputeTime));
        [Tprnt, T_in, MeltFrac,MeltFrac_in]=S1(ComputeTime(1:Eest));  %Compute states at times in ComputeTime (S1 must be called with 1 arg in 2017b)
        EstTime=toc;
        tic
        if length(ComputeTime)>StepsToEstimate
        %    AddStatusLine(sprintf('(Est. %.1s)',EstTime*(length(ComputeTime)-2)))
            [Tprnt2,~, MeltFrac2,~]=S1(ComputeTime(StepsToEstimate+1:end));  %Compute states at times in ComputeTime (S1 must be called with 1 arg in 2017b)
            Tprnt   =cat(4, T_in        , Tprnt   ,  Tprnt2   );
            MeltFrac=cat(4, MeltFrac_in , MeltFrac,  MeltFrac2);
        else
            Tprnt=cat(4,T_in,Tprnt);
            MeltFrac=cat(4,MeltFrac_in,MeltFrac);
        end
        ActTime=toc;
        fprintf('Estimated Time: %f, Actual Time %f\n',EstTime,ActTime)
    end 
    Tmatrix{I}=Tprnt;
end        

for I=1:2
    for K=1:length([InitTime ComputeTime])
        MaxTemp(K,I)=max(max(max(Tmatrix{I}(:,:,4:end,K))));
    end
end
if 0
    Tprnt_g=Tmatrix{1};
    Tprnt_s=Tmatrix{2};
    figure(1)
    clf
    subplot(1,3,1)
    Visualize('Global',MI,'state',Tprnt_g(:,:,:,end));
    subplot(1,3,2)
    Visualize('Segmented',MI,'state',Tprnt_s(:,:,:,end));
    subplot(1,3,3)
    Visualize('Segmented',MI,'state',Tprnt_s(:,:,:,end)-Tprnt_g(:,:,:,end));
end

figure(2)
clf
subplot(1,2,1)
plot(MIorig.GlobalTime,MaxTemp)
legend('Whole Time','Split Time')
title('Max Temperature')

subplot(1,2,2)
plot(abs(MaxTemp(:,2)-MaxTemp(:,1)))
title('Delta between two max temps.')
