function [para,master,envmaster,count1,count2,R1,R2,Re3,Re4,x,georow,envrow,sides,delta_t,transteps]=parametricsweep(para,master,envmaster,count1,count2,R1,R2,Re3,Re4,x,georow,lp,envrow,sides,delta_t,transteps,baselayers,lb) 
if count1==lp                                                               % if the all parameters have been considered the nested loop will break
return
else
    count1=count1+1;                                                        % itterates to next position in parametric matrix.
    min=para{count1,4};                                                     % retrieves initial value of parametric sweep
    n=para{count1,5};                                                       % retrieves number of steps in sweep
    max=para{count1,6};                                                     % retrieves final value of parametric sweep
    range=linspace(min,max,n);                                              % creates range of parametric sweep
    R3=R1-1;                                                                % R3 represents the end of the region that needs to be copied for parametric use                                                       
    Re5=Re3-1;
%% Geometry Pull
    if isnan(str2double(para{count1,2}(1,end)))==0
    rownum=str2double(para{count1,2}(1,2))                                 % retrieves layer number that parameter influences
    featnum=str2double(para{count1,2}(1,end));                              % retrieves the layout feature number that parameter influences
    layer=find(x(:,6)==rownum)                                             % retrieves the rows of the xlayout matrix that are equal to the selected layer 
    row=layer(1,1)+featnum-1;                                               % takes the first occurance of the edited layer and shifts to correct 
% Sweep Geometry Based  
    for i=1:n
    master(R1:R2,:)=master(1:R3,:);                                       % takes a copy of proceeding region and places it after the last entry, now parameter change can be made incrimentally on each previous variation
    envmaster(Re3:Re4,:)=envmaster(1:Re5,:);
    [lt,~]=size(master(1:R3,:));                                           % finds how many sub routines are required to sweep every variation due to parameters
for ii=1:lt/georow
    if strcmp(para{count1,1},'Position X')==1                               % action required by a change in the X-Pos of any feature
        count1
        strcmp(para{count1,2},'Base')
        if strcmp(para{count1,2},'Base')==1
            for iii=1:lb
                disp 'basss'
             master(R1+baselayers(iii,1)-1,1:4)=master(R1+baselayers(iii,1)-1,1:4)+range(1,i);
            end
        else
    master(R1+row-1,1:4)=master(R1+row-1,1:4)+range(1,i);             % shift made to all x-coor for a value of i'th itteration of range
%     count2=count2+1;                                                        % incriment made to validate that all parameters have been checked
        end
    elseif strcmp(para{count1,1},'Position Y')==1                               % action required by a change in the X-Pos of any feature
    master(R1+row-1,10:13)=master(R1+row-1,10:13)+range(1,i);             % shift made to all y-coor for a value of i'th itteration of range
%     count2=count2+1;                                                        % incriment made to validate that all parameters have been checked
    elseif strcmp(para{count1,1},'Length')==1                               % action required by a change in the Length of any feature (i.e. x size)
    master(R1+row-1,1:2)=master(R1+row-1,1:2)-range(1,i)/2;           % x-coor 1 and 2 grow by subtracting half the length 
    master(R1+row-1,3:4)=master(R1+row-1,3:4)+range(1,i)/2;           % x-coor 3 and 4 grow by adding half the length 
%     count2=count2+1;                                                        % incriment made to validate that all parameters have been checked
    elseif strcmp(para{count1,1},'Width')==1                               % action required by a change in the X-Pos of any feature
    master(R1+row-1,10:11)=master(R1+row-1,10:11)-range(1,i)/2;           % y-coor 1 and 2 grow by subtracting half the length 
    master(R1+row-1,12:13)=master(R1+row-1,12:13)+range(1,i)/2;           % y-coor 3 and 4 grow by adding half the length 
%     count2=count2+1; 
    elseif strcmp(para{count1,1},'Scale')==1                                % action required by a change in the scale of any feature (i.e. x and y size equally)
    master(R1+row-1,1:2)=master(R1+row-1,1:2)-range(1,i)/2;           % x-coor 1 and 2 grow by subtracting half the scale 
    master(R1+row-1,3:4)=master(R1+row-1,3:4)+range(1,i)/2;           % x-coor 3 and 4 grow by adding half the scale
    master(R1+row-1,10:11)=master(R1+row-1,10:11)-range(1,i)/2;           % y-coor 1 and 2 grow by subtracting half the length 
    master(R1+row-1,12:13)=master(R1+row-1,12:13)+range(1,i)/2;           % y-coor 3 and 4 grow by adding half the length 
%     count2=count2+1;                                                        % incriment made to validate that all parameters have been checked
    elseif strcmp(para{count1,1},'Layer Thickness')==1                                % action required by a change in the scale of any feature (i.e. x and y size equally)
    master(R1+row-1,14)=master(R1+row-1,14)+range(1,i);         
%     count2=count2+1;
    elseif strcmp(para{count1,1},'Environment')==1 
        sidecol=find(strcmp(sides,para{count1,3})==1);
        if strcmp(para{count1,2},'h')==1 
            envmaster(Re3,sidecol)=envmaster(Re3,sidecol)+range(1,i);
%             count2=count2+1;
        elseif strcmp(para{count1,2},'Ta')==1 
            envmaster(Re3+1,sidecol)=envmaster(Re3+1,sidecol)+range(1,i);
%             count2=count2+1;    
        end 
    elseif strcmp(para{count1,1},'Transient')==1 
        tranhold=para(count1,4:6);
        [tranmin,transteps, tranmax]=tranhold{:};
        delta_t=(tranmax-tranmin)/transteps;
        return
    end
    count2=count2+1;                                                        % incriment made to validate that all parameters have been checked
    R1=R1+georow;                                                               % shifts the region of interest by the length of a single xlayout trial to then perform a parametric action on the next                                                      
    R2=R2+georow;                                                               % shifts the region of interest "               
    Re3=Re3+envrow;                                                               % shifts the region of interest by the length of a single xlayout trial to then perform a parametric action on the next                                                      
    Re4=Re4+envrow;                                                               % shifts the region of interest "               e4
end
    end
    end
% % %% Assosiated Geometry Pull   
% %     if isnan(str2double(para{count1,3}(1,end)))~=1
% %     asrownum=str2double(para{count1,3}(1,2));                                 % retrieves layer number that parameter influences
% %     asfeatnum=str2double(para{count1,3}(1,end));                              % retrieves the layout feature number that parameter influences
% %     aslayer=find(x(:,6)==asrownum);                                             % retrieves the rows of the xlayout matrix that are equal to the selected layer 
% %     asrow=aslayer(1,1)+asfeatnum-1;                                               % takes the first occurance of the edited layer and shifts to correct 
% % % Sweep with associated Geometry   
% %     for i=1:n
% %     master(R1:R2,:)=master(1:R3,:);                                       % takes a copy of proceeding region and places it after the last entry, now parameter change can be made incrimentally on each previous variation
% %     envmaster(Re3:Re4,:)=envmaster(1:Re5,:);
% %     [lt,~]=size(master(1:R3,:));                                           % finds how many sub routines are required to sweep every variation due to parameters
% % for ii=1:lt/georow
% %     if strcmp(para{count1,1},'Position X')==1                               % action required by a change in the X-Pos of any feature
% %     master(R1+row-1,1:4)=master(R1+row-1,1:4)+range(1,i);             % shift made to all x-coor for a value of i'th itteration of range
% %     count2=count2+1;                                                        % incriment made to validate that all parameters have been checked
% %     elseif strcmp(para{count1,1},'Position Y')==1                               % action required by a change in the X-Pos of any feature
% %     master(R1+row-1,10:13)=master(R1+row-1,10:13)+range(1,i);             % shift made to all y-coor for a value of i'th itteration of range
% %     count2=count2+1;                                                        % incriment made to validate that all parameters have been checked
% %     elseif strcmp(para{count1,1},'Length')==1                               % action required by a change in the Length of any feature (i.e. x size)
% %     master(R1+row-1,1:2)=master(R1+row-1,1:2)-range(1,i)/2;           % x-coor 1 and 2 grow by subtracting half the length 
% %     master(R1+row-1,3:4)=master(R1+row-1,3:4)+range(1,i)/2;           % x-coor 3 and 4 grow by adding half the length 
% %     count2=count2+1;                                                        % incriment made to validate that all parameters have been checked
% %     elseif strcmp(para{count1,1},'Width')==1                               % action required by a change in the X-Pos of any feature
% %     master(R1+row-1,10:11)=master(R1+row-1,10:11)-range(1,i)/2;           % y-coor 1 and 2 grow by subtracting half the length 
% %     master(R1+row-1,12:13)=master(R1+row-1,12:13)+range(1,i)/2;           % y-coor 3 and 4 grow by adding half the length 
% %     count2=count2+1; 
% %     elseif strcmp(para{count1,1},'Scale')==1                                % action required by a change in the scale of any feature (i.e. x and y size equally)
% %     master(R1+row-1,1:2)=master(R1+row-1,1:2)-range(1,i)/2;           % x-coor 1 and 2 grow by subtracting half the scale 
% %     master(R1+row-1,3:4)=master(R1+row-1,3:4)+range(1,i)/2;           % x-coor 3 and 4 grow by adding half the scale
% %     master(R1+row-1,10:11)=master(R1+row-1,10:11)-range(1,i)/2;           % y-coor 1 and 2 grow by subtracting half the length 
% %     master(R1+row-1,12:13)=master(R1+row-1,12:13)+range(1,i)/2;           % y-coor 3 and 4 grow by adding half the length 
% %     count2=count2+1;                                                        % incriment made to validate that all parameters have been checked
% %     elseif strcmp(para{count1,1},'Layer Thickness')==1                                % action required by a change in the scale of any feature (i.e. x and y size equally)
% %     master(R1+row-1,14)=master(R1+row-1,14)+range(1,i);         
% %     count2=count2+1;
% %     elseif strcmp(para{count1,1},'Environment')==1 
% %         sidecol=find(strcmp(sides,para{count1,3})==1);
% %         if strcmp(para{count1,2},'h')==1 
% %             envmaster(Re3,sidecol)=envmaster(Re3,sidecol)+range(1,i);
% %             count2=count2+1;
% %         elseif strcmp(para{count1,2},'Ta')==1 
% %             envmaster(Re3+1,sidecol)=envmaster(Re3+1,sidecol)+range(1,i);
% %             count2=count2+1;    
% %         end 
% %     elseif strcmp(para{count1,1},'Transient')==1 
% %         tranhold=para(count1,4:6);
% %         [tranmin,transteps, tranmax]=tranhold{:};
% %         delta_t=(tranmax-tranmin)/transteps;
% %         return
% %     end
% %     R1=R1+georow;                                                               % shifts the region of interest by the length of a single xlayout trial to then perform a parametric action on the next                                                      
% %     R2=R2+georow;                                                               % shifts the region of interest "               
% %     Re3=Re3+envrow;                                                               % shifts the region of interest by the length of a single xlayout trial to then perform a parametric action on the next                                                      
% %     Re4=Re4+envrow;                                                               % shifts the region of interest "               e4
% % end
% %     end
% %     end

R2=(R1-1)*2;                                                                % once a parameter has been wholesomely considered now all prior itterations are to be copied for the next parameter 
Re4=(Re3-1)*2;                                                                            % to address on each individual case. R2 grows to now find the end of all trials. 
[para,master,envmaster,count1,count2,R1,R2,Re3,Re4,x,georow,envrow,sides,delta_t,transteps]=parametricsweep(para,master,envmaster,count1,count2,R1,R2,Re3,Re4,x,georow,lp,envrow,sides,delta_t,transteps,baselayers,lb); % nested loop to sweep all parameters.
end

