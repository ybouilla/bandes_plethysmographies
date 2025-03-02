function varargout = Display_2_Signals(varargin)
% DISPLAY_2_SIGNALS MATLAB code for Display_2_Signals.fig
%      DISPLAY_2_SIGNALS, by itself, creates a new DISPLAY_2_SIGNALS or raises the existing
%      singleton*.
%
%      H = DISPLAY_2_SIGNALS returns the handle to a new DISPLAY_2_SIGNALS or the handle to
%      the existing singleton*.
%
%      DISPLAY_2_SIGNALS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPLAY_2_SIGNALS.M with the given input arguments.
%
%      DISPLAY_2_SIGNALS('Property','Value',...) creates a new DISPLAY_2_SIGNALS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Display_2_Signals_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Display_2_Signals_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Display_2_Signals

% Last Modified by GUIDE v2.5 10-Jul-2017 11:14:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Display_2_Signals_OpeningFcn, ...
                   'gui_OutputFcn',  @Display_2_Signals_OutputFcn, ...
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


% --- Executes just before Display_2_Signals is made visible.
function Display_2_Signals_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Display_2_Signals (see VARARGIN)

% Choose default command line output for Display_2_Signals
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Inputs
Plot_Cycle_THO = varargin{1};
Plot_Cycle_ABD = varargin{2};
Val_pred_ABD = varargin{3};
Val_pred_THO = varargin{4};

setappdata(0,'Max',min(length(Plot_Cycle_THO),length(Plot_Cycle_ABD)))
setappdata(0,'Ext_ABD',[max(Plot_Cycle_ABD),min(Plot_Cycle_ABD)])
setappdata(0,'Ext_THO',[max(Plot_Cycle_THO),min(Plot_Cycle_THO)])
setappdata(0,'ABD',Plot_Cycle_ABD)
setappdata(0,'THO',Plot_Cycle_THO)

[~,Loc_Min_ABD] = findpeaks(-Plot_Cycle_ABD,'MinPeakProminence',Val_pred_ABD);
axes(handles.Graph_ABD)

%display ABD plot
plot(Plot_Cycle_ABD)
hold on
plot(Loc_Min_ABD,Plot_Cycle_ABD(Loc_Min_ABD),'o')
findpeaks(Plot_Cycle_ABD,'MinPeakProminence',Val_pred_ABD,'Annotate','extents')
handles.Graph_ABD.XGrid = 'off';
handles.Graph_ABD.YGrid = 'off';
ylabel('Voltage de l''Abdomen (en V)')
l1 = line([2,2],[min(Plot_Cycle_ABD), max(Plot_Cycle_ABD)],'Color','black','LineStyle',':');
axis([0, length(Plot_Cycle_ABD), min(Plot_Cycle_ABD), max(Plot_Cycle_ABD)])
t1 = text(0,0,'');
hold off

[~,Loc_Min_THO] = findpeaks(-Plot_Cycle_THO,'MinPeakProminence',Val_pred_THO);
%Display THO plot
axes(handles.Graph_THO)
plot(Plot_Cycle_THO,'r')
hold on 
plot(Loc_Min_THO,Plot_Cycle_THO(Loc_Min_THO),'o')
findpeaks(Plot_Cycle_THO,'MinPeakProminence',Val_pred_THO,'Annotate','extents')
handles.Graph_THO.XGrid = 'off';
handles.Graph_THO.YGrid = 'off';
ylabel('Voltage du Thorax (en V)')
xlabel('Nombre de points')
l2 = line([2,2],[min(Plot_Cycle_THO), max(Plot_Cycle_THO)],'Color','black','LineStyle',':');
axis([0, length(Plot_Cycle_THO), min(Plot_Cycle_THO), max(Plot_Cycle_THO)])
t2 = text(0,0,'');
hold off
%Slider's propreties

set(handles.Slider,'max',min(length(Plot_Cycle_THO),length(Plot_Cycle_ABD)))
set(handles.Slider,'value',2)

%Outputs
setappdata(0,'Line_THO',l2)
setappdata(0,'Line_ABD',l1)
setappdata(0,'Text_1',t1)
setappdata(0,'Text_2',t2)
%uicontrol('Style','slider','Max',Max)
% UIWAIT makes Display_2_Signals wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Display_2_Signals_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function Slider_Callback(hObject, eventdata, handles)
% hObject    handle to Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Inputs
Val = get(hObject,'Value');
V_Max = getappdata(0,'Max');

Max_Min_ABD = getappdata(0,'Ext_ABD');
Max_Min_THO = getappdata(0,'Ext_THO');
l1_previous = getappdata(0,'Line_ABD');
l2_previous = getappdata(0,'Line_THO');
ABD = getappdata(0,'ABD');
THO = getappdata(0,'THO');
t1_previous = getappdata(0,'Text_1');
t2_previous = getappdata(0,'Text_2');

delete(l1_previous)
delete(l2_previous)
delete(t1_previous)
delete(t2_previous)
%Set range of slider
set(handles.Slider,'Max',V_Max)
set(handles.Slider,'sliderstep',[1/(V_Max-1),0.01])
%Display line on Abdomen's plot
axes(handles.Graph_ABD)
l1 = line([Val,Val],[Max_Min_ABD(2), Max_Min_ABD(1)],'Color','black','LineStyle',':');
t1 = text(Val,ABD(round(Val,0)) + round(0.05*Max_Min_ABD(1),0),num2str(ABD(round(Val,0))));

%Display line on Thorax's plot
axes(handles.Graph_THO)
l2 = line([Val, Val],[Max_Min_THO(2), Max_Min_THO(1)],'Color','black','LineStyle',':');
t2 = text(Val,THO(round(Val,0) + round(0.05*Max_Min_THO(1),0)),num2str(THO(round(Val,0))));

setappdata(0,'Line_ABD',l1)
setappdata(0,'Line_THO',l2)
setappdata(0,'Text_1',t1)
setappdata(0,'Text_2',t2)

% --- Executes during object creation, after setting all properties.
function Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
