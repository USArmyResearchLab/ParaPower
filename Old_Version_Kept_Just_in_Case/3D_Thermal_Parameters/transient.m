function [Cap,T] = transient(steps,delta_t,B_stead,Cap,A,B,T,T_init)
if steps > 1
    B_stead=B;
    % Claculate the capacitance term associated with each node and adjust the 
    % A matrix and B vector to include the transient effects
    for kk=1:NL
        for ii=1:NR
            for jj=1:NC
                Ind=(kk-1)*NR*NC+(ii-1)*NC+jj;
                Cap(ii,jj,kk)=mass(ii,jj,kk);
                A(Ind,Ind)=A(Ind,Ind)-Cap(ii,jj,kk); %Includes Transient term in the A matrix
                B(Ind)=B_stead(Ind)-Cap(ii,jj,kk)*T_init(ii,jj,kk); %Includes Transient term in the B vector
            end
        end
    end
end
% Form loop over the number of time steps desired
for it=1:steps
    T(:,it)=A\B;
    if steps > 1
        % Update B vector for next time step of a transient solution
        for kk=1:NL
            for ii=1:NR
                for jj=1:NC
                    Ind=(kk-1)*NR*NC+(ii-1)*NC+jj;
                    B(Ind)=B_stead(Ind)-Cap(ii,jj,kk)*T(Ind,it); %Includes Transient term in the B vector 
                end
            end
        end
    end
end

end

