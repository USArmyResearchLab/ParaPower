function OutText=ARLParaPowerVersion(Entity)
%If file does not exist return program version, otherwise file version
    if ~exist('Entity')
        Entity='file';
    end
    
    switch lower(Entity)
        case 'file'
            OutText='V2.1';
        case 'program'
            OutText='3.2.4';
        otherwise
            OutText='';
            disp('Unknown entity for version info.')
    end