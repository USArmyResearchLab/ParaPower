function [data] = checkbounds(list,data,row,type,props,minallow,maxallow)
        tempmat=find(strcmp(list,data(row,2))==1);                          % compares the list of potential inputs and finds the index within props matrix
        tempprop=find(strcmp(type,data(row,3))==1);                         % compares types of inputs and finds index within props matrix
        tempdata=props(tempmat,tempprop);                                   % finds the value to compare with bounds
        min=cell2mat(data(row,4));                                          % develops input bounds from table
        n=cell2mat(data(row,5));
        max=cell2mat(data(row,6));
        range=linspace(min,max,n)+tempdata;             
        inputrange=[range(1,1),range(1,end)];                               % finds extremes of input bounds
        validbounds=[minallow maxallow];                                    % develops the valid bounds based on min and max allowable values for this check
        if range(1,1)<minallow || range(1,end)<minallow                     % if either entry is below min... error out
            errordlg(['One or both the bounds are below the minimum' newline...
                'allowable bounds of [' num2str(validbounds) ']' newline...
                'Input Range [' num2str(inputrange) ']'],'Invalid Entry','modal');
            data(row,[4 6])=cell(1,1);                                      % empty out min and max cells
        elseif range(1,1)>maxallow || range(1,end)>maxallow                 % if either entry is above max... error out
           errordlg(['One or both bounds are above the maximum ' newline...
                'allowable bounds of [' num2str(validbounds) ']' newline
                'Input Range [' num2str(inputrange) ']'],'Invalid Entry','modal');
           data(row,[4 6])=cell(1,1);                                       % empty out min and max cells
        end
end

