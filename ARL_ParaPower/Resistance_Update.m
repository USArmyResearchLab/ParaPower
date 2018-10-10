function [A,B] = Resistance_Update(ind,A,B,Ta,Mat,h,K,dx,dy,dz)

K=reshape(K,size(Mat));

Ind=index(size(Mat),ind);

        CLT=left(Ind(1),Ind(2),Ind(3),h,Mat,K,dx,dy,dz);
        CRT=right(Ind(1),Ind(2),Ind(3),h,Mat,K,dx,dy,dz,size(Mat,2));
        CFT=front(Ind(1),Ind(2),Ind(3),h,Mat,K,dx,dy,dz);
        CBK=back(Ind(1),Ind(2),Ind(3),h,Mat,K,dx,dy,dz,size(Mat,1));
        CBM=bottom(Ind(1),Ind(2),Ind(3),h,Mat,K,dx,dy,dz);
        CTP=top(Ind(1),Ind(2),Ind(3),h,Mat,K,dx,dy,dz,size(Mat,3));

A=A;
B=B;

end