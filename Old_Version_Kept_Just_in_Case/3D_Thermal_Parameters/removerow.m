function [data]=removerow(data,cellselect)
if isempty(cellselect)==1    % checks to see if a selection in the table has been made 
    errordlg('No selection made. Select a row to remove','Unidentified Object','modal') % if no cell was selected, present error
     return
end
[~,c]=size(data); % solve for dim. of data 
data(cellselect(1,1),:)=[]; %set selected row to empty, matrix will automatically shift to consume row
emptymat=isempty(cellfun('isempty',data)); %determine if the mat was totally emptied by previous command
if emptymat==1 % if cell array is entirely empty
   data=cell(1,c);% build new matrix what is one row tall
end
end

