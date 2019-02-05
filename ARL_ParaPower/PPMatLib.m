classdef PPMatLib < handle
    
%    properties (Access=public)
%        Name    {mustBeChar(Name)} 
%    end
    
    properties (Access = protected)
        PropValPairs = {}
        iMatObjList
        iParamList 
        iFilename
        iMatTypeList
        iNameList
        ErrorText='';
        iNewMatF
    end
    
    properties (Access=public, Dependent)
        NumMat
        Params
        MatList
    end

    methods (Access = protected)
        function CheckProperties (obj, MfileClass)

        end
        function AddError(obj,Text) %Empty clears the error list
            if ~exist('Text','var')
                obj.ErrorText='';
            else
                obj.ErrorText=sprintf('%s\n%s',obj.ErrorText,Text);
            end
        end
    end
    methods (Static)
        function Types=GetMatTypesAvail
            F=dir('PPMat*.m');
            Types={};
            for I=1:length(F)
                MatFile=F(I).name;
                MatFile=MatFile(1:end-2);
                if ~strcmp(MatFile,'PPMatLib') & ~strcmp(MatFile,'PPMat')
                    eval(sprintf('TempMat=%s;',MatFile));
                    Types{end+1}=TempMat.Type;
                end
            end
        end
    end
    
    methods
        function varargout=subsref(obj,s)
           switch s(1).type
              case '.'
                 if length(s) == 1 & ~isprop(obj,s.subs)
                    % Implement obj.PropertyName
                     varargout{1}=obj.GetParam(s.subs);
                 %elseif length(s) == 2 && strcmp(s(2).type,'()')
                 %   % Implement obj.PropertyName(indices)
                 %   ...
                 else
                    [varargout{1:nargout}] = builtin('subsref',obj,s);
                 end
              case '()'
                 if length(s) == 1
                    % Implement obj(indices)
                    TempOut=PPMatLib;
                    for Mi=s.subs{1}
                        TempOut.AddMatl(obj.iMatObjList{Mi})
                    end
                    varargout{1}=TempOut;
                 elseif length(s) == 2 && strcmp(s(2).type,'.')
                    % Implement obj(ind).PropertyName
                    TempLib=PPMatLib;
                    for Mi=s(1).subs{1}
                        TempLib.AddMatl(obj.iMatObjList{Mi});
                    end
                    varargout{1}=TempLib.GetParam(s(2).subs);
%                  elseif length(s) == 3 && strcmp(s(2).type,'.') && strcmp(s(3).type,'()')
%                     % Implement obj(indices).PropertyName(indices)
%                     ...
                 else
                    % Use built-in for any other expression
                    [varargout{1:nargout}] = builtin('subsref',obj,s);
                 end
%               case '{}'
%                  if length(s) == 1
%                     % Implement obj{indices}
%                     ...
%                  elseif length(s) == 2 && strcmp(s(2).type,'.')
%                     % Implement obj{indices}.PropertyName
%                     ...
%                  else
%                     % Use built-in for any other expression
%                     [varargout{1:nargout}] = builtin('subsref',obj,s);
%                  end
              otherwise
                 error('Not a valid indexing expression')
           end

        end
        function OutParam=GetParam(obj, Param)
            AvailParams=obj.Params;
            if isempty(find(strcmp(AvailParams, Param),1))
                obj.AddError(sprintf('Parameter ''%s'' doesn''t exist in this MatLib',Param))
                OutParam=[];
            else
                IsNumericParam=true;
                for Imat=1:obj.NumMat
                    MatObj=obj.GetMatNum(Imat);
                    if isprop(MatObj, Param)
                        OutParam{Imat}=getfield(MatObj,Param);
                        if ~isnumeric(OutParam{Imat})
                            IsNumericParam=false;
                        end
                    else
                        OutParam{Imat}=NaN;
                    end
                end
                if IsNumericParam
                    OutParam=cell2mat(OutParam);
                end
            end
            OutParam=reshape(OutParam,[],1);
            obj.ShowErrorText
        end
        function ShowErrorText(obj)
            if ~isempty(obj.ErrorText)
                warning(obj.ErrorText)
                obj.AddError();
            end
        end
        function MatObj=GetMatName(obj, MatName)
            obj.AddError();
            MatNum=find(strcmpi(obj.MatList,MatName));
            if ~isempty(MatNum)
                MatObj=obj.iMatObjList{MatNum};
            else
                obj.AddError(sprintf('Material named ''%s'' is not in library',MatName));
            end
            obj.ShowErrorText;
        end
        function MatObj=GetMatNum(obj, MatNum)
            obj.AddError();
            if MatNum<=obj.NumMat
                MatObj=obj.iMatObjList{MatNum};
            else
                obj.AddError(sprintf('Material number ''%.0f'' does not exist.',MatNum));
            end
            obj.ShowErrorText;
        end
        function OutText=ParamDesc(obj, Param)
            MatNum=1;
            while MatNum <= length(obj.iMatObjList)
                OutText=obj.iMatObjList{MatNum}.ParamDesc(Param);
                if ~isempty(OutText)
                    MatNum=length(obj.iMatObjList)+1;
                else
                    MatNum=MatNum+1;
                end
                
            end
            if isempty(OutText)
                AddError(sprintf('No descriptor found for %s',Param));
                obj.ShowErrorText;
            end
        end
        function N=get.NumMat(obj)
            N=length(obj.iMatObjList);
        end
        function P=get.Params(obj)
            P=reshape(obj.iParamList,[],1);
        end
        function M=get.MatList(obj)
            for I=1:length(obj.iMatObjList)
                M{I}=obj.iMatObjList{I}.Name;
            end
            
        end
        function obj =PPMatLib(varargin)
            obj.iParamList={}; 
            obj.iFilename='';
            obj.iMatTypeList={};
            obj.iNameList={};
            obj.iMatObjList={};
            %if nargin=1 & 
        end
        
        function DefineNewMaterial (obj, Action)
            switch lower(Action)
                case 'init'
                    if ishandle(obj.iNewMatF) & isvalid(obj.iNewMatF)
                        delete(obj.iNewMatF)
                    end
                    NP=[0.1 .8 .1 .1];
                    FS=12;
                    obj.iNewMatF=figure('name','Define Material','menu','none','toolbar','none');
                    Temp=uicontrol('unit','normal','style','edit','string','012345678910','fontsize',FS);
                    E=get(Temp,'extent');
                    delete(Temp);
                    NP(3:4)=E(3:4);
                    CloseWindow=@(A,B)delete(obj.iNewMatF);
                    H.OKBtn=uicontrol('unit','normal','style','pushbutton','string','OK','posit',[0.3 0.1 0.19 0.1],'fontsize',FS);
                    H.CnBtn=uicontrol('unit','normal','style','pushbutton','string','Cancel','posit',[0.6 0.1 0.19 0.1],'fontsize',FS,'callback',CloseWindow);
                    H.Name=uicontrol('unit','normal','style','text','string','Name:','posit',NP,'fontsize',FS,'horiz','left');
                    H.NameE=uicontrol('unit','norma','style','edit','string','','posit',[NP(1)+NP(3)+.01 NP(2) 1-NP(1)-NP(3)-.05 NP(4)],'fontsize',FS,'horizon','left');
                    H.Type=uicontrol('unit','normal','style','text','string','Type:','posit',[NP(1) NP(2)-E(4)*1.05 E(3) E(4)],'fontsize',FS,'horiz','left');
                    PopParms=@(A,B)obj.DefineNewMaterial('PopParms');
                    H.TypeE=uicontrol('unit','norma','style','popup','string',obj.GetMatTypesAvail,'posit',[NP(1)+NP(3)+.01 NP(2)-E(4)*1.05 1-NP(1)-NP(3)-.05 NP(4)],'fontsize',FS,'horizon','left','callback');
                    set(obj.iNewMatF,'user',H);
                case 'popparms'
                otherwise
                    obj.AddError(sprintf('Unknown action for DefineNewMaterial function',Action))
                    obj.ShowErrorText;
            end
            
        end
        
        function AddMatl(obj, PPMatObject)
            obj.AddError;
            if any(strcmpi(PPMatObject.Name, obj.iNameList))
                obj.AddError(sprintf('Material "%s" already exists in library (material names MUST be unique).',PPMatObject.Name))
            end
            if strcmpi(PPMatObject.Type,'abstract')
                obj.AddError(sprintf('Abstract materials cannot be added to the library. (%s)',PPMatObject.Name))
            end
            if isempty(obj.ErrorText)
                obj.iMatObjList{end+1}=PPMatObject;
                obj.iMatTypeList{end+1}=PPMatObject.Type;
                obj.iMatTypeList=unique(obj.iMatTypeList);
                obj.iNameList{end+1}=PPMatObject.Name;
                obj.iParamList=unique([obj.iParamList; fields(PPMatObject)]);
                %Ensure Abstract fields are at the top
                AbstractFields=fields(PPMat);
                for I=1:length(AbstractFields)
                    obj.iParamList=obj.iParamList(~strcmpi(obj.iParamList,AbstractFields(I)));
                end
                obj.iParamList=[AbstractFields; obj.iParamList];
            else
                obj.AddError('No material added.')
                obj.ShowErrorText;
            end 
        end
    end
end

function mustBeChar(Value)
    if ~isempty(Value) & ~ischar(Value)
        error('Value must be a character.')
    end
end
    
