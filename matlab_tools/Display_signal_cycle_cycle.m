function varargout = Display_signal_cycle_cycle(varargin)
% DISPLAY_SIGNAL_CYCLE_CYCLE MATLAB code for Display_signal_cycle_cycle.fig
%      DISPLAY_SIGNAL_CYCLE_CYCLE, by itself, creates a new DISPLAY_SIGNAL_CYCLE_CYCLE or raises the existing
%      singleton*.
%
%      H = DISPLAY_SIGNAL_CYCLE_CYCLE returns the handle to a new DISPLAY_SIGNAL_CYCLE_CYCLE or the handle to
%      the existing singleton*.
%
%      DISPLAY_SIGNAL_CYCLE_CYCLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPLAY_SIGNAL_CYCLE_CYCLE.M with the given input arguments.
%
%      DISPLAY_SIGNAL_CYCLE_CYCLE('Property','Value',...) creates a new DISPLAY_SIGNAL_CYCLE_CYCLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Display_signal_cycle_cycle_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Display_signal_cycle_cycle_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Display_signal_cycle_cycle

% Last Modified by GUIDE v2.5 13-Jul-2017 13:32:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Display_signal_cycle_cycle_OpeningFcn, ...
                   'gui_OutputFcn',  @Display_signal_cycle_cycle_OutputFcn, ...
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
end

% --- Executes just before Display_signal_cycle_cycle is made visible.
function Display_signal_cycle_cycle_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Display_signal_cycle_cycle (see VARARGIN)


% Choose default command line output for Display_signal_cycle_cycle
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


%Initialisation des cycles
Plot_Cycle_THO = varargin{1};
Plot_Cycle_ABD = varargin{2};
%Moyenne des angles calculés cycles à cycles 

setappdata(0,'average_angle',varargin{3});

%Pop up Menu

Cycle_Number = min(size(Plot_Cycle_ABD,1),size(Plot_Cycle_THO,1));
%Plot_Cycle_ABD = getappdata(0,'Plot_Cycle_ABD');
%Plot_Cycle_THO = getappdata(0,'Plot_Cycle_THO');
MatChar = [];

for j = 2:1:Cycle_Number+1
    
    MatChar{j}=(['Cycle n° ',num2str(j - 1)]);
end
MatChar{1} = 'Ensemble des cycles';
set(handles.Select_Cycle,'String',MatChar);
set(handles.pushbutton_Deleate,'Enable','off')




setappdata(0,'Plot_Cycle_ABD',Plot_Cycle_ABD);
setappdata(0,'Plot_Cycle_THO',Plot_Cycle_THO);
setappdata(0,'i',1);
setappdata(0,'Exit',true);
setappdata(0,'Exist_Error',zeros(Cycle_Number,1));
setappdata(0,'funct1_call',0); % has the rule meter been used? ->0 no, -> 1 yes

setappdata(0,'save',0);
XBorder = get(gca,'XLim');
YBorder = get(gca,'YLim');
setappdata(0,'XBorder',XBorder)
setappdata(0,'YBorder',YBorder)
guidata(hObject,handles)

% %Button use meter
% set(hObject, 'WindowButtonDownFcn', @mouse1, 'WindowsButtonUpFcn', @mouse2, 'WindowButtonMotionFcn', @mouse3);
%Elimination des '0' en trop

k = 1;
Temp_plot_ABD = [];
Temp_plot_THO = [];
    
while (k < size(Plot_Cycle_THO,2)-6)&&(Plot_Cycle_THO(1,k)~=0 || Plot_Cycle_THO(1,k+1)~=0 || Plot_Cycle_THO(1,k+5)~=0)
        Temp_plot_THO(k) = Plot_Cycle_THO(1,k);
        k = k + 1; 
end

 k = 1;
    
while (k < size(Plot_Cycle_ABD,2)-6)&&(Plot_Cycle_ABD(1,k)~=0 || Plot_Cycle_ABD(1,k+1)~=0 || Plot_Cycle_ABD(1,k+5)~=0)
        Temp_plot_ABD(k) = Plot_Cycle_ABD(1,k);
        k = k + 1; 
end

Tmin = min(size(Temp_plot_ABD,2),size(Temp_plot_THO,2));

%Remove baseline
Temp_plot_ABD(1:Tmin) = Temp_plot_ABD(1:Tmin) - mean(Temp_plot_ABD(1:Tmin));
Temp_plot_THO(1:Tmin) = Temp_plot_THO(1:Tmin) - mean(Temp_plot_THO(1:Tmin));

plot(Temp_plot_ABD(1:Tmin),Temp_plot_THO(1:Tmin))
hold on
Th = Calcul_Angle_Geometrique_2(Temp_plot_ABD(1:Tmin),Temp_plot_THO(1:Tmin),handles);
hold off
%plot(Temp_plot_THO)
    %plot(sin(0:0.1:10))
grid on    
%end
%Display Plot
set(handles.Title,'String',['Konno-Mead Plot ',...
    char(10),'Cycle n° 1  Angle de Phase : ', num2str(Th),' °']);
handles.figure1.Visible = 'on';
xlabel('Amplitude de l''Abdomen')
ylabel('Amplitude du Thorax')

guidata(handles.figure1)
%pushbutton_PreviousCycle_Callback(hObject, eventdata, handles,1,Cycle_Number)
%pushbutton_NextCycle_Callback(hObject, eventdata, handles,1,Cycle_Number)
% UIWAIT makes Display_signal_cycle_cycle wait for user response (see UIRESUME)
% uiwait(handles.figure1);
uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = Display_signal_cycle_cycle_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = getappdata(0,'average_angle');
%Calcul du nombre de cycles restants
Plot_Cycle_ABD = getappdata(0,'Plot_Cycle_ABD');
Plot_Cycle_THO = getappdata(0,'Plot_Cycle_THO');
Cycle_Number = min(size(Plot_Cycle_ABD,1),size(Plot_Cycle_THO,1));
varargout{2} = Cycle_Number;
varargout{3} = getappdata(0,'Exist_Error');

%varargout{1} = handles.output;
end

% --- Executes on button press in pushbutton_PreviousCycle.
function pushbutton_PreviousCycle_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_PreviousCycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Warning,'ForegroundColor',[1,1,1]);
set(handles.pushbutton_Deleate,'Enable','on')
Plot_Cycle_ABD = getappdata(0,'Plot_Cycle_ABD');
Plot_Cycle_THO = getappdata(0,'Plot_Cycle_THO');
Cycle_Number = min(size(Plot_Cycle_ABD,1),size(Plot_Cycle_THO,1));

i = getappdata(0,'i');
i = i - 1;
if i < 0
    i = Cycle_Number;
end
setappdata(0,'i',i);
if i~= 0
    %Elimination des '0' en trop

    k = 1;
    Temp_plot_ABD = [];
    Temp_plot_THO = [];

    while (k < size(Plot_Cycle_ABD,2)-6)&&(Plot_Cycle_ABD(i,k)~=0 || Plot_Cycle_ABD(i,k+1)~=0 || Plot_Cycle_ABD(i,k+5)~=0)
        Temp_plot_ABD(k) = Plot_Cycle_ABD(i,k);
        k = k + 1; 
    end
    
%      k = 1;
     
%     while (k < size(Plot_Cycle_THO,2)-6)&&(Plot_Cycle_THO(i,k)~=0 || Plot_Cycle_THO(i,k+1)~=0 || Plot_Cycle_THO(i,k+5)~=0)
%         Temp_plot_THO(k) = Plot_Cycle_THO(i,k);
%         k = k + 1; 
%     end

    Temp_plot_THO = Plot_Cycle_THO(i,:);
    Tmin = min(size(Temp_plot_THO,2),size(Temp_plot_ABD,2));
    %Remove baseline
    Temp_plot_ABD(1:Tmin) = Temp_plot_ABD(1:Tmin) - mean(Temp_plot_ABD(1:Tmin));
    Temp_plot_THO(1:Tmin) = Temp_plot_THO(1:Tmin) - mean(Temp_plot_THO(1:Tmin));

    plot(Temp_plot_ABD(1:Tmin),Temp_plot_THO(1:Tmin))
    hold on
    Th = Calcul_Angle_Geometrique_2(Temp_plot_ABD(1:Tmin),Temp_plot_THO(1:Tmin),handles);
    hold off
    set(handles.Title,'String',['Konno-Mead Plot ',...
    char(10),'Cycle n° ',num2str(i), '  Angle de Phase : ', num2str(Th),' °']);
    setappdata(0,'Previous_angle',Th)
else
    for j=1:min(size(Plot_Cycle_ABD,1),size(Plot_Cycle_THO,1))
        
        %Drop unnecessary '0'
        k = 1;
        Temp_plot_ABD = [];
        Temp_plot_THO = [];
        
        while (k < size(Plot_Cycle_ABD,2)-6)&&(Plot_Cycle_ABD(j,k)~=0 || Plot_Cycle_ABD(j,k+1)~=0 || Plot_Cycle_ABD(j,k+5)~=0)
            Temp_plot_ABD(k) = Plot_Cycle_ABD(j,k);
            k = k + 1; 
            
%         while (k < size(Plot_Cycle_THO,2)-6)&&(Plot_Cycle_THO(j,k)~=0 || Plot_Cycle_THO(j,k+1)~=0 || Plot_Cycle_THO(j,k+5)~=0)
%             Temp_plot_THO(k) = Plot_Cycle_THO(j,k);
%             k = k + 1; 
%         end
%         k = 1;
        Temp_plot_THO = Plot_Cycle_THO(j,:);
          
        end
        Tmin = min(size(Temp_plot_THO,2),size(Temp_plot_ABD,2));
        plot(Temp_plot_ABD(1:Tmin),Temp_plot_THO(1:Tmin))
        set(handles.Title,'String',['Représentation de l''ensemble des ',...
        num2str(min(size(Plot_Cycle_ABD,1),size(Plot_Cycle_THO,1))),' cycles',char(10),'Angle de Phase moyen :',...
        num2str(getappdata(0,'average_angle'))]);
        hold on
    end
    hold off
end
xlabel('Amplitude de l''Abdomen')
ylabel('Amplitude du Thorax')
grid on
XBorder = get(gca,'XLim');
YBorder = get(gca,'YLim');
setappdata(0,'XBorder',XBorder)
setappdata(0,'YBorder',YBorder)
handles.figure1.WindowButtonDownFcn = @funct1;


%plot(cos(0:0.1:1*i))
%pushbutton_PreviousCycle_Callback = i;
end

% --- Executes on button press in pushbutton_NextCycle.
function pushbutton_NextCycle_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_NextCycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcf);
set(handles.Warning,'ForegroundColor',[1,1,1]);
set(handles.pushbutton_Deleate,'Enable','on')

Plot_Cycle_ABD = getappdata(0,'Plot_Cycle_ABD');
Plot_Cycle_THO = getappdata(0,'Plot_Cycle_THO');
Control_Callback = getappdata(0,'funct1_call');
Cycle_Number = min(size(Plot_Cycle_ABD,1),size(Plot_Cycle_THO,1));
i = getappdata(0,'i');

% h = findobj('Type','axes','Tag','Display_Cycle');
% axes(h)
% axes(handles.Display_Cycle)
% 
% set(0,'currentfigure',handles.figure1)
% set(handles.figure1,'currentaxes',handles.Display_Cycle)
%handles.figure1.HandleVisibility ='off';
handles.Display_Cycle = gca;
%set(p,'Parent',handles.Display_Cycle)
%handles.Display_Cycle

if ~isvalid(handles.Display_Cycle)
    disp('prb Display_Cycle')
end
if ~isvalid(handles.Title)
    disp('prb Title')
end

if Control_Callback 
    
    %handles.figure1 = guidata(handles.figure1);
    inco = guidata(handles.figure1)
    
    %handles.Display_Cycle = guidata(handles.Display_Cycle);
%     inco2 = guidata(handles.Display_Cycle)
%     inco2.Display_Cycle
%     handles
%     h = findobj('Tag','Display_Cycle')
%     h2 =axes(gcf)
%     handles.Display_Cycle = axes(gcf);
%     tst = findobj(gca,'Type','line')
%     handles.figure1.WindowButtonDownFcn = '';
%     handles.figure1.WindowButtonUpFcn = '';
%     set(handles.figure1,'CurrentAxes',h2)
%     set(handles.figure1,'CurrentObject',hObject)
%set(groot,'CurrentFigure',figure1)
end
if isempty(get(groot,'CurrentFigure'))
   disp('probleme avec currentfigure')
end

i = i + 1;
if i > Cycle_Number
    i = 0;
    
    for j=1:min(size(Plot_Cycle_ABD,1),size(Plot_Cycle_THO,1))
        
        %Drop unnecessary '0'
        k = 1;
        Temp_plot_ABD = [];
        Temp_plot_THO = [];
        

    
        while (k < size(Plot_Cycle_ABD,2)-6)&&(Plot_Cycle_ABD(j,k)~=0 || Plot_Cycle_ABD(j,k+1)~=0 || Plot_Cycle_ABD(j,k+5)~=0)
            Temp_plot_ABD(k) = Plot_Cycle_ABD(j,k);
            k = k + 1; 
        end
%         while (k < size(Plot_Cycle_THO,2)-6)&&(Plot_Cycle_THO(j,k)~=0 || Plot_Cycle_THO(j,k+1)~=0 || Plot_Cycle_THO(j,k+5)~=0)
%             Temp_plot_THO(k) = Plot_Cycle_THO(j,k);
%             k = k + 1; 
%         end
%         k = 1;        
        Temp_plot_THO = Plot_Cycle_THO(j,:);
        Tmin = min(size(Temp_plot_THO,2),size(Temp_plot_ABD,2));
        plot(Temp_plot_ABD(1:Tmin),Temp_plot_THO(1:Tmin))
        
        l = getappdata(0,'average_angle');
        set(handles.Title,'String',['Représentation de l''ensemble des ',...
        num2str(min(size(Plot_Cycle_ABD,1),size(Plot_Cycle_THO,1))),' cycles',char(10),'Angle de phase moyen : ',...
         num2str(getappdata(0,'average_angle'))]);
        hold on
    end
    hold off
else
%     Tmin = min(size(Plot_Cycle_ABD(i,:),2),size(Plot_Cycle_THO(i,:),2));
%     plot(Plot_Cycle_ABD(i,1:Tmin),Plot_Cycle_THO(i,1:Tmin))

%Elimination des '0' en trop

    k = 1;
    Temp_plot_ABD = [];
    Temp_plot_THO = [];
        
    while (k < size(Plot_Cycle_ABD,2)-6)&&(Plot_Cycle_ABD(i,k)~=0 || Plot_Cycle_ABD(i,k+1)~=0 || Plot_Cycle_ABD(i,k+5)~=0)
        Temp_plot_ABD(k) = Plot_Cycle_ABD(i,k);
        k = k + 1; 
    end
%     while (k < size(Plot_Cycle_THO,2)-6)&&(Plot_Cycle_THO(i,k)~=0 || Plot_Cycle_THO(i,k+1)~=0 || Plot_Cycle_THO(i,k+5)~=0)
%         Temp_plot_THO(k) = Plot_Cycle_THO(i,k);
%         k = k + 1; 
%     end
%     k = 1;    
    Temp_plot_THO = Plot_Cycle_THO(i,:);
    Tmin = min(size(Temp_plot_THO,2),size(Temp_plot_ABD,2));
    %Remove baseline
    Temp_plot_ABD(1:Tmin) = Temp_plot_ABD(1:Tmin) - mean(Temp_plot_ABD(1:Tmin));
    Temp_plot_THO(1:Tmin) = Temp_plot_THO(1:Tmin) - mean(Temp_plot_THO(1:Tmin));
    
    plot(handles.Display_Cycle,Temp_plot_ABD(1:Tmin),Temp_plot_THO(1:Tmin));
    hold on
    Th = Calcul_Angle_Geometrique_2(Temp_plot_ABD(1:Tmin),Temp_plot_THO(1:Tmin),handles);
    hold off
    set(handles.Title,'String',['Konno-Mead Plot ',...
    char(10),'Cycle n° ',num2str(i), '  Angle de Phase : ', num2str(Th),' °']);
    setappdata(0,'Previous_angle',Th)
end
%pushbutton_NextCycle_Callback = i;
%plot(cos(0:0.1:1*i))
setappdata(0,'i',i)
%plot(Plot_Cycle_ABD(i,:),Plot_Cycle_THO(i,:))
xlabel('Amplitude de l''Abdomen')
ylabel('Amplitude du Thorax')
grid on
hold off

%set(p,'Parent',handles.Display_Cycle)
XBorder = get(gca,'XLim');
YBorder = get(gca,'YLim');
setappdata(0,'XBorder',XBorder)
setappdata(0,'YBorder',YBorder)
handles.figure1.IntegerHandle = 'off';


try
    handles.figure1.WindowButtonDownFcn = @funct1;
catch
    
    disp('erreur detectee')
end
%handles.figure1.WindowButtonDownFcn = '';
disp(handles.figure1.BeingDeleted)
guidata(handles.figure1,handles);
end


% --- Executes on button press in pushbutton_Continue.
function pushbutton_Continue_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Continue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close 
end

% --- Executes on selection change in Select_Cycle.
function Select_Cycle_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Cycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Select_Cycle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Select_Cycle

Plot_Cycle_ABD = getappdata(0,'Plot_Cycle_ABD');
Plot_Cycle_THO = getappdata(0,'Plot_Cycle_THO');
set(handles.Warning,'ForegroundColor',[1,1,1]);
set(handles.pushbutton_Deleate,'Enable','on')



i = get(handles.Select_Cycle,'value');

if i > 1
    i = i-1;
    k = 1;
    Temp_plot_ABD = [];
    Temp_plot_THO = [];

    
    while (k < size(Plot_Cycle_ABD,2)-6)&&(Plot_Cycle_ABD(i,k)~=0 || Plot_Cycle_ABD(i,k+1)~=0 || Plot_Cycle_ABD(i,k+5)~=0)
        Temp_plot_ABD(k) = Plot_Cycle_ABD(i,k);
        k = k + 1; 
    end
    
%     while (k < size(Plot_Cycle_THO,2)-6)&&(Plot_Cycle_THO(i,k)~=0 || Plot_Cycle_THO(i,k+1)~=0 || Plot_Cycle_THO(i,k+5)~=0)
%         Temp_plot_THO(k) = Plot_Cycle_THO(i,k);
%         k = k + 1; 
%     end
%     k = 1;
    Temp_plot_THO = Plot_Cycle_THO(i,:);    
    Tmin = min(size(Temp_plot_THO,2),size(Temp_plot_ABD,2));
    %Remove baseline
    Temp_plot_ABD(1:Tmin) = Temp_plot_ABD(1:Tmin) - mean(Temp_plot_ABD(1:Tmin));
    Temp_plot_THO(1:Tmin) = Temp_plot_THO(1:Tmin) - mean(Temp_plot_THO(1:Tmin));
    plot(Temp_plot_ABD(1:Tmin),Temp_plot_THO(1:Tmin))
    hold on
    Th = Calcul_Angle_Geometrique_2(Temp_plot_ABD(1:Tmin),Temp_plot_THO(1:Tmin),handles);
    hold off
    
    set(handles.Title,'String',['Konno-Mead Plot ',...
    char(10),'Cycle n° ',num2str(i), '  Angle de Phase : ', num2str(Th),' °']);
    setappdata(0,'Previous_angle',Th)
else
    
    for j=1:min(size(Plot_Cycle_ABD,1),size(Plot_Cycle_THO,1))
        k = 1;
        Temp_plot_ABD = [];
        Temp_plot_THO = [];

    
        while (k < size(Plot_Cycle_ABD,2)-6)&&(Plot_Cycle_ABD(j,k)~=0 || Plot_Cycle_ABD(j,k+1)~=0 || Plot_Cycle_ABD(j,k+5)~=0)
            Temp_plot_ABD(k) = Plot_Cycle_ABD(j,k);
            k = k + 1; 
        end
                
%         while (k < size(Plot_Cycle_THO,2)-6)&&(Plot_Cycle_THO(j,k)~=0 || Plot_Cycle_THO(j,k+1)~=0 || Plot_Cycle_THO(j,k+5)~=0)
%             Temp_plot_THO(k) = Plot_Cycle_THO(j,k);
%             k = k + 1; 
%         end
%         k = 1;
        Temp_plot_THO = Plot_Cycle_THO(j,:);        
        Tmin = min(size(Temp_plot_THO,2),size(Temp_plot_ABD,2));
        plot(Temp_plot_ABD(1:Tmin),Temp_plot_THO(1:Tmin))
        set(handles.Title,'String',['Représentation de l''ensemble des ',...
        num2str(min(size(Plot_Cycle_ABD,1),size(Plot_Cycle_THO,1))),' cycles',char(10),'Angle de Phase moyen : ',...
         num2str(getappdata(0,'average_angle'))]);
        hold on
    end
    hold off
    i = i-1;
end
xlabel('Amplitude de l''Abdomen')
ylabel('Amplitude du Thorax')
grid on
setappdata(0,'i',i)
XBorder = get(gca,'XLim');
YBorder = get(gca,'YLim');
setappdata(0,'XBorder',XBorder)
setappdata(0,'YBorder',YBorder)

handles.figure1.WindowButtonDownFcn = @funct1;
guidata(handles.figure1,handles)

%handles.figure1.WindowButtonDownFcn = '';


end

% --- Executes during object creation, after setting all properties.
function Select_Cycle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Cycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton_Deleate.
function pushbutton_Deleate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Deleate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Inputs
i = getappdata(0,'i');
Plot_Cycle_ABD = getappdata(0,'Plot_Cycle_ABD');
Plot_Cycle_THO = getappdata(0,'Plot_Cycle_THO');
average_angle = getappdata(0,'average_angle');
Previous_angle = getappdata(0,'Previous_angle');

Cycle_Number = min(size(Plot_Cycle_ABD,1),size(Plot_Cycle_THO,1));


if i<=1 || Cycle_Number <=1
    %set(handles.pushbutton_Deleate,'Enable','off')
    %do nothing
else
    if i ~= Cycle_Number
        

        
        for j = 1:(Cycle_Number - i)
            Plot_Cycle_ABD_2(Cycle_Number - j,:) = Plot_Cycle_ABD(Cycle_Number - j + 1,:);
            Plot_Cycle_THO_2(Cycle_Number - j,:) = Plot_Cycle_THO(Cycle_Number - j + 1,:);
        end
        Plot_Cycle_ABD_2(1:i - 1,:) = Plot_Cycle_ABD(1:i - 1,:);
        Plot_Cycle_THO_2(1:i - 1,:) = Plot_Cycle_THO(1:i - 1,:);
    else
        Plot_Cycle_ABD_2 = Plot_Cycle_ABD(1:end-1,:);
        Plot_Cycle_THO_2 = Plot_Cycle_THO(1:end-1,:);
    end
    %Correction de la valeur de l'angle moyen
    average_angle = (average_angle - Previous_angle/Cycle_Number)*Cycle_Number/(Cycle_Number - 1);
    
    setappdata(0,'Plot_Cycle_ABD',Plot_Cycle_ABD_2)
    setappdata(0,'Plot_Cycle_THO',Plot_Cycle_THO_2)
    setappdata(0,'average_angle',average_angle)
    
    
    pushbutton_PreviousCycle_Callback(hObject, eventdata, handles);
    disp(['Suppression du cycle n° ',num2str(i)])
    
    for j = 2:1:Cycle_Number
    
        MatChar{j}=(['Cycle n° ',num2str(j - 1)]);
    end
    MatChar{1} = 'Ensemble des cycles';
    set(handles.Select_Cycle,'Value',i - 1);
    set(handles.Select_Cycle,'String',MatChar);
end

end




function Th = Calcul_Angle_Geometrique_2(sabd,stho,handles)

Liss = [sabd(:),stho(:)];

%m egale la distance de part et d'autre de la conique à max(RC)*0.5-min(RC)*0.5
[LissMax,IndexMax] = max(Liss);


MaxRC = ([sabd(IndexMax(2)),stho(IndexMax(2))]);
[LissMin,IndexMin] = min(Liss);
MinRC = ([sabd(IndexMin(2)),stho(IndexMin(2))]);

%MiddleRC=(MaxRC(2)-MinRC(2))*0.5+MinRC(2);

MiddleABD = abs(LissMin(1) - LissMax(1)) /2 + min(LissMin(1),LissMax(1));
MiddleRC = abs(LissMax(2) - LissMin(2)) /2 + min(LissMax(2),LissMin(2));

MiddlePtRC=([LissMin(1),LissMax(1);MiddleRC,MiddleRC]);
Centre=[MiddleABD,MiddleRC];

%Détection de l'extremité du segment m (à doite: PtDroit, à gauche:
%PtGauche)

%Initialisation
%i1 = 1;
%i1=IndexMin(2); i2=IndexMin(2);
i1 = ceil(length(Liss)/2);
i2 = floor(length(Liss)/2);
Correction_Needed_Right = 1;%Augmente l'intervalle de détection pour PtDroit
Correction_Needed_Left = 1; %Augmente l'intervalle de détection pour PtGauche
Interval_Right = 0.02;
Interval_Left = 0.02;
%Epoch = 1;
%Extraction des coordonnées de PtDroit (ou Pt gauche, en fonction du sens
%de rotation de la conique)
while Correction_Needed_Right == 1 && Interval_Right<2 %&& Epoch >5
    while abs(Liss(i1,2)-MiddleRC)>Interval_Right && i1<=length(Liss)-1
    
        i1=i1+1;
    
    end
    
    if i1==length(Liss)


        Interval_Right = Interval_Right + 0.01;
        i1 = ceil(length(Liss)/2);
    else
        Correction_Needed_Right = 0;
    end

    %Epoch = Epoch + 1;
end
if Interval_Right>2
    disp(['Erreur : l''algorithme n''a pas réussi à détecter les bords de la coniques. Cette mauvaise détection est probablement due',...
    '  au signal échantillionné avec une fréquence d''échantillonnage trop faible'])
    warning(['Attention ! : l''algorithme n''a pas réussi à détecter les bords de la coniques. Cette mauvaise détection est probablement due',...
    '  au signal échantillionné avec une fréquence d''échantillonnage trop faible'])
    set(handles.Warning,'ForegroundColor','red');
    Err = getappdata(0,'Exist_Error');
    [Ind,~] = find(Err ==0,1,'first');
    Err(Ind) = 1;
    setappdata(0,'Exist_Error',Err)
end

PtDroit=([Liss(i1,1),Liss(i1,2)]); 

% i2 = i1 + 1;
%Extraction des coordonnées de PtGauche

%  while (abs(Liss(i2,2)-MiddleRC)>0.02)&& i2<=length(Liss)-1
%           i2=i2+1;
%  end
while Correction_Needed_Left && Interval_Left<2
    while (abs(Liss(i2,2)-MiddleRC)>Interval_Left)&& i2>1
        i2=i2-1;
    end
 
    if i2==1 && i2 - 3 <= length(Liss)
        i2=i1+3;
        while (abs(Liss(i2,2)-MiddleRC)>0.02)&& (i2<=length(Liss)-1)
            i2=i2+1;
        end
    end


    if i2 == length(Liss)
    
        Interval_Left = Interval_Left + 0.01;
        i2 = floor(length(Liss)/2);
    else
        Correction_Needed_Left = 0;

    end
end
PtGauche=([Liss(i2,1),Liss(i2,2)]);

if Interval_Left > 2
         disp(['Erreur : l''algorithme n''a pas réussi à détecter les bords de la coniques. Cette mauvaise détection est probablement due',...
        '  au signal échantillionné avec une fréquence d''échantillonnage trop faible'])
    warning(['Attention ! : l''algorithme n''a pas réussi à détecter les bords de la coniques. Cette mauvaise détection est probablement due',...
        '  au signal échantillionné avec une fréquence d''échantillonnage trop faible'])
    set(handles.Warning,'ForegroundColor','red');
        Err = getappdata(0,'Exist_Error');
        if Interval_Left < 2
            [Ind,~] = find(Err ==0,1,'first');
            Err(Ind) = 1;
            setappdata(0,'Exist_Error',Err)
        end
end
%Calcul de la valeur de m
m=(abs(Liss(i2,1)-Liss(i1,1)));

%Calcul de la valeur de s
s=(abs(LissMax(1)-LissMin(1)));
sPt=([LissMin(1),LissMax(1);min(LissMax(1),LissMax(2)),min(LissMax(1),LissMax(2))]);

%Calcul de l'angle de phase

if stho(IndexMax(1))-stho(IndexMin(1))<0
    Th=pi+asin(-m/s);
else
    Th=asin(m/s);
end

Th=Th*180/pi; %Convertir l'angle de rad->°
axis([LissMin(1)-0.3,LissMax(1)+0.3,LissMin(2)-0.3,LissMax(2)+0.3])
text(double(Centre(1)),double(Centre(2)+0.1),['m = ' num2str(m)])
text(double(Centre(1)),double(LissMax(2)+0.1),['s = ' num2str(s)])
hold on
%plot(MaxRC(1),MaxRC(2),'*')%Position du max selon RC
plot(sabd(IndexMax(2)),stho(IndexMax(2)),'*')
hold on
%plot(MinRC(1),MinRC(2),'*')%Position du min selon RC
plot(sabd(IndexMin(2)),stho(IndexMin(2)),'*')
hold on
%plot(MiddlePtRC(1,:),MiddlePtRC(2,:))%Droite de longueur s contenant m
plot([PtDroit(1),PtGauche(1)],[PtDroit(2),PtGauche(2)]);%Droite représentant m
hold on
plot(MiddleABD,MiddleRC,'+')%Centre de la conique
hold on
plot(PtDroit(1),PtDroit(2),'+')%Extrémité droite de m
hold on
plot(PtGauche(1),PtGauche(2),'+')%Extremité gauche de m
hold on
if length(sabd)>30 && length(stho)>30
    quiver(sabd(10),stho(10),sabd(30)-sabd(1),stho(30)-stho(1),0,'Color','red','MaxHeadSize',1000)
    hold on
    plot(sabd(1),stho(1),'bo')%Clockwise or counterclockwise?
    hold on 
    plot(sabd(20),stho(20),'ro')%Clockwise or counterclockwise?
    hold on
end
%plot(sPt(1,:),sPt(2,:),'k')%longueur de s
plot([sabd(IndexMin(1)),sabd(IndexMax(1))],[min(LissMax(1),LissMax(2)),min(LissMax(1),LissMax(2))],'k')%longueur de s
hold on


%line([LissMin(1),LissMin(1)],[sPt(2,2),stho(IndexMin(1))],'Color','black','LineStyle',':');
line([sabd(IndexMin(1)),sabd(IndexMin(1))],[sPt(2,2),stho(IndexMin(1))],'Color','black','LineStyle',':');
%line([LissMax(1),LissMax(1)],[sPt(2,2),stho(IndexMax(1))],'Color','black','LineStyle',':');
line([sabd(IndexMax(1)),sabd(IndexMax(1))],[sPt(2,2),stho(IndexMax(1))],'Color','black','LineStyle',':');

grid on
end

% --- Executes on button press in togglebutton.
function togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton
end

% --- Executes on slider movement.
function Slider_SelectValue_Callback(hObject, eventdata, handles)
% hObject    handle to Slider_SelectValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
end

% --- Executes during object creation, after setting all properties.
function Slider_SelectValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Slider_SelectValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

% --- Executes on button press in Pushbutton_Erase.
function Pushbutton_Erase_Callback(hObject, eventdata, handles)
% hObject    handle to Pushbutton_Erase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in Pushbutton_save.
function Pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to Pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Result,'String',num2str(getappdata(0,'save')))
end
% function mouse1(handles, varargin)
% 
% %Position of the mouse cursor whithin the display plot
% currentPoint = get(handles, 'CurrentPoint');
% 
% x = currentPoint(1,1);
% y = currentPoint(1,2);
% 
% axesPos = get(handles.Display_Cycle,'Position');
% 
% Max_x = axesPos(1) + axesPos(3);
% Max_y = axesPos(2) + axesPos(4);
% if x>=axesPos(1) && x<=Max_x && y>=axesPos(2) && y<=Max_y
%     currentPoint = 
% end


% --- Executes on button press in checkbox.
function checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox
end
function funct1(src,jj, hObject)
src.Interruptible = 'off';

%.pushbutton_NextCycle.BusyAction = 'cancel';
% handles.pushbutton_NextCycle.Interruptible = 'off';
% src.BusyAction = 'cancel';

seltype = src.SelectionType;

if strcmp(seltype,'normal')
    disp('ok')
  ax = gca;
  ax.Units = 'characters';

%disp(ax.XLim)

XBorder = getappdata(0,'XBorder');
YBorder = getappdata(0,'YBorder');
ax.XLim = XBorder;
ax.YLim = YBorder;

ax.SortMethod = 'childorder';

src.Pointer = 'cross';
src.Units = 'characters';

   
Loc = ax.CurrentPoint; 
    
Linea = line(Loc(1,1),Loc(1,2),'Marker','+','color','b');
    
if (Loc(1,1) > XBorder(2)) || (Loc(1,1) < XBorder(1)) || (Loc(1,2) > YBorder(2)) || (Loc(1,2) < YBorder(1))
    disp('en dehors')
    src.Pointer = 'arrow';
    src.WindowButtonMotionFcn = '';
    src.WindowButtonUpFcn = '';
    src.WindowButtonDownFcn = '';
    error('User want to stop to use manual method')
end
src.WindowButtonMotionFcn = @funct2;


    
elseif strcmp(seltype,'alt')
    disp('click gauche')
end
h = findobj('Type','line','color','b','Linestyle','-');
if mod(length(h),2) == 0
    src.NextPlot = 'replace';
    disp('trop de traits')
    disp(length(h))
    src.Interruptible = 'on';
                  src.WindowButtonMotionFcn = '';
              src.WindowButtonUpFcn = '';
%               disp('X')
%               disp(h(2).XData)
%               disp('Y')
%               disp(h(2).YData)
    IndX = h(2).XData;
    IndY = h(2).YData;
    if (length(IndX) >= 2)&&(length(IndY) >= 2)
        Dist = sqrt((IndY(2) - IndY(1)).^2 + (IndX(2) - IndX(1)).^2);
              text(abs(IndX(2)-IndX(1))*.5 + min(IndX(2),IndX(1)),abs(IndY(2)-IndY(1))*.5 + min(IndY(2),IndY(1)),...
                  num2str(Dist),'Color','red','FontSize',14)
              setappdata(0,'save',Dist)
              
    end
    
end
    
        src.WindowButtonUpFcn = @funct3;
        setappdata(0,'funct1_call',1);
return


    function funct2(src,jj)
       
        if exist('Loc') && exist('Linea')
        Loc2 =ax.CurrentPoint;
        
        
        Linea.XData = [Loc(1,1),Loc2(1,1)];
        Linea.YData = [Loc(1,2),Loc2(1,2)];
        drawnow
        end
    end
    function funct3(src,jj)
        if strcmp(src.SelectionType,'alt')&& mod(length(findobj('Type','line')),2) == 0 
            h2 = findobj('Type','line','color','b','Linestyle','-');
            
          
            delete(h2)
            disp('h2 deleted')
            disp(length(h2))
            t = findobj('Type','text','Color','red','FontSize',14);
            disp(length(t))
            delete(t)
        end
    end
end


