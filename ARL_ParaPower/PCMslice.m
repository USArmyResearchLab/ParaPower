%Written by Michael Deckard
%subdivides any layer that has a PCM into smaller layers for more accurate
%simulation


function [xlayout,ylayout,NL,dz,bmat,Q_matrix] = PCMslice(xlayout,ylayout,dz,bmat,matprops,delta_t,transteps)

%ASSUMPTIONS
%assumes layers are in ascending numerical order

program_steps = 5; %set this number to the longest number of heat generation settings in the run
Q_setup = zeros(2,program_steps,size(xlayout,1)); %preallocates Q_setup matrix

Q_setup(1:2,1:3,1) = [0,100,200;0,.005,.01]; %this places heat generation into a feature. The second index of the assignment of Q_setup should be number of heat generation settings in the run
%the third index in the assignment of Q_setup is the nth feature in
%xlayout. The first row of the assignment is the heat generation in watts for the feature, and the second row is the time at which the feature achieves this heat generation. repeat as necessary for each feature
%times must start at the initial time of the run and end at the final time
%of the run

Q_setup(1:2,1:5,3) = [50,20,200,-30,0;0,.001,.002,.003,.01];

Q_matrix = zeros(size(xlayout,1),transteps); %preallocates Q_matrix
%Q_matrix has indexes with meaning of (for each feature,for each timestep)
%each row in Q_matrix corresponds to a row in xlayout
for i = 1:size(xlayout,1)
    if any(Q_setup(2,:,i)) %if times for a Q have been assigned for this feature
        for p = 1:size(Q_setup(2,1+find(Q_setup(2,2:end,i)~=0),i),2) %for each entry heat generation entry into Q_setup for a specific feature
            if rem((Q_setup(2,p,i)+delta_t),delta_t) < delta_t/2
                t1 = floor((Q_setup(2,p,i)+delta_t)/delta_t)*delta_t;
            else
                t1 = ceil((Q_setup(2,p,i)+delta_t)/delta_t)*delta_t;
            end
            if rem(Q_setup(2,p+1,i),delta_t) < delta_t
                t2 = floor(Q_setup(2,p+1,i)/delta_t)*delta_t;
            else
                t2 = ceil(Q_setup(2,p+1,i)/delta_t)*delta_t;
            end
            %finds start and end times that are divisible by the delta_t closest to the
            %setpoint start and end times for each programmed Q setpoint
            Q_matrix(i,t1/delta_t:t2/delta_t) = interp1(Q_setup(2,p:p+1,i),Q_setup(1,p:p+1,i),t1:delta_t:t2);
            %assignes matrix of interpolated Q values for each set of times
        end
    end
end

% Q_matrix = sparse(Q_matrix);

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
                %NEEDS CHANGE, NO LONGER LINEAR POWER
                xlayout(ii+jj,5) = xlayout(ii+jj,5)/(n+1);
                editxlayout = repmat(xlayout(ii+jj,:),n,1); %xlayout matrix of subdivided layers, minus the first layer
                xlayout = cat(1,xlayout(1:ii+jj,:),editxlayout,xlayout(ii+jj+1:end,:)); %combine xlayout layers
                editQ_matrix = bsxfun(@times,repmat(Q_matrix(ii+jj,:),n,1)./Ltot,dz(ii+1:ii+n)'); %I think this is how spreading out the Q_matrix to match the change in xlayout should work
                Q_matrix(ii+jj,:) = Q_matrix(ii+jj,:)./Ltot.*dz(ii+jj); %assigns power generation of new subdivided layer based on total power of feature
                
                %need to account for the change in power for each
                %subdivided element the occurs when slicing
                Q_matrix = cat(1,Q_matrix(1:ii+jj,:),editQ_matrix,Q_matrix(ii+jj+1:end,:));
                
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