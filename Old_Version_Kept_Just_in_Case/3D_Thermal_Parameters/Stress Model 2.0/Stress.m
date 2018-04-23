function sigma=Stress(Lf,d,row,col,lay,dT)
% This function calculates the thermal stress due to cte mismatch at a
% loaction in the assembly based on the constrained final length, the free
% expansion length, the difference between the processing and operating
% temperatures, cte and E at that location
global cte E Mat
if Mat(row,col,lay) == 0
    sigma=0;
else
    if lay == 1 %added
        sigma=E(Mat(row,col,lay))*((Lf/d)-1); %added
    else %added
        sigma=E(Mat(row,col,lay))*((Lf/(d*(cte(Mat(row,col,lay))*dT+1)))-1);
    end %added
end