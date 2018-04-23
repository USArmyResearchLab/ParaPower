function Lfy=L_final_y(row,col,dT)
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
        sumn=sumn+Ei*dx(col)*dz(i);
        if i == 1 %added
            sumd=sumd+Ei*dx(col)*dz(i)/dy(row); %added
        else %added
            sumd=sumd+(Ei*dx(col)*dz(i))/(dy(row)*(cte(Mat(row,col,i))*dT(i)+1));
        end %added
    end
end
Lfy=sumn/sumd;
end
