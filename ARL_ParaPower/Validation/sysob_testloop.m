clear
load('MItest.mat')

S1=sPPT;
S1.MI=MI;
GT=[1:1000];

for i=1:100
    [~,~]=step(S1,GT);
end