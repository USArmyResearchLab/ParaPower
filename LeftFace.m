function [A,B] = LeftFace(Num_Row,Num_Col,Num_Lay,A,B,Ta,Q,Mat,h,kond,dx,dy,dz)
% global NR NC NL A B Ta Q Mat
% Interior nodes
j=1;
for k=2:Num_Lay-1
    for i=2:Num_Row-1
        Ind=(k-1)*Num_Row*Num_Col+(i-1)*Num_Col+j;
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
        % Load the [A] matrix and {B} vector
        A(Ind,Ind+1)=CRT;
        A(Ind,Ind-Num_Col)=CFT;       
        A(Ind,Ind+Num_Col)=CBK;
        A(Ind,Ind-Num_Row*Num_Col)=CBM;
        A(Ind,Ind+Num_Row*Num_Col)=CTP;
        A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
        B(Ind)=-(CLT*Ta(1)+Q(i,j,k));
        end
    end
end
% Front edge interior nodes
i=1;
j=1;
for k=2:Num_Lay-1
        Ind=(k-1)*Num_Row*Num_Col+(i-1)*Num_Col+j;
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
        % Load the [A] matrix and {B} vector
        A(Ind,Ind+1)=CRT;
        A(Ind,Ind+Num_Col)=CBK;
        A(Ind,Ind-Num_Row*Num_Col)=CBM;
        A(Ind,Ind+Num_Row*Num_Col)=CTP;
        A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
        B(Ind)=-(CLT*Ta(1)+CFT*Ta(3)+Q(i,j,k));
        end
end
% Back edge interior nodes
i=Num_Row;
j=1;
for k=2:Num_Lay-1
        Ind=(k-1)*Num_Row*Num_Col+(i-1)*Num_Col+j;
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
        % Load the [A] matrix and {B} vector
        A(Ind,Ind+1)=CRT;
        A(Ind,Ind-Num_Col)=CFT;       
        A(Ind,Ind-Num_Row*Num_Col)=CBM;
        A(Ind,Ind+Num_Row*Num_Col)=CTP;
        A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
        B(Ind)=-(CLT*Ta(1)+CBK*Ta(4)+Q(i,j,k));
        end
end
% Bottom edge interior nodes
k=1;
j=1;
for i=2:Num_Row-1
        Ind=(k-1)*Num_Row*Num_Col+(i-1)*Num_Col+j;
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
        % Load the [A] matrix and {B} vector
        A(Ind,Ind+1)=CRT;
        A(Ind,Ind-Num_Col)=CFT;       
        A(Ind,Ind+Num_Col)=CBK;
        A(Ind,Ind+Num_Row*Num_Col)=CTP;
        A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
        B(Ind)=-(CLT*Ta(1)+CBM*Ta(5)+Q(i,j,k));
        end
end
% Top edge interior nodes
k=Num_Lay;
j=1;
for i=2:Num_Row-1
        Ind=(k-1)*Num_Row*Num_Col+(i-1)*Num_Col+j;
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
        % Load the [A] matrix and {B} vector
        A(Ind,Ind+1)=CRT;
        A(Ind,Ind-Num_Col)=CFT;       
        A(Ind,Ind+Num_Col)=CBK;
        A(Ind,Ind-Num_Row*Num_Col)=CBM;
        A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
        B(Ind)=-(CLT*Ta(1)+CTP*Ta(6)+Q(i,j,k));
        end
end
% Bottom, Front corner
i=1;
j=1;
k=1;
Ind=(k-1)*Num_Row*Num_Col+(i-1)*Num_Col+j;
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
% Load the [A] matrix and {B} vector
A(Ind,Ind+1)=CRT;
A(Ind,Ind+Num_Col)=CBK;
A(Ind,Ind+Num_Row*Num_Col)=CTP;
A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
B(Ind)=-(CLT*Ta(1)+CFT*Ta(3)+CBM*Ta(5)+Q(i,j,k));
end
% Bottom, Back corner
i=Num_Row;
j=1;
k=1;
Ind=(k-1)*Num_Row*Num_Col+(i-1)*Num_Col+j;
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
% Load the [A] matrix and {B} vector
A(Ind,Ind+1)=CRT;
A(Ind,Ind-Num_Col)=CFT;
A(Ind,Ind+Num_Row*Num_Col)=CTP;
A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
B(Ind)=-(CLT*Ta(1)+CBK*Ta(4)+CBM*Ta(5)+Q(i,j,k));
end
% Top, Front corner
i=1;
j=1;
k=Num_Lay;
Ind=(k-1)*Num_Row*Num_Col+(i-1)*Num_Col+j;
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
% Load the [A] matrix and {B} vector
A(Ind,Ind+1)=CRT;
A(Ind,Ind+Num_Col)=CBK;
A(Ind,Ind-Num_Row*Num_Col)=CBM;
A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
B(Ind)=-(CLT*Ta(1)+CFT*Ta(3)+CTP*Ta(6)+Q(i,j,k));
end
% Top, Back corner
i=Num_Row;
j=1;
k=Num_Lay;
Ind=(k-1)*Num_Row*Num_Col+(i-1)*Num_Col+j;
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
% Load the [A] matrix and {B} vector
A(Ind,Ind+1)=CRT;
A(Ind,Ind-Num_Col)=CFT;
A(Ind,Ind-Num_Row*Num_Col)=CBM;
A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
B(Ind)=-(CLT*Ta(1)+CBK*Ta(4)+CTP*Ta(6)+Q(i,j,k));
end