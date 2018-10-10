function [Ind] = index(NRCL,i,j,k)
%Converts indices from Z3 to Z and back 
%   
%Converts from an indexed location 3D matrix with rows, columns, layers 
%   NRCL = [NR,NC,NL] to Z in flattened 1D vector and vice versa.
%   If three indices are passed, a single index is returned.
%   If one index is passed, the corresponding three are returned as [i,j,k].

%Convert NRCL to integer array by rounding
%NRCL=int16(NRCL);

if length(NRCL)~=3
    error('Require triple of NRCL = [NR,NC,NL]')
end

if nargin == 4
    %assume conversion from Z3 to Z
    
    if i>NRCL(1)
        error('Index i exceeds NR')
    elseif j>NRCL(2)
        error('Index j exceeds NC')
    elseif k>NRCL(3)
        error('Index k exceeds NL')
    elseif i<=0 || j<=0 || k<=0
        error('Non-positive Index')
    else
         Ind=(k-1)*NRCL(1)*NRCL(2)+(i-1)*NRCL(2)+j;
        %indices are flattened from row, column, layer to (row1+row2+...) of
        %layer 1 concatenated with that of layer 2....
    end

elseif nargin == 2
    %assume lookup from flattened index in Z to Z3
    Ind(3)=ceil(i/(NRCL(1)*NRCL(2)) ); %find layer
    sub_ind=rem(i,(NRCL(1)*NRCL(2)) ); %find the subindex that holds row, col info
    if sub_ind == 0         %indicates location within layer is NR*NC
        Ind(1)=NRCL(1);
        Ind(2)=NRCL(2);
    else
        Ind(1)=ceil(sub_ind/NRCL(2));  %find row
        sub_ind=rem(sub_ind,NRCL(2));
        if sub_ind == 0         %indicates location within row is NC
            Ind(2)=NRCL(2);
        else
            Ind(2)=sub_ind;
        end
    end
else
    error('Wrong number of indices')
end
    
end

