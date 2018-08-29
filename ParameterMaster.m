function [master,envmaster,envrow,delta_t,transteps,bmatmaster,matpropsmaster,tranmin] = ParameterMaster(para,envdata,sides,x,y,z,basestatus,basedata,bmat,NL,matlist,matprops,matparatype)
% envdata=[10 10 10 10 1000 10; 20 20 20 20 20 20];
% para,envdata,sides,x,y,z,basestatus,basedata

%variable documentation
%georow: origin - ParaPowerGUI; unedited since - ParaPowerGUI

envdata=cell2mat(envdata);
delta_t=0;
tranmin=0;
transteps=1;
group=[x y z];
assignin('base','group',group)
baselayers=find(x(:,8)==0);
[lb,~]=size(baselayers);
% % para={'Position X' 'L4.2 F 1.2' 'N/A' 100 3 200;...
% %     'Position Y' 'L5.1 F 1.1' 'N/A' 300 3 400;...
% %     'Scale' 'L5.1 F 1.4' 'N/A' 500 3 600;...
% %     'Layer Thickness' 'L5.0' 'N/A' 500 3 600};                                  % stand in parametric matrix
% sides={'Left';'Right';'Front';'Back';'Top';'Bottom'}';
% para={'Position X' 'L4.2 F 1.2' 'N/A' 100 3 200;...
%     'Environment' 'Ta' 'Back' 300 3 400;...
%     'Scale' 'L5.1 F 1.4' 'N/A' 500 3 600;...
%     'Environment' 'h' 'Right' 300 3 400};                                  % stand in parametric matrix
[lp,~]=size(para);                                                          % lp represents the number of individual parameters
% para(:,1)
% idx=find(contains(para(:,1),'Layer Thickness'));
idx = find(strcmp(para(:,1),'Layer Thickness'));
if idx>0
    para{idx,2}=['L' para{idx,2}(1,end)];
    if strcmp(para{idx,3},'N/A')==0
        para{idx,3}=['L' para{idx,3}(1,end)];
    end
end
sx=prod(1+cell2mat(para(:,5)));                                             % sx is the number of unique itterations that the parameter sweep will cover product of (1+n1)(1+n2)...(1+nn)
idx=find(strcmp(para(:,1),'Transient'));
if idx>0
    sx=sx/(1+cell2mat(para(idx,5)));
end
count1=0;                                                                   % count1 stores the parameter that is being analysed.
count2=1;                                                                   % count2 stores the total number of individual parameter actions have been taken place. Used to all individual cases have been considered.
count3=1;
[georow,cx]=size(group);                                                            % finds the size of a single xlayout
[envrow,ec]=size(envdata);
[bmatrow,bmatcol]=size(bmat);
[matpropsrow,matpropscol]=size(matprops);
totrows=georow*sx;                                                              % finds total number of rows that are required to store each xlayout variation
if floor(totrows)~=totrows
    errordlg('Steps must be intengers','Impropper Entry','modal')
    return
end
envrows=(envrow*sx);
master=zeros(totrows,cx);                                                  % generates master matrix to store all variations
master(1:georow,:)=group;                                                          % stores first trial as orginal matrix pulled from gui input
envmaster=zeros(envrows,ec);
envmaster(1:envrow,1:ec)=envdata;
bmatmaster=zeros(NL,sx);
bmatmaster(1:NL,1:bmatcol)=bmat;
matpropsmaster=zeros(matpropsrow*sx,matpropscol);
matpropsmaster(1:matpropsrow,1:end)=matprops;
R1=georow+1;                                                                    % Region 1 is defined as row following the origianl trial and goes...
R2=2*georow;                                                                    % to Region 2 as correctly sized end position
Re3=envrow+1;                                                                   % Env equivalant to Region 1...
Re4=2*envrow;
Rb7=bmatcol+1;
Rb8=2*bmatcol;
Rm9=matpropsrow+1;
Rm10=2*matpropsrow;
[para,master,envmaster,count1,count2,R1,R2,Re3,Re4,Rb7,Rb8,Rm9,Rm10,x,envrow,bmatcol,sides,delta_t,transteps,basestatus,bmat,bmatmaster,NL,count3,matlist,matpropsmaster,matpropsrow,matparatype,tranmin]...
    =parametricsweep(para,master,envmaster,count1,count2,R1,R2,Re3,Re4,Rb7,Rb8,Rm9,Rm10,x,georow,lp,envrow,bmatcol,sides,delta_t,transteps,baselayers,lb,basestatus,bmat,bmatmaster,NL,count3,matlist,matpropsmaster,matpropsrow,matparatype,tranmin); % calls nested loop parametric sweep function to generate master parametric matrix
% tran=find(strcmp(para{:,1},'Transient')==1)
% envmaster;
% x;
% master
%% Base Reset... has been moved to be handled by boundary conditions.
% % % R1=1;                                                                    % Region 1 is defined as row following the origianl trial and goes...
% % % R2=georow;                                                                    % to Region 2 as correctly sized end position
% % % R3=0;
% % % if basestatus==1
% % %     if iscell(basedata)==1
% % %         basedata=cell2mat(basedata);
% % %     end
% % %    for i=1:sx
% % %        tempmaster=master(R1:R2,:);
% % %        tempmaxX=max(max(tempmaster(:,1:4)));
% % %        tempminX=min(min(tempmaster(:,1:4)));
% % %        tempmaxY=max(max(tempmaster(:,10:13)));
% % %        tempminY=min(min(tempmaster(:,10:13)));
% % %         for ii=1:lb
% % %            master(baselayers(ii)+R3,1:4)=[tempminX tempminX tempmaxX tempmaxX]+[-basedata(1,1) -basedata(1,1) basedata(1,1) basedata(1,1)];
% % %            master(baselayers(ii)+R3,10:13)=[tempminY tempmaxY tempmaxY tempminY]+[-basedata(1,1) basedata(1,1) basedata(1,1) -basedata(1,1)];
% % %         end
% % %         R1=R1+georow;
% % %         R2=R2+georow;
% % %         R3=R3+georow;
% % %    end
% % % end
% master
%ERRORS
% if count2~=totrows/georow || count2~=envrows/envrow                                                      % checks to ensure all sub routrines have been actuated for each parameter
%     errordlg((['There is a serious error while evaluating.'...
%         newline newline 'The data constructed is not accurate,'...
%         newline 'every parameter was not considered' newline newline...
%         'Verify string check on parameter types.' newline]),'Parameter Error','modal')
% end
end

