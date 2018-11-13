function [layerstack] = layerconfig( layerdata )
[L,~]=size(layerdata);
if L<1
    disp less
end
layerstack(:,1)=layerdata(:,1);
layerstack(1,2)=0;
for i= 1:L-1
layerstack(i+1,2)=layerstack(i,2)+layerstack(i,1);
end
