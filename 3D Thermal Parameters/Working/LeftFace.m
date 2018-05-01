function LeftFace
global NR NC NL A B Ta Q Mat
% Interior nodes
j=1;
for k=2:NL-1
    for i=2:NR-1
        Ind=(k-1)*NR*NC+(i-1)*NC+j;
        if Mat(i,j,k)==0
           A(Ind,Ind)=1;
           B(Ind)=-1;
        else
        CLT=left(i,j,k);
        CRT=right(i,j,k);
        CFT=front(i,j,k);
        CBK=back(i,j,k);
        CBM=bottom(i,j,k);
        CTP=top(i,j,k);
        % Load the [A] matrix and {B} vector
        A(Ind,Ind+1)=CRT;
        A(Ind,Ind-NC)=CFT;       
        A(Ind,Ind+NC)=CBK;
        A(Ind,Ind-NR*NC)=CBM;
        A(Ind,Ind+NR*NC)=CTP;
        A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
        B(Ind)=-(CLT*Ta(1)+Q(i,j,k));
        end
    end
end
% Front edge interior nodes
i=1;
j=1;
for k=2:NL-1
        Ind=(k-1)*NR*NC+(i-1)*NC+j;
        if Mat(i,j,k)==0
           A(Ind,Ind)=1;
           B(Ind)=-1;
        else
        CLT=left(i,j,k);
        CRT=right(i,j,k);
        CFT=front(i,j,k);
        CBK=back(i,j,k);
        CBM=bottom(i,j,k);
        CTP=top(i,j,k);
        % Load the [A] matrix and {B} vector
        A(Ind,Ind+1)=CRT;
        A(Ind,Ind+NC)=CBK;
        A(Ind,Ind-NR*NC)=CBM;
        A(Ind,Ind+NR*NC)=CTP;
        A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
        B(Ind)=-(CLT*Ta(1)+CFT*Ta(3)+Q(i,j,k));
        end
end
% Back edge interior nodes
i=NR;
j=1;
for k=2:NL-1
        Ind=(k-1)*NR*NC+(i-1)*NC+j;
        if Mat(i,j,k)==0
           A(Ind,Ind)=1;
           B(Ind)=-1;
        else
        CLT=left(i,j,k);
        CRT=right(i,j,k);
        CFT=front(i,j,k);
        CBK=back(i,j,k);
        CBM=bottom(i,j,k);
        CTP=top(i,j,k);
        % Load the [A] matrix and {B} vector
        A(Ind,Ind+1)=CRT;
        A(Ind,Ind-NC)=CFT;       
        A(Ind,Ind-NR*NC)=CBM;
        A(Ind,Ind+NR*NC)=CTP;
        A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
        B(Ind)=-(CLT*Ta(1)+CBK*Ta(4)+Q(i,j,k));
        end
end
% Bottom edge interior nodes
k=1;
j=1;
for i=2:NR-1
        Ind=(k-1)*NR*NC+(i-1)*NC+j;
        if Mat(i,j,k)==0
           A(Ind,Ind)=1;
           B(Ind)=-1;
        else
        CLT=left(i,j,k);
        CRT=right(i,j,k);
        CFT=front(i,j,k);
        CBK=back(i,j,k);
        CBM=bottom(i,j,k);
        CTP=top(i,j,k);
        % Load the [A] matrix and {B} vector
        A(Ind,Ind+1)=CRT;
        A(Ind,Ind-NC)=CFT;       
        A(Ind,Ind+NC)=CBK;
        A(Ind,Ind+NR*NC)=CTP;
        A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
        B(Ind)=-(CLT*Ta(1)+CBM*Ta(5)+Q(i,j,k));
        end
end
% Top edge interior nodes
k=NL;
j=1;
for i=2:NR-1
        Ind=(k-1)*NR*NC+(i-1)*NC+j;
        if Mat(i,j,k)==0
           A(Ind,Ind)=1;
           B(Ind)=-1;
        else
        CLT=left(i,j,k);
        CRT=right(i,j,k);
        CFT=front(i,j,k);
        CBK=back(i,j,k);
        CBM=bottom(i,j,k);
        CTP=top(i,j,k);
        % Load the [A] matrix and {B} vector
        A(Ind,Ind+1)=CRT;
        A(Ind,Ind-NC)=CFT;       
        A(Ind,Ind+NC)=CBK;
        A(Ind,Ind-NR*NC)=CBM;
        A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
        B(Ind)=-(CLT*Ta(1)+CTP*Ta(6)+Q(i,j,k));
        end
end
% Bottom, Front corner
i=1;
j=1;
k=1;
Ind=(k-1)*NR*NC+(i-1)*NC+j;
if Mat(i,j,k)==0
   A(Ind,Ind)=1;
   B(Ind)=-1;
else
CLT=left(i,j,k);
CRT=right(i,j,k);
CFT=front(i,j,k);
CBK=back(i,j,k);
CBM=bottom(i,j,k);
CTP=top(i,j,k);
% Load the [A] matrix and {B} vector
A(Ind,Ind+1)=CRT;
A(Ind,Ind+NC)=CBK;
A(Ind,Ind+NR*NC)=CTP;
A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
B(Ind)=-(CLT*Ta(1)+CFT*Ta(3)+CBM*Ta(5)+Q(i,j,k));
end
% Bottom, Back corner
i=NR;
j=1;
k=1;
Ind=(k-1)*NR*NC+(i-1)*NC+j;
if Mat(i,j,k)==0
   A(Ind,Ind)=1;
   B(Ind)=-1;
else
CLT=left(i,j,k);
CRT=right(i,j,k);
CFT=front(i,j,k);
CBK=back(i,j,k);
CBM=bottom(i,j,k);
CTP=top(i,j,k);
% Load the [A] matrix and {B} vector
A(Ind,Ind+1)=CRT;
A(Ind,Ind-NC)=CFT;
A(Ind,Ind+NR*NC)=CTP;
A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
B(Ind)=-(CLT*Ta(1)+CBK*Ta(4)+CBM*Ta(5)+Q(i,j,k));
end
% Top, Front corner
i=1;
j=1;
k=NL;
Ind=(k-1)*NR*NC+(i-1)*NC+j;
if Mat(i,j,k)==0
   A(Ind,Ind)=1;
   B(Ind)=-1;
else
CLT=left(i,j,k);
CRT=right(i,j,k);
CFT=front(i,j,k);
CBK=back(i,j,k);
CBM=bottom(i,j,k);
CTP=top(i,j,k);
% Load the [A] matrix and {B} vector
A(Ind,Ind+1)=CRT;
A(Ind,Ind+NC)=CBK;
A(Ind,Ind-NR*NC)=CBM;
A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
B(Ind)=-(CLT*Ta(1)+CFT*Ta(3)+CTP*Ta(6)+Q(i,j,k));
end
% Top, Back corner
i=NR;
j=1;
k=NL;
Ind=(k-1)*NR*NC+(i-1)*NC+j;
if Mat(i,j,k)==0
   A(Ind,Ind)=1;
   B(Ind)=-1;
else
CLT=left(i,j,k);
CRT=right(i,j,k);
CFT=front(i,j,k);
CBK=back(i,j,k);
CBM=bottom(i,j,k);
CTP=top(i,j,k);
% Load the [A] matrix and {B} vector
A(Ind,Ind+1)=CRT;
A(Ind,Ind-NC)=CFT;
A(Ind,Ind-NR*NC)=CBM;
A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
B(Ind)=-(CLT*Ta(1)+CBK*Ta(4)+CTP*Ta(6)+Q(i,j,k));
end