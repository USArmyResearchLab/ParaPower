clf
hold on
for t = 1:size(a,4)
    mymaxdata = max(max(max(a(:,:,:,t))));
    plot(t,mymaxdata,'o')
end


clf

subplot(2,2,1)
hold on
for x = 1:size(a,1)
    for y = 1:size(a,2)
        for z = 1:size(a,3)
            plot(squeeze(a(x,y,z,:)));
        end
    end
end

return
