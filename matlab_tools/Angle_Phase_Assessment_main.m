%% ~~~~ Angle phase Assessment program~~~~
 
%For: Dr. Guillaume Carteaux 
%Location : Hopital Henri Mondor
%Date : July, 2017
%Author : Yannick Bouillard, UTC
%
%% Note to user:
%In this program, 2 methods for assessing angle phase are used 
%1 ) Konno - Mead Method : it is a geometrical method in which Rib Chest
%signal is plotted versus Abdomen signal. 2 parameters are then calculated
%in order to assess phase angle
%2) Extrema detection method : distances between all maxima of the Rib
%Chest signal and  of the Abdomen Signal are computed, a phase angle
%assessment is then obtained by dividing this distance by each Abdomen
%cycle length 's
%
% Step 1) : First, store data into a .txt file (with a header)
% Step 2) : a window will ask you if the Extrema detection is correct. If
% not, adapt the predomiance value, or/and press correction pushbutton
% Step 3): results will be displayed, you can delete or measure manually
% results if some issues occured
%% ~~~~ Angle phase Assessment code~~~~
close all; clc; clear

%Default values
Val_pred = 0.3; %Preominance default value

%-----Step 1) Import file containing Rib Chest and Abdomen datas

Matlab_Path = pwd;%Matlab path name

%Search on the system a file named OldPath2 contaning the path of the
%previous opened file. If the file doesn't exist, create it
Previous_File = fopen('OldPath2.tmp');
try
    defopath = textscan(Previous_File, '%s','delimiter', '#');
catch 
    Previous_File = fopen('OldPath2.tmp','w');
    fprintf(Previous_File,'%s',Matlab_Path);
    defopath = string(Matlab_Path);
    
end

fclose(Previous_File);

if exist(char(defopath{1}))==7
    cd(char(defopath{1}));
end

[NomFichier,NomChemin] = uigetfile({'*.txt','*.csv'},'Please Select a *.txt file containing Rib Chest and Abdomen Datas', 'File Selection');

if NomFichier==0
    disp('Program stopped by user');
    close;
    return;
end

if ~exist(NomFichier,'file')
    disp('error')
end
try
    Datas = readtable(NomFichier,'Delimiter','\t');
catch ME
    warning(['Error happen when trying to open file (bug matlab apprently....)',...
        char(10),'Using robust algorithm to open file'])
    matlabroot;%Acceder au fichier matlab

     path(path,NomChemin)
    Datas = readtable(NomFichier,'Delimiter','\t');
end
cd(Matlab_Path);

Previous_File = fopen('OldPath2.tmp','w');
fprintf(Previous_File,'%s',NomChemin);
fclose(Previous_File);

%-----Step 2) Import datas from the *.txt file

DatasStr = table2struct(Datas);
disp(['Nom du fichier ouvert : ',NomFichier])

disp('Nom des variables lues :')

%Create an array contaning the  columns name readed
for i=1:size(Datas,2)
disp(['Variable ',num2str(i),' :',Datas.Properties.VariableNames{i}])
Msg(i)={[num2str(i) ' pour ' char(Datas.Properties.VariableNames{i})]};
end

% Import Abdomen datas
Rep = listdlg('PromptString','Please select ABDOMEN datas','SelectionMode','single','ListSize',[250,360],'ListString',Msg');

if isempty(Rep)
    error('Arrêt de l''algorithme décidé par l''utilisateur')
end
%Remplacer les ',' par des points '.' sous Matlab

Data_ABD = Datas{2:end,Rep};

Data_ABD = replace(Data_ABD,',','.');
Array_ABD = zeros(size(Data_ABD,1),size(Data_ABD,2));
Array_ABD = str2double(Data_ABD);

i = 1; Indic = false;

while i<length(Array_ABD) && Indic
    if isnan(Array_ABD(i)) || isinf(Array_ABD(i))
        Indic = true;
        disp('Erreur: des NaN et/ou des Inf ont été détectés')
        error(['Erreur: attention, des valeurs incorrectes (NaN et Inf) ont été retrouvées dans la colonne contenant les données de l''Abdomen',char(10),...
            'Vérifier que les données importées ne contiennent que les noms des variables et leurs valeurs. Pour rappel, les unités doivent être effacées',...
            'sur Excel avant de réaliser un copier-coller sur fichier *.txt']);
    end
    i = i+1;
end

%Import Thorax Datas

Sortie = true;
while Sortie
    Rep2 = listdlg('PromptString','Please Select RIB CHEST datas','SelectionMode','single','ListSize',[250,360],'ListString',Msg');
    if Rep2 == Rep
        Rep_msgbox = questdlg(['Le tracé a déjà été utilisé pour tracer le signal de l''Abdomen.',...
            '\Etes vous sûr de vouloir continuer avec les mêmes données?'],'Pas de différence entre Thorax et Abdomen',...
            'Oui','Non','Non');
        if Rep_msgbox == 'Oui'
            Sortie = false;
        end
    else
        Sortie = false;
    end
end

if isempty(Rep2)
    error('Arrêt de l''algorithme décidé par l''utilisateur')
end

%Remplacer les ',' par des points '.' sous Matlab

Data_THO = Datas{2:end,Rep2};

Data_THO = replace(Data_THO,',','.');
Array_THO = zeros(size(Data_THO,1),size(Data_THO,2));
Array_THO = str2double(Data_THO);

i = 1; Indic = true;

while i<length(Array_THO) && Indic
    if isnan(Array_THO(i)) || isinf(Array_THO(i))
        Indic = false;
        disp('Erreur: des NaN et/ou des Inf ont été détectés')
        error(['Erreur: attention, des valeurs incorrectes (NaN et Inf) ont été retrouvées dans la colonne contenant les données du Thorax',char(10),...
            'Vérifier que les données importées ne contiennent que les noms des variables et leurs valeurs. Pour rappel, les unités doivent être effacées',...
            'sur Excel avant de réaliser un copier-coller sur fichier *.txt']);
    end
    i = i+1;
end

%----Step 3) Display Rib Chest and Abdomen waveforms, and the Konno-Mead plot

%Remove signals baseline
Array_ABD = Array_ABD - mean(Array_ABD);
Array_THO = Array_THO - mean(Array_THO);

% Compute figure 's size according to the user 's monitor
fig_Border = get(0,'MonitorPositions');
fig_Border(2) = fig_Border(2)*.9;
fig_Border(4) = fig_Border(4)*.9;

fig1 = figure();
fig1.OuterPosition = get(0,'MonitorPositions');
fig1.Position = fig_Border;
% Abdomen Waveform
subplot(2,2,1)
plot(Array_ABD)
title(['Tracé des signaux électriques de l''Abdomen (',char(Datas.Properties.VariableNames{Rep}),')'])
axis([0, length(Array_ABD),min(Array_ABD)*1.1,max(Array_ABD)*1.1])
xlabel('Nombre de points')
ylabel('Voltage (V)')
grid on
%Rib Chest Waveform
subplot(2,2,3)
plot(Array_THO)
title(['Tracé des signaux électriques du thorax (',char(Datas.Properties.VariableNames{Rep2}),')'])
axis([0, length(Array_THO),min(Array_THO)*1.1,max(Array_THO)*1.1])
xlabel('Nombre de points')
ylabel('Voltage (V)')
grid on

% Konno-Mead Plot 

subplot(2,2,[2,4])
plot(Array_ABD,Array_THO)
title('Konno-Mead Plot')
ylabel('Amplitude du signal du Thorax (THO)')
xlabel('Amplitude du signal de l''Abdomen (ABD)')
grid on
hold off
sabd = Array_ABD;
stho = Array_THO;


if length(Array_ABD)~=length(Array_THO)
    disp('Erreur au niveau des données importées')
    error('Erreur au niveau des données importées: taille des données de Thorax et Abdomen différente!')
end

%---- Step 4): Ask user to check if the extrema deetction is OK

% Use Display_Max_Min GUI and Display_2_Signals
try
[Val_pred_ABD,Val_pred_THO,Display_2,Interv,Is_min_max] = Display_Max_Min(Array_ABD,Array_THO,Val_pred,Val_pred,[],0);
catch ME
   if strcmp(ME.identifier,'MATLAB:UndefinedFunction')
       warndlg(sprintf('File entitled "Display_Min_Max" cannot be found  on the folder.\nHowever, you can contiue using default setting'))
        Interv = [];
        Val_pred_ABD = Val_pred;
        Val_pred_THO = Val_pred;
        Is_min_max = 0;
        Display_2 = 0;
   end
end
Manual_Method_Used = 0;
while Display_2 ~= 0
    
   if Display_2 == 1
    Display_2_Signals(Array_THO,Array_ABD,Val_pred_ABD,Val_pred_THO,Interv,Is_min_max)
   elseif Display_2 == 2
       %Use manual method
       Rep_msgbox_MM = questdlg({'Please make sure you have selected  good preominance values before using Manual Method';...
           ['Do you want to use Maxima detection or Minima detection',...
            ' for signals segmentation ?']},'Manual Method',...
            'Maxima','Minima','Don''t','Maxima');
        if  strcmp(Rep_msgbox_MM,'Maxima') && all(Rep_msgbox_MM == 'Maxima')
            %User want to segment signals using Maxima detection
            [~,Loc_Max_ABD] = findpeaks(Array_ABD(Interv),Interv,'MinPeakProminence',Val_pred_ABD);
            [~,Loc_Max_THO] = findpeaks(Array_THO(Interv),Interv,'MinPeakProminence',Val_pred_THO);
            %Select Pic for Abdomen waveform
            
            fig2_ABD = Manual_Method_Seg(Loc_Max_ABD,Array_ABD,Loc_Max_THO,Array_THO,Interv,fig_Border);
            Max_ABD_V = Manual_Method_Mouse(fig2_ABD);
            
            %Select Pic for Rib Chest waveform
            fig2_THO = Manual_Method_Seg(Loc_Max_THO,Array_THO,sort(Loc_Max_ABD(Max_ABD_V)),...
                Array_ABD,Interv,fig_Border);
            Max_THO_V = Manual_Method_Mouse_2(fig2_THO,Max_ABD_V);
            % Check user selection
            [Display_2,Manual_Method_Used] = CheckUserSelection(Max_ABD_V,Max_THO_V);
            
            %End while loop
                
        elseif strcmp(Rep_msgbox_MM,'Minima') && all(Rep_msgbox_MM == 'Minima')
            %User want to segment signals Using Minima detection
            [~,Loc_Min_ABD] = findpeaks(-Array_ABD(Interv),Interv,'MinPeakProminence',Val_pred_ABD);
            [~,Loc_Min_THO] = findpeaks(-Array_THO(Interv),Interv,'MinPeakProminence',Val_pred_THO);
            
            %Select Pic for Abdomen waveform
            
            fig2_ABD = Manual_Method_Seg(Loc_Min_ABD,Array_ABD,Loc_Max_THO,...
                Array_THO,Loc_Max_THO,Array_THO,Interv,fig_Border);
            Min_ABD_V = Manual_Method_Mouse(fig2_ABD);
            
            %Select Pic for Rib Chest waveform
            fig2_THO = Manual_Method_Seg(Loc_Min_THO,Array_THO,sort(Loc_Min_ABD(Min_ABD_V)),...
                Array_ABD,Interv,fig_Border);
            Min_THO_V = Manual_Method_Mouse_2(fig2_THO,Min_ABD_V);
            % Check user selection
            [Display_2,Manual_Method_Used] = CheckUserSelection(Min_ABD_V,Min_THO_V);
            Is_min_max = -1;
            %End while loop
            
        else
            Display_2 = 2;
        end
   end
   if Display_2 ~= 0
    [Val_pred_ABD,Val_pred_THO,Display_2,Interv,Is_min_max] = Display_Max_Min(Array_ABD,Array_THO,Val_pred_ABD,Val_pred_THO,Interv,Is_min_max);
   end
end

if isempty(Interv)||(length(Interv)>length(Array_ABD))
    
    Interv = 1:length(Array_ABD);%Interv is the intervalle of both ABDOMEN and RIB CHEST signals on which 
    %The angle phase assessmet will be computed
end


% Detection of Signals ' Extrema 
%~~> Maxima detection
[Max_ABD,Loc_Max_ABD] = findpeaks(Array_ABD(Interv),Interv,'MinPeakProminence',Val_pred_ABD);
[Max_THO,Loc_Max_THO] = findpeaks(Array_THO(Interv),Interv,'MinPeakProminence',Val_pred_THO);
%~~> Minima detection
[~,Loc_Min_ABD] = findpeaks(-Array_ABD(Interv),Interv,'MinPeakProminence',Val_pred_ABD);
[~,Loc_Min_THO] = findpeaks(-Array_THO(Interv),Interv,'MinPeakProminence',Val_pred_THO);
Min_ABD = Array_ABD(Loc_Min_ABD);
Min_THO = Array_THO(Loc_Min_THO);

if ~Manual_Method_Used
%Calcul du nombre de cycles segmenté possible: L
if length(Loc_Max_ABD)~=length(Loc_Min_ABD)
    %L = min(length(Max_ABD),length(Min_ABD));
    if length(Loc_Max_ABD) == length(Loc_Max_THO)
        L = length(Loc_Max_ABD) - 1;
    elseif length(Loc_Min_ABD) == length(Loc_Min_THO)
        L = length(Loc_Min_ABD) - 1;
    else
        if Is_min_max == 1
            L = lenght(Max_ABD)-1;
        elseif Is_min_max == -1
            L = lenght(Min_ABD)-1;
        else
            L = min(length(Max_ABD),length(Min_ABD));
        end
    end
    
else
    L =  length(Loc_Min_ABD) - 1;
    
end

%Decide if Sgementation must be done using Maxima detection or Minima
%Detection
if  Is_min_max == 0
    if length(Loc_Max_ABD) >= length(Loc_Min_ABD)
        Is_min_max = 1;
        L = length(Loc_Max_ABD) - 1;
    else
        Is_min_max = 0;
        L =  length(Loc_Min_ABD) - 1;
    end
end
else
    %In case the manual method is used
    if  all(Rep_msgbox_MM == 'Minima')
        Is_min_max = -1;
        L = length(Min_ABD_V) - 1;
        Loc_Min_ABD_2 = Loc_Min_ABD(Min_ABD_V);
        Loc_Min_ABD = sort(Loc_Min_ABD_2);
        Loc_Min_THO_2 = Loc_Min_THO(Min_THO_V);
        Loc_Min_THO = sort(Loc_Min_THO_2);
    else
        Is_min_max = +1;
        L = length(Max_ABD_V) - 1;
        Loc_Max_ABD_2 = Loc_Max_ABD(Max_ABD_V);
        Loc_Max_ABD = sort(Loc_Max_ABD_2);
        Loc_Max_THO_2 = Loc_Max_THO(Max_THO_V);
        Loc_Max_THO = sort(Loc_Max_THO_2);
    end
end
%---- Step 5): Process Signals Segmentation
% Tab_ABD array is created, each row containing Abdomen segmented signals
for i=1:L 
    
    if Is_min_max == 1
        for j=Loc_Max_ABD(i):Loc_Max_ABD(i+1)
        
            Tab_ABD(i,round(j - Loc_Max_ABD(i),0)+1) = Array_ABD(round(j,0));
        end
        Tab_ABD(i,round(j - Loc_Max_ABD(i),0)+2:round(j - Loc_Max_ABD(i),0)+8)=zeros(1,7);
    else
        for j=Loc_Min_ABD(i):Loc_Min_ABD(i+1)
        
            Tab_ABD(i,round(j - Loc_Min_ABD(i),0)+1) = Array_ABD(round(j,0));
        end
        Tab_ABD(i,round(j - Loc_Min_ABD(i),0)+2:round(j - Loc_Min_ABD(i),0)+8)=zeros(1,7);
    end
end





% Tab_THO will contain Rib Chest segmented signals, using Abdomen Extrema
% detection

for i=1:L
    k = 1;
    
    if Is_min_max == 1
        for j=Loc_Max_ABD(i):Loc_Max_ABD(i+1)
        
            Tab_THO(i,round(j - Loc_Max_ABD(i),0)+1) = Array_THO(round(j,0));
        end
        Tab_THO(i,round(j - Loc_Max_ABD(i),0)+2:round(j - Loc_Max_ABD(i),0)+8)=zeros(1,7);
    else
        for j=Loc_Min_ABD(i):Loc_Min_ABD(i+1)
        
            Tab_THO(i,round(j - Loc_Min_ABD(i),0)+1) = Array_THO(round(j,0));
        end
        Tab_THO(i,round(j - Loc_Min_ABD(i),0)+2:round(j - Loc_Min_ABD(i),0)+8)=zeros(1,7);
    end

end

%---Step 6): Method 1 Display Konno Mead plot for each Abdomen cycles using
% Display_Sgnal_Cycle_Cycle

% Fist, compute automatically all the phase angle value for all the cycles segmented
for i=1:L
    k = 1;
    Temp_plot_ABD = [];
    Temp_plot_THO = [];
    

    %if Is_min_max == 1
        while (k < size(Tab_ABD,2)-6)&&(Tab_ABD(i,k)~=0 || Tab_ABD(i,k+1)~=0 || Tab_ABD(i,k+5)~=0)
            Temp_plot_ABD(k) = Tab_ABD(i,k);
            k = k + 1; 
        end
        k = 1;

%     else
%         while (k < size(Tab_ABD,2)-6)&&(Tab_ABD(i,k)~=0 || Tab_ABD(i,k+1)~=0 || Tab_ABD(i,k+5)~=0)
%             Temp_plot_ABD(k) = Tab_ABD(i,k);
%             k = k + 1; 
%         end
%         k = 1;
% 
%     end
    Temp_plot_THO = Tab_THO(i,:);
    val_min = min(length(Temp_plot_ABD),length(Temp_plot_THO));
    Temp_plot_ABD(1:val_min) = Temp_plot_ABD(1:val_min) - mean(Temp_plot_ABD(1:val_min));%Remove baseline
    Temp_plot_THO(1:val_min) = Temp_plot_THO(1:val_min) - mean(Temp_plot_THO(1:val_min));

    disp(['Résultat du cycle n°', num2str(i)])
    Mat_Tho(i) = Calcul_Angle_Geometrique(Temp_plot_ABD(1:val_min),Temp_plot_THO(1:val_min),i);
    Mat_Tho(i) = round(Mat_Tho(i),2);
    numCycle{i} = (['Cycle n° ',num2str(i)]);
end

%Then, use Display_signal_cycle_cycle so that the user will be able to
%check the results 
try
    [angle,Cycle_Remained,Mat_Err,Deleted_Cycle] = Display_signal_cycle_cycle(Tab_THO,Tab_ABD,Mat_Tho);
catch ME
   if strcmp(ME.identifier,'MATLAB:UndefinedFunction')
       warndlg(sprintf('File entitled "Display_signal_cycle_cycle" cannot be found in the folder \nMethod 1 cannot be used !\nHowever, you will be able to use Method 2'))
        Mat_Err = zeros(length(Tab_ABD),1);
        Deleted_Cycle = zeros(length(Tab_ABD),1);
        angle = Mat_Tho;
        Cycle_Remained = length(Tab_ABD)-1;
   end
end

%Calcul de la valeur de l'angle de phase moyen

disp('Méthode 1: calcul de l''angle de phase suivant la méthode géomètrique')
disp(['Moyenne sur les ',num2str(min(length(Max_THO),length(Min_THO)) - 1),' cycles'])
disp([num2str(round(mean(Mat_Tho),2)),'°'])

disp('Decision de l''utilisateur')
disp(['Angle moyen ',num2str(round(mean(angle),2)),' ° sur ',num2str(Cycle_Remained),' cycles'])
disp([num2str(sum(Mat_Err(:))), ' erreurs détectées sur ', num2str(length(Mat_Err)), ' cycles (supprimés ou conservés)'])
disp(['Nombre de cycles supprimés : ',num2str(length(Mat_Err) - Cycle_Remained)])


%Preparing datas 
if sum(Deleted_Cycle)>0
    disp('Numéro des cycles supprimés')
end
i_1 = 1;
    for i = 1:length(Deleted_Cycle)
        if Deleted_Cycle(i) == 1
            disp(['Cycle n° ', num2str(i)])
            Is_Deleted{i} = 'non';
            Value_angle(i) = Mat_Tho(i);
        else
            Is_Deleted{i} = 'oui';
            Value_angle(i) = round(angle(i_1),2);
            
            i_1 = i_1 + 1;
        end
    end
    
%Store results angles (if a cycle is deleted, the automatically computed
%value will be stored instead, otherwise it could be either the automatically computed value 
% or the hand computed value)
Table_Method1 = table(transpose(Value_angle),transpose(Is_Deleted),'RowNames',numCycle,'VariableNames',{'Angle','Pris_en_Compte'});
Table_Method1_1 = Create_Table(angle,Mat_Tho);

if length(Loc_Max_THO)~=length(Loc_Max_ABD) && length(Loc_Min_THO)~=length(Loc_Min_ABD)
    disp(Table_Method1_1)
    disp(Table_Method1)
    error(['Erreur : Impossible d''éxecuter la méthode 2 : le nombre de maxima détectés pour le Thorax et l''Abdomen sont différents, probablement du à une mauvaise détection des extrema, pour deux raisons possibles.',...
        char(10),'1) La valeur de préominance pour la détection des Extréma n''est pas adaptée',char(10),...
        '2) Un des Extréma n''a pu être détecté car trop proche ou non présent  dans l''ensemble des échantillons importé depuis Acqknowledge :',...
        ' Dans ce cas, veuillez importer une autre portion du tracé à analyser',char(10),...
        'Il n''est pas exclu qu''il peut s''agir d''un bug Matlab : dans ce cas, fermer et rouvrir Matlab'])

end

%---- Step 7): Method 2, assessing phase angle using cycle lenght, and
%relative position between Abdomen and Rib Chest extrema
Color_mat = [1,0,1;0,1,1;0,1,0;0,0,1;0,0,0]; % Matrix containing colors
fig4 = figure();

 Txt = findobj(gcf,'Type','text'); % delete existing text object on the new figure object
 if ~isempty(Txt)
     delete(Txt)
 end
Array_ABD = Array_ABD - mean(Array_ABD);
 plot(Array_ABD,'b-')
hold on
Array_THO = Array_THO - mean(Array_THO);
plot(Array_THO,'r--')

axis([0, length(Array_ABD),min(min(Array_ABD),min(Array_THO))*1.1,max(max(Array_THO),max(Array_ABD))*1.1])

% Choose axis 's borders
% Compute phase angle on each cycle thanks to  Extrema Detection previously
% applied on Rib Chest and Abdomen waveforms. Computing is different
% according to the number of max and min detected (ie Is_min_max value)

if Is_min_max == 1
for i=1:min(L,length(Deleted_Cycle) + 1)
    hold on
    line([Loc_Max_ABD(i),Loc_Max_ABD(i)],[max(max(Max_ABD),max(Max_THO)),-max(max(Max_ABD),max(Max_THO))],'Color','blue','LineStyle',':')
    line([Loc_Max_THO(i),Loc_Max_THO(i)],[max(max(Max_ABD),max(Max_THO)),-max(max(Max_ABD),max(Max_THO))],'Color','red','LineStyle',':')
    
    plot([Loc_Max_ABD(i),Loc_Max_THO(i)],[max(Max_THO(i),max(Max_ABD(i))),max(Max_THO(i),max(Max_ABD(i)))],'k')
    
    if i>1 
     %value = abs(Loc_Max_THO(i)-Loc_Max_ABD(i));
        Cycle_Length(i-1) = Loc_Max_ABD(i) - Loc_Max_ABD(i - 1);
        value(i-1) = (Loc_Max_THO(i)-Loc_Max_ABD(i))*360/Cycle_Length(i-1);
        value(i-1) = round(value(i-1),1);
        
        if abs(value(i-1))>360
            value(i-1) = sign(value(i-1))*mod(value(i-1),360);
        end
        if Deleted_Cycle(i-1) == 1
             text(0.5*abs(Loc_Max_ABD(i)-Loc_Max_ABD(i-1))+min(Loc_Max_ABD(i-1),Loc_Max_THO(i-1)),max(Max_THO(i),max(Max_ABD(i)))+0.15,[num2str(round(value(i-1),1)),'°'],...
                 'Color','red','BackgroundColor','y')
             hold on
             plot([Loc_Max_ABD(i-1),Loc_Max_ABD(i)],[0,0],'Color','red','LineWidth',3,'Marker','s',...
                 'MarkerEdgeColor','k')
        else
            text(0.5*abs(Loc_Max_THO(i)-Loc_Max_THO(i-1))+min(Loc_Max_ABD(i-1),Loc_Max_THO(i-1)),max(Max_THO(i),max(Max_ABD(i)))+0.15,[num2str(round(value(i-1),1)),'°'])
            Non_Deleted_Cycle(i-1) = round(value(i-1),1);
            hold on
            plot([Loc_Max_ABD(i-1),Loc_Max_ABD(i)],[0,0],'Color',Color_mat(1+mod(i,4),:),'LineWidth',3)
        end
        NumCycle2{i - 1} = (['Cycle n° ',num2str(i - 1)]);
    end
    
end
else
for i=1:min(L,length(Deleted_Cycle) + 1)
    hold on
    line([Loc_Min_ABD(i),Loc_Min_ABD(i)],[min(min(Min_ABD),min(Min_THO)),-min(min(Min_ABD),min(Min_THO))],'Color','blue','LineStyle',':')
    line([Loc_Min_THO(i),Loc_Min_THO(i)],[min(min(Min_ABD),min(Min_THO)),-min(min(Min_ABD),min(Min_THO))],'Color','red','LineStyle',':')
    
    plot([Loc_Min_ABD(i),Loc_Min_THO(i)],[min(min(Min_THO(i)),min(Min_ABD(i))),min(min(Min_THO(i)),min(Min_ABD(i)))],'k')
    
    
    if i>1 
     %value = abs(Loc_Max_THO(i)-Loc_Max_ABD(i));
        Cycle_Length(i-1) = Loc_Min_ABD(i) - Loc_Min_ABD(i - 1);
        value(i-1) = (Loc_Min_THO(i)-Loc_Min_ABD(i))*360/Cycle_Length(i-1);
        value(i-1) = round(value(i-1),1);
        
        if abs(value(i-1))>360
            value(i-1) = sign(value(i-1))*mod(value(i-1),360);
        end
%         if value(i-1)< -180
%             Value(i-1) = 360 + value(i-1);
%         end
        
        if Deleted_Cycle(i-1) == 1
             text(0.5*abs(Loc_Min_ABD(i)-Loc_Min_ABD(i-1))+min(Loc_Min_ABD(i-1),Loc_Min_THO(i-1)),min(Min_THO(i),min(Min_ABD(i)))+0.15,[num2str(round(value(i-1),1)),'°'],...
                 'Color','red','BackgroundColor','y')
             hold on
             plot([Loc_Min_ABD(i-1),Loc_Min_ABD(i)],[0,0],'Color','red','LineWidth',3,'Marker','s',...
                 'MarkerEdgeColor','k')
        else
            text(0.5*abs(Loc_Min_THO(i)-Loc_Min_THO(i-1))+min(Loc_Min_ABD(i-1),Loc_Min_THO(i-1)),min(Min_THO(i),min(Min_ABD(i)))+0.15,[num2str(round(value(i-1),1)),'°'])
            Non_Deleted_Cycle(i-1) = round(value(i-1),1);
            hold on
            plot([Loc_Min_ABD(i-1),Loc_Min_ABD(i)],[0,0],'Color',Color_mat(mod(i,4)+1,:),'LineWidth',3)
        end
        NumCycle2{i - 1} = (['Cycle n° ',num2str(i - 1)]);
    end
    
end
end

Title_Msg = create_title(value,Non_Deleted_Cycle);
title(Title_Msg)
xlabel('Nombre de points')
ylabel('Amplitude du signal')
grid on
legend('Signal Abdominal','Signal du Thorax','Pic de l''Abdomen','Pic du Thorax')


fig4.OuterPosition = get(0,'MonitorPositions');
fig4.Position = fig_Border;

 Disp = 1;
while Disp
    try
        warning('off','MATLAB:modes:mode:InvalidPropertySet')
        fig4.WindowButtonDownFcn = @funct1;
        [Out,All_Value,~] = funct1(fig4);
        fig4.WindowButtonUpFcn = '';
        warning('on','MATLAB:modes:mode:InvalidPropertySet')
    catch 
        %Disp = 0;
        Out = [];
        
    end
if ~isempty(Out)
    Highlighted_V = [];
    for i=1:size(Out,2)
        Out2 = Out{i};
        Highlighted_V(i) = str2num(Out2(1:end-1));
    end
else
    Highlighted_V = [];
end
Title_Msg = create_title(value,Highlighted_V);
title(gca,Title_Msg)

try
    
    waitforbuttonpress
catch 
    Disp = 0;
end
end

if isempty(Highlighted_V)
    All_Value = Is_Deleted;
    i_1 = 1;
    for i =1:length(Deleted_Cycle)
        if Deleted_Cycle(i) == 0
            Highlighted_V(i_1) = value(i);
            i_1 = i_1 + 1;
        end
    end
     
end
disp(Table_Method1_1)

%--- Step 8): generate a report for the user
%Report for the attention of the user
disp('Méthode 2 : calcul du déphasage à partir de la position des Extrema')
disp('Angle de phase (ensemble des cycles):')
disp([num2str(mean(value)),'°'])
disp('Angle de phase en valeur absolue (ensemble des cycles):')
disp([num2str(mean(abs(value))),' °'])
fprintf(['\n Angle de phase (cycles non séléctionnés) : %f °\nAngle de phase',...
    ' (cycles séléctionnés : %f °\n'],mean(Highlighted_V),mean(abs(Highlighted_V)))
disp(Create_Table(Highlighted_V,value))
Table_Method2 = table(transpose(value),transpose(All_Value),'RowNames',NumCycle2,'VariableNames',{'Angle','Pris_en_compte'});


%Show Table results, containing phase angle for each cycles detected, and
%if the cycle is deleted or not
disp('Résultats Méthode 1: Calcul du déphasage à partir de la méthode de Konno Mead')
disp(Table_Method1)
disp('Résultats Méthode 2 : calcul du déphasage à partir de la position des Extrema')
disp(Table_Method2)

%% ------- Functions library
%1) : Calcul_Angle_Geometrique function
%2) : Create_Table function
%3) : Create title
%4) : funct1
%5) : Manual_Method_Mouse
%6) : Manual_Method_Seg
%7) : Manual_Method_Mouse_2
%8) : Manual_Method_Seg
%9) : CheckUserSelection
function Th = Calcul_Angle_Geometrique(sabd,stho,num)



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

%Extraction des coordonnées de PtDroit (ou Pt gauche, en fonction du sens
%de rotation de la conique)
while Correction_Needed_Right == 1 && Interval_Right<2 
    while abs(Liss(i1,2)-MiddleRC)>Interval_Right && i1<=length(Liss)-1
    
        i1=i1+1;
    
    end
    
    if i1>=length(Liss)
        Interval_Right = Interval_Right + 0.01;
        i1 = ceil(length(Liss)/2);
    else
        Correction_Needed_Right = 0;
    end
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
 
    if i2==1 && i2 - 3 <= length(Liss) %&& i1 + 3 <= length(Liss)
        i2=i1+3;
        while (i2<=length(Liss)-1)&&(abs(Liss(i2,2)-MiddleRC)>Interval_Left) 
            i2=i2+1;
        end
    end
 % A rajouter pour augmenter la robustesse de l'algorithme   
%     if i2 < length(Liss)-5 && (abs(i1 - 12)<10 || abs(Liss(i2,2) - Liss(i1,2))< 0.1)
%         i3= i2 + 1;
%                 while (abs(Liss(i3,2)-MiddleRC)>Interval_Left)&& i3>1
%                     i3=i3-1;
%                 end
%  
%                 if i3==1 && i3 - 3 <= length(Liss) %&& i1 + 3 <= length(Liss)
%                     i3=i1+3;
%                     while (i3<=length(Liss)-1)&&(abs(Liss(i3,2)-MiddleRC)>Interval_Left) 
%                         i3=i3+1;
%                     end
%                 end
%                 if i3 < length(Liss) && i3~=i2 && abs(Liss(i3,1)-Liss(i2,1))<abs(Liss(i1,1) - Liss(i2,1))
%                     i2 = i3;
%                 end
%     end


    if i2 >= length(Liss)
    
        Interval_Left = Interval_Left + 0.01;
        i2 = floor(length(Liss)/2);

        
    else
        Correction_Needed_Left = 0;

    end
end

if abs(Liss(i2,2)-Liss(i1,2))<0.1 && (abs(abs(Liss(1,2)-MiddleRC)-(abs(Liss(i2,2)-MiddleRC)))<.1 || abs(abs(Liss(end,2)-MiddleRC)-abs(Liss(i2,2)-MiddleRC))<.1)
    if abs(Liss(1,2)-MiddleRC)>abs(Liss(end,2)-MiddleRC)
        i2 = length(Liss);
    else
        i2 = 1;
    end
    
end
PtGauche=([Liss(i2,1),Liss(i2,2)]);


%Calcul de la valeur de m

m=(abs(Liss(i2,1)-Liss(i1,1)));
disp('Valeur de m (en V)')
disp(m)


%Calcul de la valeur de s

s=(abs(LissMax(1)-LissMin(1)));
sPt=([LissMin(1),LissMax(1);min(LissMax(1),LissMax(2)),min(LissMax(1),LissMax(2))]);

disp('Valeur de s :')
disp(s)
%Calcul de l'angle de phase

if stho(IndexMax(1))-stho(IndexMin(1))<0
    Th=pi+asin(-m/s);
else
    Th=asin(m/s);
end
Th=Th*180/pi; %Convertir l'angle de rad->°
disp('Valeur de l''angle de phase Tho (en °) :')
%disp(Th)
fprintf('%.5f \n',round(Th,5))

end

function Table_Method = Create_Table(V_User,V_Auto)
if isempty(V_User)
    V_User = 0;
end
Mean_Method = [round(mean(V_User),2);round(mean(V_Auto),2)];
SD_Method = [round(std(V_User),2);round(std(V_Auto),2)];
Mediane_Method = [round(median(V_User),2);round(median(V_Auto),2)];
Max_Method = [max(V_User);max(V_Auto)];
Min_Method = [min(V_User);min(V_Auto)];
Q0_25 = [quantile(V_User,.25);quantile(V_Auto,.25)];
Q0_75 = [quantile(V_User,.75);quantile(V_Auto,.75)];
IQR_Method = [round(iqr(V_User),2);round(iqr(V_Auto),2)];
Table_Method = table(Mean_Method,SD_Method,Mediane_Method,Min_Method,Max_Method,Q0_25,...
    Q0_75,IQR_Method,'RowNames',{'Valeurs utilisateur';'Valeurs calculées automatiquement'},...
    'VariableNames',{'Moyenne','SD','Mediane','MinValue','MaxValue','First_Quartile','Last_Quartile',...
    'IntervalleInterquartile'});
end

function Title_Msg = create_title(value,Highlighted_V)
%Display a title depending on "value" and "highlighted_V" content. to be used with fig4 
if ~isempty(value)&&~isempty(Highlighted_V)
    Title_Msg = ['Signal électrique de l''Abdomen (Bleu) et du Thorax (Rouge)',char(10),...
        'Angle de phase : ', num2str(round(mean(value),2)),'°       (moyenne des valeurs n''apparaissant pas sous fond jaune) :',...
        num2str(round(mean(Highlighted_V),2)),'°', char(10),...
        'Angle de phase (absolu) : ', num2str(round(mean(abs(value)),2)),'° (moyenne des valeurs n''apparaissant pas sous fond jaune_absolue) :',...
        num2str(round(mean(abs(Highlighted_V)),2)),'°'];
else
    if isempty(Highlighted_V)
        if isempty(value)
        Title_Msg = ['Signal électrique de l''Abdomen (Bleu) et du Thorax (Rouge)',char(10),...
            'Angle de phase : 0°   (moyenne des valeurs n''apparaissant pas sous fond jaune) :',...
            '0°', char(10),...
            'Angle de phase (absolu) : 0° (moyenne des valeurs n''apparaissant pas sous fond jaune_ absolue) : 0°'];  
        else
        Title_Msg = ['Signal électrique de l''Abdomen (Bleu) et du Thorax (Rouge)',char(10),...
            'Angle de phase : ', num2str(round(mean(value),2)),'°   (moyenne des valeurs n''apparaissant pas sous fond jaune) : 0°',...
             char(10),...
            'Angle de phase (absolu) : ', num2str(round(mean(abs(value)),2)),'° (moyenne des valeurs n''apparaissant pas sous fond jaune_ absolue) : 0°'];
        end
    end
end
end

function [Selected_Value,All_Value,Non_Selected_Value] = funct1(varargin)
%While the figure is displayed, a right click will select angles values, and a
%left click unselect a previously selected values
src = varargin{1};
seltype = src.SelectionType;

 src.Units = 'characters';
 ax = gca;
 ax.Units = 'characters';
 Loc = ax.CurrentPoint;
 Txt = findobj('Type','text');
 L = size(Txt,1);
 XBorder = ax.XLim;
 M = XBorder(2)/L * 0.4;
 
if strcmp(seltype,'normal')

 for i=1:size(Txt,1)
     Txt1 = Txt(i);
     
     
     Pos = Txt1.Position;
  
     if ((Loc(1,1)>=(Pos(1) - M)) && (Loc(1,1)<=(Pos(1) + M*1.5)) && (Loc(1,2)<=(Pos(2)*1.1)) && (Loc(1,2)>= (Pos(2)*0.9)))
         Txt1.BackgroundColor = 'y';
     end
 end
 
elseif  strcmp(seltype,'alt')
    
    for i=1:size(Txt,1)
     Txt1 = Txt(i);
     
     
     Pos = Txt1.Position;

     if ((Loc(1,1)>=(Pos(1) - M)) && (Loc(1,1)<=(Pos(1) + M*1.5)) && (Loc(1,2)<=(Pos(2)*1.1)) && (Loc(1,2)>= (Pos(2)*0.9)))
         Txt1.BackgroundColor = 'none';
     end
    end
end
Selected_String = findobj(gcf,'Type','text','BackgroundColor','none');
Selected_Value = [];
for i=1:length(Selected_String)
    Selected_String_1 = Selected_String(i);
    Selected_Value{i} = Selected_String_1.String;
    
end
Non_Selected_String = findobj(gcf,'Type','text','BackgroundColor','y');
Non_Selected_Value = [];
for i=1:length(Non_Selected_String)
    Non_Selected_String_1 = Non_Selected_String(i);
    Non_Selected_Value{i} = Non_Selected_String_1.String;
end
Txt3 = findobj(gcf,'Type','text');
for i =1:size(Txt3,1)
    Txt_1 = Txt3(i);

    Back_Color = Txt_1.BackgroundColor;
    if ~strcmp(Back_Color,'none')
        All_Value{size(Txt3,1) + 1 - i} = 'non compté (sur fond jaune)';
    else
        All_Value{size(Txt3,1) + 1  - i} = 'compté';
        
    end
end

end

function Max_ABD_V = Manual_Method_Mouse(fig2_ABD)
             Disp_fig2 = 1;
            while Disp_fig2
                try
                    warning('off','MATLAB:modes:mode:InvalidPropertySet')
                    fig2_ABD.WindowButtonDownFcn = @funct1;
                    [~,~,Max_ABD_MM] = funct1(fig2_ABD);
                    fig2_ABD.WindowButtonUpFcn = '';
                    warning('on','MATLAB:modes:mode:InvalidPropertySet')

                catch
                %Disp = 0;
                   Max_ABD_MM = [];
        
                end  
                if ~isempty(Max_ABD_MM)
                    Max_ABD_V = [];
                    for i=1:size(Max_ABD_MM,2)
                        Max_ABD_MM_2 = Max_ABD_MM{i};
                        Max_ABD_V(i) = str2num(Max_ABD_MM_2(6:end));
                    end
                else
                    Max_ABD_V = [];
                end
                
                title(gca,['Manual Method : Please right click on peaks you want to be no detected',...
                    char(10),'Left click on peaks to cancel',char(10),...
                    'Abdomen Waveform',char(10),'Number of Extrema Selected : ',...
                    num2str(length(Max_ABD_V))])

                try
    
                    waitforbuttonpress
                catch 
                Disp_fig2 = 0;
                end
            end
end

function Max_THO_V = Manual_Method_Mouse_2(fig2_THO,Max_ABD_V)
Disp_fig2 = 1;
            while Disp_fig2
                try
                    warning('off','MATLAB:modes:mode:InvalidPropertySet')
                    fig2_THO.WindowButtonDownFcn = @funct1;
                    [~,~,Max_THO_MM] = funct1(fig2_THO);
                    fig2_THO.WindowButtonUpFcn = '';
                    warning('on','MATLAB:modes:mode:InvalidPropertySet')

                catch
                %Disp = 0;
                   Max_THO_MM = [];
        
                end  
                if ~isempty(Max_THO_MM)
                    Max_THO_V = [];
                    for i=1:size(Max_THO_MM,2)
                        Max_THO_MM_2 = Max_THO_MM{i};
                        Max_THO_V(i) = str2num(Max_THO_MM_2(6:end));
                    end
                else
                    Max_THO_V = [];
                end
                
                title(gca,['Manual Method : Please right click on peaks you want to be no detected',...
                    char(10),'Left click on peaks to cancel',char(10),...
                    'Rib Chest Waveform', char(10),...
                    'Number of Extrema Selected ',num2str(length(Max_THO_V)),...
                    char(10),'Number of Extrema Selcted on Abdomen Signal : ',num2str(length(Max_ABD_V))])

                try
    
                    waitforbuttonpress
                catch 
                Disp_fig2 = 0;
                end
            end
end

function fig2_ABD = Manual_Method_Seg(Loc_Max_ABD,Array_ABD,Loc_Max_THO,Array_THO,Interv,fig_Border)
fig2_ABD = figure();
fig2_ABD.OuterPosition = get(0,'MonitorPositions');
fig2_ABD.Position = fig_Border;
ax = gca;
AxesPosition = ax.Position;
AxesPosition(3) = AxesPosition(3)*1.1;
AxesPosition(1) = AxesPosition(1)*.5;
ax.Position = AxesPosition; 

plot(Array_ABD,'red')
hold on
plot(Interv,Array_ABD(Interv),'m')
ax.XLim = [1,length(Array_ABD)];
ax.YLim = [min(min(Array_ABD),min(Array_THO)),max(max(Array_THO),max(Array_ABD))];
    

for k1 = 1:length(Loc_Max_ABD)
	text(Loc_Max_ABD(k1),Array_ABD(Loc_Max_ABD(k1)),['Pic :',num2str(k1)],'BackgroundColor','y')
end
hold on
plot(Array_THO,'c')
hold on
plot(Interv,Array_THO(Interv),'b')
hold on
plot(Loc_Max_THO,Array_THO(Loc_Max_THO),'Marker','v','Color','k',...
    'MarkerFaceColor','y','LineStyle','none')
xlabel('Nombre de points')
ylabel('Amplitude')
grid on
hold off

end

function [outpt,Manual_Method_Used] = CheckUserSelection(Max_ABD_V,Max_THO_V)

if length(Max_ABD_V) < length(Max_THO_V)
    Rep_msgbox = questdlg({['Warning ! The number of Maxima (or Minima) detected on the Rib Chest waveform is ',...
            'Higher than the number of Maxima on the Abdomen waveform'];...
            'Pressing "no" will allow you to use the first method (Konno-Mead Method) only';...
            'Go back to the last window ?'},'Error detected when using manual method',...
            'Ok','No','Ok');
        
elseif length(Max_ABD_V) > length(Max_THO_V)
    Rep_msgbox = questdlg({['Warning ! The number of Maxima (or Minima) detected on the Rib Chest waveform is ',...
            'samller than the number of Maxima on the Abdomen waveform'];...
            'Pressing "no" will allow you to use the first method (Konno-Mead Method) only';...
            'Go back to the last window ?'},'Error detected when using manual method',...
            'Ok','No','Ok');
else
    Rep_msgbox = 'No';
    h_msgbox = msgbox(['Manual Method successful ! The number of Maxima (or Minima) detected',...
        'on both signals are stricly equals',char(10), 'Press "ok" to continue']);
    waitfor(h_msgbox);
end

if Rep_msgbox == 'Ok'
    outpt = 2;
    Manual_Method_Used = 0;
else
    outpt = 0;
    Manual_Method_Used = 1;
end
end