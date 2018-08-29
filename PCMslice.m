function [xlayout,ylayout,NL,dz,bmat] = PCMslice(xlayout,ylayout,dz,bmat,matprops)

%ASSUMPTIONS
%assumes layers are in ascending numerical order

layermax = 0.0017/20; %max layer thickness for any layer with PCM
isPCM = matprops(:,7)'; %vector that takes a material list pointer and returns true if that material is a PCM
j = 0; %index adjustment from adding layers
m = 0; %current layer count
% num_feat = 0; %number of features in a layer
n = 0; %number of additional layers a layer should be subdivided into

% Ltot=2e-4;  %total length to be spanned
% n=8;        %number of elements
% ratio=20;  %size ratio between first and last element
% %growth from element to element will be ratio^(1/(N-1))
% 
% factor=logspace(0,log10(ratio),n);
% L1=Ltot/sum(factor');
% ele_length=L1.*factor;  %vector of element lengths, which sums to Ltot
% 
% n = size(ele_length);

%xlayout(:,7) is the pointer to the material of a feature or layer
%xlayout(:,6) is the layer of the feature

for i = 1:size(xlayout,1) %for each original layer
    if xlayout(i+j,6) > m+n && isPCM(xlayout(i+j,7)) == 1 %if we find PCM in an original layer that we haven't before
%         n = ceil(dz(xlayout(i+j,6))/layermax)-1; %find the number of additional layers this layer should be subdivided into
        
        Ltot = dz(i+j);
        k = 64;
        ratio = 20;
        
        factor = logspace(0,log10(ratio),k);
        L1 = Ltot/sum(factor');
        dz = cat(2,dz(1:i+j-1),L1.*factor,dz(i+j+1:end));
        n = k-1;

        m = xlayout(i+j,6); %set the layer number of this layer, helps indicate whether we have found PCM in this layer before
        if n
%             num_feat = sum(xlayout(:,6)==m); %number of features in layer
            xlayout(xlayout(:,6)>xlayout(i+j,6),6) = xlayout(xlayout(:,6)>xlayout(i+j,6),6) + n; %update layer numbers for each layer after the current (unsplit) layer
            
            editbmat = repmat(bmat(i+j),n,1);
            if size(bmat,1) >= i+j+1
                bmat = cat(1,bmat(1:i+j),editbmat,bmat(i+j+1:end));
            else
                bmat = cat(1,bmat(1:i+j),editbmat);
            end
            
%             thickness = dz(i+j)/(n+1); %thickness of each subdivided layer
%             editdz = ones(1,n)*thickness; %dz matrix of subdivided layers, minus the first layer
%             dz(i+j) = thickness; %edit the thickness of the first subdivided layer
%             
% %             editdz = diff([0 dz(i+j)*logspace(-1,0,n+1)]); %creates logarithmically spaced dz values where the smallest value is 1/10th of the total original thickness of the PCM layer
%             
%             
% %             dz = cat(2,dz(1:i+j-1),editdz,dz(i+j+1:end));
%             dz = cat(2,dz(1:i+j),editdz,dz(i+j+1:end)); %add the rest of the subdivided layers
            
            jj = 0; %index adjustment for multiple features in the same layer
            for ii = find(xlayout(:,6)==m)'
                xlayout(ii+jj,5) = xlayout(ii+jj,5)/(n+1);
                editxlayout = repmat(xlayout(ii+jj,:),n,1); %xlayout matrix of subdivided layers, minus the first layer
                xlayout = cat(1,xlayout(1:ii+jj,:),editxlayout,xlayout(ii+jj+1:end,:)); %combine xlayout layers
                for iii = 1:n %update layer number values for subdivided layers
                    xlayout(ii+jj+iii,6) = xlayout(ii+jj,6) + iii;
                end
                
                editylayout = repmat(ylayout(ii+jj,:),n,1);
                ylayout = cat(1,ylayout(1:ii+jj,:),editylayout,ylayout(ii+jj+1:end,:));
                
                jj= jj+n;
            end
            j = j+n;
        end
    end
end
NL = size(dz,2);