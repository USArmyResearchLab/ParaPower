function UpdateMatList(TableHandle, Ci)
%Update a material list in a table with a new materials database
%TableHandle is a handle to the table of inerest
%Ci is the column number of that table that has materials listed

    F=MaterialDatabase;
    uiwait(F)
    M=getappdata(F,'Materials');
    NewMatList=M.AllMatsList;

    ColFormat=get(TableHandle,'columnformat');
    OldMatList=ColFormat{Ci};
    Data=get(TableHandle,'data');
    for I=1:length(Data(:,1))
        MatIndex=find(strcmpi(Data(I,Ci),NewMatList));
        if isempty(MatIndex)
            ThisMat='';
        else
            ThisMat=NewMatList{MatIndex};
        end
        Data{I,Ci}=ThisMat;
    end

    ColFormat{Ci}=NewMatList;
    set(TableHandle,'columnformat',ColFormat);
    set(TableHandle,'data',Data);
end