function varargout = ExampleMaterialListUpdate(varargin)
% EXAMPLEMATERIALLISTUPDATE MATLAB code for ExampleMaterialListUpdate.fig
%      EXAMPLEMATERIALLISTUPDATE, by itself, creates a new EXAMPLEMATERIALLISTUPDATE or raises the existing
%      singleton*.
%
%      H = EXAMPLEMATERIALLISTUPDATE returns the handle to a new EXAMPLEMATERIALLISTUPDATE or the handle to
%      the existing singleton*.
%
%      EXAMPLEMATERIALLISTUPDATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXAMPLEMATERIALLISTUPDATE.M with the given input arguments.
%
%      EXAMPLEMATERIALLISTUPDATE('Property','Value',...) creates a new EXAMPLEMATERIALLISTUPDATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ExampleMaterialListUpdate_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ExampleMaterialListUpdate_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ExampleMaterialListUpdate

% Last Modified by GUIDE v2.5 30-Oct-2018 10:44:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ExampleMaterialListUpdate_OpeningFcn, ...
                   'gui_OutputFcn',  @ExampleMaterialListUpdate_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ExampleMaterialListUpdate is made visible.
function ExampleMaterialListUpdate_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ExampleMaterialListUpdate (see VARARGIN)

% Choose default command line output for ExampleMaterialListUpdate
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ExampleMaterialListUpdate wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ExampleMaterialListUpdate_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TableHandle=handles.uitable1;
Ci=2; %Column number of material list
UpdateMatList(TableHandle, Ci)
