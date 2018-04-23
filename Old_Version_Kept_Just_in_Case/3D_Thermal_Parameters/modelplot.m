function [] = modelplot(master,solrows,removeencap)
R2=solrows;
scale=1000;
a=0.05;
b=1;
c=0.5;
[rg,~]=size(master);                                                         % rows in master matrix
xmaster=master(:,1:4);                                                       % top plane x dimentions
ymaster=master(:,10:13);                                                     % top plane y dimensions
z=master(:,end);                                                             % z layer stack coordinates       
xs1=xmaster;
zs1=zeros(rg,4);
xs4=zeros(rg,4);
ys1=zeros(rg,4);
ys4=zeros(rg,4);
tt=unique(master(1:solrows,6));
[xl,~]=size(tt);                                                            % number of rows with unique height equalt to Num Layers
zhold=zeros(rg,1);
R1=0;
zextra=[z;0];
for i=1:xl
rows=find(master(1:solrows,6)==tt(i,1));
if length(rows)>1
    for ii=1:rg/solrows
for iii=1:length(rows)
    zhold(rows(iii,1)+R1,1)=zextra(rows(end,1)+R1+1,1);
end
R1=R1+solrows;
    end
else
    for ii=1:rg/solrows
    zhold(rows+R1,1)=zextra(rows+R1+1,1);
    R1=R1+solrows;
    end
end
R1=0;
end
xs4(:,1:4)=[xmaster(:,1) xmaster(:,1) xmaster(:,1) xmaster(:,1)];
ys1(:,1:4)=[ymaster(:,1) ymaster(:,1) ymaster(:,1) ymaster(:,1)];
ys4(:,1:2)=ymaster(:,2:3);
ys4(:,3:4)=ymaster(:,[1,4]);
zs1(:,[1 4])=[z z];
for i=1:rg/solrows
zhold(R2,1)=master(R2,14)+master(R2,15);
R2=R2+solrows;
end
% master
zs1(:,2:3)=[zhold zhold];
z=[zhold zhold zhold zhold];
zs4=zs1;
% zs4;
hold on
count=1;
for i=1:rg/solrows
    for ii=1:solrows-removeencap
fill3((xmaster(count,:))*scale,(ymaster(count,:))*scale,(z(count,:))*scale,[a b c],'edgecolor','white'); %Top Device Plot
fill3((xs1(count,:))*scale,(ys1(count,:))*scale,(zs1(count,:))*scale,[a b c],'edgecolor','white'); %Top Device Plot
fill3((xs4(count,:))*scale,(ys4(count,:))*scale,(zs4(count,:))*scale,[a b c],'edgecolor','white'); %Top Device Plot
count=count+1;
    end
end
% axis tight
view([-5,-5,5])
    xlabel('x (mm)','FontSize',10)                                     % x-label definition
    h=get(gca,'xlabel');                                                    % call x-label 
    set(h,'rotation',25)                                                    % rotate x-label
    ylabel('y(mm)','FontSize',10)
    h=get(gca,'ylabel');
    zlabel('Thickness (mm)','FontSize',10)
    set(h,'rotation',-25)
