Stress Models folder directory contains code responsible for calculating stress, including the Hsueh's substrate-based model, and a second, nondirectional model. 

Nondirectional: Boteler, L. M., and Miner, S. M. "Evaluation of Low Order Stress Models for Use in Co-Design Analysis of Electronics Packaging." Proceedings of the ASME 2019 International Technical Conference and Exhibition on Packaging and Integration of Electronic and Photonic Microsystems. ASME 2019 International Technical Conference and Exhibition on Packaging and Integration of Electronic and Photonic Microsystems. Anaheim, California, USA. October 7–9, 2019. V001T06A003. ASME. https://doi.org/10.1115/IPACK2019-6381

Substrate-based: Hsueh, C. H. "Thermal stresses in elastic multilayer systems." Thin solid films 418, no. 2 (2002): 182-188. https://doi.org/10.1016/S0040-6090(02)00699-5

The functions Stress_Hsueh and Stress_NonDirectional are the shells responsible for calling the code in the Hsueh and NonDirectional folders, respectively. Each folder contains the code with implemented algorithms. 