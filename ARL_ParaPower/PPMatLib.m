classdef PPMatLib < handle
%classdef PPMatLib < handle
%This object is used as a collection of materials objects.  To add a new
%material object it must have the filename PPMatXXXX where XXXX is the
%specific formulation of the material and it must have PPMat as its super
%class.
%
%Usage of PPMatLib
%
%Properties:
%   NumMat     - Number of materials currently in the library
%   ParamsCur  - List of all parameters of the material types currently in the
%                library
%   MatList    - List of materials currently in the library
%
%Access Methods:
%   MatLib(index)  - Returns a new MatLib comprised of materials identified
%                    in index
%   MatLib.Param   - Same as GetParam method below
%
%Methods:
%   GetParam (Param)   - Return vector of parameter values for all materials.
%                        material that do not define that parameter will have 
%                        NaN
%   GetMatName (Name)  - Returns the material object that matches that name
%   GetMatNum (Number) - Returns the material object that matches that
%                        index into the library
%   ParamDesc (Param)  - Returns description of that parameter
%   AddMatl (MatObj)   - Adds the material defined in MatObj to the library
%   DefineNewMaterial()- Not yet implemented
%   GetMatTypesAvail() - Returns a list of all known material types
%   GetParamAvail()    - Returns list of all parameters in all known
%                        material types

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
            N=strcmpi('Null',Types);
            if ~isempty(find(N))
                Types=Types(~N);
                Types=['Null' Types];
            end
                
        end
        
        function Params=GetParamAvail
            Params={};
            MatTypes=PPMatLib.GetMatTypesAvail();
            for I=1:length(MatTypes)
                eval(['Mat=PPMat' MatTypes{I} '();']);
                Params=[Params; fields(Mat)];
            end
            Params=unique(Params);
            AbstractFields=fields(PPMat);
            for I=1:length(AbstractFields)
                Params=Params(~strcmpi(Params,AbstractFields(I)));
            end
            Params=[AbstractFields; Params];            
        end
    end
    
    methods
        function varargout=subsref(obj,s)
           switch s(1).type
              case '.'
                 if length(s) == 1 & ~isprop(obj,s.subs)
                    % Implement obj.PropertyName
                     varargout{1}=obj.GetParam(s.subs);
                 elseif length(s) == 2 && strcmp(s(2).type,'()') && any(strcmpi(obj.iParamList,s(1).subs)) 
                    % Implement obj.PropertyName(indices)
                      List=obj.GetParam(s(1).subs);
                      varargout{1}=List(s(2).subs{1});
                 else
                    [varargout{1:nargout}] = builtin('subsref',obj,s);
                 end
              case '()'
                 if length(s) == 1
                    % Implement obj(indices)
                    TempOut=PPMatLib;
                    for Mi=reshape(s.subs{1},1,[])
                        TempOut.AddMatl(obj.iMatObjList{Mi})
                    end
                    varargout{1}=TempOut;
                 elseif length(s) == 2 && strcmp(s(2).type,'.')
                    % Implement obj(ind).PropertyName
                    TempLib=PPMatLib;
                    for Mi=reshape(s(1).subs{1},1,[])
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
            if nargin>=1 && (any(strcmp(superclasses(varargin{1}),'PPMat')))
                for Ai=1:nargin
                    if any(strcmp(superclasses(varargin{Ai}),'PPMat'))
                        obj.AddMatl(varargin{Ai})
                    else
                        obj.AddError('For PPMatLib(Mat1, Mat2, Mat3) form all arguments must be a material class.')
                        obj.AddError(sprintf('Argument %.0f is of type',class(varargin{Ai})))
                    end
                end
            elseif nargin==1 && strcmp(class(varargin{1}),'PPMatLib')
                OldLib=varargin{1};
                for I=1:OldLib.NumMat
                    obj.AddMatl(OldLib.GetMatNum(I));
                end
            elseif nargin>=1
                obj.AddError('Unknown constructor argument.')
                disp(varargin);
            end
            obj.ShowErrorText;
            %if nargin=1 & 
        end
        
        function Out=DefineNewMaterial (obj, Action, varargin)
            switch lower(Action)

                case 'init'
                    if ishandle(obj.iNewMatF) & isvalid(obj.iNewMatF)
                        delete(obj.iNewMatF)
                    end
                    NP=[0.1 0.95 0.1 0.1];
                    FS=12;
                    LongestString='Nucleation Delta Temp';
                    obj.iNewMatF=figure('name','Define Material','menu','none','toolbar','none','unit','normal');
    %DEBUG                set(obj.iNewMatF,'windowstyle','modal');
                    P=get(obj.iNewMatF,'posit');
                    set(obj.iNewMatF,'posit',[P(1) .15 P(3) .8]);
                    Temp=uicontrol('unit','normal','style','edit','string',LongestString,'fontsize',FS);
                    E=get(Temp,'extent');
                    delete(Temp);
                    NP(3:4)=E(3:4);
                    Close_CB=@(H,A)delete(obj.iNewMatF);
                    OK_CB=@(H,A)obj.DefineNewMaterial('OK',H,A);
                    MatType_CB=@(H,A)obj.DefineNewMaterial('PopParms',H,A);
                    H.OKBtn=uicontrol('unit','normal','style','pushbutton','string','OK','posit',[0.3 0.1 0.19 0.05],'fontsize',FS,'callback',OK_CB);
                    H.CnBtn=uicontrol('unit','normal','style','pushbutton','string','Cancel','posit',[0.6 0.1 0.19 0.05],'fontsize',FS,'callback',Close_CB);
                    H.Name=uicontrol('unit','normal','style','text','string','Name:','posit',NP,'fontsize',FS,'horiz','left');
                    H.NameE=uicontrol('unit','norma','style','edit','string','','posit',[NP(1)+NP(3)+.01 NP(2) 1-NP(1)-NP(3)-.05 NP(4)],'fontsize',FS,'horizon','left');
                    H.Type=uicontrol('unit','normal','style','text','string','Type:','posit',[NP(1) NP(2)-E(4)*1.05 E(3) E(4)],'fontsize',FS,'horiz','left');
                    PopParms=@(A,B)obj.DefineNewMaterial('PopParms');
                    H.TypeE=uicontrol('unit','norma','style','popup','string',obj.GetMatTypesAvail,'posit',[NP(1)+NP(3)+.01 NP(2)-E(4)*1.05 1-NP(1)-NP(3)-.05 NP(4)] ...
                                     ,'fontsize',FS,'horizon','left' ...
                                     ,'callback',MatType_CB ...
                                     );
                    H.ParamL=[];
                    H.ParamE=[];
                    set(obj.iNewMatF,'user',H);
                    MatType_CB(H.TypeE,[]);
                case 'popparms'
                    handle=varargin{1};
                    %action=varargin{2};
                    Types=get(handle,'string');
                    ThisType=Types{get(handle,'value')};
                    eval(['NewMat=PPMat' ThisType ';' ]);
                    H=get(get(handle,'parent'),'user');
                    
                    %disp(['Setting material type ' ThisType ':'])
                    NPl=get(H.Name,'posit');
                    NPl_delta=get(H.Name,'posit')-get(H.Type,'posit');
                    FS=get(H.Name,'fontsize');
                    
                    if strcmpi(ThisType,'null')
                        ParamList={};
                     else
                        ParamList=NewMat.ParamList;
                        ParamList=ParamList(~strcmpi(ParamList,'SClass'));
                    end
                    if ~isempty(H.ParamL)
                        for I=1:length(H.ParamL)
                            delete(H.ParamL(I));
                            delete(H.ParamE(I));
                        end
                        H.ParamL=[];
                        H.ParamE=[];
                    end
                    
                    for I=1:length(ParamList)
                        %disp(['Setting ' ParamList{I}])
                        Posit=NPl - (I+1)*NPl_delta - [0 .005 0 0 ];
                        Desc=NewMat.ParamDesc(ParamList{I});
                        H.ParamL(I)=uicontrol('unit','normal','style','text','string',[Desc ':'],'posit',Posit,'fontsize',FS,'horiz','left');
                        
                        Posit=[Posit(1)+Posit(3)+0.01 Posit(2) 1-Posit(1)-Posit(3)-0.05 Posit(4)]; %[NP(1)+NP(3)+.01 NP(2) 1-NP(1)-NP(3)-.05 NP(4)]
                        H.ParamE(I)=uicontrol('unit','norma','style','edit','string','','posit',Posit,'fontsize',FS,'horizon','left');
                    end
                    set(get(handle,'parent'),'user',H);
                case 'ok'
                    handle=varargin{1};
                    H=get(get(handle,'parent'),'user');
                    Types=get(H.TypeE,'string');
                    ThisType=Types{get(H.TypeE,'value')};
                    eval(['NewMat=PPMat' ThisType ';' ]);
                    Name=get(H.NameE,'string');
                    ArgList=sprintf('''Name'', ''%s'' ',Name);
                    ParamList=NewMat.ParamList;
                    for I=1:length(ParamList)
                        ArgList=sprintf('%s, ''%s'', %s ',ArgList, ParamList{I}, get(H.ParamE(I),'string'));
                    end
                    eval(['NewMat=PPMat' ThisType '(' ArgList ');' ]);
                    %assignin('base','NewMat',NewMat)
                    obj.AddMatl(NewMat);
                    delete(obj.iNewMatF)
                    
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
    
