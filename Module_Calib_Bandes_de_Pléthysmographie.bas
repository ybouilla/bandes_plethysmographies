Attribute VB_Name = "Module1"

Public Type Output
    OutMatMin() As Single
    OutMatMax() As Single
    Bool As Boolean
    End Type
    
Sub Display_Instruction()
'A utiliser pour rappeller � l'utilisateur comment utiliser l'ensemble des macros

Call MsgBox("Voici quelques instructions et recommandations pour se servir des macros :" & vbNewLine & _
"Les Macros sont des algorithmes que l'on peut implanter dans Microsoft Excel. Ont �t� d�velopp� dans le cas du traitement des donn�es relatives aux bandes de pl�thysmographies 4 Macro, dont 3 principales" _
& vbNewLine & "Il s'agit de :" & vbNewLine & "MainCalib( ),MainCalib2( ) et Main2( ), ainsi que Detect_Advanced( )." & vbNewLine & _
"La macro MainCalib( ) permet de calculer les extrema des trois signaux_ Les tensions �lectriques du Thorax et de l'abdomen et les signaux du volume." _
& vbNewLine & "MainCalib2( ) permet le calcul de la RLM et Main2( ) permet de calculer directement le volume courant pr�dit" & vbNewLine & "Les macros doivent s'utiliser dans l'ordre suivant:" & vbNewLine & " (1)MainCalib( )-> (2)[MainCalib2( ) ou Main2( )]" _
& vbNewLine & vbNewLine & "Les diff�rents type de donn�es accessibles: " & vbNewLine & "-> Dans le cas d'une calibration; il est n�cessaire d'avoir les donn�es du temps, les voltages �lectriques du Thorax et de l'Abdomen et de Volume" _
& vbNewLine & "-> Autrement, seules les donn�es de temps et de volatge (Thorax et Abdomen) sont accessibles" _
& vbNewLine, vbOKOnly, "Instruction Message 1/9 : introduction")
'"Pr�paration des donn�es:"

Call MsgBox("Les Macros ont �t� �tudi�es pour traiter les signaux directement depuis AcqKnowledge" & vbNewLine & vbNewLine & "Pr�paration des donn�es:" & vbNewLine & "Les donn�es issues d'Acqknowledge doivent �tre pr�sent�es selon cet ordre :" & vbNewLine & _
"_ Colonne A : Temps" & vbNewLine & "_ Colonne B: Tension Thorax (Indispensable)" & vbNewLine & "_ Colonne C : Tension Abdomen (Indispensble)" & vbNewLine & _
"_ Colonne D : signaux du volume (si disponible)" & vbNewLine & "Il est tr�s important que les signaux repectent cet ordre" & vbNewLine & "les donn�es peuvent �tre directement copi�es-coll�es � partir d'un fichier Excel cr�� au moyen d'AcqKnowledge" _
& vbNewLine & "Il peut �tre n�cessaire de retirer la deuxi�me ligne contenant les unit�s sur le Fichier d'Excel import� d'AcqKnowledge", vbOKOnly, "Instruction Message 2/9 : Pr�paration des donn�es")

Call MsgBox("Aussi, il est important de v�rifier ces aspects : " & vbNewLine & "_ Les seules colonnes devant �re remplies sont les 4 premi�res: A, B, C et D. Rien ne doit �tre ajout� dans ces colonnes" & vbNewLine & _
"_ Le seul fichier Excel devant �tre ouvert est celui contenant les 4 colonnes correspondant au param�tre temporel ou aux signaux" & vbNewLine & _
"_ La feuille Excel (Sheet) devant �tre affich�e � l'�cran est la feuille (1) 'Feuil1'" & vbNewLine & "_Aucune feuille ne doit �tre incorpor�e avant la feuille(1) 'Feuill1'" _
& vbNewLine & "_ La feuille 'Feuil2' doit rester vierge" & vbNewLine & "_ Le premier cycle du signal de volume doit correspondre � une inspiration", vbOKOnly, "Instruction Message 3/9 : Pr�paration des donn�es (2)")

Call MsgBox("       Calibration:" & vbNewLine & vbNewLine & "La Macro mainCalib( ) doit �tre ex�cut�e dans un premier temps :" & vbNewLine & "Elle consiste � d�tecter les Extrema sur l'ensemble des cycles pr�sents sur le Volume. Chaques Maxima et Minima des 3 signaux sont ensuites renseign�s dans les colonnes suivantes:" & vbNewLine & _
"- Colonne E : y est indiqu� le nombre d'�chantillions total (nombres de colonnes)," & vbNewLine & "- Colonnes F & G : Max et Min du Thorax" & vbNewLine & "- Colonnes I & J : Max et Min de l'abdomen" & vbNewLine & _
"- Colonnes L & M : Max et Min du volume" & vbNewLine & _
 "La pr�sence de bruits lors de l'enregistrement ou suite � l'�chantillionnage peuvent se traduire par des oscillations pouvant conduire � une mauvaise d�tection des extrema." _
& vbNewLine & "Un algorithme de d�tection plus pouss� permet de d�tecter les Extrema trop pr�s les uns des autres" & vbNewLine & "Les valeurs des Extrema correspondant � du bruit sont surlign�es en rouge. L'algorithme se charge ensuite de corriger ces valeurs." _
, vbOKOnly, "Instuction Message 4/9 (Calibration)")

Call MsgBox("       Calibration (suite):" & vbNewLine & vbNewLine & "Un autre algorithme incorpor� dans la Macro d�tecte les Maxima � valeurs n�gatives, en les surlignant en bleu : un Maxima � valeur n�gative � de forte chance d'�tre li� � un probl�me de d�tection" _
& vbNewLine & "En outre; les graphiques repr�sentant les variations des tensions �lectriques et volumes sont affich�s et les Extrema d�tect�s" & vbNewLine & _
"Outre les algorithmes de correction de d�tection, des probl�me de d�tection des Extrema peuvent persister." & vbNewLine & "L'utilisateur � alors la possibilit� de :" & vbNewLine & _
"1) Corriger lui m�me les d�fauts de d�tections des Extrema" & vbNewLine & "2) Utiliser la Macro de d�tection d'Extrema avanc�e DetectAdvanced( )." & vbNewLine & _
"La Macro de d�tection avanc�e va vous demander de choisir un intervalle de d�tection plus grand (exprim� en nombre de points) pour affiner la d�tection d'Extrema." _
& " L'algorithme est efficace si la fr�quence de respiration du signal analys� est suffisamment r�guli�re.", vbOKOnly, "Instruction Message 5/9 (Calibration)")

Call MsgBox("       Calibration (suite):" & vbNewLine & vbNewLine & "Fonctionnement de la Macro Detect_Advanced( ):" & vbNewLine & "L'algorithme demande tout d'abord � l'utilisateur une p�riode (en nombre de points) n�cessaire, la valeur id�ale correspond � la distance " _
& "minimale entre deux Maxima ou Minima. Apr�s s�lection de la valeur, l'algorithme r�alise une d�tection tr�s basique, puis r�-it�re en retirant les Extrema qui se suivent de trop pr�s." & vbNewLine & "Dans certains cas, si l'enregistrement est trop chaotique, vous serez oblig� de retirer vous m�me les valeurs." & vbNewLine & vbNewLine & _
vbNewLine & "       Calcul des inspirations:" & vbNewLine & "Une fois la d�tection des Extrema vous para�t satisfaisante, vous pouvez utiliser les Macro suivantes" & vbNewLine & "-> mainCalib2( ) si les signaux du Thorax, Abdomen et Volume sont disponibles" & vbNewLine & _
 "Attention � ne pas choisir un trop grand interval, au risque que l'algorithme ne parvienne pas � d�tecter les Extrema r�els" & vbNewLine & vbNewLine & "-> Main2( ) si seules les donn�es du Thorax et Abdomen sont disponibles", vbOKOnly, "Instruction Message 6/9 (Calibration)")
 
Call MsgBox("       Calibration (suite):" & vbNewLine & "Dans le cas d'une calibration, il convient d'utiliser ensuite la Macro mainCalib2( ). La Macro vous propose deux m�thodes :" & vbNewLine & _
"1) Une premi�re m�thode consiste � calculer soit m�me les amplitudes," & vbNewLine & "2) Une seconde un outil de calcul automatique des amplitudes que l'on utilise en s�lectionant soi-m�me les valeurs des Extrema" & vbNewLine & "La deuxi�me m�thode n�cessite de s�lectionner uniquement les Maxima et Minima correspondant chacun � un cycle respiratoire" & vbNewLine & _
"_ _ _ _ _ _ _ _ _ _ _" & vbNewLine & "| [Max 1] [Min 1] |" & vbNewLine & "| [Max 2] [Min 2] |" & vbNewLine & "|         ...                 |" & vbNewLine & "| [Max n] [Min n]|" & vbNewLine & " - - - - - - - - - - - " & vbNewLine & "Repr�sentation sch�matique de la zone � s�lectionner (apparaissant en tirets), c'est-�-dire des Minima et Maxima sur n cycles." _
& " La s�lection se fait en glissant la souris sur une plage de valeurs: La s�lection doit strictement couvrir 2 colonnes: la colonne des maxima et celles des minima.", vbOKOnly, "Instruction Message 7/9 (Calibration)")

Call MsgBox("      Calibration (suite):" & vbNewLine & "Apr�s calcul des amplitudes, la Macro mainCalib2() demande si vous souhaitez r�aliser la regression lin�aire multiple sur les valeurs des amplitudes du Thorax et de l'abdomen et sur le volume courant inspir�." & vbNewLine & _
"R�aliser une R�gression Lin�aire Multiple (RLM) consiste � d�terminer les coefficients a et b v�rifiant l'�quation :" & vbNewLine & "              Vt = a x Tabd + b x Ttho + Cste" & vbNewLine & _
"Ces coefficients permettent ainsi le calcul du volume pr�dit calcul� alors en colonne S." & vbNewLine & " Et Ttho : Amplitude du Thorax, Tabd : Amplitude de l'Abdomen" & vbNewLine & "Les coefficients apparaissent dans les cases suivantes:" & vbNewLine & "_ a en U4" _
& vbNewLine & "_ b en U5" & vbNewLine & "_ Cste en U6" & vbNewLine & "Sont affich�s �galement le coefficient R�, le degr� de libert� et l'erreur entre la moyenne des volumes courants mesur�s et des volumes courants pr�dits." _
, vbOKOnly, "Instruction Message 8/9 (Calibration)")

Call MsgBox("       Calibration (suite):" & vbNewLine & "Si les coefficients ont d�j� �t� calcul�s, vous pouvez les s�l�ctionner vous m�me afin de calculer le volume pr�dit et calculer l'erreur." _
& "Pour ce faire, il faut que les valeurs soient enregistr�es sur le fichier Excel utilis�. S�lectionner les valeurs en cliquant sur leurs cases respectives." & vbNewLine & vbNewLine & "Calcul du volume pr�dit � partir des donn�es du thorax et de l'abdomen seulement" _
& vbNewLine & vbNewLine & "Apr�s avoir calcul� les valeurs des Extrema du Thorax et de l'Abdomen, utilisez la Macro Main2( ). De m�me que pour la Macro mainCalib2( ), Main2( ) vous propose de calculer " _
& " ou bien vous m�me les valeurs des Extrema ou bien de fa�on automatique." & vbNewLine & "Ensuite s�lectionner les valeurs des coefficients a,b et Cste (que vous auriez pr�c�demment rentr� dans la feuille Excel)." _
& "Atention de ne pas les mettre dans les colonnes A,B,C,D nottamment. Il est recommand� de les mettre en colonne T et au del� � partir de la 10� ligne" & vbNewLine & "Les valeurs du volume courant pr�dit s'affichent en colonne P.", vbOKOnly, "Instruction Message 9/9 Use of Main2( )")


End Sub






    



Sub mainCalib2()
'Calcul les amplitudes des signaux �lectriques ou du volume
'(N�cessite d'avoir utiliser mainCalib() au pr�alabe)
'D�claration des variables
Dim Rep As Integer, Rep2 As Integer, T As Integer, T1 As Integer, T2 As Integer, i As Integer
Dim rng As Range, rngAbd As Range, rngVol As Range, rngVolPredit As Range
Dim Coeff_Abd As Single, Coeff_Tho As Single, Cste As Single
Dim SortieWhile As Boolean

SortieWhile = True

Rep = MsgBox("Avez vous calcul� les amplitudes vous m�me ou voulez vous le faire automatiquement?" & vbNewLine & _
"Colonne O: amplitudes du Thorax, Colonne P: amplitudes de l'abdomen, Colonne R: amplitudes du volume" & vbNewLine & "Oui: D�j� fait  Non: calcul automatique", vbDefaultButton2 + vbQuestion + vbYesNoCancel)
If Rep = 7 Then

    'For i = 0 To 2

        'T1 = WorksheetFunction.CountA(Worksheets(1).Columns(7 + 3 * i))
        'T2 = WorksheetFunction.CountA(Worksheets(1).Columns(8))
        'T = Application.Max(T1, T2)
        'Range(Cells(1, 15 + i * 2), Cells(T + 1, 15 + i * 2)).ClearContents
    'Next i
    Columns(15).ClearContents
    Columns(16).ClearContents
    Columns(18).ClearContents
    
    
    'Amplitudes du Thorax
    Call Calcul_Inspiration(15, "Thorax")
    
    If DetectEmptyCells(15) Then
        
        Call MsgBox("Aucune valeur n'a pu �tre s�lectionn�e" & vbNewLine & "Assurez-vous que vous avez bien vous m�me d�pos� dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne O vide!")
        Exit Sub
    End If
   
    'Amplitude de l'abdomen
    Call Calcul_Inspiration(16, "Abdomen")
    
    If DetectEmptyCells(16) Then
        
        Call MsgBox("Aucune valeur n'a pu �tre s�lectionn�e" & vbNewLine & "Assurez-vous que vous avez bien vous m�me d�pos� dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne P vide!")
        Exit Sub
    End If
    
    'Amplitude du volume
    If DetectEmptyCells(12) Or DetectEmptyCells(13) Then
        
            Rep2 = MsgBox("Pas de donn�es d�tect�es en colonne L et M (Max et Min du Volume)" & vbNewLine & "Assurez-vous que vous avez bien vous m�me d�pos� dans la colonne vos propres valeurs" & vbNewLine & "A moins que vous n'ayez aucune donn�es de volume" & vbNewLine & "'Ok': Continuer sans les donn�es du volume     'Annuler': mettre fin � la macro", vbExclamation + vbOKCancel, "Colonne L et M vides!")
            
            If Rep2 = 2 Then
            
                Exit Sub
            
            Else
                Call Main2
                Exit Sub
                
            End If
    End If
    Call Calcul_Inspiration(18, "Volume")

    ElseIf Rep = 2 Then
    
        Exit Sub
        
        Else
        'V�rification de la pr�sence de donn�es dans la colonne O
        If DetectEmptyCells(15) Then
        
            Call MsgBox("Pas de donn�es d�tect�es en colonne O (Thorax)" & vbNewLine & "Assurez-vous que vous avez bien vous m�me d�pos� dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne O vide!")
            Exit Sub
        End If
        'V�rification de la pr�sence de donn�es dans la colonne P
        If DetectEmptyCells(16) Then
        
            Call MsgBox("Pas de donn�es d�tect�es en colonne P (Thorax)" & vbNewLine & "Assurez-vous que vous avez bien vous m�me d�pos� dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne P vide!")
            Exit Sub
        End If
        'V�rification de la pr�sence de donn�es dans la colonne R
        If DetectEmptyCells(18) Then
        
            Call MsgBox("Pas de donn�es d�tect�es en colonne R (Volume)" & vbNewLine & "Assurez-vous que vous avez bien vous m�me d�pos� dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne R vide!")
            Exit Sub
        End If
        
End If
    
If ((Cells(1, 15).End(xlDown).Row - Cells(1, 16).End(xlDown).Row) <> 0 Or (Cells(1, 15).End(xlDown).Row - Cells(1, 18).End(xlDown).Row) <> 0) Then
Call MsgBox("ATTENTION: une ou plusieurs des colonnes contenant les valeurs des amplitude(s) n'a (ont) pas la m�me taille!" & vbNewLine & "Assurez-vous que les colonnes des �l�ments Amplitude Thorax, Amplitude Abdomen et Amplitude Volume soient de la m�me longueur", vbOKOnly + vbExclamation, "Longueur des Param�tres non respect�s")
Exit Sub
End If


Rep = MsgBox("Voluez-vous r�aliser la r�gression lin�aire Multipe sur les donn�es calcul�es?" & vbNewLine & "(Pour la Calibration)" & vbNewLine & "Appuyer sur 'ANNULER' si les coefficients sont d�j� calcul�s", vbOKCancel + vbDefaultButton2, "R�aliser la regression lin�aire?")


'V�rification du Bon nombre d'�l�ments avant de r�aliser une RLM



Set rngVol = Range(Cells(2, 18), Cells(2, 18).End(xlDown))

If Rep = 1 Then
    Set rng = Application.Union(Range(Cells(2, 15), Cells(2, 15).End(xlDown)), Range(Cells(2, 16), Cells(2, 16).End(xlDown)))
    
    '= Range(Cells(1, 17).End(xlDown).Row)
    
    'Dsplay Linear Regression Results
    RegLin = Application.LinEst(rngVol, rng, True, True)
    Range("T1") = "R�sultats de la R�gression Lin�aire"
    Range("T2") = "Mod�le de l'�quation: "
    Range("T3") = "Volume= Coeff.Tho x AmplitudeThorax + Coeff.Abd x Amplitude Abdomen + Cste"
    Range("T4") = "Coeff.Tho"
    Range("U4") = RegLin(1, 2)
    Coeff_Tho = RegLin(1, 2)
    Range("T5") = "Coeff.Abd"
    Range("U5") = RegLin(1, 1)
    Coeff_Abd = RegLin(1, 1)
    Range("T6") = "Cste"
    Range("U6") = RegLin(1, 3)
    Cste = RegLin(1, 3)
    Range("T7") = "R�"
    Range("U7") = RegLin(3, 1)
    Range("T8") = "Degr�s de libert�"
    Range("U8") = RegLin(4, 2)
    'Range("T10:W20") = RegLin
    
    Else
    
    Coeff_Tho = Select_Coeff("Rentrer le coefficient pour la r�gression lin�aire � appliquer aux amplitudes du signal �lectrique du Thorax", "Coeff_Tho")
    If Coeff_Tho = NaN Then
        Exit Sub
    End If
    Coeff_Abd = Select_Coeff("Rentrer le coefficient pour la r�gression lin�aire � appliquer aux amplitudes du signal �lectrique de l'Abdomen", "Coeff_Abd")
    If Coeff_Abd = NaN Then
        Exit Sub
    End If
    Cste = Select_Coeff("Rentrer la valeur de la constante", "Cste")
    
    If Cste = NaN Then
        Exit Sub
    End If
    
   
End If
'Estimation du volume pr�dit

For i = 2 To Cells(1, 15).End(xlDown).Row
    Cells(i, 19).Value = Round(Cells(i, 15).Value, 4) * Round(Coeff_Tho, 1) + Round(Cells(i, 16).Value, 4) * Round(Coeff_Abd, 1) + Cste
Next i
Range("S1") = "Volume Pr�dit"

Set rngVolPredit = Range(Cells(2, 19), Cells(2, 19).End(xlDown))

'Estimation de l'erreur
Call Assess_Error(rngVol, rngVolPredit)

End Sub
Sub Assess_Error(rngVol As Range, rngVolPredit As Range)

'Estimation de l'erreur

'1) Calcul de la moyenne des Volume Courants mesur�s
Cells(Cells(1, 18).End(xlDown).Row + 2, 18) = "Moyenne"
Cells(Cells(1, 18).End(xlDown).Row + 3, 18) = Application.Average(rngVol)

'2) Calcul de la moyenne des volumes courants pr�dits


Cells(Cells(1, 19).End(xlDown).Row + 2, 19) = "Moyenne"
Cells(Cells(1, 19).End(xlDown).Row + 3, 19) = Application.Average(rngVolPredit)

'3)Calcul de l'erreur

Range("T11") = "Erreur Moyenne"
Range("T12") = "sur les volumes courants"
Range("U11").NumberFormat = "0.00%"
Range("U11") = Abs(Application.Average(rngVolPredit) - Application.Average(rngVol)) / Application.Average(rngVol)

End Sub
Function Select_Coeff(Msg As String, Msg2 As String) As Single
Dim SortieWhile As Boolean

SortieWhile = True

While SortieWhile
        'Boite de dialogue demandant les coefficents � rentrer pour effectuer la regression lin�aire
            Coeff = Application.InputBox(Msg & vbNewLine & "(" & Msg2 & ")", Msg2, Type:=8)
        
            'Range("U10") = Coeff
    
            'Range("U11") = VarType(Coeff)
            If VarType(Coeff) <> 5 And VarType(Coeff) <> 11 Then
                Call MsgBox("Merci de recommancer en ne s�lectionnant qu' une UNIQUE cellule (et non une rang�e de cellules)" & vbNewLine & "OU BIEN" & vbNewLine & "De s�l�ctionner une case non vide")
            ElseIf VarType(Coeff) = 11 Then
                
                Call MsgBox("Arr�t du programme demand� par l'utilisateur", vbOKOnly, "Arr�t Pr�matur�")
                Coeff = NaN
                SortieWhile = False
                'Exit Function
            Else
                SortieWhile = False
             End If
Wend

Select_Coeff = Coeff
End Function
Sub Calcul_Inspiration(Ind As Integer, Txt As String)
Dim i As Integer, TailleMin As Integer, iStart As Integer, iAdjust As Integer
Dim rng As Range


'rng contient les Extrema � s�lectionner

'Boite de dialogue demandant � l'utilisateur de s�l�ctionner les donn�es
On Error Resume Next
Set rng = Application.InputBox("Selectioner les Extrema Detectes " & Txt, "Extrema du " & Txt, Type:=8)
 
 'If VarType(rng2) = vbBoolean Then
 'Exit Sub
 'End If
  'rng = rng2
'rng(1, 1).End(xlDown).Select
 
'TailleMin = rng.Rows.Count
TailleMin = Application.Min(rng(1, 1).End(xlDown).Row - 1, rng(1, 2).End(xlDown).Row - 1, rng.Rows.Count)
 
If VarType(rng(1, 1).Value) = vbString Or VarType(rng(1, 2).Value) = vbString Then
'Cas o� les �tiiquettes sont prises dans la s�lection
    iStart = 2
    iAdjust = 0
    TailleMin = TailleMin + 1
Else
    iStart = 1
    iAdjust = 1
    'TailleMin = TailleMin - 1
End If
 
 'Range("P1") = rng(1, 1).End(xlDown).Row
 'Range("P2") = rng(1, 2).End(xlDown).Row
 'Range("P3") = TailleMin
'rngTho(1, 1).Select
  
Cells(1, Ind) = "Amplitude " & Txt
 'Cells(1, Ind) = rng(i, 1).Value
For i = iStart To TailleMin
    Cells(i + iAdjust, Ind) = rng(i, 1).Value - rng(i, 2).Value
Next i
  
  
End Sub
Sub Main2()
'Petit programme pour obtenir la volume courant pr�dit uniquement � partir des Extrema d�t�ct�s du Thorax et de l'Abdomen
'(N�cessite d'avoir utiliser main() au pr�alable)

'D�claration de variables
Dim Rep As Integer
Dim cell As Range


Rep = MsgBox("L'utilisation de cette Macro pr�suppose que les coefficients pour la r�gression lin�aires multiples ont �t� calcul�s et enrgistr�s sur la feuille Excel Utilis�e" & vbNewLine & _
"Colonne L : amplitudes du thorax, Colonne N: amplitudes de l'abdomen" & vbNewLine & "Avez vous calcul� les amplitudes vous m�me ou voulez vous le faire automatiquement?" & vbNewLine & "Oui: D�j� fait  Non: calcul automatique", vbDefaultButton2 + vbQuestion + vbYesNoCancel)
If Rep = 7 Then

    'For i = 0 To 2

        'T1 = WorksheetFunction.CountA(Worksheets(1).Columns(7 + 3 * i))
        'T2 = WorksheetFunction.CountA(Worksheets(1).Columns(8))
        'T = Application.Max(T1, T2)
        'Range(Cells(1, 15 + i * 2), Cells(T + 1, 15 + i * 2)).ClearContents
    'Next i
    Columns(12).ClearContents
    Columns(14).ClearContents
    Columns(15).ClearContents
    Columns(16).ClearContents
    Columns(18).ClearContents
    'Amplitudes du Thorax
    Call Calcul_Inspiration(12, "Thorax")
    
    If DetectEmptyCells(12) Then
        
        Call MsgBox("Aucune valeur n'a pu �tre s�lectionn�e" & vbNewLine & "Assurez-vous que vous avez bien vous m�me d�pos� dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne L vide!")
        Exit Sub
    End If
    
    'Amplitude de l'abdomen
    Call Calcul_Inspiration(14, "Abdomen")

    If DetectEmptyCells(14) Then
        
        Call MsgBox("Aucune valeur n'a pu �tre s�lectionn�e" & vbNewLine & "Assurez-vous que vous avez bien vous m�me d�pos� dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne N vide!")
        Exit Sub
    End If

    ElseIf Rep = 2 Then
        Exit Sub
    Else
        'Verification de la pr�sence de donn�es dans les colonnes du Thorax (L) et de l'Abdomen (N)
        
        'V�rfication de la colonne L (Thorax)
       
        If DetectEmptyCells(12) Then
        
            Call MsgBox("Pas de donn�es d�tect�es en colonne L (Thorax)" & vbNewLine & "Assurez-vous que vous avez bien vous m�me d�pos� dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne L vide!")
            Exit Sub
        End If
        'V�rification de la colonne N (Abdomen)
        
        If DetectEmptyCells(14) Then
        
            Call MsgBox("Pas de donn�es d�tect�es en colonne N (Abdomen)" & vbNewLine & "Assurez-vous que vous avez bien vous m�me d�pos� dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne N vide!")
            Exit Sub
        End If
        
End If

'V�rification du nombre correct de valeurs contenues dans les colonnes des amplitudes
If (Cells(1, 12).End(xlDown).Row - Cells(1, 14).End(xlDown).Row) <> 0 Then
Call MsgBox("ATTENTION: les colonnes contenant les valeurs des amplitudes n'ont pas la m�me taille!" & vbNewLine & "Assurez-vous que les colonnes des �l�ments Amplitude Thorax et Amplitude Abdomen soient de la m�me longueur", vbOKOnly + vbExclamation, "Longueur des Param�tres non respect�s")
Exit Sub
End If

'Ajouter les valeurs des constantes pour calculer le volume courant pr�dit

Coeff_Tho = Select_Coeff("Rentrer le coefficient pour la r�gression lin�aire � appliquer aux amplitudes du signal �lectrique du Thorax", "Coeff_Tho")
    If Coeff_Tho = NaN Then
        Exit Sub
    End If
    Coeff_Abd = Select_Coeff("Rentrer le coefficient pour la r�gression lin�aire � appliquer aux amplitudes du signal �lectrique de l'Abdomen", "Coeff_Abd")
    If Coeff_Abd = NaN Then
        Exit Sub
    End If
    Cste = Select_Coeff("Rentrer la valeur de la constante", "Cste")
    
    If Cste = NaN Then
        Exit Sub
    End If
    
'Estimation du volume pr�dit

For i = 2 To Cells(1, 12).End(xlDown).Row
    Cells(i, 16).Value = Round(Cells(i, 12).Value, 4) * Round(Coeff_Tho, 1) + Round(Cells(i, 14).Value, 4) * Round(Coeff_Abd, 1) + Cste
Next i
Range("P1") = "Volume Pr�dit"


Set rngVolPredit = Range(Cells(2, 16), Cells(2, 16).End(xlDown))



End Sub
Function DetectEmptyCells(Ind As Integer) As Boolean
'Test la pr�sence ou non de valeurs
'Si cases vides-> DetectEmptyCells=True
'Sinon -> DetectEmptyCells=False
Dim x As Integer
Dim cell As Range

 x = 0
        For Each cell In Range(Cells(2, Ind), Cells(6, Ind))
            If IsEmpty(cell) = False Then
                x = x + 1
            End If
            
        Next cell
 Range("A2") = x
        If x = 0 Then
        
            
            DetectEmptyCells = True
        Else
            DetectEmptyCells = False
        End If
        

End Function


'Global size As Integer
Sub mainCalib()
'D�claration des variables
Dim size As Integer, Rep As Integer, x As Integer
Dim CheckItTho As Boolean, CheckItAbd As Boolean, CheckItVol As Boolean
Dim TxtError As String
Dim ThoOutput As Output  ', ThoOutput2 As Output 'Caract�ristiques du signal �lectrique du thorax
Dim TableMinTho() As Single, TableMaxTho() As Single
Dim ThoError As Boolean
Dim AbdOutput As Output  ', AbdOutput2 As Output 'Caract�ristiques du signal �lectrique de l'abdomen
Dim TableMinAbd() As Single, TableMaxAbd() As Single
Dim AbdError As Boolean
Dim VolumeOutput As Output  ', VolumeOutput2 As Output 'Caract�ristiques du signal volume
Dim TableMinVol() As Single, TableMaxVol() As Single
Dim VolError As Boolean, NoVolume As Boolean

Dim Sh As Worksheet
If Worksheets.Count < 2 Then
    Set WS = Sheets.Add(After:=Sheets(Worksheets.Count)) 'Dans certaines versions d'Excel, un seul fixhier Excel est ouvert. Il en faut deux pour r�aliser l'algorithme
     
End If

Set Sh = ActiveWorkbook.Sheets(2)

ActiveWorkbook.Sheets(1).Activate
'Colonnes o� introduire les variables: A,B,C,D,E
'Message d'indication � l'utilisateur de l'utilisation du programme et de l'agencement des variables
CheckItVol = False
CheckItTho = False
CheckItAbd = False
ThoError = False
AbdError = False
VolError = False
NoVolume = False
Rep = MsgBox("Avant de d�buter l'algorithme de d�tection des extrema, merci de v�rifier l'ordre des variables introduites" & vbNewLine & "Colonne A: Time, Colonne B: Tho, Colonne C: Abd, Colonne D: Volume" & vbNewLine & "Si le volume n'est pas disponible, merci de laisser la colonne D vierge" & vbNewLine & "Appuyer sur Oui si les variables ont �t� correctement agenc�es" & vbNewLine & vbNewLine & "V�rifier d'autre part qu'aucun autre fichier Excel n'est ouvert", vbYesNo + vbInformation + vbDefaultButton1)
'Range("Q1") = Rep
If Rep = 7 Then
    Exit Sub
End If

'Test de la pr�sence des donn�es des signaux Tho
If DetectEmptyCells(2) Then
        
    Call MsgBox("Pas de donn�es d�tect�es en colonne B (Tho)" & vbNewLine & "Assurez-vous que vous avez bien vous m�me d�pos� dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne B vide!")
    Exit Sub
End If

'Test de la pr�sence des signaux Abd
If DetectEmptyCells(3) Then
        
    Call MsgBox("Pas de donn�es d�tect�es en colonne C (Abd)" & vbNewLine & "Assurez-vous que vous avez bien vous m�me d�pos� dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne C vide!")
    Exit Sub
End If

Cells.Interior.ColorIndex = 0 'Retirer les cases de couleurs
Sheets(2).Cells.ClearContents 'Effacer toutes les donn�es de la feuille de calcul 2
size = WorksheetFunction.CountA(Worksheets(1).Columns(1)) 'Calcul de la longueur du signal en colonne A

Range("E1") = "Taille des �chantillions"
Range("E2") = size
'************
'D�tection des Extrema des signaux �lectriques du Thorax
ReDim TableMinTho(5, 3)
ReDim TableMaxTho(5, 3)

ThoOutput = Test(1, False, size, TableMinTho(), TableMaxTho(), 50)
CheckItTho = ThoOutput.Bool

'D�tection plus robuste des extrema
If CheckItTho Then
    TableMinTho = ThoOutput.OutMatMin
    TableMaxTho = ThoOutput.OutMatMax
    'ThoOutput2 = test(1, True, size, TableMinTho, TableMaxTho)
    Call Lunch_Test(1, size, TableMinTho, TableMaxTho)
End If

'*****************
'D�tection des Extrema des signaux �lectriques de l'Abdomen
ReDim TableMinAbd(5, 3)
ReDim TableMaxAbd(5, 3)

AbdOutput = Test(2, False, size, TableMinAbd(), TableMaxAbd(), 50)
CheckItAbd = AbdOutput.Bool

'D�tection plus robuste des extrema
If CheckItAbd Then
    TableMinAbd = AbdOutput.OutMatMin
    TableMaxAbd = AbdOutput.OutMatMax
    Call Lunch_Test(2, size, TableMinAbd, TableMaxAbd)
    'AbdOutput2 = test(2, True, size, TableMinAbd, TableMaxAbd)
End If

'*****************
'D�tection des Extrema du volume

ReDim TableMin(5, 3)
ReDim TableMax(5, 3)
    
'D�tection de la pr�sence de cases vides dans la colonne D : il y a t'il des valeurs de volume?
x = 0
For Each cell In Range(Cells(1, 4), Cells(10, 4))
    If IsEmpty(cell) Then
 
    Else
        x = x + 1
 End If
 Next cell
Rep = 0
If x = 0 Then
Rep = MsgBox("Aucune donn�e n'a �t� d�tect�e dans la colonne D correspondant au volume" & vbNewLine & "Continuer sans calculer les Extrema du volume?", vbYesNo + vbExclamation, "Donn�es Manquante en colonne D")
End If

If Rep <> 6 Then
    VolumeOutput = Test(3, False, size, TableMinVol(), TableMaxVol(), 50)
'Utilisation de la d�tection d'extrema standard
    CheckItVol = VolumeOutput.Bool

'D�tection plus robuste des extrema
    If CheckItVol Then
        TableMinVol = VolumeOutput.OutMatMin
        TableMaxVol = VolumeOutput.OutMatMax
        Call Lunch_Test(3, size, TableMinVol, TableMaxVol)
    'VolumeOutput2 = test(3, True, size, TableMinVol, TableMaxVol)
    End If
Else
    NoVolume = True
End If
'Range("W1") = "fonction"
'Range("W2") = VolumeOutput.Bool

'Si il n'y a pas eu de probl�mes, le nombre de  extremas d�tect�s doivent �tre �gaux
'Les lignes de codes suivantes permettent de v�rifier ce fait
TxtError = ""
If Abs(Range("E4").Value - Range("E8").Value) > 1 And Abs(Range("E4").Value - Range("E12").Value) > 1 Then
    ThoError = True
    TxtError = TxtError & "Signaux �lectrique du thorax_"
End If
If Abs(Range("E4").Value - Range("E12").Value) > 1 And Abs(Range("E8").Value - Range("E12").Value) > 1 Then
    
    VolError = True
    TxtError = TxtError & "Signaux du volume_"
End If
If Abs(Range("E8").Value - Range("E12").Value) > 1 And Abs(Range("E8").Value - Range("E4").Value) > 1 Then
    
    AbdError = True
    TxtError = TxtError & "Signaux �lectrique de l'abdomen_"
End If

If (ThoError Or VolError Or AbdError) And NoVolume = False Then
    Call MsgBox("Un probl�me de d�tection des extr�ma semble survenir pour les signaux suivant:" & vbNewLine & TxtError, vbOKOnly + vbExclamation, "Attention!")
    
End If

'V�rification de possibles erreurs



End Sub
Sub Lunch_Test(Signal_Type As Integer, size As Integer, TableMin() As Single, TableMax() As Single)
Dim Out As Output
    
Out = Test(Signal_Type, True, size, TableMin, TableMax, 50)

End Sub
Sub Detect_Advanced()
'****************
'Cet algorithme permet une d�tection plus aboutie des maxima en proposant de choisir l'intervalle de d�tection entre deux maxima ou minima (fix� � 50 dans la macro mainCalib())

'D�claration des variables
Dim Rep As Integer, Rep2 As Integer, Rep3 As Integer, Ind As Integer
Dim Fs As Single, size As Integer
Dim TableMin() As Single, TableMax() As Single
Dim Out As Output, Out2 As Output

Rep3 = False

Dim Sh As Worksheet
If Worksheets.Count < 2 Then
    Set WS = Sheets.Add(After:=Sheets(Worksheets.Count)) 'Dans certaines versions d'Excel, un seul fixhier Excel est ouvert. Il en faut deux pour r�aliser l'algorithme
     
End If


If Cells(4, 1).Value - Cells(3, 1).Value <> 0 Then
    Fs = 1 / (Cells(4, 1).Value - Cells(3, 1).Value) ':calculer la fr�quence d'�chantillionnage
Else
    Fs = 50 'Valeur par d�faut
End If

On Error Resume Next
Rep = InputBox("Vous avez choisi d'utiliser l'algorithme de d�tection des extrema avanc� (Detect_Advanced)" & vbNewLine & "Veuillez fixer l'intervalle de d�tection entre deux Maxima ou Minima:", "Ins�rer Intervalle de d�tection", Fs / 3)
If Rep = 0 Then
    Exit Sub
End If

Rep2 = MsgBox("Indiquer sur quel signal appliquer l'algorithme" & vbNewLine & "Oui: Signal du thorax" & vbNewLine & "Non: Signal de l'abdomen" & vbNewLine & "Cancel: Signal du volume", vbYesNoCancel, "Quel signal ?")
'Rep2:6 -> Thorax
'Rep2= 7-> Abdomen
'Rep2= 2-> Volume

If Rep2 = 6 Then
    Ind = 1 'l'utilisateur demande d'appliquer l'logorithme aux signaux du thorax
ElseIf Rep2 = 7 Then
    Ind = 2 'l'utilisateur demande d'appliquer l'logorithme aux signaux de l'abdomen
Else
    Ind = 3 'l'utilisateur demande d'appliquer l'logorithme aux signaux du volume
End If


size = WorksheetFunction.CountA(Worksheets(1).Columns(1)) 'Calcul de la longueur du signal en colonne A
ReDim TableMin(5, 3)
ReDim TableMax(5, 3)
Out = Test(Ind, False, size, TableMin(), TableMax(), Rep)

While Rep3 = False
Out2 = Test(Ind, True, size, Out.OutMatMin, Out.OutMatMax, Rep)
Rep2 = MsgBox("La d�t�ction des Extrema vous semble t'elle maintentant plus adapt�e?" & vbNewLine & "'Ok' : Continuer en choisissant un nouvel intervalle de d�tection" & vbNewLine & "'Annuler': Arr�ter la Macro", vbOKCancel)
If Rep2 = 2 Then
    Rep3 = True
    Else
    Rep = InputBox("Veuillez fixer un nouvel intervalle de d�tection entre deux Maxima ou Minima:", "Ins�rer Intervalle de d�tection", Rep)

End If
Wend

End Sub
 
Function Test(ByVal Signal_Type As Integer, ByRef Advanced As Boolean, ByVal size As Integer, TableMin() As Single, TableMax() As Single, Interval As Integer) As Output
'Signal_Type: 1 -> Tho
'___________: 2 -> Abd
'___________: 3 -> volume
'Advanced : False par defaut, True si l'utilisateur souhaite des r�sultats plus pr�cis
' size: taille des valeurs


'D�claration des variables
Dim MaxDetect() As Single, MinDetect() As Single, i As Integer, var As Integer, cell As Range, Txt As String
Dim j As Integer, k As Integer, l As Integer, IndiceMin As Integer, IndiceMax As Integer, Taille1 As Integer, Taille2 As Integer, Rep As Integer, Taillef As Integer, Rep2 As Integer
Dim Title As String, yLegend As String, SerieName As String
'Title: Nom du titre du graphique,  yLegend: nom de l'axe des ordonn�es, SerieName: nom de la s�rie �tudi�e
Dim Out As Output
Dim MaxTrace() As Single, MinTrace() As Single
Dim Prb As Boolean, Prb2 As Boolean, NewPicDetected As Boolean
'La variable Prb indique si il y a un probleme en ce qui concerne la d�tection des extr�ma
'Dim rngMin As Range
'Dim rngMax As Range
Dim cht As Object
Dim rng As Range, rng2 As Range, r As Range 'rng sert � tracer le graphique, tandis que r et rng 2 servent � copier-coller les donn�es pr�cedemment calcul�es
Dim temp As Single
Dim rngMin As Range, rngMax As Range
'Dim cht As ChartObject

'Range("C3").Select

'Range("A:A").Select
'Range("A:A").Copy
Set Sh1 = ActiveWorkbook.Sheets(1)
Set Sh2 = ActiveWorkbook.Sheets(2)

'Range("E:E").Select
'ActiveSheet.Paste

Select Case Signal_Type
    Case Is = 1
'Colonne F : reserv�e pour Maxima Detect�s de Tho
'Colonne G: reserv�e pour Minima D�tect�s de Tho

        'Set r = ActiveSheet.Range("F" & 2 & ":G" & 100)
        Sh1.Range("F1") = "Max Tho"
        Sh1.Range("G1") = "Min Tho"
        Sh2.Range("B1") = "Max Tho"
        Sh2.Range("C1") = "Min Tho"
        IndiceMax = 6
        IndiceMin = 7
        
        
        'Colone des donn�es de Tho pour  chart
        'Set rng = ActiveSheet.Range("B" & 2 & ":B" & size)
        Set rng = Sh1.Range(Sh1.Cells(2, 2), Sh1.Cells(size, 2))
        'Titres et axes
        Title = "D�tection des Extrema des signaux �lectriques du Thorax"
        yLegend = "Voltage (V)"
        SerieName = "Signaux du Thorax"
        
    Case Is = 2
 'Colonne H laiss�e vide
 'Colonne I : reserv�e pour Maxima D�tect�s de Abd
 'Colonne J : reserv�e pour Minima D�tcet�s de Abd
        'Set r = ActiveSheet.Range("I" & 2 & ":J" & 100)
        
        IndiceMax = 9
        IndiceMin = 10
        Sh1.Range("I1") = "Max Abd"
        Sh1.Range("J1") = "Min Abd"
        Sh2.Range("E1") = "Max Abd"
        Sh2.Range("F1") = "Min Abd"
        
        'Colone des donn�es de Tho pour  chart
        'Set rng = ActiveSheet.Range("C" & 2 & ":C" & size)
        Set rng = Sh1.Range(Sh1.Cells(2, 3), Sh1.Cells(size, 3))
        'Titres et axes
        Title = "D�tection des Extrema des signaux �lectriques de L'abdomen"
        yLegend = "Voltage (V)"
        SerieName = "Signaux de l'abdomen"
        
    Case Is = 3
  'Colonne K laiss�e vide
  'Colonne L : reserv�e pour Maxima D�tect�s de Volume
  'Colonne M : reserv�e pour Minima D�tect�s de Volume
        
        Sh1.Range("L1") = "Max Volume"
        Sh1.Range("M1") = "Min Volume"
        Sh2.Range("H1") = "Max Volume"
        Sh2.Range("I1") = "Min Volume"
        IndiceMax = 12
        IndiceMin = 13
        
        
        'Colone des donn�es de Tho pour  chart
        'Set rng = ActiveSheet.Range("D" & 2 & ":D" & size)
        Set rng = Sh1.Range(Sh1.Cells(2, 4), Sh1.Cells(size, 4))
        'Titres et axes
        Title = "D�tection des Extrema des signaux du volume"
        yLegend = "Volume (mL)"
        SerieName = "Volume"
    Case Else
    
        MsgBox ("Erreur sur la variable 'Signal_Type'" & vbNewLine & "Arr�t du programme ! ")
        
        Exit Function
        
End Select

Taille1 = WorksheetFunction.CountA(Worksheets(1).Columns(IndiceMin))
Taille2 = WorksheetFunction.CountA(Worksheets(1).Columns(IndiceMax))
Taillef = Application.Max(Taille1, Taille2)

Set r = ActiveSheet.Range(Cells(1, IndiceMax), Cells(Taillef, IndiceMin))
'(En cas de r�-execution de l'algorithme) conserver les valeurs pr�c�dentes? (copier coller?)
If Advanced Then

    
    Rep2 = MsgBox("Voulez-vous conserver les valeurs trouv�es pr�cedemment?" & vbNewLine & "(Elles seront copi�s-coll�es plus bas, sinon elles seront effac�es)", vbYesNo + vbDefaultButton2)
        If Rep2 = 6 Then
        'Copier-Coller les r�sultats pr�c�dents
            'r.Select
            Set rng2 = Sh1.Range(Sh1.Cells(Taillef + 2, IndiceMax), Sh1.Cells(Taillef * 2 + 2, IndiceMin))
            r.Copy rng2
            r.Copy
            'For l = 1 To Taillef
             '   Range(Cells(l, IndiceMax), Cells(l, IndiceMax)).Copy Range(Cells(l + Taillef, IndiceMax), Cells(l + Taillef, IndiceMax))
              '  Range(Cells(l, IndiceMin), Cells(l, IndiceMin)).Copy Range(Cells(l + Taillef, IndiceMin), Cells(l + Taillef, IndiceMin))
               ' Range(Cells(l + Taillef, IndiceMax), Cells(l + Taillef, IndiceMax)).Interior.ColorIndex = Range(Cells(l, IndiceMax), Cells(l, IndiceMax)).Interior.ColorIndex
           ' Next l
            
            'rng2.PasteSpecial Paste:=xlPasteAll

            'Application.CutCopyMode = False
            'Range("L2:M23").Copy Range("N25:O48")
            'rng2.Select
            
            'ActiveSheet.Paste
           ' rng2.Parent.Activate
            'rng2.PasteSpecial Paste:=xlPasteAll, Operation:=xlNone, SkipBlanks:=False, Transpose:=False
            
            For i = 1 To Taillef
            
            
                'Cells(i, IndiceMin).Interior.ColorIndex = Cells(i + 2 + Taillef, IndiceMin).Interior.ColorIndex
                'Copier-coller des cases de couleurs (un defaut d'excel fait qu'il n'est pas possible de copier -coller la couleur des cases)
                'Pour la colonne des maximum
                If TableMax(i, 3) = 1 Then
                    Cells(i + Taillef, IndiceMax).Interior.ColorIndex = 22
                    Cells(i + Taillef, IndiceMin).Interior.ColorIndex = 22
                    Cells(i - 1 + Taillef, IndiceMax).Interior.ColorIndex = 22
                End If
                
                
                If TableMin(i, 3) = 1 Then
                    Cells(i + Taillef, IndiceMin).Interior.ColorIndex = 22
                    Cells(i - 1 + Taillef, IndiceMin).Interior.ColorIndex = 22
                    Cells(i + Taillef, IndiceMax).Interior.ColorIndex = 22
                    
                End If
                
                
                'Cells(i + Taillef, IndiceMin).Interior.ColorIndex = 22
            Next i
            
            
        End If
                    
End If


'Effacer les donn�es contenues dans la matrice (IndiceMax,IndiceMin)
   Range(Cells(3, IndiceMax), Cells(Taillef, IndiceMin)).ClearContents
' Remmettre les Cases des colonnes pour les min et max d�tect�s vides
'For Each cell In r
    'cell.Interior.ColorIndex = 0
'Next cell
r.Interior.ColorIndex = 0

ReDim MaxDetect(size, 3) 'Table dynamique
ReDim MinDetect(size, 3) 'Table dynamique
ReDim MaxTrace(size)
ReDim MinTrace(size)


'Debug.Print r.Width
'Debug.Print r.Height

'Initialisation des variables
Prb = False 'Prb indique si il y a un risque de mauvaise d�t�ction d'extremum
Prb2 = False
j = 2 'Indice des Max
k = 2 'Indice des Min
NewPicDetected = False

For i = 2 To size

'Detection des minima
If Cells(i, Signal_Type + 1) < Cells(i - 1, Signal_Type + 1) And Cells(i + 1, Signal_Type + 1) > Cells(i, Signal_Type + 1) Then
MinDetect(k, 1) = Cells(i, Signal_Type + 1).Value
MinDetect(k, 2) = i
NewPicDetected = True

'Detection de possible anomalies
    If (MinDetect(k, 2) - MinDetect(k - 1, 2)) < Interval And k > 2 Then
    
        
        Prb = True 'Une anomalie est d�tect�e: deux maximum se suivent trop pr�s
        
        'Robustesse face aux oscillations (n'est activ� que lorsque Advanced est Vrai)
        If Advanced Then
             If MinDetect(k, 1) < MinDetect(k - 1, 1) Then
        
                MinTrace(MinDetect(k, 2) - 2) = MinDetect(k, 1)
                MinTrace(MinDetect(k - 1, 2) - 2) = 0
                'Cells(MinDetect(k, 2), 6) = MinDetect(k, 1) '*
                'Cells(MinDetect(k - 1, 2), 6) = 0'*
                MinDetect(k - 1, 1) = MinDetect(k, 1)
                MinDetect(k - 1, 2) = MinDetect(k, 2)
        
            Else
            
                MinTrace(MinDetect(k - 1, 2) - 2) = MinDetect(k - 1, 1)
                MinTrace(MinDetect(k, 2) - 2) = 0
                'Cells(MinDetect(k - 1, 2), 6) = MinDetect(k, 1)'*
                'Cells(MinDetect(k, 2), 6) = 0'*
            
            End If
        
            k = k - 1
            j = j - 1 ' Retrait du max en plus
            'Cells(k, 8) = MinDetect(k, 1) - 1'*
            'Cells(k, 16) = MinDetect(k, 2) - 1'*
            'Cells(i, 6) = 0
            'MinTrace(i - 2) = 0
            'Cells(MaxDetect(j, 2) - 2, 5) = 0'*
            MaxTrace(MaxDetect(j, 2) - 2) = 0
            
        Else
        
            
            Range(Cells(k, IndiceMin), Cells(k, IndiceMin)).Interior.ColorIndex = 22 'Colorie en rouge les cases o� son pr�sent les anomalies
            Range(Cells(k - 1, IndiceMin), Cells(k - 1, IndiceMin)).Interior.ColorIndex = 22
            Range(Cells(j - 1, IndiceMax), Cells(j - 1, IndiceMax)).Interior.ColorIndex = 22
            MinDetect(k, 3) = 1
        
        End If
        
    End If


Cells(k, IndiceMin) = MinDetect(k, 1)
MinTrace(i - 2) = MinDetect(k, 1)
'Cells(k + Taillef + 2, IndiceMin) = MinDetect(k, 3)
'Cells(k, 16) = MinDetect(k, 2)

k = k + 1

Else
'Cells(i, 6) = 0
MinTrace(i - 2) = 0
End If

' D�tection de maximum
If Cells(i, Signal_Type + 1) > Cells(i - 1, Signal_Type + 1) And Cells(i + 1, Signal_Type + 1) < Cells(i, Signal_Type + 1) And k > 2 Then

'Cells(i, 3) = Cells(i, 2).Value
MaxDetect(j, 1) = Cells(i, Signal_Type + 1).Value
MaxDetect(j, 2) = i
NewPicDetected = True
        'Detection de possibles anomalies
    'If MaxDetect(j, 1) < 0 Then
        'Prb2 = True 'Il n'est pas possible d'avoir un maximum n�gatif sauf dans des cas particuliers
        'Range(Cells(j, IndiceMax), Cells(j, IndiceMax)).Interior.ColorIndex = 33 'Colorie en  les cases en bleu o� sont pr�sentes les anomalies
    'End If
    
    If (MaxDetect(j, 2) - MaxDetect(j - 1, 2)) < Interval And k >= 3 Then
    
        Prb = True
        
        
        If Advanced Then
        
            If MaxDetect(j, 1) > MaxDetect(j - 1, 1) Then
        
                MaxTrace(MaxDetect(j - 1, 2) - 2) = 0
                MaxTrace(MaxDetect(j, 2) - 2) = MaxDetect(j, 1)
                'Cells(MaxDetect(j - 1, 2), 5) = 0'*
                'Cells(MaxDetect(j, 2), 5) = MaxDetect(j, 1)'*
                MaxDetect(j - 1, 1) = MaxDetect(j, 1)
                MaxDetect(j - 1, 2) = MaxDetect(j, 2)
            
            Else
            
                MaxTrace(MaxDetect(j - 1, 2) - 2) = MaxDetect(j - 1, 1)
                MaxTrace(MaxDetect(j, 2) - 2) = 0
                'Cells(MaxDetect(j - 1, 2), 5) = MaxDetect(j - 1, 1)'*
                'Cells(MaxDetect(j, 2), 5) = 0'*
            
            End If
        
            j = j - 1
            k = k - 1 'Retrait du min en plus
            'Cells(i, 5) = 0
            'MaxTrace(i - 2) = 0
            'Cells(MinDetect(k, 2), 6) = 0
            MinTrace(MinDetect(k, 2) - 2) = 0
        Else
            Range(Cells(j, IndiceMax), Cells(j, IndiceMax)).Interior.ColorIndex = 22 'Colorie en rouge les cases o� son pr�sent les anomalies
            Range(Cells(j - 1, IndiceMax), Cells(j - 1, IndiceMax)).Interior.ColorIndex = 22
            Range(Cells(k - 1, IndiceMin), Cells(k - 1, IndiceMin)).Interior.ColorIndex = 22
            MaxDetect(k, 3) = 1
        End If
        
    End If
'Cells(j + Taillef + 2, IndiceMax) = MaxDetect(j, 3)
Cells(j, IndiceMax) = MaxDetect(j, 1)
MaxTrace(i - 2) = MaxDetect(j, 1)
'Cells(j, 15) = MaxDetect(j, 2)
j = j + 1


Else
'Cells(i, 5) = 0
MaxTrace(i - 2) = 0
End If



Next i

'Rcopie les donn�es des extremum pour chaque courbe sur la feuille 2 du fichier Excel
For i = 1 To size
Sheets(2).Cells(i + 2, IndiceMax - 4).Value = MaxTrace(i)
Sheets(2).Cells(i + 1, IndiceMin - 4).Value = MinTrace(i - 1)
Next i

'D�tection des Maxima n�gatifs, existant probablement � cause d'une mauvaise d�t�ction)

i = 1

While IsEmpty(Range(Cells(i, IndiceMax), Cells(i, IndiceMax))) = False
    If Sh1.Cells(i, IndiceMax).Value < 0.0001 Then
        Cells(i, IndiceMax).Interior.ColorIndex = 33
        
        'Colorie en  les cases en bleu o� sont pr�sentes les anomalies
        
        Prb2 = True
    End If
    i = 1 + i
Wend

'Call Color_Blue(IndiceMax)
'Annonce de la d�tection d'une possible Erreur
If Prb2 Then
    MsgBox ("Il semble avoir des probl�mes quant � la d�tection des Extrema: sont surlign�s en bleu les Maxima reconnus comme n�gatifs")
End If

'Impression des r�sultats
'Tailles des vecteurs contenant les extrema d�tect�s
Select Case Signal_Type

    Case Is = 1
    
    Sh1.Range("F1") = "Max Tho"
    Sh1.Range("G1") = "Min Tho"
    Range("E3") = "Nbre Max Tho"
    Range("E5") = "Nbre Min Tho"
    Range("E4") = j - 2
    Range("E6") = k - 2
    Range("B20").Select
    
    Case Is = 2
    
    Range("I1") = "Max Abd"
    Range("J1") = "Min Abd"
    Range("E7") = "Nbre Max Abd"
    Range("E9") = "Nbre Min Abd"
    Range("E8") = j - 2
    Range("E10") = k - 2
    Range("I20").Select
    
    Case Is = 3
    
    Range("L1") = "Max Volume"
    Range("M1") = "Min Volume"
    Range("E11") = "Nbre Max Vol"
    Range("E13") = "Nbre Min Vol"
    Range("E12") = j - 2
    Range("E14") = k - 2
    Range("N20").Select
    
End Select


' Cr�ation d'un diagramme
' S�lection des Max

If Advanced Then
    Range(Cells(35, IndiceMax), Cells(35, IndiceMax)).Select 'Selectione une zone sur le fichier Excel o� afficher la courbe
End If


  'size = WorksheetFunction.CountA(Worksheets(1).Columns(1))
  
  
  
'Create a chart
  Set cht = ActiveSheet.ChartObjects.Add( _
    Left:=ActiveCell.Left, _
    Width:=450, _
    Top:=ActiveCell.Top, _
    Height:=250)


'Give chart some data
  cht.Chart.SetSourceData Source:=rng

'Determine the chart type
  cht.Chart.ChartType = xlXYScatterLinesNoMarkers
  
  'Ajouter des data au chart
  'cht.Chart.SeriesCollection.NewSeries.Values = rngMin.Offset(, 1)
If size < 10000 Then
  
  cht.Chart.SeriesCollection.NewSeries.Values = MinTrace
  'cht.Chart.SeriesCollection(1).Points(PointNumber).MarkerStyle = xlMarkerStyleCircle
  'cht.Chart.SeriesCollection.NewSeries.Values = rngMax.Offset(, 1)
  cht.Chart.SeriesCollection.NewSeries.Values = MaxTrace
  'cht.Chart.SeriesCollection.NewSeries.Name(6) = "Min Detectes"
Else
    
    Set rngMin = Sh2.Range(Sh2.Cells(2, IndiceMin - 4), Sh2.Cells(size, IndiceMin - 4))
    Set rngMax = Sh2.Range(Sh2.Cells(2, IndiceMax - 4), Sh2.Cells(size, IndiceMax - 4))
    
    cht.Chart.SeriesCollection.NewSeries.Values = rngMin
    cht.Chart.SeriesCollection.NewSeries.Values = rngMax
    
End If
  
  'Propri�t�s du graphique
  If Advanced Then
    Title = Title & "(apr�s application du correctif)"
    
  End If
  cht.Activate
  With ActiveChart
    .ChartType = xlLine
    .HasTitle = True
    .ChartTitle.Text = Title
    .HasLegend = False
    '.SeriesCollection(1).Name = SerieName
    '.SeriesCollection(2).Name = "Minima"
    '.SeriesCollection(3).Name = "Maxima"
    '.Legend.Font.Name = "1"
    
  End With
  'Ajouter les noms pour les abscisses
  
With cht.Chart.Axes(xlCategory)
 .HasTitle = True
 .AxisTitle.Text = "Nombre de points"
End With
With cht.Chart.Axes(xlValue)
.HasTitle = True
 .AxisTitle.Text = yLegend
End With
  'Charts("cht").Axes(xlCategory).HasTitle = True
  'cht.AxisTitle.Text = "Nombres de points"

For i = 2 To k - 1
      'If Cells(i, 5) <> 0 Then
      'cht.Chart.SeriesCollection.NewSeries.Values = Cells(i, 5)
      temp = MinDetect(i, 2)
      
      cht.Chart.SeriesCollection(2).Points(temp - 1).MarkerStyle = xlMarkerStyleSquare 'xlMarkerStyleSquare
Next i
For i = 2 To j - 1
      temp = MaxDetect(i, 2)
      cht.Chart.SeriesCollection(3).Points(temp - 1).MarkerStyle = xlMarkerStyleCircle 'xlMarkerStyleSquare
      'End If
Next i
With ActiveChart
    .SeriesCollection(2).Format.Line.Visible = False
    .SeriesCollection(3).Format.Line.Visible = False
End With


ActiveChart.Deselect

'Rafraichir les graphes fournis par Excel
ActiveSheet.Calculate
ActiveWindow.SmallScroll
Application.WindowState = Application.WindowState
Application.ScreenUpdating = False
temp = ActiveCell.ColumnWidth
ActiveCell.Columns.AutoFit
ActiveCell.ColumnWidth = temp
Application.ScreenUpdating = True
Application.CalculateFullRebuild

'Recentrage des graphiques Excel
If Advanced = False Then
    Range(Cells(35, IndiceMax + 5), Cells(35, IndiceMax + 5)).Select
End If

'Annonce d'une possible erreur
'Ouverture de la boite de dialogue
If Prb And Advanced = False Then
    Rep = MsgBox("Il semblerait qu'il y ait un ou plusieurs Extremum (a) mal d�t�ct�s" & vbNewLine & "Les Extrema suceptibles d'�tre mal d�tect�s apparaissent en rouge dans la colone des extrema" & vbNewLine & "Appuyer sur Retry r� �valuera les extrema en reconnaissant les �ventuelles ondulations", vbRetryCancel + vbExclamation)
'Rep=4 -> retry/ Rep=2 -> annule

End If

'If Prb2 Then
   ' MsgBox ("Les Valeurs Surlign�es en bleu semblent erronn�es")
'End If

If Advanced = True Then
    MsgBox ("Extrema R�-�valu�s" & vbNewLine & "Si des probl�mes de d�tection persistent, vous pouvez Appliquer l'algorithme de d�tection avanc�e, Detect_Advanced()" & vbNewLine & "proposant de changer l'intervalle de d�tection entre deux extrema successifs, trop rapproch�s � cause des oscillations")
End If

If Rep = 4 Then
Advanced = True
Else
Advanced = False
End If

'Range("R1") = Rep


'G�n�ration des Outputs
ReDim Out.OutMatMax(Taillef, 3)
ReDim Out.OutMatMin(Taillef, 3)

Out.OutMatMax = MaxDetect
Out.OutMatMin = MinDetect
Out.Bool = Advanced

Test = Out



End Function





