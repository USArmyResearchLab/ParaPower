function [isPCM,kondl,rhol,sphtl,Lw,Tm,meltfrac,hft,K,CP,RHO] = PCM_init(matprops,Num_Row,Num_Col,Num_Lay,steps,Mat,kond,spht,rho)

isPCM = matprops(:,7)'; %flags material as Phase Change Material, and thus meltable
kondl = matprops(:,8)'; %liquid thermal conductivity
rhol = matprops(:,9)'; %density of the liquid state
sphtl = matprops(:,10)'; %solid volumetric heat (volumetric form of specific heat)
Lw = matprops(:,11)'; %Latent heat of fusion
Tm = matprops(:,12)'; %Melting point of material, in degrees C
meltfrac = zeros(Num_Row,Num_Col,Num_Lay,steps); %percent melted of a given node
hft = zeros(Num_Row,Num_Col,Num_Lay); %latent heat absorbed in a given node
K = zeros(Num_Row,Num_Col,Num_Lay); %effective conductivity matrix
CP = zeros(Num_Row,Num_Col,Num_Lay); %effective specific heat matrix
RHO = zeros(Num_Row,Num_Col,Num_Lay); %effective density matrix

for kk=1:Num_Lay
    for ii=1:Num_Row
        for jj=1:Num_Col
            %assumes all materials start simulation in solid form
            if Mat(ii,jj,kk)~=0
                K(ii,jj,kk) = kond(Mat(ii,jj,kk)); %Thermal Conductivity matrix for effective nodal thermal conductivities. Changes with time
                CP(ii,jj,kk) = spht(Mat(ii,jj,kk)); %Specific heat matrix for effective nodal specific heats. Changes with time for PCM nodes
                RHO(ii,jj,kk) = rho(Mat(ii,jj,kk)); % density matrix. Changes with time for PCM nodes
            end
        end
    end
end