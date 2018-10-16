function [T,PH,changing,K,CP,RHO]=vec_Phase_Change(T,PH,Mat,kond,kondl,spht,sphtl,rho,rhol,Tm,Lv,K,CP,RHO)
%take in T(:,t),PH(:,t-1),Mat,properties,geometry
%make sure latent heat is volumetric!
%pass out updated T(:,t), current PH(:,t), updated properties, and flags to
%use updated properties.
% post melt.

Mat=reshape(Mat,[],1);

%Case Checking
state=[T>Tm(Mat)',PH~=0,PH==1];

%      011 (Solidifying)  |  111 (Liquid)
%    1 -------------------|---------------------
% PH   010 (Solidifying)  |  110 (Melting)
%    0 -------------------|---------------------
%      000 (Solid)        |  100 (Melting)
%     ____________________|_____________________T
%                         Tm                   

% compute direction of Temp, PH adjustments
changing = ~all(state,2) & any(state,2);  %ones where some change is happening

if any(changing)  %things are changing phase, update
    direction = (2*state(changing,1)-1);  %decide a direction based on T>Tm
    %has length=nnz(changing) i.e. is only defined for changing nodes
    
    %Update DOF of changing elements
    PH(changing) = PH(changing) + direction .*(abs(T(changing)-Tm(Mat(changing))')).*(RHO(changing).*CP(changing)./Lv(Mat(changing))');  %increment PH according to excess sensible
    T(changing) = T(changing) - direction .* abs(T(changing)-Tm(Mat(changing))');                %decrement T by temperature excess
    %Everything right unless overmelted/oversolidified  PH>1 || PH<0
    
    PH_ex=max(1/2,abs(PH(changing)-1/2))-1/2;   %unsigned excursion outside of interval 0<PH<1
    PH(changing)=PH(changing)-PH_ex.*direction; %PH is pinned to be within [0,1]
    
    K(changing) = 1./( PH(changing)./kondl(Mat(changing))' +(1-PH(changing))./kond(Mat(changing))');  %update properties, K using series resistance
    CP(changing) = sphtl(Mat(changing))'.*PH(changing)+spht(Mat(changing))'.*(1-PH(changing));           %others using rule of mixtures
    RHO(changing) = rhol(Mat(changing))'.*PH(changing)+rho(Mat(changing))'.*(1-PH(changing));
    
    %walk back PH_ex into T using new properties
    T(changing) = T(changing) + direction .* PH_ex .* (Lv(Mat(changing))'./(RHO(changing).*CP(changing)));
    
    
else %no change

end

end


