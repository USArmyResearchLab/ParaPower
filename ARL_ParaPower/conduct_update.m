function [A,B] = conduct_update(A,B,Acon,Bcon,Mask,Map,header,K,hint,h,Mat,drow,dcol,dlay)
%Updates Conductance Matrices using connectivity matrices, dimensional info,
%and material properties/convection coefficients.
