function [Acond,Bcond,A_areas,B_areas,htcs] = conduct_build(Acon,Bcon,Map,header,K,hint,h,Mat,drow,dcol,dlay)
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
A_areas=zeros(size(Acon)); 
A_hLengths=A_areas; Acond=A_areas;
%A_mask=zeros(size(Acon.'logical')); 

B_areas=zeros(size(Bcon));
B_hLengths=B_areas; Bcond_out=B_areas;
%B_mask=zeros(size(Bcon),'logical');

Map_A=repmat(Map,1,size(Acon,2));
Map_B=repmat(Map,1,size(Bcon,2));

    function c_sum = har(c1,c2,varargin)  %harmonic sum of conductances
        c_sum = 1./(1./c1  + 1./c2);        %should this be a spfun?
    end

sparse_flag=true;  
%sparse_flag=false; 


%% Store Geometry
tic;
for dir=1:3
    A_mask=Acon==dir;
    B_mask=Bcon==dir;
    
    [A_rows,A_cols,A_lays]=ind2sub(size(Mat),Map_A(A_mask));   
    [B_rows,B_cols,B_lays]=ind2sub(size(Mat),Map_B(B_mask));
    
    switch dir
        case 1      %row-wise connections
            areasA=dcol(A_cols).*dlay(A_lays);
            areasB=dcol(B_cols).*dlay(B_lays);
            lengthsA=drow(A_rows)/2;
            lengthsB=drow(B_rows)/2;
        case 2      %column-wise connections
            areasA=drow(A_rows).*dlay(A_lays);
            areasB=drow(B_rows).*dlay(B_lays);
            lengthsA=dcol(A_cols)/2;
            lengthsB=dcol(B_cols)/2;
        case 3      %layer-wise connections
            areasA=dcol(A_cols).*drow(A_rows);
            areasB=dcol(B_cols).*drow(B_rows);
            lengthsA=dlay(A_lays)/2;
            lengthsB=dlay(B_lays)/2;
    end
    

    B_areas(B_mask)=areasB;
    B_hLengths(B_mask)=lengthsB;
    
    if sparse_flag           %convert A components to sparse
        [i,j]=find(A_mask);
        A_areas=sparse(i,j,areasA);
        A_hLengths=sparse(i,j,lengthsA);
    else
        A_areas(A_mask)=areasA;
        A_hLengths(A_mask)=lengthsA;
    end
end
toc;

%% Incorporate Conductivities
A_mask=Acon>0;
B_mask=Bcon>0;

if ~sparse_flag  %build Acond as a full matrix
    
    Acond(A_mask)=A_areas(A_mask)./A_hLengths(A_mask);
    Acond=diag(K(Map))*Acond;  %conductance from center of element i up to bdry of element j
    Acond=har(Acond,Acond');  %cond'nce from i to j is harmonic sum of each piecewise component

else  %build Acond as sparse
    recip=@(x) 1./x;  %anonymous function handle
    Acond=A_areas.* spfun(recip,A_hLengths);
    Acond=spdiags(K(Map),0,size(Acon,1),size(Acon,2))*Acond;  %conductance from center of element i up to bdry of element j
    Acond=spfun(recip, (spfun(recip,Acond) + spfun(recip,Acond')) );
end   

if ~issymmetric(Acond)
    error('Symmetry Error!')
end

Bcond_out(B_mask)=B_areas(B_mask)./B_hLengths(B_mask);
Bcond_out=diag(K(Map))*Bcond_out;  %conductance from center of element i up to bdry of convection
htcs=[hint(-header(header<0)) h(header(header>0))];  %build htcs from header and h lists
Bcond_in = B_areas*diag(htcs);
Bcond = har(Bcond_out,Bcond_in);

%the diagonal of the A conductance matrix holds the center of the central
%differences.  These must balance
%cntr=sum([Acond Bcond],2);

if ~sparse_flag
    Acond=Acond-diag(sum([Acond Bcond],2));
else
    Acond=Acond-spdiags(sum([Acond Bcond],2),0,size(Acon,1),size(Acon,2));
end


end
