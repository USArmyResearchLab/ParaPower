load('mydata_07012020.mat')

clf
hold on
for t = 1:size(mat,4)
    x = 1;
    y = 1;
    z = 1;
    
    
    m = 2;
    
    mat_t = mat(:,:,:,t);
    mat_t_1d = reshape(mat_t,size(mat))
    mask = (mat == 2);
    %plot(t,temperature(x,y,z,t),'og');
    %plot(t,yourfunc(x,y,z,t),'or');
    
    
   guimax = max(max(max(temperature(:,:,:,t))));
   plot(t,guimax,'xg');
end
