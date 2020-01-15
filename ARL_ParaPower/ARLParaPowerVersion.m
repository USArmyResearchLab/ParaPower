function OutText=ARLParaPowerVersion(Entity)
%If file does not exist return program version, otherwise file version
    if ~exist('Entity','var')
        Entity='file';
    end
    
    switch lower(Entity)
        case 'file'
            OutText='V3.0';
        case 'program'
            OutText='4.0.1b';
        otherwise
            OutText='';
            disp('Unknown entity for version info.')
    end
%V1.0.0 - Initial Release
% 	Initial release includes the following primary features...
% 		Time invariant heat input
% 		Stress analysis
% 		Thermal analysis
% 		Single phase materials
% V1.0.1 - Fixed bug, added 'ARL'	
% V1.0.2 - Added Parapower Manual, version 1	
% 
% V1.1.0 - Adding PCM
% 
% V2.0.0 - Added transient and PCM
% 
% V3.0.0 - Complete GUI rewrite
%          Core parapowerthermal rewritten to be directionally agnostic
% 		 Core parapowerthermal rewritten to be better vectorized
% 		 FormModel and Visualize intermediary functions added to ease model build by script
% 		 MaterialDatabase added to replace matlibfun
% 		 Voids do not quite work yet.
% V3.1.0 - Refined GUI
% 		 Major rewrite of visualization with significant speed improvement
% V3.2.0 - Converting to material objects.  
%          Main analysis rewite into an object to support SimuLink usage
% V3.2.2 - Material Library code rewritten as object and incorporated into main code
% V3.2.4 - Modified material library code to optimize performance
% V3.2.5 - Materials melt fraction is now initialized to be consistent with
%               its starting temperature
%          Visualizes modified so that if min(plotstate)=max(plotstate) the
%               color scale is set to [plotstate(1) Inf]. This ensure it
%               does not result in [-1 1] for all melt fractions @ 0
%          Added test case for material initialization
% 		   Timing for testcases validation changed to fraction
% V4.0.0 - Initial implementation of parametric functionality (File version
%          updated as all items in testcasemodel may be strings.
% V4.0.1 - Created function for Dist statement.  Adjusted dist statement to A
% V4.0.1b- Added drawnow during gui initialization to ensure parameter
%          buttons are propertly displayed
%
% Features to Add
% 1. Enable 'stop' button on GUI
% 2. Address the defined Q for features that are overwritten
% 3. Ensure potting material in testmodelcase structure is 0