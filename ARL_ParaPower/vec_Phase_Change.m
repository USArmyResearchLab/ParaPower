function [T,PH,changing,K,CP,RHO]=vec_Phase_Change(T,PH,Mat,kond,kondl,spht,sphtl,rho,rhol,Tm,Lv,K,CP,RHO)
%take in T(:,t),PH(:,t-1),Mat,properties,geometry
%make sure latent heat is volumetric!
%pass out updated T(:,t), current PH(:,t), updated properties, and flags to
%use updated properties.
% post melt.

Mat=reshape(Mat,[],1);

cutoff=1e100;  %we want direction .* abs(T-Tm(Mat)') to evaluate to 0 when 0 * inf
% so direction.*min(abs(T-Tm(Mat)'),cutoff) -> 0 * min(inf,cutoff) -> 0
%issue is direction is a should be thought of as logical 0, but is int
%valued

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
    direction = (2*state(:,1)-1).*changing;  %decide a direction based on T>Tm then zero out if not changing
    
    %Update DOF
    PH = PH + direction .* min(abs(T-Tm(Mat)'),cutoff).*(RHO.*CP./Lv(Mat)');  %increment PH according to excess sensible
    T = T - direction .* min(abs(T-Tm(Mat)'),cutoff);                %decrement T by temperature excess
    %Everything right unless overmelted/oversolidified  PH>1 || PH<0
    
    PH_ex=max(1/2,abs(PH-1/2))-1/2;   %unsigned excursion outside of interval 0<PH<1
    PH=PH-PH_ex.*direction; %PH is pinned to be within [0,1]
    
    K = 1./( PH./kondl(Mat)' +(1-PH)./kond(Mat)');  %update properties, K using series resistance
    CP = sphtl(Mat)'.*PH+spht(Mat)'.*(1-PH);           %others using rule of mixtures
    RHO = rhol(Mat)'.*PH+rho(Mat)'.*(1-PH);
    
    %walk back PH_ex into T using new properties
    T = T + direction .* PH_ex .* min((Lv(Mat)'./(RHO.*CP)),cutoff);
    
    
else %no change
    T = T;
    PH = PH;
    K = K;
    CP = CP;
    RHO = RHO;
end

end


