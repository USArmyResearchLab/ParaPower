function [Acond,Bcond,htcs] = conduct_update(Acond,Bcond,A_areas,B_areas,A_hLengths,B_hLengths,htcs,K,Mask)
%Updates Conductance Matrices using connectivity matrices, dimensional info,
%and material properties/convection coefficients.

recip=@(x) 1./x;  %anonymous function handle
Acond(Mask,Mask)=A_areas(Mask,Mask).* spfun(recip,A_hLengths(Mask,Mask));
Acond(Mask,Mask)=spdiags(K(Mask),0,length(Mask),length(Mask))*Acond(Mask,Mask);  %conductance from center of element i up to bdry of element j
Acond(Mask,Mask)=spfun(recip, (spfun(recip,Acond(Mask,Mask)) + spfun(recip,Acond(Mask,Mask)')) );
 

if ~issymmetric(Acond)
    error('Symmetry Error!')
end

Bcond_out=sparse(B_areas(Mask,:)).*spfun(recip,sparse(B_hLengths(Mask,:)));
Bcond_out=spdiags(K(Mask),0,length(Mask),length(Mask))*Bcond_out;  %conductance from center of element i up to bdry of convection

if ~isempty(htcs) && ~isempty(B_areas)
    Bcond_in = sparse(B_areas(Mask)*diag(htcs));
    Bcond(Mask,:) = spfun(recip, (spfun(recip,Bcond_out) + spfun(recip,Bcond_in)) );
end

%zero the A diagonal!
%Acond(Mask,Mask)=spdiags(zeros(length(Mask),1),0,Acond(Mask,Mask));
%the diagonal of the A conductance matrix holds the center of the central
%differences.  These must balance cntr=sum([Acond Bcond],2);
Acond(Mask,Mask)=Acond(Mask,Mask)-spdiags(sum([Acond(Mask,:) Bcond(Mask,:)],2),0,length(Mask),length(Mask));

end

