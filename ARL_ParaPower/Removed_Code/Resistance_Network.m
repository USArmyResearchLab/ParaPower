function [A,B] = Resistance_Network(Num_Row,Num_Col,Num_Lay,A,B,Ta,Mat,h,K,dx,dy,dz)

K=reshape(K,[Num_Row,Num_Col,Num_Lay]);

% Load A matrix and B vector for left face nodes
[A,B] = LeftFace(Num_Row,Num_Col,Num_Lay,A,B,Ta,Mat,h,K,dx,dy,dz);
% Load A matrix and B vector for right face nodes
[A,B] = RightFace(Num_Row,Num_Col,Num_Lay,A,B,Ta,Mat,h,K,dx,dy,dz);
% Load A matrix and B vector for front face nodes
[A,B] = FrontFace(Num_Row,Num_Col,Num_Lay,A,B,Ta,Mat,h,K,dx,dy,dz);
% Load A matrix and B vector for back face nodes
[A,B] = BackFace(Num_Row,Num_Col,Num_Lay,A,B,Ta,Mat,h,K,dx,dy,dz);
% Load A matrix and B vector for bottom face nodes
[A,B] = BottomFace(Num_Row,Num_Col,Num_Lay,A,B,Ta,Mat,h,K,dx,dy,dz);
% Load A matrix and B vector for top face nodes
[A,B] = TopFace(Num_Row,Num_Col,Num_Lay,A,B,Ta,Mat,h,K,dx,dy,dz);
% Load A matrix and B for the interior nodes
[A,B]= Interior(Num_Row,Num_Col,Num_Lay,A,B,Ta,Mat,h,K,dx,dy,dz);
% Check to see if a transient solution is desired, steps > 1.
if ~issymmetric(A)
    warning('Conductance Matrix is not symmetric!')
end