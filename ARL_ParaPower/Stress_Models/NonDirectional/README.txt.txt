NonDirectional folder directory contains code responsible for calculating the four stress states (X, Y, Z, and Von Mises or VM).

Stress_NoSubstrate3D calculates stresses X, Y, and Z at one timestep. This code is modified from the original code written by Dr. Miner (Stress_NoSubstrate_orig). This exists in the "original" folder. 

Stress_NoSubstrate3D_time expands the 3D stresses from Stress_NoSubstrate3D along the time vector, creating 4D stresses X, Y, and Z. Von Mises stress is also calculated in Stress_NoSubstrate3D_time. 

Please look in the "html" folder for summaries of both functions.

The "validation" folder contains two scripts that compare the stress and temperature of NonDirectional to the published results in iPACK17 and iPACK19. The input geometry used to generate the stress/temp results is ipackmodel.ppmodel. The PPResults object is saved as the variable "ipack" in ipackobj.mat. This object can be used directly as input for Stress_NoSubstrate3D and Stress_NoSubstrate3D_time. 

The "references" folder contains the two iPACK papers (iPACK17 and iPACK19) used for validation.