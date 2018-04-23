function [layerstack] = layerstack( layerdata )
[~,L]=size(layerdata);
layerstack(:,1:2)=layerdata(:,1:2);
layerstack(1,3)=0;
for i= 1:L
layerstack(i+1,3)=layerstack(i,3)+layerstack(i,1);
end

