function [A,B,Map,fullheader,Ta_vec]=null_void_init(Mat,h,hint,A,B,Map,Ta,Ta_void)
% Modifies connectivity maps to account for internal voids and null
% materials.  The returned index Map is updated from optional 4th arg or
% from default constructed via Mat.
%  Does not break connectivity due to low dimensional elements or
%  explicitly zero conductances.  Row/Col of nulled materials deleted, void
%  connections reordered to become part of B.

Map=reshape(Map,[],1);


%{
Aold=A;
Bold=B;
Matold=Mat;
Mapold=Map;
%}

header=[];

if any(Mat(:)<0)        %Handle any voids present in the model and reconfigure

   
    
    for voidnum=1:abs(min(Mat(:)))
        voids = Mat(:)==-voidnum;
        if ~any(voids)  %there are no voids of this number
            continue
        end
        if voidnum>numel(hint)|| hint(voidnum)==0  %the voids of this number have an undefined or zero h
            Mat(Mat==-voidnum) = 0;  %reset the material number of these voids to null material
            fprintf('Void %d has zero or undefined h.\n',-voidnum)
            continue
        end
        
        remap_full = [find(~voids); find(voids)];
        remain = nnz(~voids);  
               
        A(:,:)=A(remap_full,remap_full); 
        B(:,:)=B(remap_full,:);
        Map(:)=Map(remap_full);
        Mat(:)=Mat(remap_full);
        
        %collapse A by shifting void connections to B and collecting
        %be careful of connection multiplicity
        
        %B=[sum(A(1:remain,remain+1:end),2) B(1:remain,:)]; %Does not
        %respect multiplicity
        
        Badd = A(1:remain,remain+1:end);
        [i,~]=find(Badd);
        if length(i)==length(unique(i)) %there are no multiplicities
            B=[sum(Badd,2) B(1:remain,:)]; %essentially or'ing things
            mt=1;
        else
            Badd = sort(Badd,2,'descend');  %move all nonzero entries to left
            [~,j]=find(Badd);
            mt=max(j);                       %j lists multiplicity
            B = [Badd(:,1:mt) B(1:remain,:)];  
        end
        
        
        A=A(1:remain,1:remain);
        Map=Map(1:remain);
        Mat=Mat(1:remain);
        
        header=[-voidnum*ones(1,mt) header];
        
    end
end

%{
Attempt at a direct reconfigure
if any(Mat(:)<0)
    for voidnum=1:abs(min(Mat(:)))
        voids = Mat==-voidnum;
        remap_full = [find(~voids); find(voids)];
        remain = nnz(~voids);
        remap_trc = remap_full(1:remain);  
               
        A=A(remap_trc,remap_trc); 
        B=B(remap_full,:);
        Map=Map(remap_trc);
        Mat=Mat(remap_trc);
        
        %collapse B by shifting void connections as single column fort this
        %void type
        B=[any(A(1:remain,remain+1:end),2) B(1:remain,:)];
    end
end
%}

if any(Mat(:)==0)  %Handle any null materials and reconfigure
    remap=find(Mat);
    
    A=A(remap,remap);   %delete rows and cols corresponding to null materials
    B=B(remap,:);       %delete rows 
    Map=Map(remap);     %consolidate Map and Mat
    Mat=Mat(remap);
end

fullheader=[header find(h)]; %fullheader is a rowvector of negative matnums and a subset of 1 thru 6
Ta_vec=Ta_void(-(header)); 
Ta_vec=[Ta_vec Ta(h~=0)];  %grab just those Ta corresponding to the active ext boundaries

end