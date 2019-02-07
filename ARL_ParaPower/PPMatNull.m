classdef PPMatNull < PPMat
    
    methods
        function [obj]=PPMatNull(varargin)
            %Default Values
            Type='Null';
            obj=obj@PPMat([ 'type' Type varargin]);
        end
    end
end
