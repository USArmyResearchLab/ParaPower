% Compare results from two stress models
% fn1, fn2 are .mat files containing the 4 cubes
function debug_comp (fn1, fn2)

    load(fn1,'stressx','stressy','stressz','stressvm')
    x1 = stressx;
    y1 = stressy;
    z1 = stressz;
    v1 = stressvm;
    
    load(fn2,'stressx','stressy','stressz','stressvm')
    x2 = stressx;
    y2 = stressy;
    z2 = stressz;
    v2 = stressvm;
    
    assert(comp_two_cube(x1,x2))
    assert(comp_two_cube(y1,y2))
    assert(comp_two_cube(z1,z2))
    assert(comp_two_cube(v1,v2))
    
    ['Pass the test!!']
    
    return

    function equ = comp_two_cube (x,y)
        
        threshold = 0.001;
        
        max1 = max(abs(x),[],'all');
        max2 = max(abs(y),[],'all');
        
        max_diff = max(abs(x - y),[],'all');
        max12 = max(max1,max2);
        percent = max_diff/max12;
        
        equ = max_diff/max12 < threshold;
        
        sizex = size(x);
        nanx = nnz(isnan(x));
        sizey = size(y);
        nany = nnz(isnan(y));
        elemx = numel(x);
        elemy = numel(y);

        whos x
        whos y
        disp(sprintf('Number of NaN, x = %d',nnz(isnan(x))))
        disp(sprintf('Number of NaN, y = %d',nnz(isnan(y))))
        disp(sprintf('Maximum difference = %.4f',max_diff))
        disp(sprintf('Maximum data = %.4f',max12))
        disp(sprintf('Error percentage = %f',percent))
        
        return
    end
end

