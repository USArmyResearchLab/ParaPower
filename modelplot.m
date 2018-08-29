function [] = modelplot(master,georow,removeencap,colors,dz)

%variable documentation
%georow: origin - ParaPowerGUI; unedited since - ParaPowerGUI


scale=1000;
[rg,~]=size(master);                                                         % rows in master matrix
xmaster=master(:,1:4);                                                       % top plane x dimentions
ymaster=master(:,10:13);                                                     % top plane y dimensions
z=master(:,end);                                                             % z layer stack coordinates
xs1=xmaster;
% zs1=zeros(rg,4);
zs1 = [z z+dz(master(:,6))' z+dz(master(:,6))' z];                           %upper and lower z coordinates for each feature, for rendering
zs4 = zs1;
z = [z+dz(master(:,6))' z+dz(master(:,6))' z+dz(master(:,6))' z+dz(master(:,6))']; %upper z coordinates for each feature, for rendering
xs4=zeros(rg,4);
ys1=zeros(rg,4);
ys4=zeros(rg,4);


xs4(:,1:4)=[xmaster(:,1) xmaster(:,1) xmaster(:,1) xmaster(:,1)];
ys1(:,1:4)=[ymaster(:,1) ymaster(:,1) ymaster(:,1) ymaster(:,1)];
ys4(:,1:2)=ymaster(:,2:3);
ys4(:,3:4)=ymaster(:,[1,4]);

count=1;
view([-5,-5,5])
hold on
for i=1:rg/georow
    if removeencap
        for ii = 1:georow
            if master(count,7) ~= 5
                fill3((xmaster(count,:))*scale,(ymaster(count,:))*scale,(z(count,:))*scale,colors(master(count,7),:),'edgecolor','white'); %Top Device Plot
                fill3((xs1(count,:))*scale,(ys1(count,:))*scale,(zs1(count,:))*scale,colors(master(count,7),:),'edgecolor','white'); %Top Device Plot
                fill3((xs4(count,:))*scale,(ys4(count,:))*scale,(zs4(count,:))*scale,colors(master(count,7),:),'edgecolor','white'); %Top Device Plot
            end
            count=count+1;
        end
    else
        for ii=1:georow                                            %solrows boils down to number of layers, or handles.NL
            
            fill3((xmaster(count,:))*scale,(ymaster(count,:))*scale,(z(count,:))*scale,colors(master(count,7),:),'edgecolor','white'); %Top Device Plot
            fill3((xs1(count,:))*scale,(ys1(count,:))*scale,(zs1(count,:))*scale,colors(master(count,7),:),'edgecolor','white'); %Top Device Plot
            fill3((xs4(count,:))*scale,(ys4(count,:))*scale,(zs4(count,:))*scale,colors(master(count,7),:),'edgecolor','white'); %Top Device Plot
            
            count=count+1;
        end
    end
end

xlabel('x (mm)','FontSize',10)                                     % x-label definition
h=get(gca,'xlabel');                                                    % call x-label
set(h,'rotation',25)                                                    % rotate x-label
ylabel('y(mm)','FontSize',10)
h=get(gca,'ylabel');
zlabel('Thickness (mm)','FontSize',10)
set(h,'rotation',-25)
