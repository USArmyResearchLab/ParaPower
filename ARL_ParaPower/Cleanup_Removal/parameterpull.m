function [data,choice,datahold]=parameterpull(data)
emptydata=cellfun('isempty',data);                                          %matrix of logicals indicating if cell is empty
[re,ce]=size(data);                                                         %size of data in feature parameter parametric study table
emptyrows=sum(emptydata,2);                                                 %sum across rows
% pause
count=1;
choice=0;
datahold=cell(1,ce);                                                        %empty vector of length of data matrix
% datahold=[];
% data
% length(emptyrows)
% pause
for i=1:length(emptyrows)                                                   %for each feature parameter
    if emptyrows(i,1)>5                                                     %if row entirely empty
        data(count,:)=[];                                                   %wipe row
    elseif emptyrows(i,1)>0                                                 %if row is not fully filled out
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
        datahold(count,:)=data(count,:);                                    %assign data
        count=count+1;
    end
end
% if sum(cellfun('isempty',data))==1
%     data=cell(1,6)
% end
% cellfun('isempty',data)
[rd,cd]=size(data);
if rd<1 || cd<6
    data=cell(1,6);                                                         %expand truncated cells
end
if sum(cellfun('isempty',datahold))==ce
    datahold=[];
end
end

