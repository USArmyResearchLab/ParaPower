function [sigmaX,sigmaY]=layer_ex_Miner1(Resultsl,row,col,lay,dT,dzl,nlsubl,NLl,Ex,Ey,nux,nuy,ctex,ctey,Matl,Meltl)
% This function calculates the thermal stress in the film layers
% Based on paper by C. H. Hsueh, Thin Solid Films, Vol 418, 2002
if lay == nlsubl+1
    z=dzl(lay)/2;
else
    z=sum(dzl(nlsubl+1:lay-1))+dzl(lay)/2;
end
EbsX=Ex(Matl(row,col,nlsubl))/(1-nux(Matl(row,col,nlsubl)));
EbsY=Ey(Matl(row,col,nlsubl))/(1-nuy(Matl(row,col,nlsubl)));
dTs=mean(dT(row,col,1:nlsubl));
ts=sum(dzl(1:nlsubl));
EblX=Ex(Matl(row,col,lay))/(1-nux(Matl(row,col,lay)));
EblY=Ey(Matl(row,col,lay))/(1-nuy(Matl(row,col,lay)));
% Calculate sums in the equations for c, tb and r
sumcnX=0;
sumdX=0;
sumtbnX=0;
sumrnX=0;
sumrdX=0;
sumcnY=0;
sumdY=0;
sumtbnY=0;
sumrnY=0;
sumrdY=0;
for i=nlsubl+1:NLl
    % Skip locations that have no material, IBC's, Fluid and
    % non-zero Melt fractions
    if Matl(row,col,i) == 0
        ckMatl=false;
    else
        ckMatl=isa(Resultsl.Model.MatLib.GetMatNum(Matl(row,col,i)),'PPMatSolid');
    end
    if  ckMatl == 0 || Meltl(row,col,i) > 0
        sumcnX=sumcnX+0;
        sumdX=sumdX+0;
        sumtbnX=sumtbnX+0;
        sumcnY=sumcnY+0;
        sumdY=sumdY+0;
        sumtbnY=sumtbnY+0;        
    else
        EbiX=Ex(Matl(row,col,i))/(1-nux(Matl(row,col,i)));
        sumcnX=sumcnX+EbiX*dzl(i)*ctex(Matl(row,col,i))*dT(row,col,i);
        sumdX=sumdX+EbiX*dzl(i);
        EbiY=Ey(Matl(row,col,i))/(1-nuy(Matl(row,col,i)));
        sumcnY=sumcnY+EbiY*dzl(i)*ctey(Matl(row,col,i))*dT(row,col,i);
        sumdY=sumdY+EbiY*dzl(i);        
        if i == nlsubl+1
            him1=0;
        else
            him1=sum(dzl(nlsubl+1:i-1));
        end
        sumtbnX=sumtbnX+EbiX*dzl(i)*(2*him1+dzl(i));
        sumtbnY=sumtbnY+EbiY*dzl(i)*(2*him1+dzl(i));        
    end
end
cX=(EbsX*ts*ctex(Matl(row,col,nlsubl))*dTs+sumcnX)/(EbsX*ts+sumdX);
tbX=((-EbsX*ts^2)+sumtbnX)/(2*(EbsX*ts+sumdX));
cY=(EbsY*ts*ctey(Matl(row,col,nlsubl))*dTs+sumcnY)/(EbsY*ts+sumdY);
tbY=((-EbsY*ts^2)+sumtbnY)/(2*(EbsY*ts+sumdY));
for i=nlsubl+1:NLl
    % Skip locations that have no material, IBC's, Fluid and
    % non-zero Melt fractions
    if Matl(row,col,i) == 0
        ckMatl=false;
    else
        ckMatl=isa(Resultsl.Model.MatLib.GetMatNum(Matl(row,col,i)),'PPMatSolid');
    end
    if  ckMatl == 0 || Meltl(row,col,i) > 0
        sumrnX=sumrnX+0;
        sumrdX=sumrdX+0;
        sumrnY=sumrnY+0;
        sumrdY=sumrdY+0;        
    else
        EbiX=Ex(Matl(row,col,i))/(1-nux(Matl(row,col,i)));
        EbiY=Ey(Matl(row,col,i))/(1-nuy(Matl(row,col,i)));        
        if i == nlsubl+1
            him1=0;
        else
            him1=sum(dzl(nlsubl+1:i-1));
        end
        sumrdX=sumrdX+EbiX*dzl(i)*(cX-ctex(Matl(row,col,i))*dT(row,col,i))*(2*him1+dzl(i));
        sumrnX=sumrnX+EbiX*dzl(i)*(6*(him1^2+him1*dzl(i))+2*dzl(i)^2-3*tbX*(2*him1+dzl(i)));
        sumrdY=sumrdY+EbiY*dzl(i)*(cY-ctey(Matl(row,col,i))*dT(row,col,i))*(2*him1+dzl(i));
        sumrnY=sumrnY+EbiY*dzl(i)*(6*(him1^2+him1*dzl(i))+2*dzl(i)^2-3*tbY*(2*him1+dzl(i)));        
    end
end
rX=((EbsX*ts^2)*(2*ts+3*tbX)+sumrnX)/(3*(EbsX*(cX-ctex(Matl(row,col,nlsubl))*dTs)*ts^2-sumrdX));
epsX=cX+(z-tbX)/rX;
sigmaX=EblX*(epsX-ctex(Matl(row,col,lay))*dT(row,col,lay));
rY=((EbsY*ts^2)*(2*ts+3*tbY)+sumrnY)/(3*(EbsY*(cY-ctey(Matl(row,col,nlsubl))*dTs)*ts^2-sumrdY));
epsY=cY+(z-tbY)/rY;
sigmaY=EblY*(epsY-ctey(Matl(row,col,lay))*dT(row,col,lay));
end
