function [para,master,envmaster,count1,count2,R1,R2,Re3,Re4,Rb7,Rb8,Rm9,Rm10,x,georow,envrow,bmatcol,sides,delta_t,transteps,basestatus,bmat,bmatmaster,NL,count3,matlist,matpropsmaster,matpropsrow,matparatype,tranmin]...
    =parametricsweep(para,master,envmaster,count1,count2,R1,R2,Re3,Re4,Rb7,Rb8,Rm9,Rm10,x,georow,lp,envrow,bmatcol,sides,delta_t,transteps,baselayers,lb,basestatus,bmat,bmatmaster,NL,count3,matlist,matpropsmaster,matpropsrow,matparatype,tranmin) 
if count1==lp                                                               % if the all parameters have been considered the nested loop will break
return
else
    layers=0;
    count1=count1+1;                                                        % itterates to next position in parametric matrix.
    if isnan(str2double(para{count1,1}(1,end)))==0 && strcmp(para{count1,3},'N/A')==1
           min=0;max=0;
        range=0;
            layerdata=para{count1,2};
                    [n,~]=size(layerdata);
     if isnan(str2double(para{count1,1}(1,end-2)))==0
    rownum=str2double(para{count1,1}(1,2));                                 % retrieves layer number that parameter influences
    featnum=str2double(para{count1,1}(1,end-3:end));                              % retrieves the layout feature number that parameter influences
    layer=find(x(:,6)==rownum);                                          % retrieves the rows of the xlayout matrix that are equal to the selected layer 
    tt=find(x(layer,9)==featnum);
    layers=layer(1,1)+tt-1;
    [lx,~]=size(layers);
    action=para{count1,2};
    else
       rownum=str2double(para{count1,1}(1,end));                                 % retrieves layer number that parameter influences
       layers=find(x(:,6)==rownum);
       [lx,~]=size(layers);
     end     
    else
    min=para{count1,4};                                                     % retrieves initial value of parametric sweep
    n=para{count1,5};                                                       % retrieves number of steps in sweep
    max=para{count1,6};                                                     % retrieves final value of parametric sweep
    range=linspace(min,max,n);                                              % creates range of parametric sweep
    end  
    R3=R1-1;                                                                % R3 represents the end of the region that needs to be copied for parametric use                                                       
    Re5=Re3-1;
    Rb6=Rb7-1;
    Rm11=Rm9-1;
if isnan(str2double(para{count1,2}(1,end)))==0                              % if there is a feature number at the end of the parameter
    if strcmp(para{count1,2}(1,end-1),'.')==0
    rownum=str2double(para{count1,2}(1,2));
    layer=find(x(:,6)==rownum);
    layers=layer';
    [lx,~]=size(layer);
    else
    rownum=str2double(para{count1,2}(1,2));                                 % retrieves layer number that parameter influences
    featnum=str2double(para{count1,2}(1,end-3:end));                              % retrieves the layout feature number that parameter influences
    layer=find(x(:,6)==rownum);                                          % retrieves the rows of the xlayout matrix that are equal to the selected layer 
    tt=find(x(layer,9)==featnum);
    layers=layer(1,1)+tt-1';
%     layers=layer(1,1)+featnum-1                                               % takes the first occurance of the edited layer and shifts to correct 
    [lx,~]=size(layers);
%     pause
    end
elseif strcmp(para{count1,2},'Base')==1
   layers=baselayers;
   [lx,~]=size(layers);
end
if strcmp(para{count1,3},'N/A')==1
%     action=range;
else %Associated Feature action build
    if strcmp(para{count1,3}(1,end-1),'.')==0                               
    rownum2=str2double(para{count1,3}(1,2));
    layer2=find(x(:,6)==rownum2);
    layers2=layer2;
%     [lx,~]=size(layer);
    else
    % Associated Feature
    rownum2=str2double(para{count1,3}(1,2));                                % retrieves layer number that parameter influences
    featnum2=str2double(para{count1,3}(1,end-3:end));                       % retrieves the layout feature number that parameter influences
    layer2=find(x(:,6)==rownum2);                                           % retrieves the rows of the xlayout matrix that are equal to the selected layer 
    tt2=find(x(layer2,9)==featnum2);                                        % finds index in the sub layer that the feature exists on
    layers2=layer2(1,1)+tt2-1;                                              % finds the final row in layer stack that feature exists on
    
%     layers=layer(1,1)+featnum-1                                               % takes the first occurance of the edited layer and shifts to correct 
%     [lx2,~]=size(layers2);
    %     asrownum=str2double(para{count1,3}(1,2))                                 % retrieves layer number that parameter influences
%     asfeatnum=str2double(para{count1,3}(1,end));                              % retrieves the layout feature number that parameter influences
%     aslayer=find(x(:,6)==asrownum)                                             % retrieves the rows of the xlayout matrix that are equal to the selected layer 
%     aslayers=aslayer(1,1)+asfeatnum-1;                                               % takes the first occurance of the edited layer and shifts to correct   
% action=1111;
% action=range;
    end
end
action=range;
    for i=1:n
    master(R1:R2,:)=master(1:R3,:);                                       % takes a copy of proceeding region and places it after the last entry, now parameter change can be made incrimentally on each previous variation
    envmaster(Re3:Re4,:)=envmaster(1:Re5,:);
    bmatmaster(1:NL,Rb7:Rb8)=bmatmaster(:,1:Rb6);
    matpropsmaster(Rm9:Rm10,:)=matpropsmaster(1:Rm11,:);
    [lt,~]=size(master(1:R3,:));                                           % finds how many sub routines are required to sweep every variation due to parameters
for ii=1:lt/georow
% Geometric  
% layers
    if strcmp(para{count1,1},'Position X')==1                               % action required by a change in the X-Pos of any feature
            for iii=1:lx
                if strcmp(para{count1,3},'N/A')==1
                master(R1+layers(iii,1)-1,1:4)=master(R1+layers(iii,1)-1,1:4)+action(1,i);             % shift made to all x-coor for a value of i'th itteration of range
                
                else
                   cntfeat=(master(R1+layers2(1,1)-1,3)+master(R1+layers2(1,1)-1,2))/2; % temp stores the center coor. of the feature (passenger)
                   len=master(R1+layer(iii,1)-1,3)-master(R1+layer(iii,1)-1,2);
                   master(R1+layers(iii,1)-1,1:2)=cntfeat-(len/2)+action(1,i);           % shift made to all x-coor for a value of i'th itteration of range
                   master(R1+layers(iii,1)-1,3:4)=cntfeat+(len/2)+action(1,i);           % shift made to all x-coor for a value of i'th itteration of range
                end
            end
    elseif strcmp(para{count1,1},'Position Y')==1                               % action required by a change in the X-Pos of any feature
            for iii=1:lx
                 if strcmp(para{count1,3},'N/A')==1
                master(R1+layers(iii,1)-1,10:13)=master(R1+layers(iii,1)-1,10:13)+action(1,i);             % shift made to all y-coor for a value of i'th itteration of range
                 else
                   cntfeat=(master(R1+layers2(1,1)-1,11)+master(R1+layers2(1,1)-1,10))/2; % temp stores the center coor. of the feature (passenger)
                   wid=master(R1+layer(iii,1)-1,11)-master(R1+layer(iii,1)-1,10);
                   master(R1+layers(iii,1)-1,[10 13])=cntfeat-(wid/2)+action(1,i);           % shift made to all x-coor for a value of i'th itteration of range
                   master(R1+layers(iii,1)-1,[11 12])=cntfeat+(wid/2)+action(1,i);           % shift made to all x-coor for a value of i'th itteration of range
                end
            end
    elseif strcmp(para{count1,1},'Length')==1                               % action required by a change in the Length of any feature (i.e. x size)
            for iii=1:lx
                if strcmp(para{count1,3},'N/A')==1
                master(R1+layers(iii,1)-1,1:2)=master(R1+layers(iii,1)-1,1:2)-action(1,i)/2;           % x-coor 1 and 2 grow by subtracting half the length 
                master(R1+layers(iii,1)-1,3:4)=master(R1+layers(iii,1)-1,3:4)+action(1,i)/2;           % x-coor 3 and 4 grow by adding half the length 
                 else
                   cntfeat=(master(R1+layers(iii,1)-1,3)+master(R1+layers(iii,1)-1,2))/2; % temp stores the center coor. of the feature (passenger)
                   len=master(R1+layers2(1,1)-1,3)-master(R1+layers2(1,1)-1,2);
                   master(R1+layers(iii,1)-1,1:2)=cntfeat-((len+action(1,i))/2);           % shift made to all x-coor for a value of i'th itteration of range
                   master(R1+layers(iii,1)-1,3:4)=cntfeat+((len+action(1,i))/2);           % shift made to all x-coor for a value of i'th itteration of range
                end
            end                                                  
    elseif strcmp(para{count1,1},'Width')==1                               % action required by a change in the X-Pos of any feature
            for iii=1:lx
                if strcmp(para{count1,3},'N/A')==1
                master(R1+layers(iii,1)-1,[10 13])=master(R1+layers(iii,1)-1,[10 13])-action(1,i)/2;           % y-coor 1 and 2 grow by subtracting half the length 
                master(R1+layers(iii,1)-1,[11 12])=master(R1+layers(iii,1)-1,[11 12])+action(1,i)/2;           % y-coor 3 and 4 grow by adding half the length 
                else
                   cntfeat=(master(R1+layers(iii,1)-1,11)+master(R1+layers(iii,1)-1,10))/2; % temp stores the center coor. of the feature (passenger)
                   wid=master(R1+layers2(1,1)-1,11)-master(R1+layers2(1,1)-1,10);
                   master(R1+layers(iii,1)-1,[10 13])=cntfeat-((wid+action(1,i))/2);           % shift made to all x-coor for a value of i'th itteration of range
                   master(R1+layers(iii,1)-1,[11 12])=cntfeat+((wid+action(1,i))/2);           % shift made to all x-coor for a value of i'th itteration of range
                end
            end
    elseif strcmp(para{count1,1},'Scale')==1                                % action required by a change in the scale of any feature (i.e. x and y size equally)
            for iii=1:lx
                if strcmp(para{count1,3},'N/A')==1
                master(R1+layers(iii,1)-1,1:2)=master(R1+layers(iii,1)-1,1:2)-action(1,i)/2;           % x-coor 1 and 2 grow by subtracting half the scale 
                master(R1+layers(iii,1)-1,3:4)=master(R1+layers(iii,1)-1,3:4)+action(1,i)/2;           % x-coor 3 and 4 grow by adding half the scale
                master(R1+layers(iii,1)-1,[10 13])=master(R1+layers(iii,1)-1,[10 13])-action(1,i)/2;           % y-coor 1 and 2 grow by subtracting half the length 
                master(R1+layers(iii,1)-1,[11 12])=master(R1+layers(iii,1)-1,[11 12])+action(1,i)/2;           % y-coor 3 and 4 grow by adding half the length 
                else
                    % Scale Length
                   cntfeat=(master(R1+layers(iii,1)-1,3)+master(R1+layers(iii,1)-1,2))/2; % temp stores the center coor. of the feature (passenger)
                   len=master(R1+layers2(1,1)-1,3)-master(R1+layers2(1,1)-1,2);
                   master(R1+layers(iii,1)-1,1:2)=cntfeat-((len+action(1,i))/2);           % shift made to all x-coor for a value of i'th itteration of range
                   master(R1+layers(iii,1)-1,3:4)=cntfeat+((len+action(1,i))/2);           % shift made to all x-coor for a value of i'th itteration of range
                   % Scale Width
                   cntfeat=(master(R1+layers(iii,1)-1,11)+master(R1+layers(iii,1)-1,10))/2; % temp stores the center coor. of the feature (passenger)
                   wid=master(R1+layers2(1,1)-1,11)-master(R1+layers2(1,1)-1,10);
                   master(R1+layers(iii,1)-1,[10 13])=cntfeat-((wid+action(1,i))/2);           % shift made to all x-coor for a value of i'th itteration of range
                   master(R1+layers(iii,1)-1,[11 12])=cntfeat+((wid+action(1,i))/2);           % shift made to all x-coor for a value of i'th itteration of range
                end
            end
    elseif strcmp(para{count1,1},'Heat Gen.')==1                               % action required by a change in the X-Pos of any feature
            for iii=1:lx
                if strcmp(para{count1,3},'N/A')==1
                master(R1+layers(iii,1)-1,5)=master(R1+layers(iii,1)-1,5)+action(1,i);           % y-coor 1 and 2 grow by subtracting half the length 
                else
                master(R1+layers(1,1)-1,5)=master(R1+layers2(1,1)-1,5)+action(1,i);
                end
            end
    elseif strcmp(para{count1,1},'Layer Thickness')==1                                % action required by a change in the scale of any feature (i.e. x and y size equally)
            for iii=1:lx
                if strcmp(para{count1,3},'N/A')==1
                master(R1+layers(iii,1)-1,14)=master(R1+layers(iii,1)-1,14)+action(1,i);         
                else
                master(R1+layers(iii,1)-1,14)=master(R1+layers2(1,1)-1,14)+action(1,i); 
                end
            end
            if strcmp(para{count1,3},'N/A')==1
            master(R1+layers(end,1):R1+georow-1,15)=master(R1+layers(end,1):R1+georow-1,15)+action(1,i);
            else
                diff=master(layers2(1,1),14)-master(layers(1,1),14);
                master(R1+layers(end,1):R1+georow-1,15)=master(R1+layers(end,1):R1+georow-1,15)+action(1,i)+diff;
            end
% Environment    
%Convection Coefficient
    elseif strcmp(para{count1,1},'Conv. Coeff. (h)')==1 
        associatedsidecol=find(strcmp(sides,para{count1,3})==1); 
        if strcmp(para{count1,2},'System')==1
            for iii=1:6
                envmaster(Re3,iii)=envmaster(Re3,associatedsidecol)+action(1,i);
            end
        elseif strcmp(para{count1,3},'N/A')==1
        sidecol=find(strcmp(sides,para{count1,2})==1);
        envmaster(Re3,sidecol)=envmaster(Re3,sidecol)+action(1,i);
        else
            sidecol=find(strcmp(sides,para{count1,2})==1);
            envmaster(Re3,sidecol)=envmaster(Re3,associatedsidecol)+action(1,i);
        end
%Ambient Temperature        
    elseif strcmp(para{count1,1},'Ambient Temp. (Ta)')==1
    associatedsidecol=find(strcmp(sides,para{count1,3})==1); 
        if strcmp(para{count1,2},'System')==1
            for iii=1:6
                envmaster(Re3+1,iii)=envmaster(Re3+1,associatedsidecol)+action(1,i);
            end
        elseif strcmp(para{count1,3},'N/A')==1
        sidecol=find(strcmp(sides,para{count1,2})==1);
        envmaster(Re3+1,sidecol)=envmaster(Re3+1,sidecol)+action(1,i);
        else
            sidecol=find(strcmp(sides,para{count1,2})==1);
            envmaster(Re3+1,sidecol)=envmaster(Re3+1,associatedsidecol)+action(1,i);
        end     
% Transient        
    elseif strcmp(para{count1,1},'Transient')==1 
        tranhold=para(count1,4:6);
        [tranmin,transteps,tranmax]=tranhold{:};
%         delta_t=(tranmax-tranmin)/transteps;
        range=linspace(tranmin,tranmax,transteps);
        delta_t=range(1,2)-range(1,1);
        return
% Material
    elseif  strcmp(para{count1,1},'System')==1
%         if find(strcmp(matparatype,para{count1,3})==1)>0
       subrow=find(strcmp(matlist,para{count1,2})==1);
       subcol=find(strcmp(matparatype,para{count1,3})==1);
       matpropsmaster(Rm9+subrow-1,subcol)=matpropsmaster(Rm9+subrow-1,subcol)+action(1,i);
    elseif isnan(str2double(para{count1,1}(1,end)))==0
       matlocation=strcmp(matlist,layerdata(i,:));   
       matval=find(matlocation==1);
       if isnan(str2double(para{count1,1}(1,end)))==0 % if feat or layer if selected from col 1
        for iii=1:lx
            master(R1+layers(iii,1)-1,7)=matval; %updates everything on the defined layers to the new material assignment. A layer selction will update all features on that layer 
        end
        if isnan(str2double(para{count1,1}(1,end-2)))==1 % if layer is selected from col 1
           sololayer=str2num(para{count1,1}(1,end));
            bmatmaster(sololayer,Rb7)=matval;  %action will be the material type the layer is switched to
        end
       end
    end
    count2=count2+1;                                                        % incriment made to validate that all parameters have been checked
    R1=R1+georow;                                                               % shifts the region of interest by the length of a single xlayout trial to then perform a parametric action on the next                                                      
    R2=R2+georow;                                                               % shifts the region of interest "               
    Re3=Re3+envrow;                                                               % shifts the region of interest by the length of a single xlayout trial to then perform a parametric action on the next                                                      
    Re4=Re4+envrow;                                                               % shifts the region of interest "               e4
    Rb7=Rb7+bmatcol;
    Rb8=Rb8+bmatcol;
    Rm9=Rm9+matpropsrow;
    Rm10=Rm10+matpropsrow;
end
    end
R2=(R1-1)*2;                                                                % once a parameter has been wholesomely considered now all prior itterations are to be copied for the next parameter 
Re4=(Re3-1)*2;                                                                            % to address on each individual case. R2 grows to now find the end of all trials. 
Rb8=(Rb7-1)*2;
Rm10=(Rm9-1)*2;
count3=count3+1;
[para,master,envmaster,count1,count2,R1,R2,Re3,Re4,Rb7,Rb8,Rm9,Rm10,x,georow,envrow,bmatcol,sides,delta_t,transteps,basestatus,bmat,bmatmaster,NL,count3,matlist,matpropsmaster,matpropsrow,matparatype,tranmin]...
    =parametricsweep(para,master,envmaster,count1,count2,R1,R2,Re3,Re4,Rb7,Rb8,Rm9,Rm10,x,georow,lp,envrow,bmatcol,sides,delta_t,transteps,baselayers,lb,basestatus,bmat,bmatmaster,NL,count3,matlist,matpropsmaster,matpropsrow,matparatype,tranmin); % nested loop to sweep all parameters.
end

