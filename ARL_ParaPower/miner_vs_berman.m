% load ipack.mat


length(ipack.Model.GlobalTime)

clf

time_vec = [1 8 16 24 31];
totalcol = length(time_vec);
ncol = 0;

for time = time_vec
    
    ncol = ncol + 1;
    
[a b c] = Stress_NoSubstrate_Miner_time(ipack,time);
[x y z] = Stress_NoSubstrate3D(ipack,time);
diff = ((a-x).^2).^0.5;
        
    subplot(3,totalcol,0*totalcol+ncol)
    imagesc(a(:,:,3))
    axis equal
    colorbar
    title(sprintf('Miner @%d',time))
    
    subplot(3,totalcol,1*totalcol+ncol)
    imagesc(x(:,:,3))
    axis equal
    colorbar
    title(sprintf('Berman @%d',time))
    
    subplot(3,totalcol,2*totalcol+ncol)
    imagesc(diff(:,:,3))
    axis equal
    colorbar
    title(sprintf('Diff @%d',time))
    
end