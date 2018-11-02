function Dout=CreateTime(GlobalTime, Temp, Stress, MeltFraction)

Dout(:,1)=GlobalTime;
Dout(:,2)=zeros(size(GlobalTime));
Dout(:,3)=zeros(size(GlobalTime));
Dout(:,4)=zeros(size(GlobalTime));

% if length(GlobalTime)~=length(Temp(1,1,1,:))
% 	warning('Temp length does not match global time length')
% end
% if length(GlobalTime)~=length(Stress(1,1,1,:))
% 	warning('Stress length does not match global time length')
% end
% if length(GlobalTime)~=length(MeltFraction(1,1,1,:))
% 	warning('Melt fraction length does not match global time length')
% end

for I=1:length(GlobalTime)
	Dout(I,2)=max(max(Temp(:,:,:,I)));
	Dout(I,3)=max(max(Stress(:,:,:,I)));
	Dout(I,4)=max(max(MeltFraction(:,:,:,I)));
end