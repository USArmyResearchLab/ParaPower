
load('Copper_Core.ppmodel','-mat')
%load('4Chip_Module.ppmodel','-mat')
clear O
tic
O=ThermalObj(Results.Model);
% O=ThermalObj();
% O=O.Init(Results.Model);
% O=O.RunTime(Results.Model.GlobalTime);
Out=step(O,Results.Model.GlobalTime);

ObjTime=toc;

tic
[Tres,ModelInput,PHres] = ParaPowerThermal(Results.Model);
FunTime=toc;
fprintf('Object Time %f, Function Time %f\n',ObjTime,FunTime)

figure(1)
subplot(1,2,1)
cla;Visualize('Object',Results.Model,'state',Out.Tres(:,:,:,end),'btnlinint')
subplot(1,2,2)
cla;Visualize('Function',Results.Model,'state',Tres(:,:,:,end))
Delta=Tres(:,:,:,end)-Out.Tres(:,:,:,end);
fprintf('Delta -> Max: %f, Min: %f\n',max(Delta(:)),min(Delta(:)));


