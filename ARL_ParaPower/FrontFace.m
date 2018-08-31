function [A,B] = FrontFace(NR,NC,NL,A,B,Ta,Q,Mat,h,kond,dx,dy,dz)
% global NL NR NC A B Ta Q Mat
% Interior nodes
i=1;
for k=2:NL-1
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
        A(Ind,Ind+NC)=CBK;
        A(Ind,Ind-NR*NC)=CBM;
        A(Ind,Ind+NR*NC)=CTP;
        A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
        B(Ind)=-(CFT*Ta(3)+Q(i,j,k));
        end
    end
end
% Bottom edge interior nodes
k=1;
i=1;
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
        A(Ind,Ind+NC)=CBK;
        A(Ind,Ind+NR*NC)=CTP;
        A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
        B(Ind)=-(CFT*Ta(3)+CBM*Ta(5)+Q(i,j,k));
        end
end
% Top edge interior nodes
k=NL;
i=1;
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
        A(Ind,Ind+NC)=CBK;
        A(Ind,Ind-NR*NC)=CBM;
        A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
        B(Ind)=-(CFT*Ta(3)+CTP*Ta(6)+Q(i,j,k));
        end
end