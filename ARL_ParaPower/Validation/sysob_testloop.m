clear
load('MItest.mat') %load preconfigured model to workspace

S1=hookPPT;  %construct object
%hookPPT is a derived simulation object from the base system obj sPPT.
%it adds the additional discrete state 'bdry_watts', which is populated
%using using flux computations at every substep.

S1.MI=MI;    %import model into object
S1.GlobalTime=0;  %override preconfigured timestep data, set initial time to zero
GT=1:100;  %generate new (sub)timestep data

%force setup so that we can tune Ta_vec, the default is 20C
setup(S1);

for i=1:10  %run 100 Simulink "supersteps"
    %set tunable property Ta_vec
    if mod(i,2)==1  
        S1.Ta_vec(:)=50; %fluid is hot for odd i
    else
        S1.Ta_vec(:)=10;
    end
    
    [~]=step(S1,GT); %evolve model according to subtimestep data
    GT=GT+100; %advance time by another 100s
    
    Results=getDiscreteState(S1);  %pull structure of states flagged for Simulink
    
    %append results
    if i==1
        Flux=Results.bdry_watts;
    else
        Flux=cat(2,Flux,Results.bdry_watts);
    end
    
end

figure
plot(Flux(1,:))