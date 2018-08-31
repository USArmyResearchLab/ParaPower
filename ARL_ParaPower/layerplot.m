function [] = layerplot(xlayout,ylayout,zlayout,matcolors,xgrid,ygrid,toplayer,ND)
devlayers=find(xlayout(:,5)>0);
scale=1000;                                                                 %plot scale defined
hold on
axis tight
axis square
shiftx=xlayout(1,1);                                                             %shift required to place corner of board at (0,0)
shifty=ylayout(1,1);
zlayout=[zlayout(:,2),zlayout(:,2),zlayout(:,2),zlayout(:,2)];
ztop=zlayout(end,2);
it=max(find(xlayout(:,6)==toplayer));
for i=1:it
    fill3((xlayout(i,1:4)-shiftx)*scale,(ylayout(i,1:4)-shifty)*scale,zlayout(i,1:4),matcolors(xlayout(i,7),:));   % fill pad top side into plot. 
end
xgrid=[xgrid;xgrid]; 
ygrid=[ygrid;ygrid];
zgrid=[zlayout(end,1:4);zlayout(end,1:4)];
for i=1:length(xgrid)
plot3((xgrid(:,i)-shiftx)*scale,([ygrid(1,1);ygrid(1,end)]-shifty)*scale,zgrid,'k')                        % plots grids that extend from the y-min to the y-max at all instances of a grid in the x-direction 
end
for i=1:length(ygrid)
plot3(([xgrid(1,1);xgrid(1,end)]-shiftx)*scale,(ygrid(:,i)-shifty)*scale,zgrid,'b')                        % plots grids that extend from the x-min to the x-max at all instances of a grid in the y-direction
end
xlabel('Length (mm)','FontSize',10)                                         %defines axis labels
ylabel('Width (mm)','FontSize',10)
ii=1;
% Device Text Numbering
   for i=1:ND
    txt = ['#' num2str(i)];                                                     % defines the device number
    xcntr=(xlayout(devlayers(i,1),2)+xlayout(devlayers(i,1),3))/2;
    ycntr=(ylayout(devlayers(i,1),1)+ylayout(devlayers(i,1),2))/2;
    text((xcntr-shiftx)*scale,(ycntr-shifty)*scale,ztop,txt,'Color','white')
   end
end

