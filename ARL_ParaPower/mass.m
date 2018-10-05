function [cap,vol]=mass(dx,dy,dz,RHO,CP)
%takes dx, dy, dz of length NR, NC, NL to compute volume vector
% capacity is computed from vol RHO and CP vectors - length NR*NC*NL
vol = reshape(reshape(dy'*dx,[],1)*dz,[],1);        
cap=RHO'.*CP'.*vol;
end


%for i=1:12
%    for j=1:12
%       for k=1:7
%            check(index(NRCL,i,j,k))=isequal(vol(index(NRCL,i,j,k)),dx(i)*dy(j)*dz(k));
%        end
%    end
%end
