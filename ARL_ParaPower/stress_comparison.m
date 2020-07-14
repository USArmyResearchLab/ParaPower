load sample.mat
[stressx,stressy,stressz] = Stress_NoSubstrateTrinity(@Stress_NoSubstrate1,sample_PPResults);
[stressx1,stressy1,stressz1] = Stress_NoSubstrateTrinity(@Stress_NoSubstrateVectorized,sample_PPResults);
