function [kondl,rhol,sphtl,Lw,Tm,PH,PH_init] = PCM_init(ModelInput)
%function [isPCM,kondl,rhol,sphtl,Lw,Tm,PH,PH_init] = PCM_init(Mat,matprops,Num_Row,Num_Col,Num_Lay,steps)
%Initializes property pointers and dof vectors that are relevant for phase
%change


kondl = ModelInput.Matlib.kondl; %liquid thermal conductivity
rhol = ModelInput.Matlib.rhol; %density of the liquid state
sphtl = ModelInput.Matlib.sphtl; %solid volumetric heat (volumetric form of specific heat)
Lw = ModelInput.Matlib.L; %Latent heat of fusion
Tm = ModelInput.Matlib.Tm; %Melting point of material, in degrees C

PH = zeros(nnz(ModelInput.Model>0),length(ModelInput.GlobalTime)); %percent melted of a given node
PH_init=zeros(nnz(ModelInput.Model>0),1);
end