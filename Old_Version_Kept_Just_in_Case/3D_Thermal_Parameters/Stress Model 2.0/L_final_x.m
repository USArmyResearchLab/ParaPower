function Lfx=L_final_x(row,col,dT)
% This function calculates the final y length of an element as a result of 
% the CTE mismatch between the materials in all the layers
global dx dy dz cte E Mat NL
% Calculate sums in the equation for Lf
sumn=0;
sumd=0;
for i=1:NL
    if Mat(row,col,i) == 0
        sumn=sumn+0;
        sumd=sumd+0;
    else
        Ei=E(Mat(row,col,i));
        sumn=sumn+Ei*dy(row)*dz(i);
        if i == 1 %added
            sumd=sumd+Ei*dy(row)*dz(i)/dx(col); %added
        else %added
            sumd=sumd+(Ei*dy(row)*dz(i))/(dx(col)*(cte(Mat(row,col,i))*dT(i)+1));
        end %added
    end
end
Lfx=sumn/sumd;
end
