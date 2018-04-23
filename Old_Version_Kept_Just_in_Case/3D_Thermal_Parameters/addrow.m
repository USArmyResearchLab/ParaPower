function [data]=addrow(data)
[r,c]=size(data); % find existing dim. of data
data(r+1,:)=cell(1,c); % add empty row of cells to data following last entry
end