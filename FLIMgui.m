function varargout = FLIMgui(varargin)
% FLIMGUI M-file for FLIMgui.fig
%      FLIMGUI, by itself, creates a new FLIMGUI or raises the existing
%      singleton*.
%
%      H = FLIMGUI returns the handle to a new FLIMGUI or the handle to
%      the existing singleton*.
%
%      FLIMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FLIMGUI.M with the given input arguments.
%
%      FLIMGUI('Property','Value',...) creates a new FLIMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FLIMgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FLIMgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FLIMgui

% Last Modified by GUIDE v2.5 06-Jan-2010 15:46:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FLIMgui_OpeningFcn, ...
                   'gui_OutputFcn',  @FLIMgui_OutputFcn, ...
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


% --- Executes just before FLIMgui is made visible.
function FLIMgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FLIMgui (see VARARGIN)

% Choose default command line output for FLIMgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FLIMgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

filenames = {'file1' 'file2' 'file3'};


% --- Outputs from this function are returned to the command line.
function varargout = FLIMgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        listbox1'




% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
filenames = {'file1' 'file2' 'file3'};
set(hObject,'String',filenames)

