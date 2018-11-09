function traverse(h)

    P=get(h);
    if isstruct(P)
        fields=fieldnames(P);
        for I=1:length(fields)
            FH=getfield(P,fields{I});
            if isa(FH,'function_handle')
                FH=func2str(FH);
                %disp(Cbs)
                FHn=strrep(FH,'ThermalParameterV1','ParaPowerGUI');
                disp(['Changing from ' FH ' to ' FHn])
                FH=str2func(FHn);
                set(h,fields{I},FH)
            end
        end

        C=get(h,'children');
        for i=1:length(C)
            traverse(C(i))
        end
    end

end