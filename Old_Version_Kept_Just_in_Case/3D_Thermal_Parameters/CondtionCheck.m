function [masterlayout,quar,quardetails,quarenv] = ConditionCheck(Cond,envcnames,rx,masterlayout, envmaster)

%% Inputs
% clc
% close all
count1=1;
% BC={ 'Base Size' 'System' 'N/A' 0 0 0;...
%     'Distance: Fixed X' 'L5.1 F 1.3' 'L5.1 F 1.4' 10 1 10;...
%     'Layer Thickness' 'System' 'N/A' 0.1 0 0;...
%     'Module Volume' 'System' 'N/A' 0.000001 0 .0001};
% BC={'Distance: Range X' 'L5.1 F 1.1' 'L5.1 F 1.3' -.018 -.018 0};
% BC={'Module Volume' 'System' 'N/A' 0.000001 0.00001 .0001};
% BC={'Substrate Thickness Rat.' 'System' 'N/A' 0.2 0 0};
% BC={'Layer Thickness' 'L5.1 F 1.3' 'N/A' 0.000 0.0001 0};
% BE={ 'Distance: Fixed X' 'L5.1 F 1.3' 'L5.1 F 1.4' 10 1 10};
% BC={ 'Base Size' 'System' 'N/A' -0.001 0.001 0};

% BC={'Distance: Y' 'L5.1 F 1.3' 'L5.1 F 1.4' 100 0 0;...
%     'Layer Thickness' 'L5.1 F 1.3' 'N/A' 0.2 0 0;...
%     'Layer Thickness' 'L5.1 F 1.3' 'N/A' 0.1 0 0;...
%     'Base Border Size' 'System' 'N/A' -0.001 0.001 0;...
%     'Module Volume' 'System' 'N/A' 0.000001 10000 1;...
%     'Distance: Y' 'L5.1 F 1.3' 'L5.1 F 1.2' -1 50 1;...
%     'Module Volume' 'System' 'N/A' 0.000001 10 1};
    
% Base Border Size

% envcnames={'Left','Right','Front','Back','Bottom','Top'};
% BC={'Convection Coefficient (h)' 'System' 'N/A' 12 100;...
%     'Ambient Temp. (Ta)' 'Left' 'N/A' 99 100};
% BC={'Layer Thickness: Fixed' 'L5.1 F 1.3' 'N/A' 0.2 0 0}
% rx=11;
% masterlayout=group;
% masterlayout(7:9,:)
% masterlayout=[group*200;group;group*200];
RR=1;
RR2=rx;
group=masterlayout(RR:RR2,:);
for i=1:3
    masterlayout(RR:RR2,8)=i;
    RR=RR+rx;
    RR2=RR2+rx;
end
% envmaster=[10 10 10 10 1000 10; 20 20 20 20 20 20];
% envmaster=[envmaster; envmaster];
%% Program
[br,~]=size(Cond);
quardetails=cell(br,6);
count2=1;
count3=1;
% t=br/11;
% layerstack =[0.0100;0.0003;0.0006;0.0003;0.0005;0.0058];
% group1=[group layerst
% layout=[group;group+1;group*22];
Cond=cell(1,6);
[lx,ly]=size(masterlayout);                                                  % total length of master trial matrix
trials=lx/rx;                                                              % calculates total number of trial itterations
quar=zeros(lx,ly);
quarenv=zeros(trials*2,6);
for iii=1:br                                                                % itterates through each boundary condition to evaluate
    minval=Cond{count1,4};                                                     % retrieves initial value of BCmetric sweep
    maxval=Cond{count1,5};                                                     % retrieves final value of BCmetric sweep
if strcmp(Cond{count1,2},'System')==1                                         % checks feature column of B.C. for System
bus=find(group(:,8)==0);                                          % layers in each trial that are represented by a completly solid base layer
[lb,~]=size(bus);                                                 % finds number of layers in each itteration that are a base
elseif strcmp(Cond{count1,2},'N/A')==1                                        % checks feature column of B.C. for N/A
elseif isnan(str2double(Cond{count1,2}(1,end)))==0                            % check feature column for a feature number
    rownum=str2double(Cond{count1,2}(1,2));                                 % retrieves layer number that BCmeter influences
    featnum=str2double(Cond{count1,2}(1,end));                              % retrieves the layout feature number that BCmeter influences
    sublayers=find(group(:,6)==rownum);                                             % retrieves the rows of the xlayout matrix that are equal to the selected layer 
    bus=sublayers(1,1)+featnum-1;
else 
% %     bus=0;
% %     pause
end
if isnan(str2double(Cond{count1,3}(1,end)))==0                                % checks linked feature column for a feature number
    rownum2=str2double(Cond{count1,3}(1,2));                                 % retrieves layer number that BCmeter influences of associated
    featnum2=str2double(Cond{count1,3}(1,end));                              % retrieves the layout feature number that BCmeter influences
    layer2=find(group(:,6)==rownum2);                                             % retrieves the rows of the xlayout matrix that are equal to the selected layer 
    layers2=layer2(1,1)+featnum2-1;                                               % takes the first occurance of the edited layer and shifts to correct 
    bus2=layers2;
end
    R1=1;                                                                   % sets the starting row point for master matrix
    R2=rx;                                                                  % finds the end of the first trial's itteration of master matrix
    R3=0;                                                                   % sets the starting row as zero for base layer definition                                                            
    R4=1;
    R98=1;
    R99=rx;
    R100=1;
    iii
    bus
   [bx,~]=size(bus);        % finds itterations required of feature. 
%% Evaluate B.C.
for i=1:trials
    
%% Distance: X
if strcmp(Cond{count1,1}(1,end),'X')==1 
for ii=1:bx
cntfeat=(masterlayout(R1+bus(ii,1)-1,3)+masterlayout(R1+bus(ii,1)-1,2))/2; % temp stores the center coor. of the feature (passenger)
cntlinkedfeat=(masterlayout(R1+bus2(ii,1)-1,3)+masterlayout(R1+bus2(ii,1)-1,2))/2; % temp stores the center coor. of the linked feature (driver)
    if strcmp(Cond{count1,1},'Distance Fixed: X')==1                               % action required by a change in the X-Pos of any feature
        if cntfeat<cntlinkedfeat+minval
        masterlayout(R1+bus(ii,1)-1,1:2)=masterlayout(R1+bus2(ii,1)-1,2)+minval; % sets to the minimum value if it goes below min value
        masterlayout(R1+bus(ii,1)-1,3:4)=masterlayout(R1+bus2(ii,1)-1,3)+minval;          
        end
    elseif strcmp(Cond{count1,1},'Distance Range: X')==1
        if cntfeat<cntlinkedfeat+minval||cntfeat>cntlinkedfeat+maxval
        quar(R98:R99,:)=masterlayout(R1:R2,:);
        quardetails(count2,:)=[iii, Cond(count1,:)];
        count2=count2+1;
        masterlayout(R1:R2,:)=[];
        R1=R1-rx;
        R2=R2-rx;
        quarenv(R100:R100+1,:)=envmaster(R4:R4+1,:);
        envmaster(R4:R4+1,:)=[];
        R4=R4-2;
        R100=R100+2
        trials=trials-1;
        break    
        end
    end
end
end
%% Distance: Y
if strcmp(Cond{count1,1}(1,end),'Y')==1                               % action required by a change in the Y-Pos of any feature
for ii=1:bx
cntfeat=(masterlayout(R1+bus(ii,1)-1,11)+masterlayout(R1+bus(ii,1)-1,10))/2;  % temp stores the center coor. of the feature (passenger)
cntlinkedfeat=(masterlayout(R1+bus2(ii,1)-1,11)+masterlayout(R1+bus2(ii,1)-1,10))/2; % temp stores the center coor. of the linked feature (driver)
if strcmp(Cond{count1,1},'Distance Fixed: Y')==1
    if cntfeat~=cntlinkedfeat+minval
        masterlayout(R1+bus(ii,1)-1,[10 13])=masterlayout(R1+bus2(ii,1)-1,10)+minval; % sets to the minimum value if it goes below min value
        masterlayout(R1+bus(ii,1)-1,[11 12])=masterlayout(R1+bus2(ii,1)-1,11)+minval;
    end
elseif strcmp(Cond{count1,1},'Distance Range: Y')==1      
     if cntfeat<cntlinkedfeat+minval||cntfeat>cntlinkedfeat+maxval
        quar(R98:R99,:)=masterlayout(R1:R2,:);
        quardetails(count2,:)=[iii, Cond(count1,:)];
        count2=count2+1;
        masterlayout(R1:R2,:)=[];
        R1=R1-rx;
        R2=R2-rx;
        trials=trials-1;
        quarenv(R100:R100+1,:)=envmaster(R4:R4+1,:);
        envmaster(R4:R4+1,:)=[];
        R4=R4-2;
        R100=R100+2;
        break
     end
end
end
end
%% Base Border Size
if strcmp(Cond{count1,1}(1:4),'Base')==1
    tempmaster=masterlayout(R1:R2,:);                                    % pulls out this itterations matrix
       tempmaxX=max(max(tempmaster(:,1:4)));                                % finds max and mins of both X and Y coordinates
       tempminX=min(min(tempmaster(:,1:4)));                                
       tempmaxY=max(max(tempmaster(:,10:13)));
       tempminY=min(min(tempmaster(:,10:13)));
if strcmp(Cond{count1,1},'Base Border Size')==1                               % Constraint: border size 
        for iiii=1:lb  
           masterlayout(bus(iiii)+R3,1:4)=[tempminX tempminX tempmaxX tempmaxX]+[-minval -minval minval minval]; % publishes board size based on range set
           masterlayout(bus(iiii)+R3,10:13)=[tempminY tempmaxY tempmaxY tempminY]+[-maxval maxval maxval -maxval];
        end
end
if strcmp(Cond{count1,1},'Base Length Range')==1                                   %Boundary Condition
    blen=tempmaxX-tempminX;
    if blen<minval||blen>maxval
        quar(R98:R99,:)=masterlayout(R1:R2,:);
        quardetails(count2,:)=[iii, Cond(count1,:)];
        count2=count2+1;
        masterlayout(R1:R2,:)=[];
        R1=R1-rx;
        R2=R2-rx;
        trials=trials-1; 
        quarenv(R100:R100+1,:)=envmaster(R4:R4+1,:);
        envmaster(R4:R4+1,:)=[];
        R4=R4-2;
        R100=R100+2;
    end
end
    if strcmp(Cond{count1,1},'Base Width Range')==1                               %BC
    bwid=tempmaxY-tempminY;
        if bwid<minval||bwid>maxval
        quar(R98:R99,:)=masterlayout(R1:R2,:);
        quardetails(count2,:)=[iii, Cond(count1,:)];
        count2=count2+1;
        masterlayout(R1:R2,:)=[];
        R1=R1-rx;
        R2=R2-rx;
        trials=trials-1; 
        quarenv(R100:R100+1,:)=envmaster(R4:R4+1,:);
        envmaster(R4:R4+1,:)=[];
        R4=R4-2;
        R100=R100+2;
        end
    end
end
%% Module Volume
if strcmp(Cond{count1,1},'Module Volume')==1  
    tempmaster=masterlayout(R1:R2,:);                                       % creates temp master for this itteration
       tempmaxX=max(max(tempmaster(:,1:4)));                                % finds max and min values for X and Y coor.
       tempminX=min(min(tempmaster(:,1:4)));
       tempmaxY=max(max(tempmaster(:,10:13)));
       tempminY=min(min(tempmaster(:,10:13)));
    x=tempmaxX-tempminX;                                                    % x length
    y=tempmaxY-tempminY;                                                    % y width 
    z=tempmaster(end,15)-tempmaster(1,15);                                  % z height
    tempvol=x*y*z;                                                          % vol calc
    if tempvol<minval||tempvol>maxval                                       % compares it to conditions
        quar(R98:R99,:)=masterlayout(R1:R2,:);
        quardetails(count2,:)=[iii, Cond(count1,:)];
        count2=count2+1;
        masterlayout(R1:R2,:)=[];
        R1=R1-rx;
        R2=R2-rx;
        trials=trials-1;
        quarenv(R100:R100+1,:)=envmaster(R4:R4+1,:);
        envmaster(R4:R4+1,:)=[];
        R4=R4-2;
        R100=R100+2;
    end
end
%% Layer Thickness
if strcmp(Cond{count1,1},'Layer Thickness: Fixed')==1  %Constraint                            
    for ii=1:bx                                                             % loops through bus 
            masterlayout(R1+bus(ii,1)-1,14)=minval;                         % if layer is too thin it will be updated to min value
    end
end
if strcmp(Cond{count1,1},'Layer Thickness: Range')==1                         %B.C.                       
    for ii=1:bx                                                             %loops through bus 
        if masterlayout(R1+bus(ii,1)-1,14)<minval ||masterlayout(R1+bus(ii,1)-1,14)>maxval  % checks if layer is thinner than min 
        quar(R98:R99,:)=masterlayout(R1:R2,:);
        quardetails(count2,:)=[iii, Cond(count1,:)];
        count2=count2+1;
        masterlayout(R1:R2,:)=[];
        R1=R1-rx;
        R2=R2-rx;
        trials=trials-1;
        quarenv(R100:R100+1,:)=envmaster(R4:R4+1,:);
        envmaster(R4:R4+1,:)=[];
        R4=R4-2;
        R100=R100+2;
        break
        end
    end
end
%% Substrate Thickness Ratio
if strcmp(Cond{count1,1},'Substrate Thickness Rat.')==1                      % B.C.!!!
       subthick=masterlayout(R1,14);                                        % finds substrate layer thickness for trial
       smallestthickness=max(masterlayout(R1+1:R2-1,14)); % R2-1 assumes top layer is encapsulent. R2 would check every layer% finds the smallest layer in stack
       thickrat=smallestthickness/subthick;                                 % finds thickness ratio
       if thickrat>minval
        quar(R98:R99,:)=masterlayout(R1:R2,:);
        quardetails(count2,:)=[iii, Cond(count1,:)];
        count2=count2+1;
        masterlayout(R1:R2,:)=[];
        R1=R1-rx;
        R2=R2-rx;
        trials=trials-1;
        quarenv(R100:R100+1,:)=envmaster(R4:R4+1,:);
        envmaster(R4:R4+1,:)=[];
        R4=R4-2;
        R100=R100+2;
       end
end
%% Environment h, Ta               %Constraints 
if strcmp(Cond{count1,1},'Conv. Coeff. (h) Fixed')==1||strcmp(Cond{count1,1},'Ambient Temp. (Ta) Fixed')==1
   R5=R4;
    if strcmp(Cond{count1,1},'Ambient Temp. (Ta) Fixed')==1
       R5=R5+1;
   end
    if strcmp(Cond{count1,2},'System')==1
        holding=(1:1:6);
        for iiiii=1:6
            if envmaster(R5,iiiii)<minval
            envmaster(R5,iiiii)=minval;
            elseif envmaster(R5,iiiii)>maxval
            envmaster(R5,iiiii)=maxval;
            end
        end
    else
    IndexC = strfind(envcnames,Cond{count1,2});
    Index = find(not(cellfun('isempty', IndexC)));
    envmaster(R5,Index)=minval;
    end
end
%% Environment h, Ta Boundary Condtions
if strcmp(Cond{count1,1},'Conv. Coeff. (h) Range')==1||strcmp(Cond{count1,1},'Ambient Temp. (Ta) Range')==1
   R5=R4;
    if strcmp(Cond{count1,1},'Ambient Temp. (Ta) Range')==1
       R5=R5+1;
   end
    if strcmp(Cond{count1,2},'System')==1
        holding=(1:1:6);
        for iiiii=1:6
            if envmaster(R5,iiiii)<minval||envmaster(R5,iiiii)>maxval
            quar(R98:R99,:)=masterlayout(R1:R2,:);
            quardetails(count2,:)=[iii, Cond(count1,:)];
            count2=count2+1;
            masterlayout(R1:R2,:)=[];
            R1=R1-rx;
            R2=R2-rx;
            trials=trials-1;
            quarenv(R100:R100+1,:)=envmaster(R4:R4+1,:);
            envmaster(R4:R4+1,:)=[];
            R4=R4-2;
            R100=R100+2;
            break
            end
        end
    else
    IndexC = strfind(envcnames,Cond{count1,2});
    Index = find(not(cellfun('isempty', IndexC)));
    envmaster(R5,Index)=minval;
    end
end
%% Heat Generation
% Constrains
if strcmp(Cond{count1,1},'Heat Gen. (W) Fixed')==1
   for ii=1:bx
   masterlayout(R1+bus(ii,1)-1,5)=minval;
   end
end
%Boundary Conditions
if strcmp(Cond{count1,1},'Heat Gen. (W) Range')==1
   for ii=1:bx
   if masterlayout(R1+bus(ii,1)-1,5)<minval||masterlayout(R1+bus(ii,1)-1,5)>maxval
   quar(R98:R99,:)=masterlayout(R1:R2,:);
   quardetails(count2,:)=[iii, Cond(count1,:)];
   count2=count2+1;
   masterlayout(R1:R2,:)=[];
   R1=R1-rx;
   R2=R2-rx;
   trials=trials-1; 
   quarenv(R100:R100+1,:)=envmaster(R4:R4+1,:);
   envmaster(R4:R4+1,:)=[];
   R4=R4-2;
   R100=R100+2;
   break
   end
   end
end
%% Incriments
R1=R1+rx;
R2=R2+rx;
R3=R3+rx;
R4=R4+2;
R98=R98+rx;
R99=R99+rx;
count3=count3+1;
% trials
end
count1=count1+1;
end
% quardetails;
% masterlayout
% quardetailsskinny=quardetails(~cellfun('isempty', quardetails));
% lq=length(quardetailsskinny);
% quardetails=reshape(quardetailsskinny,lq/8,8);
% masterlayout(7:9,:)
% envmaster
end

