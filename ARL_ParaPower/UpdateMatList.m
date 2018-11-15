function UpdateMatList(TableHandle, Ci, CloseImmediately)
%Update a material list in a table with a new materials database
%TableHandle is a handle to the table of inerest
%Ci is the column number of that table that has materials listed

        
    F=get(TableHandle,'userdata');
    
    if isempty(F)
        F=MaterialDatabase('nonmodal');
        set(TableHandle,'userdata',F);
    end
    
    if exist('CloseImmediately','var')
        close(F)
    else
        set(F,'windowstyle','modal')
        set(F,'visible','on')
        uiwait(F)
    end
    
    
    M=getappdata(F,'Materials');
    NewMatList=M.AllMatsList;

    ColFormat=get(TableHandle,'columnformat');
    OldMatList=ColFormat{Ci};
    Data=get(TableHandle,'data');
    if not(isempty(Data))
        for I=1:length(Data(:,1))
            MatIndex=find(strcmpi(Data(I,Ci),NewMatList));
            if isempty(MatIndex)
                ThisMat='';
            else
                ThisMat=NewMatList{MatIndex};
            end
            Data{I,Ci}=ThisMat;
        end
    end
    ColFormat{Ci}=NewMatList;
    set(TableHandle,'columnformat',ColFormat);
    set(TableHandle,'data',Data);
end