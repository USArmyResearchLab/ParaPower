function [NL,Tproc,T_init,h,Ta,layerthick,matbylayer,layerdata,basegeo,NLayouts,NCON,NBC,NP,NG,featdata,CONdata,BCdata,paradata,groupdata,results,tabstatus,layoutfeatdata,cx,bx,px,gx,status] = ProfileLoad()
[filename, pathname] = uigetfile('*.xlsx', 'Choose a profile file');
if ischar(filename)==0
    status=0;
    NL=0;Tproc=0;T_init=0;h=0;Ta=0;layerthick=0;matbylayer=0;layerdata=0;basegeo=0;NLayouts=0;NCON=0;NBC=0;NP=0;NG=0;featdata=0;CONdata=0;BCdata=0;paradata=0;groupdata=0;results=0;tabstatus=0;layoutfeatdata=0;cx=0;bx=0;px=0;gx=0;
    return
else
    status=1;
end
[~,~,raw]=xlsread([pathname,filename]); % pulls raw data from excel document named by entry
NL=cell2mat(raw(1,2));                                                      % pulls number of layers from row 1
Tproc=cell2mat(raw(2,2));                                                   % pulls process temp
T_init=cell2mat(raw(3,2));                                                  % pulls initial node temp
h=cell2mat(raw(4,2:7));                                                     % pulls convection coeff. 
Ta=cell2mat(raw(5,2:7));                                                    % pulls ambient temp
layerthick=raw(6,2:NL+1);                                                   % pulls layer thickness stack
matbylayer=raw(7,2:NL+1);                                                   % pulls materials by layer
layertype=raw(8,2:NL+1);                                                    % pulls layer types
layertypecode=raw(9,2:NL+1);                                                % pulls layer type codes
layerdata=[matbylayer' layerthick' layertype' layertypecode'];              % builds layer data into matrix
lb=cell2mat(raw(10,2));                                                     % finds length of base geo definition
basegeo=raw(10,3:2+lb);
if lb<3
basegeo=cell2mat(basegeo);                                           % pulls the required length of data for base definition
end
NLayouts=cell2mat(raw(11,2));                                               % pulls number of layouts from quantity 
if NLayouts==0
    layoutfeatdata=0;
    NLayouts=-1;
else
    layoutfeatdata=cell2mat(raw(13:13+NLayouts-1,2:end));                       % pulls feature data which includes quantity of each feature, total number of features, # of feature 1,...# of feature n for everylayout                     
end
NCON=cell2mat(raw(11,3));                                                   % pulls number of constraints from quantity 
NBC=cell2mat(raw(11,4));                                                    % pulls number of boundary conditions from quantity 
NP=cell2mat(raw(11,5));                                                     % pulls number of parameters from quantity 
NG=cell2mat(raw(11,6));                                                     % pulls number of groups from quantity 
tabstatus=cell2mat(raw(12,2:11));                                           % pulls tab status vector 
R1=13+NLayouts;                                                             % starting row of geometry data for features
if NLayouts~=-1
R2=R1+sum(layoutfeatdata(:,2))-1;                                           % ending row of geometry data
featdata=raw(R1:R2,2:8);
else
    R2=R1;
    featdata=cell(1,7);
end
R1=R2+1;                                                                    % shift to new starting point
CONdata=raw(R1:R1+NCON-1,2:5);                                              % constraint data                                           
[cx,~]=size(CONdata);                                                       % dim of constraint data
R1=R1+cx;                                                                                                                       
BCdata=raw(R1:R1+NBC-1,2:6);                                                % boundary condition data
[bx,~]=size(BCdata);
R1=R1+bx;
paradata=raw(R1:R1+NP-1,2:7);                                               % parameter data
[px,~]=size(paradata);
R1=R1+px;
groupdata=raw(R1:R1+NG-1,2:7);                                              % group data
[gx,~]=size(groupdata);
R1=R1+gx;
results=raw(R1,2:7);                                                        % results data
% [rx,~]=size(results);
% R1=R1+rx;
end

