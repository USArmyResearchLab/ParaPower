function [isPCM,kondl,rhol,sphtl,Lw,Tm,PH,PH_init] = PCM_init(Mat,matprops,Num_Row,Num_Col,Num_Lay,steps)
%Initializes property pointers and dof vectors that are relevant for phase
%change

isPCM = matprops(:,7)'; %flags material as Phase Change Material, and thus meltable
kondl = matprops(:,8)'; %liquid thermal conductivity
rhol = matprops(:,9)'; %density of the liquid state
sphtl = matprops(:,10)'; %solid volumetric heat (volumetric form of specific heat)
Lw = matprops(:,11)'; %Latent heat of fusion
Tm = matprops(:,12)'; %Melting point of material, in degrees C

PH = zeros(nnz(Mat>0),steps); %percent melted of a given node
PH_init=zeros(nnz(Mat>0),1);
end