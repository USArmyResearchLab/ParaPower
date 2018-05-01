function Interior
global NL NR NC A B Q Mat
for k=2:NL-1
    for i=2:NR-1
        for j=2:NC-1
            Ind=(k-1)*NR*NC+(i-1)*NC+j;
            % Calculate the standard conductance values for the six nodes surrounding
            % a standard interior node
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
            % Load the [A] matrix and {B} vector with values for the standard interior node
            A(Ind,Ind-1)=CLT;
            A(Ind,Ind+1)=CRT;
            A(Ind,Ind-NC)=CFT;
            A(Ind,Ind+NC)=CBK;
            A(Ind,Ind-NR*NC)=CBM;
            A(Ind,Ind+NR*NC)=CTP;
            A(Ind,Ind)=-(CLT+CRT+CFT+CBK+CBM+CTP);
            B(Ind)=-Q(i,j,k);
           end
        end
    end
end