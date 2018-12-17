function [kondl,rhol,sphtl,Lw,Tm,PH,PH_init] = PCM_init(ModelInput,Mat)
%function [isPCM,kondl,rhol,sphtl,Lw,Tm,PH,PH_init] = PCM_init(Mat,matprops,Num_Row,Num_Col,Num_Lay,steps)
%Initializes property pointers and dof vectors that are relevant for phase
%change


kondl = ModelInput.MatLib.k_l; %liquid thermal conductivity
rhol = ModelInput.MatLib.rho_l; %density of the liquid state
sphtl = ModelInput.MatLib.cp_l; %solid volumetric heat (volumetric form of specific heat)
Lw = ModelInput.MatLib.lf; %Latent heat of fusion
Tm = ModelInput.MatLib.tmelt; %Melting point of material, in degrees C

PH = zeros(nnz(Mat>0),max([2 length(ModelInput.GlobalTime)])); %percent melted of a given node
PH_init=zeros(nnz(Mat>0),1);
end