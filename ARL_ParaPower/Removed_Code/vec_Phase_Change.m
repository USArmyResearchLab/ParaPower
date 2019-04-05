function [T,PH,changing,K,CP,RHO]=vec_Phase_Change(T,PH,Mat,Map,meltmask,kond,kondl,spht,sphtl,rho,rhol,Tm,Lv,K,CP,RHO)
%take in T(:,t),PH(:,t-1),Mat,properties,geometry
%make sure latent heat is volumetric!
%pass out updated T(:,t), current PH(:,t), updated properties, and flags to
%use updated properties.
% post melt.

if ~any(meltmask)  %no meltable elements declared
    changing=meltmask;
    return
end

%Case Checking
state=[T(meltmask)>Tm(Mat(Map(meltmask))),PH(meltmask)~=0,PH(meltmask)==1];
%state is only defined for the meltable rows of A


%      011 (Solidifying)  |  111 (Liquid)
%    1 -------------------|---------------------
% PH   010 (Solidifying)  |  110 (Melting)
%    0 -------------------|---------------------
%      000 (Solid)        |  100 (Melting)
%     ____________________|_____________________T
%                         Tm                   

% compute direction of Temp, PH adjustments
changing = ~all(state,2) & any(state,2);  %ones where some change is happening
%changing mask is same size as state
meltmask(meltmask==1)=changing; %update meltable rows to only those changing


if any(changing)  %things are changing phase, update
    direction = (2*state(changing,1)-1);  %decide a direction based on T>Tm
    %has length=nnz(changing) i.e. is only defined for changing nodes
    changing=meltmask;
    %changing now expanded to size of meltmask for direct pass
    
    %Update DOF of changing elements
    PH(changing) = PH(changing) + direction.*(abs(T(changing)-Tm(Mat(Map(changing))))).*(RHO(changing).*CP(changing)./Lv(Mat(Map(changing))));  %increment PH according to excess sensible
    T(changing) = T(changing) - direction .* abs(T(changing)-Tm(Mat(Map(changing))));                %decrement T by temperature excess
    %Everything right unless overmelted/oversolidified  PH>1 || PH<0
    
    PH_ex=zeros(size(PH));
    PH_ex(changing)=max(1/2,abs(PH(changing)-1/2))-1/2;   %unsigned excursion outside of interval 0<PH<1
    PH(changing)=PH(changing)-PH_ex(changing).*direction; %PH is pinned to be within [0,1]  Seen machine error issues here
    PH(PH_ex~=0)=round(PH(PH_ex~=0));
    
    
    K(changing) = 1./( PH(changing)./kondl(Mat(Map(changing))) +(1-PH(changing))./kond(Mat(Map(changing))));  %update properties, K using series resistance
    CP(changing) = sphtl(Mat(Map(changing))).*PH(changing)+spht(Mat(Map(changing))).*(1-PH(changing));           %others using rule of mixtures
    RHO(changing) = rhol(Mat(Map(changing))).*PH(changing)+rho(Mat(Map(changing))).*(1-PH(changing));
    
    %walk back PH_ex into T using new properties
    if any(PH_ex)
        T(changing) = T(changing) + direction .* PH_ex(changing) .* (Lv(Mat(Map(changing)))./(RHO(changing).*CP(changing)));
    end
    
else %no change
    changing=meltmask;  %update changing to the expanded size (its all zeros)
end

end


