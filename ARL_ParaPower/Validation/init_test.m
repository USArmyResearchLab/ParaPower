clear
clc

nomsize=16;
randsize=1;
void_offset=0;

Mat=randi(10,randi(randsize)+nomsize,randi(randsize)+nomsize,randi(randsize)+nomsize)-void_offset;

%Mat(:,:,1) =     [5    -4     0    -3     5];
%Mat(:,:,2) =    [    -4     3     4     4    -4];
%Mat(:,:,3) =    [    -1    -2     4     0     5];


K=ones(size(Mat));
drow=randi(10,size(Mat,1),1);
dcol=randi(10,size(Mat,2),1);
dlay=randi(10,size(Mat,3),1);

h=[0 3 2 0 5 0];
hint=[1 0 3];
[A,B,Bext,Map]=Connect_Init(Mat,h);
[Acon,Bcon,newMap,header]=null_void_init(Mat,hint,A,B,Map);
fullheader=[header find(h)];

[Acond,Bcond,A_areas,B_areas,htcs] = conduct_build(Acon,Bcon,newMap,fullheader,K,hint,h,Mat,drow,dcol,dlay);
%find(Bcon)


%{
tic; spA=sparse(Acond); toc;
spB=sparse(Bcond);

tic; test1=Acond*Bcond; toc;
tic; test2=spA*Bcond; toc;
tic; test3=Acond*spB; toc;
tic; test4=spA*spB; toc;
%spy([Acond Bcond],'+')
%}