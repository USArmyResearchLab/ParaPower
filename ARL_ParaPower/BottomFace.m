function [A,B] = BottomFace(NR,NC,NL,A,B,Ta,Mat,h,kond,dx,dy,dz)
% global NR NC A B Ta Q Mat
% Interior nodes
k=1;
for i=2:NR-1
    for j=2:NC-1
        Ind=(k-1)*NR*NC+(i-1)*NC+j;
        if Mat(i,j,k)==0
           A(Ind,Ind)=1;
           B(Ind)=-1;
        else
        CLT=left(i,j,k,h,Mat,kond,dx,dy,dz);
        CRT=right(i,j,k,h,Mat,kond,dx,dy,dz,NC);
        CFT=front(i,j,k,h,Mat,kond,dx,dy,dz);
        CBK=back(i,j,k,h,Mat,kond,dx,dy,dz,NR);
        CBM=bottom(i,j,k,h,Mat,kond,dx,dy,dz);
        CTP=top(i,j,k,h,Mat,kond,dx,dy,dz,NL);
        % Load the [A] matrix and {B} vector
        A(Ind,Ind-1)=CLT;
        A(Ind,Ind+1)=CRT;
        A(Ind,Ind-NC)=CFT;
        A(Ind,Ind+NC)=CBK;
        A(Ind,Ind+NR*NC)=CTP;
        A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
        B(Ind)=-CBM*Ta(5);
        end
    end
end