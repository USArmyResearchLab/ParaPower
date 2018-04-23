function [ ] = modelgeneration(layerdata,matlist,NL,layoutint) %% not functioning 
[lb,~]=size(layerdata);                                                     % move to independent function
bmat=zeros(lb,1);                                                           % initialize bmat matrix
for iii=1:lb
for ii=1:length(matlist)
if strcmp(layerdata(iii,1),matlist(ii,1))==1                        % Compare material selection with material list and based on index assign bmat with material number
    bmat(iii,1)=ii;                                 
end
end
end

layerdata=cell2mat(layerdata(:,2));
[layerstack]=layerconfig(layerdata);
count=1;
count2=1;
count3=1;
for i=1: NL
    if  layoutint(i,1)>0 &&  layoutint(i,1)<99
        n=num2str( layoutint(i,1));
geodata=get( (['layout',n,'geotable']),'data');
[lg,~]=size(geodata);
featmat=zeros(lg,1);
for iii=1:lg
for ii=1:length( matlist)                                            %move to independent function
if strcmp(geodata(iii,1), matlist(ii,1))==1
    featmat(iii,1)=ii;
end
end
end
geodata=cell2mat(geodata(:,2:6));
featdata=get( (['layout',num2str( layoutint(i,1)),'feattable']),'data');
geofeat=get( (['layout',num2str( layoutint(i,1)),'geotable']),'rowname');
if iscell(featdata)==1
sumfeat=sum(cell2mat(featdata));
else
    sumfeat=sum((featdata));
end
[ln,~]=size(geofeat);
layoutnum=zeros(ln,1);
for ii=1:ln
    layoutnum(ii,1)=str2double(geofeat{ii,1}(9:end));
end
% sumfeat=sum( (['layout',num2str( layoutint(i,1)),'featdata']));
[x,y,z,X,Y] = featurecoordinates(layerstack,i,geodata,sumfeat,featmat, layoutint(i,1),layoutnum);
xlayout(count:count+sumfeat-1,1:9)=x;
ylayout(count:count+sumfeat-1,1:4)=y;
zlayout(count:count+sumfeat-1,1:2)=z;
Xlayout(count:count+sumfeat-1,1:2)=X;
Ylayout(count:count+sumfeat-1,1:2)=Y;
count=count+sumfeat;
count3=count3+sumfeat;
layoutnum=layoutnum+1;

% % count2=count2+sumfeat;
    elseif  layoutint(i,1)==99
        [bx,by,bz,bX,bY]=basecoordinates(i,layerstack,basedata);
        xlayout(count,1:9)=bx;
        ylayout(count,1:4)=by;
        zlayout(i,1:2)=bz;
% %         Xlayout(count:count+sumfeat-1,:)=X;
% %         Ylayout(count:count+sumfeat-1,:)=Y;
        count=count+1
    elseif  layoutint(i,1)==0
        xlayout(count,:)=[0 0 0 0 0 i bmat(i) 0 0];
        ylayout(count,1:4)=0;
        zlayout(count,1:2)=0;
        baselayers(count2,1)=i;                                             % saves row number in which base layers exist in original layer stack
        baselayers(count2,2)=count3;                                        % saves row numbers in which base layers will be published to 
        count=count+1;                                                      % count itterations could use more defining variable names
        count2=count2+1;
        count3=count3+1;
    end
end
basedata=get( basegeotable,'data');

[lb,~]=size(basedata);
basemat=zeros(lb,1);
for iii=1:lb
for ii=1:length( matlist)
if strcmp(basedata(iii,1), matlist(ii,1))==1
    basemat(iii,1)=ii;
%     count4=count4+1;
end
end
end
% pause
[lb,~]=size(baselayers);
% for i=1:length(baselayers)
if iscell(basedata)==1
basedata=cell2mat(basedata);
end
for i=1:lb
    row=baselayers(i,1);                                                    % layers number in which the z stack height needs to be pulled
    row2=baselayers(i,2);                                                   % row number in layout matrix in which base layer is published to 
[bx,by,bz,bX,bY] = basecoordinates(row,layerstack,basedata,xlayout,ylayout,Xlayout,Ylayout);
        xlayout(row2,1:6)=bx;
        ylayout(row2,1:4)=by;
        zlayout(row2,1:2)=bz;
%         Xlayout(count:count+sumfeat-1,:)=X;
%         Ylayout(count:count+sumfeat-1,:)=Y;
end
 xlayout=xlayout;
 ylayout=ylayout;
 zlayout=zlayout;
 bmat=bmat;
 layerstack=layerstack;
% x=xlayout;
% y=ylayout;
% z=zlayout;
% assignin('base','x',x)
% assignin('base','y',y)
% assignin('base','z',z)
% zlayout
% pause


end

