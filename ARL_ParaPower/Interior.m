function [A,B] = Interior(Num_Row,Num_Col,Num_Lay,A,B,Ta,Mat,h,kond,dx,dy,dz)
% global Num_Lay Num_Row Num_Col A B Q Mat
for k=2:Num_Lay-1
    for i=2:Num_Row-1
        for j=2:Num_Col-1
            Ind=(k-1)*Num_Row*Num_Col+(i-1)*Num_Col+j;
            % Calculate the standard conductance values for the six nodes surrounding
            % a standard interior node
           if Mat(i,j,k)==0
           A(Ind,Ind)=1;
           B(Ind)=-1;
           else
            CLT=left(i,j,k,h,Mat,kond,dx,dy,dz);
            CRT=right(i,j,k,h,Mat,kond,dx,dy,dz,Num_Col);
            CFT=front(i,j,k,h,Mat,kond,dx,dy,dz);
            CBK=back(i,j,k,h,Mat,kond,dx,dy,dz,Num_Row);
            CBM=bottom(i,j,k,h,Mat,kond,dx,dy,dz);
            CTP=top(i,j,k,h,Mat,kond,dx,dy,dz,Num_Lay);
            % Load the [A] matrix and {B} vector with values for the standard interior node
            A(Ind,Ind-1)=CLT;
            A(Ind,Ind+1)=CRT;
            A(Ind,Ind-Num_Col)=CFT;
            A(Ind,Ind+Num_Col)=CBK;
            A(Ind,Ind-Num_Row*Num_Col)=CBM;
            A(Ind,Ind+Num_Row*Num_Col)=CTP;
            A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
           end
        end
    end
end