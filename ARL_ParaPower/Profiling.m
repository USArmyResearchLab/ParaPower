profile on
[stressx, stressy, stressz] = Stress_NoSubstrateTrinity(@Stress_NoSubstrate1,samplemodel);
profile off
profsave(profile('info'),'not_vectorized')

profile on
[stressx1, stressy1, stressz1] = Stress_NoSubstrateTrinity(@Stress_NoSubstrateVectorized,samplemodel);
profile off
profsave(profile('info'),'vectorized')