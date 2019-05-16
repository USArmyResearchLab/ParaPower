classdef cVariableList
    %cV is base class for superclasses that will manage parameters
    %   Includes functionality to evaluate and get permutations
    
    properties
        V
    end
    
    methods
        function obj = cV(V)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.V=V;
        end
        
        function AllPerms = GetPerms(obj)
            %GetPerms - Generate all permutions of the variable list
            
            %   In  -> { {1 2} {'a' 'b'} }
            %   Out -> {1 'a'
            %           2 'a'
            %           1 'b'
            %           2 'b'}     
            In=obj.V(:,2);
            Out={[]};
            for Var=1:length(In)
                LenVar=length(In{Var});
                CurOut=Out;
                Out={};
                if ~iscell(In{Var})
                    In{Var}=num2cell(In{Var});
                end
                for Val=1:LenVar
                    NewCol(1:length(CurOut(:,1)),1)=In{Var}(Val);
                    Out=[Out;CurOut NewCol];

                end
            end
            AllPerms=Out(:,2:end);
        end
        function [Scalar, Vector]=SeparateScalarVector
            %Separate variable list into vector and scalar variable lists
            V=obj.V;
            Scalar={};
            Vector={};
            ErrText='';
            if ~isempty(V)
                VarEval='';
                for Row=1:length(V(:,1))
                    VarName=V{Row,1};
                    if exist(VarName,'var')
                        Stxt=sprintf('''%s'' variable already exists in the namespace. Please change your variable name.',VarName);
                        ErrText=[ErrText Stxt];
                        warning(Stxt);
                        V{Row,1}='';
                        V{Row,2}=[];
                    elseif ~isempty(VarName)
                        try
                            if isnumeric(V{Row,2})
                                VarEval=[VarEval sprintf('%s=V{%i,2};',V{Row,1}, Row)];
                            elseif isempty(V{Row,1})
                                VarEval=[VarEval V{Row,1} '=[];'];
                            elseif iscell(V{Row,2})
                                VarEval=[VarEval sprintf('%s=V{%i,2};',V{Row,1 }, Row)];
                            else
                                VarEval=[VarEval V{Row,1} '=' V{Row,2} ';' ];
                            end
                        catch ME
                            ErrText=[ErrText sprintf('Variable ''%s'' cannot be evaluated\n',V{Row,1})];
                        end
                    end
                end
                eval(VarEval); %Evaluate all the variables in order given.
                for Row=1:length(V(:,1))
                    if ~isempty(V{Row,1})
                        eval(['TestVar=' V{Row,1} ';'])
                        if ischar(TestVar)
                            Scalar=[Scalar; {V{Row,1} TestVar}];
                        elseif length(TestVar)==1
                            Scalar=[Scalar; {V{Row,1} TestVar}];
                        else
                            Vector=[Vector; {V{Row,1} TestVar}];
                        end
                    end
                end
            end   
            if ~isempty(ErrText)
                error(ErrText)
            end
        end        
    end
    methods (Static)
        function OutVar=ProtectedEval(InString, VarList, StartString)
            ErrText='';
            OutVar=[];
            if exist('StartString','var')
                EvalText=StartString;
            else
                EvalText='';
            end
            if ~isempty(VarList)
                for Ivar=1:length(VarList(:,1))
                    if exist(VarList{Ivar,1},'var')
                        Stxt=sprintf('''%s'' variable already exists in the namespace. Please change your variable name.\n',VarName);
                        ErrText=[ErrText Stxt];
                    else
                        EvalText=[EvalText VarList{Ivar,1} '=VarList{' num2str(Ivar) ',2};'];
                    end
                end
            end
            EvalText=[EvalText 'OutVar=' InString ';'];
            if length(ErrText)==0
                eval(EvalText)
            else
                error(ErrText)
            end

        end     
    end
end

