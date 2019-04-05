function [Acond,Bcond,A_areas,B_areas,A_hLengths,B_hLengths,htcs] = conduct_build(Acon,Bcon,Map,header,K,hint,h,Mat,drow,dcol,dlay)
%Builds Conductance Matrices using connectivity matrices, dimensional info,
%and material properties/convection coefficients.

%Acon and Bcon connectivity is coded as 0,1,2,3 where 0 is no connection,
% 1 is connection row-wise, 2 is connection col-wise, 3 is conn layer-wise
% such that drow                dcol                      dlay
% are the length dimensions of these connections
%
%Want to build a A-matrix with dimensional info.  One will contain areas
%for flux computation. Symmetric.  The other will have half length info,
%with coefficient ij holding the half length from center of element i to
%boundary of element j.  

%Elemental conductivities will be multiplied into these and harmonic
%summed.

%% Initialize
A_areas=spalloc(size(Acon,1),size(Acon,2),nnz(Acon)); 
A_hLengths=A_areas; %Acond=A_areas;
%A_mask=zeros(size(Acon.'logical')); 

B_areas=spalloc(size(Bcon,1),size(Bcon,2),nnz(Bcon));
B_hLengths=B_areas; %Bcond_out=B_areas;
%B_mask=zeros(size(Bcon),'logical');

%Map_A=repmat(Map,1,size(Acon,2));  new method, 
%Map_B=repmat(Map,1,size(Bcon,2));  these full arrays are =size(A), etc


%% Store Geometry

for dir=1:3
    [Ai,Aj]=find(Acon==dir);  %is find slow here?
    [Bi,Bj]=find(Bcon==dir);
    
    
    [A_rows,A_cols,A_lays]=ind2sub(size(Mat),Map(Ai));   
    [B_rows,B_cols,B_lays]=ind2sub(size(Mat),Map(Bi));
    
    switch dir
        case 1      %row-wise connections
            areasA=dcol(A_cols').*dlay(A_lays');
            areasB=dcol(B_cols').*dlay(B_lays');
            lengthsA=drow(A_rows')/2;
            lengthsB=drow(B_rows')/2;
        case 2      %column-wise connections
            areasA=drow(A_rows').*dlay(A_lays');
            areasB=drow(B_rows').*dlay(B_lays');
            lengthsA=dcol(A_cols')/2;
            lengthsB=dcol(B_cols')/2;
        case 3      %layer-wise connections
            areasA=dcol(A_cols').*drow(A_rows');
            areasB=dcol(B_cols').*drow(B_rows');
            lengthsA=dlay(A_lays')/2;
            lengthsB=dlay(B_lays')/2;
    end

    A_areas=A_areas+sparse(Ai,Aj,areasA,size(Acon,1),size(Acon,2));
    A_hLengths=A_hLengths+sparse(Ai,Aj,lengthsA,size(Acon,1),size(Acon,2));
    
    B_areas=B_areas+sparse(Bi,Bj,areasB,size(Bcon,1),size(Bcon,2));
    B_hLengths=B_hLengths+sparse(Bi,Bj,lengthsB,size(Bcon,1),size(Bcon,2));
end


%% Incorporate Conductivities

recip=@(x) 1./x;  %anonymous function handle
Acond=A_areas.* spfun(recip,A_hLengths);
Acond=spdiags(K,0,size(Acon,1),size(Acon,2))*Acond;  %conductance from center of element i up to bdry of element j
Acond=spfun(recip, (spfun(recip,Acond) + spfun(recip,Acond')) );
 

if ~issymmetric(Acond)
    error('Symmetry Error!')
end

Bcond_out=B_areas.* spfun(recip,B_hLengths);
Bcond_out=spdiags(K,0,size(Acon,1),size(Acon,2))*sparse(Bcond_out);  %conductance from center of element i up to bdry of convection
htcs=[hint(-header(header<0)) h(header(header>0))];  %build htcs from header and h lists
Bcond_in = sparse(B_areas*diag(htcs));
Bcond = spfun(recip, (spfun(recip,Bcond_out) + spfun(recip,Bcond_in)) );

%the diagonal of the A conductance matrix holds the center of the central
%differences.  These must balance cntr=sum([Acond Bcond],2);
Acond=Acond-spdiags(sum([Acond Bcond],2),0,size(Acon,1),size(Acon,2));
end
