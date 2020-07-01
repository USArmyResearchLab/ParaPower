function [sigmaX,sigmaY]=substrate_ex_Miner1(Resultss,row,col,lay,dT,dzs,nlsubs,NLs,Ex,Ey,nux,nuy,ctex,ctey,Mats,Melts)
% This function calculates the thermal stress in the top layer of the
% substrate material
z=-sum(dzs(1:nlsubs))+sum(dzs(1:lay))-dzs(lay)/2;
EbsX=Ex(Mats(row,col,lay))/(1-nux(Mats(row,col,lay)));
EbsY=Ey(Mats(row,col,lay))/(1-nuy(Mats(row,col,lay)));
dTs=mean(dT(row,col,1:nlsubs));
ts=sum(dzs(1:nlsubs));
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
for i=nlsubs+1:NLs
    % Skip locations that have no material, IBC's, Fluid and
    % non-zero Melt fractions
    if Mats(row,col,i) == 0
        ckMatl=false;
    else
        ckMatl=isa(Resultss.Model.MatLib.GetMatNum(Mats(row,col,i)),'PPMatSolid');
    end
    if  ckMatl == 0 || Melts(row,col,i) > 0
        sumcnX=sumcnX+0;
        sumdX=sumdX+0;
        sumtbnX=sumtbnX+0;
        sumcnY=sumcnY+0;
        sumdY=sumdY+0;
        sumtbnY=sumtbnY+0;        
    else
        EbiX=Ex(Mats(row,col,i))/(1-nux(Mats(row,col,i)));
        sumcnX=sumcnX+EbiX*dzs(i)*ctex(Mats(row,col,i))*dT(row,col,i);
        sumdX=sumdX+EbiX*dzs(i);
        EbiY=Ey(Mats(row,col,i))/(1-nuy(Mats(row,col,i)));
        sumcnY=sumcnY+EbiY*dzs(i)*ctey(Mats(row,col,i))*dT(row,col,i);
        sumdY=sumdY+EbiY*dzs(i);        
        if i == nlsubs+1
            him1=0;
        else
            him1=sum(dzs(nlsubs+1:i-1));
        end
        sumtbnX=sumtbnX+EbiX*dzs(i)*(2*him1+dzs(i));
        sumtbnY=sumtbnY+EbiY*dzs(i)*(2*him1+dzs(i));        
    end
end
cX=(EbsX*ts*ctex(Mats(row,col,nlsubs))*dTs+sumcnX)/(EbsX*ts+sumdX);
tbX=((-EbsX*ts^2)+sumtbnX)/(2*(EbsX*ts+sumdX));
cY=(EbsY*ts*ctey(Mats(row,col,nlsubs))*dTs+sumcnY)/(EbsY*ts+sumdY);
tbY=((-EbsY*ts^2)+sumtbnY)/(2*(EbsY*ts+sumdY));
for i=nlsubs+1:NLs
    % Skip locations that have no material, IBC's, Fluid and
    % non-zero Melt fractions
    if Mats(row,col,i) == 0
        ckMatl=false;
    else
        ckMatl=isa(Resultss.Model.MatLib.GetMatNum(Mats(row,col,i)),'PPMatSolid');
    end
    if  ckMatl == 0 || Melts(row,col,i) > 0
        sumrnX=sumrnX+0;
        sumrdX=sumrdX+0;
        sumrnY=sumrnY+0;
        sumrdY=sumrdY+0;        
    else
        EbiX=Ex(Mats(row,col,i))/(1-nux(Mats(row,col,i)));
        EbiY=Ey(Mats(row,col,i))/(1-nuy(Mats(row,col,i)));        
        if i == nlsubs+1
            him1=0;
        else
            him1=sum(dzs(nlsubs+1:i-1));
        end
        sumrdX=sumrdX+EbiX*dzs(i)*(cX-ctex(Mats(row,col,i))*dT(row,col,i))*(2*him1+dzs(i));
        sumrnX=sumrnX+EbiX*dzs(i)*(6*(him1^2+him1*dzs(i))+2*dzs(i)^2-3*tbX*(2*him1+dzs(i)));
        sumrdY=sumrdY+EbiY*dzs(i)*(cY-ctey(Mats(row,col,i))*dT(row,col,i))*(2*him1+dzs(i));
        sumrnY=sumrnY+EbiY*dzs(i)*(6*(him1^2+him1*dzs(i))+2*dzs(i)^2-3*tbY*(2*him1+dzs(i)));        
    end
end
rX=((EbsX*ts^2)*(2*ts+3*tbX)+sumrnX)/(3*(EbsX*(cX-ctex(Mats(row,col,lay))*dTs)*ts^2-sumrdX));
epsX=cX+(z-tbX)/rX;
sigmaX=EbsX*(epsX-ctex(Mats(row,col,lay))*dT(row,col,lay));
rY=((EbsY*ts^2)*(2*ts+3*tbY)+sumrnY)/(3*(EbsY*(cY-ctey(Mats(row,col,lay))*dTs)*ts^2-sumrdY));
epsY=cY+(z-tbY)/rY;
sigmaY=EbsY*(epsY-ctey(Mats(row,col,lay))*dT(row,col,lay));
end
