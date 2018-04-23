function [data,choice,datahold]=parameterpull(data)
emptydata=cellfun('isempty',data);
[re,ce]=size(data);
emptyrows=sum(emptydata,2);                                                 %sum across rows
% pause
count=1;
choice=0;
datahold=cell(1,ce);
% datahold=[];
% data
% length(emptyrows)
% pause
for i=1:length(emptyrows)
   if emptyrows(i,1)>5
       data(count,:)=[];
   elseif emptyrows(i,1)>0
      dlgTitle    = 'Incomplete Entry';
      dlgQuestion = 'a parameter row is not entirely filled in, would you like to remove the row?';
      choice = questdlg(dlgQuestion,dlgTitle,'Remove','Edit Parameter','Remove');
 if strcmp(choice,'Remove')==1
     data(count,:)=[];  
 else
     choice=1;
     return
 end
   else
       datahold(count,:)=data(count,:);
       count=count+1;
   end
end
% if sum(cellfun('isempty',data))==1
%     data=cell(1,6)
% end
% cellfun('isempty',data)
[rd,cd]=size(data);
if rd<1 || cd<6
    data=cell(1,6);
end
if sum(cellfun('isempty',datahold))==ce
    datahold=[];
end
end

