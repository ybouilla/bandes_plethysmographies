function varargout = Display_Max_Min(varargin)
% DISPLAY_MAX_MIN MATLAB code for Display_Max_Min.fig
%      DISPLAY_MAX_MIN, by itself, creates a new DISPLAY_MAX_MIN or raises the existing
%      singleton*.
%
%      H = DISPLAY_MAX_MIN returns the handle to a new DISPLAY_MAX_MIN or the handle to
%      the existing singleton*.
%
%      DISPLAY_MAX_MIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPLAY_MAX_MIN.M with the given input arguments.
%
%      DISPLAY_MAX_MIN('Property','Value',...) creates a new DISPLAY_MAX_MIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Display_Max_Min_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Display_Max_Min_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Display_Max_Min

% Last Modified by GUIDE v2.5 11-Jul-2017 12:05:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Display_Max_Min_OpeningFcn, ...
                   'gui_OutputFcn',  @Display_Max_Min_OutputFcn, ...
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


% --- Executes just before Display_Max_Min is made visible.
function Display_Max_Min_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Display_Max_Min (see VARARGIN)

% Choose default command line output for Display_Max_Min
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Input
Array_ABD = varargin{1};
Array_THO = varargin{2};
Val_pred_ABD = varargin{3};
Val_pred_THO = varargin{4};

setappdata(0,'Display_ok',0);
setappdata(0,'Array_ABD',Array_ABD);
setappdata(0,'Array_THO',Array_THO);
setappdata(0,'Val_pred_THO',Val_pred_THO);
setappdata(0,'Val_pred_ABD',Val_pred_ABD);
setappdata(0,'Next_Or_Previous',0); % Indique le sens pour le pushbutton 'Next'
% Next_Or_Previous = 0 ->Thorax
% Next_Or_Previous = 1 -> Abdomen

Val_pred = Val_pred_ABD;

%Titles, String and Pushbuttons
set(handles.Title,'String','Représentation du signal électrique de l''Abdomen')
set(handles.New_Val_Pred,'String',num2str(Val_pred))
set(handles.pushbutton_Finish,'Enable','off')
set(handles.pushbutton_Next,'String','THORAX >')
set(handles.Val_Inf,'String','0.01')
set(handles.Val_Sup,'String','2')
set(handles.Slider_Value,'String',num2str(Val_pred))


%Tracé
%[Max_ABD,Loc_Max_ABD] = findpeaks(Array_ABD,'MinPeakProminence',Val_pred,'Annotate','extents');
[~,Loc_Min_ABD] = findpeaks(-Array_ABD,'MinPeakProminence',Val_pred);
%[Max_ABD,Loc_ABD] = findpeaks(Array_ABD);

plot(Array_ABD)
hold on
plot(Loc_Min_ABD,Array_ABD(Loc_Min_ABD),'o')
findpeaks(Array_ABD,'MinPeakProminence',Val_pred,'Annotate','extents')


grid on
xlabel('Nombre de points')
ylabel('Amplitude (en V)')

hold off

% UIWAIT makes Display_Max_Min wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Display_Max_Min_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;
varargout{1} = getappdata(0,'Val_pred_ABD');
varargout{2} = getappdata(0,'Val_pred_THO');
varargout{3} = getappdata(0,'Display_ok');
%Close


% --- Executes on button press in pushbutton_Next.
function pushbutton_Next_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Array_THO = getappdata(0,'Array_THO');
Array_ABD = getappdata(0,'Array_ABD');
Next_Or_Previous = getappdata(0,'Next_Or_Previous'); 
% Next_Or_Previous = 0 ->Thorax
% Next_Or_Previous = 1 -> Abdomen

if Next_Or_Previous == 0
    %Compute Thorax Signal Minima
    Val_pred = getappdata(0,'Val_pred_THO');
    
    [~,Loc_Min_THO] = findpeaks(-Array_THO,'MinPeakProminence',Val_pred);
    %Display graph
    plot(Array_THO)
    hold on
    plot(Loc_Min_THO,Array_THO(Loc_Min_THO),'o')
    findpeaks(Array_THO,'MinPeakProminence',Val_pred,'Annotate','extents')
    xlabel('Nombre de points')
    ylabel('Amplitude (en V)')

    %Titles and PushButton

    set(handles.Title,'String','Représentation du signal électrique du Thorax')
    set(handles.New_Val_Pred,'String',num2str(Val_pred))

    set(handles.pushbutton_Finish,'Enable','on')
    set(handles.pushbutton_Next,'String','< ABDOMEN')
    Achtung(Array_THO,Array_ABD, Val_pred,getappdata(0,'Val_pred_ABD'),handles)
    
    set(handles.Slider_Value,'String',num2str(Val_pred))
    if Val_pred >= 2
        set(handles.slider,'Value',2)
    else
        %set(handles.slider,'Value',getappdata(0,'Val_pred_ABD'))
        set(handles.slider,'Value',Val_pred)
    end

    hold off
    %Outputs
    Next_Or_Previous = 1;
  
else
    %Title, strngs and Pushbuttons
    Val_pred = getappdata(0,'Val_pred_ABD');
    
    set(handles.Title,'String','Représentation du signal électrique de l''Abdomen')
    set(handles.New_Val_Pred,'String',num2str(Val_pred))
    set(handles.pushbutton_Finish,'Enable','on')
    set(handles.pushbutton_Next,'String','THORAX >')

    Achtung(Array_THO,Array_ABD,getappdata(0,'Val_pred_THO'), Val_pred,handles)
    
    set(handles.Slider_Value,'String',num2str(Val_pred))
    if Val_pred >= 2
        set(handles.slider,'Value',2)
    else
        set(handles.slider,'Value',Val_pred)
    end
    %Tracé
    %[Max_ABD,Loc_Max_ABD] = findpeaks(Array_ABD,'MinPeakProminence',Val_pred,'Annotate','extents');
    [~,Loc_Min_ABD] = findpeaks(-Array_ABD,'MinPeakProminence',Val_pred);
    %[Max_ABD,Loc_ABD] = findpeaks(Array_ABD);
    
    
    plot(Array_ABD)
    hold on
    plot(Loc_Min_ABD,Array_ABD(Loc_Min_ABD),'o')
    findpeaks(Array_ABD,'MinPeakProminence',Val_pred,'Annotate','extents')

    grid on
    xlabel('Nombre de points')
    ylabel('Amplitude (en V)')
    hold off
    
    Next_Or_Previous = 0;
end

setappdata(0,'Next_Or_Previous',Next_Or_Previous)


function New_Val_Pred_Callback(hObject, eventdata, handles)
% hObject    handle to New_Val_Pred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Val_Pred as text
%        str2double(get(hObject,'String')) returns contents of New_Val_Pred as a double

New_Value = (get(hObject,'String'));
Next_Or_Previous = getappdata(0,'Next_Or_Previous'); 
% Next_Or_Previous = 0 ->Thorax
% Next_Or_Previous = 1 -> Abdomen

if (strlength(New_Value)>5) || isempty(New_Value) || any(ismissing(New_Value))
    warning('Valeur non acceptée')
    set(handles.String_Text,'String','Valeur non acceptée')
    if Next_Or_Previous == 1
        New_Value = getappdata(0,'Val_pred_THO');
    else
        New_Value = getappdata(0,'Val_pred_ABD');
    end
    
else
    New_Value = str2double(New_Value);
end


if New_Value < 0.001 
    New_Value = 0.001;
    warning('Valeur trop faible')
    set(handles.String_Text,'String','Valeur trop faible')
elseif isinf(New_Value) || isnan(New_Value)
    
    warning('Valeur non acceptée')
    set(handles.String_Text,'String','Valeur non acceptée')
    
    if Next_Or_Previous == 1
        New_Value = getappdata(0,'Val_pred_THO');
    else
        New_Value = getappdata(0,'Val_pred_ABD');
    end
else
    set(handles.String_Text,'String','Enter Prominance Value :')
end

if Next_Or_Previous == 1
    setappdata(0,'Val_pred_THO',New_Value)
else
    setappdata(0,'Val_pred_ABD',New_Value)
end
disp('')

% --- Executes during object creation, after setting all properties.
function New_Val_Pred_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Val_Pred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Adjust.
function pushbutton_Adjust_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Adjust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Inputs

Next_Or_Previous = getappdata(0,'Next_Or_Previous');
Array_THO = getappdata(0,'Array_THO');
Array_ABD = getappdata(0,'Array_ABD');



if Next_Or_Previous == 1
    Val_pred = getappdata(0,'Val_pred_THO');
    %Compute Thorax Signal Minima

    [~,Loc_Min_THO] = findpeaks(-Array_THO,'MinPeakProminence',Val_pred);
    %Display graph
    plot(Array_THO)
    hold on
    plot(Loc_Min_THO,Array_THO(Loc_Min_THO),'o')
    findpeaks(Array_THO,'MinPeakProminence',Val_pred,'Annotate','extents')
    set(handles.New_Val_Pred,'String',num2str(Val_pred))
    set(handles.Slider_Value,'String',num2str(Val_pred))
    
    if Val_pred >= 2
        set(handles.Slider_Value,'Value',2)
    else
        set(handles.Slider_Value,'Value',Val_pred)
    end
    Achtung(Array_THO,Array_ABD, Val_pred,getappdata(0,'Val_pred_ABD'),handles)
else
   
    %Tracé
    Val_pred_ABD = getappdata(0,'Val_pred_ABD');
    %[Max_ABD,Loc_Max_ABD] = findpeaks(Array_ABD,'MinPeakProminence',Val_pred,'Annotate','extents');
    [~,Loc_Min_ABD] = findpeaks(-Array_ABD,'MinPeakProminence',Val_pred_ABD);
    %[Max_ABD,Loc_ABD] = findpeaks(Array_ABD);

    plot(Array_ABD)
    hold on
    plot(Loc_Min_ABD,Array_ABD(Loc_Min_ABD),'o')
    findpeaks(Array_ABD,'MinPeakProminence',Val_pred_ABD,'Annotate','extents')
    set(handles.New_Val_Pred,'String',num2str(Val_pred_ABD))
    set(handles.Slider_Value,'String',num2str(Val_pred_ABD))
    if Val_pred_ABD >= 2
        set(handles.slider,'Value',2)
    else
        set(handles.slider,'Value',Val_pred_ABD)
    end
    Achtung(Array_THO,Array_ABD, getappdata(0,'Val_pred_THO'),Val_pred_ABD,handles)


end
hold off
grid on
xlabel('Nombre de points')
ylabel('Amplitude (en V)')


% --- Executes on button press in pushbutton_Finish.
function pushbutton_Finish_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%close(handles.Display_Max_Min)
close 



% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Inputs

Next_Or_Previous = getappdata(0,'Next_Or_Previous');
Array_THO = getappdata(0,'Array_THO');
Array_ABD = getappdata(0,'Array_ABD');

if Next_Or_Previous == 1
    %Compute Thorax Signal Minima
    Val_pred_THO = get(hObject,'Value');
    [~,Loc_Min_THO] = findpeaks(-Array_THO,'MinPeakProminence',Val_pred_THO);
    %Display graph
    plot(Array_THO)
    hold on
    plot(Loc_Min_THO,Array_THO(Loc_Min_THO),'o')
    findpeaks(Array_THO,'MinPeakProminence',Val_pred_THO,'Annotate','extents')
    set(handles.Slider_Value,'String',num2str(Val_pred_THO))
    set(handles.New_Val_Pred,'String',num2str(Val_pred_THO))
    setappdata(0,'Val_pred_THO',Val_pred_THO)
    
    Achtung(Array_THO,Array_ABD,Val_pred_THO, getappdata(0,'Val_pred_ABD'),handles)
else
   
    %Tracé
    %[Max_ABD,Loc_Max_ABD] = findpeaks(Array_ABD,'MinPeakProminence',Val_pred,'Annotate','extents');
    Val_pred_ABD = get(hObject,'Value');
    [~,Loc_Min_ABD] = findpeaks(-Array_ABD,'MinPeakProminence',Val_pred_ABD);
    %[Max_ABD,Loc_ABD] = findpeaks(Array_ABD);

    plot(Array_ABD)
    hold on
    plot(Loc_Min_ABD,Array_ABD(Loc_Min_ABD),'o')
    findpeaks(Array_ABD,'MinPeakProminence',Val_pred_ABD,'Annotate','extents')
    set(handles.Slider_Value,'String',num2str(Val_pred_ABD))
    set(handles.New_Val_Pred,'String',num2str(Val_pred_ABD))
    setappdata(0,'Val_pred_ABD',Val_pred_ABD)
    Achtung(Array_THO,Array_ABD, getappdata(0,'Val_pred_THO'),Val_pred_ABD,handles)


end
grid on
xlabel('Nombre de points')
ylabel('Amplitude (en V)')
hold off


% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function Achtung(Array_THO,Array_ABD, Val_pred_THO,Val_pred_ABD,handles)
%Achtung compute the number of cycles detected for THO and ABD : if the
%length of one is higher than the other, a warning appears on the GUI
%A correct detection is needed in order to realize signal sementation
    [Max,~] = findpeaks(Array_ABD,'MinPeakProminence',Val_pred_ABD);
    [Max2,~] = findpeaks(Array_THO,'MinPeakProminence',Val_pred_THO);
    
    set(handles.Number_Cycle_Detected,'String',num2str(max(length(Max),length(Max2))))

    if abs(length(Max) - length(Max2))>= 1
        set(handles.Achtung,'BackgroundColor','red')
        set(handles.Achtung,'ForegroundColor','black')
    else
        set(handles.Achtung,'BackgroundColor',[0.9,0.9,0.9])
        set(handles.Achtung,'ForegroundColor',[0.9,0.9,0.9])
    end


% --- Executes on button press in Display_2_Signals.
function Display_2_Signals_Callback(hObject, eventdata, handles)
% hObject    handle to Display_2_Signals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Title
%set(handles.Title,'String','Représentation du signal électrique de l''Abdomen (haut _ bleu) et du Thorax (Bas)')

setappdata(0,'Display_ok',1)
close
%Inputs
% Array_ABD = getappdata(0,'Array_ABD');
% Array_THO = getappdata(0,'Array_THO');
% Val_pred_THO = getappdata(0,'Val_pred_THO');
% Val_pred_ABD = getappdata(0,'Val_pred_ABD');
% 
% [~,Loc_Min_ABD] = findpeaks(-Array_ABD,'MinPeakProminence',Val_pred_ABD);
% %Display ABD signal and features
% subplot(2,1,1)
% plot(Array_ABD,'b')
% hold on
% plot(Loc_Min_ABD,Array_ABD(Loc_Min_ABD),'o')
% findpeaks(Array_ABD,'MinPeakProminence',Val_pred_ABD,'Annotate','extents')
% hold off
% ylabel('Amplitude de l''Abdomen (en V)')
% 
% [~,Loc_Min_THO] = findpeaks(-Array_THO,'MinPeakProminence',Val_pred_THO);
% %Display THO signal and features
% subplot(2,1,2)
% plot(Array_THO,'r')
% hold on
% plot(Loc_Min_THO,Array_THO(Loc_Min_THO),'o')
% findpeaks(Array_THO,'MinPeakProminence',Val_pred_THO,'Annotate','extents')
% ylabel('Amplitude du Thorax (en V)')
% xlabel('Nombre de points')
