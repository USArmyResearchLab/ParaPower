function [cap,vol]=mass(dx,dy,dz,RHO,CP,Mat,Mask)
%takes dx, dy, dz of length NC, NR, NL to compute volume vector
% capacity is computed from vol RHO and CP vectors - length NR*NC*NL

%if a Mask is input, cap will be calculated for only those masked elements,
%and will have length nnz(Mask).  Else, it will be calculated for the
%entire solid portion of Mat.

vol = reshape(reshape(dx'*dy,[],1)*dz,[],1);    
if ~exist('Mask','var')
    cap=RHO.*CP.*vol(Mat>0);
else
    cap=RHO(Mask).*CP(Mask).*vol(Mask);
    %make sure your target output variable is also masked!
end

end


%for i=1:12
%    for j=1:12
%       for k=1:7
%            check(index(NRCL,i,j,k))=isequal(vol(index(NRCL,i,j,k)),dx(i)*dy(j)*dz(k));
%        end
%    end
%end
