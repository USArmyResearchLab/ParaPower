  classdef PPMatNull < PPMatSolid %ADD (PPMatNew is the new material name 
%Material type Null
%To define a new material instance
%   PPMatNull('Prop_Name_1', Prop_Value_1, 'Prop_Name_2', Prop_Value_2, etc)
%
%The following Prop_Names can be defined
%   Name      

      methods

          function [obj]=PPMatNull(varargin)  %ADD Name of this function must match the class name
              %Default Values
              Type='Null';            %ADD  This is the new material type
                                     %     which must match the text following 
                                     %     PPMat in the class name
              
              if nargin == 1 & ~iscell(varargin{1})
                  Name=varargin{1};
                  varargin={'name' Name};
              elseif nargin == 1 & iscell(varargin{1})
                  varargin=varargin{1};
              end
              if length(varargin)>1
                  for I=1:2:length(varargin)
                      if ~strcmpi(varargin{I},'name') & ~strcmpi(varargin{I},'maxplot')
                            warning('Property ''%s'' cannot be set in null material.',varargin{I})
                      end
                  end
              end
              obj=obj@PPMatSolid([ 'type' Type varargin]);
              
              PropValPairs=obj.PropValPairs;
              obj.PropValPairs={};
              while ~isempty(PropValPairs) 
                  [Prop, PropValPairs]=obj.Pop(PropValPairs);
                  if ~ischar(Prop)
                      error('Property name must be a string.');
                  end
                  Pl=length(Prop);
                  %disp(Prop)

                  switch lower(Prop)  %Note that 'cases' must be lower!
                    case obj.strleft('cte',Pl)
                        warning('%s cannot be changed in Null material.',Prop); 
                    case obj.strleft('e',Pl)
                        warning('%s cannot be changed in Null material.',Prop); 
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                    case obj.strleft('nu',Pl)
                        warning('%s cannot be changed in Null material.',Prop); 
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                    case obj.strleft('k',Pl)
                        warning('%s cannot be changed in Null material.',Prop); 
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                    case obj.strleft('rho',Pl)
                        warning('%s cannot be changed in Null material.',Prop); 
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                    case obj.strleft('cp',Pl)
                        warning('%s cannot be changed in Null material.',Prop); 
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                    otherwise
                          [Value, PropValPairs]=obj.Pop(PropValPairs); 
                          obj.PropValPairs=[Prop Value obj.PropValPairs ];
                  end
              end
              obj.cte=0;
              obj.E=0;
              obj.nu=0;
              obj.k=Inf;
              obj.rho=0;
              obj.cp=0;
              obj.CheckProperties(mfilename('class'));  %Checks for left over properties.
          end
      end
  end