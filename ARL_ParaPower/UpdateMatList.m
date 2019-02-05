function UpdateMatList(Action, FeatureTableHandle, MatListCol, varargin)
%Update a material list in a table with a new materials database
%TableHandle is a handle to the table of interest
%Ci is the column number of that table that has materials listed
%If 3rd argument is a MatLib, then load that MatLib into the materials
%database.

    NoEdit=false;
    MatLib=[];
    CurrentMatDbaseH=get(FeatureTableHandle,'userdata');
    
    CurrentFig=gcf;

    switch lower(Action)
        case 'editmats'
        case 'loadmatlib'
            NoEdit=true;
            MatLib=varargin{1};
        case 'initialize'
            NoEdit=true;
            CurrentMatDbaseH=[];
        otherwise 
            error(['Unknown action for UpdateMatList "' Action '"']);
    end

   
    if isempty(CurrentMatDbaseH) || not(isvalid(CurrentMatDbaseH))
        CurrentMatDbaseH=MaterialDatabase;  %Instantiate the materials database window
        set(FeatureTableHandle,'userdata',CurrentMatDbaseH);
        drawnow  %Seems to be needed to ensure that GUI can render properly
    end

    %Allow the user to edit the mat dbase if not closed immediately
    if NoEdit
        set(CurrentMatDbaseH,'visible','off')
    else
        set(CurrentMatDbaseH,'windowstyle','modal')
        set(CurrentMatDbaseH,'visible','on')
        uiwait(CurrentMatDbaseH)
        set(CurrentMatDbaseH,'windowstyle','normal')
    end
    
    if not(isempty(MatLib))
       MaterialDatabase('ExtractMatLib',CurrentMatDbaseH, MatLib);
       set(CurrentMatDbaseH,'visible','off')
    else
       MatLib=getappdata(CurrentMatDbaseH,'Materials');
    end
    
    if ~strcmpi(class(MatLib),'PPMatLib')
        warning('Utilizing old material database format.')
        MatLib=MaterialDatabase('ConvertOldMatLib',MatLib);
    end
    NewMatList=reshape(MatLib.Name,[],length(MatLib.Name));

    ColFormat=get(FeatureTableHandle,'columnformat');
    OldMatList=ColFormat{MatListCol};
    Data=get(FeatureTableHandle,'data');
    if not(isempty(Data))
        for I=1:length(Data(:,1))
            MatIndex=find(strcmpi(Data(I,MatListCol),NewMatList));
            if isempty(MatIndex)
                ThisMat='';
            else
                ThisMat=NewMatList{MatIndex};
            end
            Data{I,MatListCol}=ThisMat;
        end
    end
    ColFormat{MatListCol}=NewMatList;
    set(FeatureTableHandle,'columnformat',ColFormat);
    set(FeatureTableHandle,'data',Data);
    figure(CurrentFig)
