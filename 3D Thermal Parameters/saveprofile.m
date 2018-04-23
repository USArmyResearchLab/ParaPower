function [] = saveprofile()
%UNTITLED2 Summary of this function goes here
% filename,NL,Tproc,ND,NP,h,Ta,FSize,Fdata,matbylayer,LT,multimatlayers,NF
% xlswrite(FILE,ARRAY,SHEET,RANGE) 
% % data(1,1)=NL;
% % data(2,1)=Tproc;
% % data(3,1)=ND;
% % data(4,1)=NP;
% % data(5,1:6)=h;
% % data(6,1:6)=Ta;
% % data(7,1:end)=matbylayer;
% % data(8,1:end)=LT;
% % data(9,1:end)=multimatlayers;
% % for i=1:NF
% % % Feature data
% % end
filename='Book1.xlsx'
data=[0 0 0.008 0.008 64; 0 0.018 0.008 0.008 64; 0.018 0.018 0.008 0.008 64; ...
    0.018 0 0.008 0.008 64];           
xlswrite(filename,data,1,'B1')
'done'
end

