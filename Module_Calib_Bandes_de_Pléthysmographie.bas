Attribute VB_Name = "Module1"

Public Type Output
    OutMatMin() As Single
    OutMatMax() As Single
    Bool As Boolean
    End Type
    
Sub Display_Instruction()
'A utiliser pour rappeller à l'utilisateur comment utiliser l'ensemble des macros

Call MsgBox("Voici quelques instructions et recommandations pour se servir des macros :" & vbNewLine & _
"Les Macros sont des algorithmes que l'on peut implanter dans Microsoft Excel. Ont été développé dans le cas du traitement des données relatives aux bandes de pléthysmographies 4 Macro, dont 3 principales" _
& vbNewLine & "Il s'agit de :" & vbNewLine & "MainCalib( ),MainCalib2( ) et Main2( ), ainsi que Detect_Advanced( )." & vbNewLine & _
"La macro MainCalib( ) permet de calculer les extrema des trois signaux_ Les tensions électriques du Thorax et de l'abdomen et les signaux du volume." _
& vbNewLine & "MainCalib2( ) permet le calcul de la RLM et Main2( ) permet de calculer directement le volume courant prédit" & vbNewLine & "Les macros doivent s'utiliser dans l'ordre suivant:" & vbNewLine & " (1)MainCalib( )-> (2)[MainCalib2( ) ou Main2( )]" _
& vbNewLine & vbNewLine & "Les différents type de données accessibles: " & vbNewLine & "-> Dans le cas d'une calibration; il est nécessaire d'avoir les données du temps, les voltages électriques du Thorax et de l'Abdomen et de Volume" _
& vbNewLine & "-> Autrement, seules les données de temps et de volatge (Thorax et Abdomen) sont accessibles" _
& vbNewLine, vbOKOnly, "Instruction Message 1/9 : introduction")
'"Préparation des données:"

Call MsgBox("Les Macros ont été étudiées pour traiter les signaux directement depuis AcqKnowledge" & vbNewLine & vbNewLine & "Préparation des données:" & vbNewLine & "Les données issues d'Acqknowledge doivent être présentées selon cet ordre :" & vbNewLine & _
"_ Colonne A : Temps" & vbNewLine & "_ Colonne B: Tension Thorax (Indispensable)" & vbNewLine & "_ Colonne C : Tension Abdomen (Indispensble)" & vbNewLine & _
"_ Colonne D : signaux du volume (si disponible)" & vbNewLine & "Il est très important que les signaux repectent cet ordre" & vbNewLine & "les données peuvent être directement copiées-collées à partir d'un fichier Excel créé au moyen d'AcqKnowledge" _
& vbNewLine & "Il peut être nécessaire de retirer la deuxième ligne contenant les unités sur le Fichier d'Excel importé d'AcqKnowledge", vbOKOnly, "Instruction Message 2/9 : Préparation des données")

Call MsgBox("Aussi, il est important de vérifier ces aspects : " & vbNewLine & "_ Les seules colonnes devant êre remplies sont les 4 premières: A, B, C et D. Rien ne doit être ajouté dans ces colonnes" & vbNewLine & _
"_ Le seul fichier Excel devant être ouvert est celui contenant les 4 colonnes correspondant au paramètre temporel ou aux signaux" & vbNewLine & _
"_ La feuille Excel (Sheet) devant être affichée à l'écran est la feuille (1) 'Feuil1'" & vbNewLine & "_Aucune feuille ne doit être incorporée avant la feuille(1) 'Feuill1'" _
& vbNewLine & "_ La feuille 'Feuil2' doit rester vierge" & vbNewLine & "_ Le premier cycle du signal de volume doit correspondre à une inspiration", vbOKOnly, "Instruction Message 3/9 : Préparation des données (2)")

Call MsgBox("       Calibration:" & vbNewLine & vbNewLine & "La Macro mainCalib( ) doit être exécutée dans un premier temps :" & vbNewLine & "Elle consiste à détecter les Extrema sur l'ensemble des cycles présents sur le Volume. Chaques Maxima et Minima des 3 signaux sont ensuites renseignés dans les colonnes suivantes:" & vbNewLine & _
"- Colonne E : y est indiqué le nombre d'échantillions total (nombres de colonnes)," & vbNewLine & "- Colonnes F & G : Max et Min du Thorax" & vbNewLine & "- Colonnes I & J : Max et Min de l'abdomen" & vbNewLine & _
"- Colonnes L & M : Max et Min du volume" & vbNewLine & _
 "La présence de bruits lors de l'enregistrement ou suite à l'échantillionnage peuvent se traduire par des oscillations pouvant conduire à une mauvaise détection des extrema." _
& vbNewLine & "Un algorithme de détection plus poussé permet de détecter les Extrema trop près les uns des autres" & vbNewLine & "Les valeurs des Extrema correspondant à du bruit sont surlignées en rouge. L'algorithme se charge ensuite de corriger ces valeurs." _
, vbOKOnly, "Instuction Message 4/9 (Calibration)")

Call MsgBox("       Calibration (suite):" & vbNewLine & vbNewLine & "Un autre algorithme incorporé dans la Macro détecte les Maxima à valeurs négatives, en les surlignant en bleu : un Maxima à valeur négative à de forte chance d'être lié à un problème de détection" _
& vbNewLine & "En outre; les graphiques représentant les variations des tensions électriques et volumes sont affichés et les Extrema détectés" & vbNewLine & _
"Outre les algorithmes de correction de détection, des problème de détection des Extrema peuvent persister." & vbNewLine & "L'utilisateur à alors la possibilité de :" & vbNewLine & _
"1) Corriger lui même les défauts de détections des Extrema" & vbNewLine & "2) Utiliser la Macro de détection d'Extrema avancée DetectAdvanced( )." & vbNewLine & _
"La Macro de détection avancée va vous demander de choisir un intervalle de détection plus grand (exprimé en nombre de points) pour affiner la détection d'Extrema." _
& " L'algorithme est efficace si la fréquence de respiration du signal analysé est suffisamment régulière.", vbOKOnly, "Instruction Message 5/9 (Calibration)")

Call MsgBox("       Calibration (suite):" & vbNewLine & vbNewLine & "Fonctionnement de la Macro Detect_Advanced( ):" & vbNewLine & "L'algorithme demande tout d'abord à l'utilisateur une période (en nombre de points) nécessaire, la valeur idéale correspond à la distance " _
& "minimale entre deux Maxima ou Minima. Après sélection de la valeur, l'algorithme réalise une détection très basique, puis ré-itère en retirant les Extrema qui se suivent de trop près." & vbNewLine & "Dans certains cas, si l'enregistrement est trop chaotique, vous serez obligé de retirer vous même les valeurs." & vbNewLine & vbNewLine & _
vbNewLine & "       Calcul des inspirations:" & vbNewLine & "Une fois la détection des Extrema vous paraît satisfaisante, vous pouvez utiliser les Macro suivantes" & vbNewLine & "-> mainCalib2( ) si les signaux du Thorax, Abdomen et Volume sont disponibles" & vbNewLine & _
 "Attention à ne pas choisir un trop grand interval, au risque que l'algorithme ne parvienne pas à détecter les Extrema réels" & vbNewLine & vbNewLine & "-> Main2( ) si seules les données du Thorax et Abdomen sont disponibles", vbOKOnly, "Instruction Message 6/9 (Calibration)")
 
Call MsgBox("       Calibration (suite):" & vbNewLine & "Dans le cas d'une calibration, il convient d'utiliser ensuite la Macro mainCalib2( ). La Macro vous propose deux méthodes :" & vbNewLine & _
"1) Une première méthode consiste à calculer soit même les amplitudes," & vbNewLine & "2) Une seconde un outil de calcul automatique des amplitudes que l'on utilise en sélectionant soi-même les valeurs des Extrema" & vbNewLine & "La deuxième méthode nécessite de sélectionner uniquement les Maxima et Minima correspondant chacun à un cycle respiratoire" & vbNewLine & _
"_ _ _ _ _ _ _ _ _ _ _" & vbNewLine & "| [Max 1] [Min 1] |" & vbNewLine & "| [Max 2] [Min 2] |" & vbNewLine & "|         ...                 |" & vbNewLine & "| [Max n] [Min n]|" & vbNewLine & " - - - - - - - - - - - " & vbNewLine & "Représentation schématique de la zone à sélectionner (apparaissant en tirets), c'est-à-dire des Minima et Maxima sur n cycles." _
& " La sélection se fait en glissant la souris sur une plage de valeurs: La sélection doit strictement couvrir 2 colonnes: la colonne des maxima et celles des minima.", vbOKOnly, "Instruction Message 7/9 (Calibration)")

Call MsgBox("      Calibration (suite):" & vbNewLine & "Après calcul des amplitudes, la Macro mainCalib2() demande si vous souhaitez réaliser la regression linéaire multiple sur les valeurs des amplitudes du Thorax et de l'abdomen et sur le volume courant inspiré." & vbNewLine & _
"Réaliser une Régression Linéaire Multiple (RLM) consiste à déterminer les coefficients a et b vérifiant l'équation :" & vbNewLine & "              Vt = a x Tabd + b x Ttho + Cste" & vbNewLine & _
"Ces coefficients permettent ainsi le calcul du volume prédit calculé alors en colonne S." & vbNewLine & " Et Ttho : Amplitude du Thorax, Tabd : Amplitude de l'Abdomen" & vbNewLine & "Les coefficients apparaissent dans les cases suivantes:" & vbNewLine & "_ a en U4" _
& vbNewLine & "_ b en U5" & vbNewLine & "_ Cste en U6" & vbNewLine & "Sont affichés également le coefficient R², le degré de liberté et l'erreur entre la moyenne des volumes courants mesurés et des volumes courants prédits." _
, vbOKOnly, "Instruction Message 8/9 (Calibration)")

Call MsgBox("       Calibration (suite):" & vbNewLine & "Si les coefficients ont déjà été calculés, vous pouvez les séléctionner vous même afin de calculer le volume prédit et calculer l'erreur." _
& "Pour ce faire, il faut que les valeurs soient enregistrées sur le fichier Excel utilisé. Sélectionner les valeurs en cliquant sur leurs cases respectives." & vbNewLine & vbNewLine & "Calcul du volume prédit à partir des données du thorax et de l'abdomen seulement" _
& vbNewLine & vbNewLine & "Après avoir calculé les valeurs des Extrema du Thorax et de l'Abdomen, utilisez la Macro Main2( ). De même que pour la Macro mainCalib2( ), Main2( ) vous propose de calculer " _
& " ou bien vous même les valeurs des Extrema ou bien de façon automatique." & vbNewLine & "Ensuite sélectionner les valeurs des coefficients a,b et Cste (que vous auriez précédemment rentré dans la feuille Excel)." _
& "Atention de ne pas les mettre dans les colonnes A,B,C,D nottamment. Il est recommandé de les mettre en colonne T et au delà à partir de la 10° ligne" & vbNewLine & "Les valeurs du volume courant prédit s'affichent en colonne P.", vbOKOnly, "Instruction Message 9/9 Use of Main2( )")


End Sub






    



Sub mainCalib2()
'Calcul les amplitudes des signaux électriques ou du volume
'(Nécessite d'avoir utiliser mainCalib() au préalabe)
'Déclaration des variables
Dim Rep As Integer, Rep2 As Integer, T As Integer, T1 As Integer, T2 As Integer, i As Integer
Dim rng As Range, rngAbd As Range, rngVol As Range, rngVolPredit As Range
Dim Coeff_Abd As Single, Coeff_Tho As Single, Cste As Single
Dim SortieWhile As Boolean

SortieWhile = True

Rep = MsgBox("Avez vous calculé les amplitudes vous même ou voulez vous le faire automatiquement?" & vbNewLine & _
"Colonne O: amplitudes du Thorax, Colonne P: amplitudes de l'abdomen, Colonne R: amplitudes du volume" & vbNewLine & "Oui: Déjà fait  Non: calcul automatique", vbDefaultButton2 + vbQuestion + vbYesNoCancel)
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
        
        Call MsgBox("Aucune valeur n'a pu être sélectionnée" & vbNewLine & "Assurez-vous que vous avez bien vous même déposé dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne O vide!")
        Exit Sub
    End If
   
    'Amplitude de l'abdomen
    Call Calcul_Inspiration(16, "Abdomen")
    
    If DetectEmptyCells(16) Then
        
        Call MsgBox("Aucune valeur n'a pu être sélectionnée" & vbNewLine & "Assurez-vous que vous avez bien vous même déposé dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne P vide!")
        Exit Sub
    End If
    
    'Amplitude du volume
    If DetectEmptyCells(12) Or DetectEmptyCells(13) Then
        
            Rep2 = MsgBox("Pas de données détectées en colonne L et M (Max et Min du Volume)" & vbNewLine & "Assurez-vous que vous avez bien vous même déposé dans la colonne vos propres valeurs" & vbNewLine & "A moins que vous n'ayez aucune données de volume" & vbNewLine & "'Ok': Continuer sans les données du volume     'Annuler': mettre fin à la macro", vbExclamation + vbOKCancel, "Colonne L et M vides!")
            
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
        'Vérification de la présence de données dans la colonne O
        If DetectEmptyCells(15) Then
        
            Call MsgBox("Pas de données détectées en colonne O (Thorax)" & vbNewLine & "Assurez-vous que vous avez bien vous même déposé dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne O vide!")
            Exit Sub
        End If
        'Vérification de la présence de données dans la colonne P
        If DetectEmptyCells(16) Then
        
            Call MsgBox("Pas de données détectées en colonne P (Thorax)" & vbNewLine & "Assurez-vous que vous avez bien vous même déposé dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne P vide!")
            Exit Sub
        End If
        'Vérification de la présence de données dans la colonne R
        If DetectEmptyCells(18) Then
        
            Call MsgBox("Pas de données détectées en colonne R (Volume)" & vbNewLine & "Assurez-vous que vous avez bien vous même déposé dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne R vide!")
            Exit Sub
        End If
        
End If
    
If ((Cells(1, 15).End(xlDown).Row - Cells(1, 16).End(xlDown).Row) <> 0 Or (Cells(1, 15).End(xlDown).Row - Cells(1, 18).End(xlDown).Row) <> 0) Then
Call MsgBox("ATTENTION: une ou plusieurs des colonnes contenant les valeurs des amplitude(s) n'a (ont) pas la même taille!" & vbNewLine & "Assurez-vous que les colonnes des éléments Amplitude Thorax, Amplitude Abdomen et Amplitude Volume soient de la même longueur", vbOKOnly + vbExclamation, "Longueur des Paramètres non respectés")
Exit Sub
End If


Rep = MsgBox("Voluez-vous réaliser la régression linéaire Multipe sur les données calculées?" & vbNewLine & "(Pour la Calibration)" & vbNewLine & "Appuyer sur 'ANNULER' si les coefficients sont déjà calculés", vbOKCancel + vbDefaultButton2, "Réaliser la regression linéaire?")


'Vérification du Bon nombre d'éléments avant de réaliser une RLM



Set rngVol = Range(Cells(2, 18), Cells(2, 18).End(xlDown))

If Rep = 1 Then
    Set rng = Application.Union(Range(Cells(2, 15), Cells(2, 15).End(xlDown)), Range(Cells(2, 16), Cells(2, 16).End(xlDown)))
    
    '= Range(Cells(1, 17).End(xlDown).Row)
    
    'Dsplay Linear Regression Results
    RegLin = Application.LinEst(rngVol, rng, True, True)
    Range("T1") = "Résultats de la Régression Linéaire"
    Range("T2") = "Modéle de l'équation: "
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
    Range("T7") = "R²"
    Range("U7") = RegLin(3, 1)
    Range("T8") = "Degrés de liberté"
    Range("U8") = RegLin(4, 2)
    'Range("T10:W20") = RegLin
    
    Else
    
    Coeff_Tho = Select_Coeff("Rentrer le coefficient pour la régression linéaire à appliquer aux amplitudes du signal électrique du Thorax", "Coeff_Tho")
    If Coeff_Tho = NaN Then
        Exit Sub
    End If
    Coeff_Abd = Select_Coeff("Rentrer le coefficient pour la régression linéaire à appliquer aux amplitudes du signal électrique de l'Abdomen", "Coeff_Abd")
    If Coeff_Abd = NaN Then
        Exit Sub
    End If
    Cste = Select_Coeff("Rentrer la valeur de la constante", "Cste")
    
    If Cste = NaN Then
        Exit Sub
    End If
    
   
End If
'Estimation du volume prédit

For i = 2 To Cells(1, 15).End(xlDown).Row
    Cells(i, 19).Value = Round(Cells(i, 15).Value, 4) * Round(Coeff_Tho, 1) + Round(Cells(i, 16).Value, 4) * Round(Coeff_Abd, 1) + Cste
Next i
Range("S1") = "Volume Prédit"

Set rngVolPredit = Range(Cells(2, 19), Cells(2, 19).End(xlDown))

'Estimation de l'erreur
Call Assess_Error(rngVol, rngVolPredit)

End Sub
Sub Assess_Error(rngVol As Range, rngVolPredit As Range)

'Estimation de l'erreur

'1) Calcul de la moyenne des Volume Courants mesurés
Cells(Cells(1, 18).End(xlDown).Row + 2, 18) = "Moyenne"
Cells(Cells(1, 18).End(xlDown).Row + 3, 18) = Application.Average(rngVol)

'2) Calcul de la moyenne des volumes courants prédits


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
        'Boite de dialogue demandant les coefficents à rentrer pour effectuer la regression linéaire
            Coeff = Application.InputBox(Msg & vbNewLine & "(" & Msg2 & ")", Msg2, Type:=8)
        
            'Range("U10") = Coeff
    
            'Range("U11") = VarType(Coeff)
            If VarType(Coeff) <> 5 And VarType(Coeff) <> 11 Then
                Call MsgBox("Merci de recommancer en ne sélectionnant qu' une UNIQUE cellule (et non une rangée de cellules)" & vbNewLine & "OU BIEN" & vbNewLine & "De séléctionner une case non vide")
            ElseIf VarType(Coeff) = 11 Then
                
                Call MsgBox("Arrêt du programme demandé par l'utilisateur", vbOKOnly, "Arrêt Prématuré")
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


'rng contient les Extrema à sélectionner

'Boite de dialogue demandant à l'utilisateur de séléctionner les données
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
'Cas où les étiiquettes sont prises dans la sélection
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
'Petit programme pour obtenir la volume courant prédit uniquement à partir des Extrema détéctés du Thorax et de l'Abdomen
'(Nécessite d'avoir utiliser main() au préalable)

'Déclaration de variables
Dim Rep As Integer
Dim cell As Range


Rep = MsgBox("L'utilisation de cette Macro présuppose que les coefficients pour la régression linéaires multiples ont été calculés et enrgistrés sur la feuille Excel Utilisée" & vbNewLine & _
"Colonne L : amplitudes du thorax, Colonne N: amplitudes de l'abdomen" & vbNewLine & "Avez vous calculé les amplitudes vous même ou voulez vous le faire automatiquement?" & vbNewLine & "Oui: Déjà fait  Non: calcul automatique", vbDefaultButton2 + vbQuestion + vbYesNoCancel)
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
        
        Call MsgBox("Aucune valeur n'a pu être sélectionnée" & vbNewLine & "Assurez-vous que vous avez bien vous même déposé dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne L vide!")
        Exit Sub
    End If
    
    'Amplitude de l'abdomen
    Call Calcul_Inspiration(14, "Abdomen")

    If DetectEmptyCells(14) Then
        
        Call MsgBox("Aucune valeur n'a pu être sélectionnée" & vbNewLine & "Assurez-vous que vous avez bien vous même déposé dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne N vide!")
        Exit Sub
    End If

    ElseIf Rep = 2 Then
        Exit Sub
    Else
        'Verification de la présence de données dans les colonnes du Thorax (L) et de l'Abdomen (N)
        
        'Vérfication de la colonne L (Thorax)
       
        If DetectEmptyCells(12) Then
        
            Call MsgBox("Pas de données détectées en colonne L (Thorax)" & vbNewLine & "Assurez-vous que vous avez bien vous même déposé dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne L vide!")
            Exit Sub
        End If
        'Vérification de la colonne N (Abdomen)
        
        If DetectEmptyCells(14) Then
        
            Call MsgBox("Pas de données détectées en colonne N (Abdomen)" & vbNewLine & "Assurez-vous que vous avez bien vous même déposé dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne N vide!")
            Exit Sub
        End If
        
End If

'Vérification du nombre correct de valeurs contenues dans les colonnes des amplitudes
If (Cells(1, 12).End(xlDown).Row - Cells(1, 14).End(xlDown).Row) <> 0 Then
Call MsgBox("ATTENTION: les colonnes contenant les valeurs des amplitudes n'ont pas la même taille!" & vbNewLine & "Assurez-vous que les colonnes des éléments Amplitude Thorax et Amplitude Abdomen soient de la même longueur", vbOKOnly + vbExclamation, "Longueur des Paramètres non respectés")
Exit Sub
End If

'Ajouter les valeurs des constantes pour calculer le volume courant prédit

Coeff_Tho = Select_Coeff("Rentrer le coefficient pour la régression linéaire à appliquer aux amplitudes du signal électrique du Thorax", "Coeff_Tho")
    If Coeff_Tho = NaN Then
        Exit Sub
    End If
    Coeff_Abd = Select_Coeff("Rentrer le coefficient pour la régression linéaire à appliquer aux amplitudes du signal électrique de l'Abdomen", "Coeff_Abd")
    If Coeff_Abd = NaN Then
        Exit Sub
    End If
    Cste = Select_Coeff("Rentrer la valeur de la constante", "Cste")
    
    If Cste = NaN Then
        Exit Sub
    End If
    
'Estimation du volume prédit

For i = 2 To Cells(1, 12).End(xlDown).Row
    Cells(i, 16).Value = Round(Cells(i, 12).Value, 4) * Round(Coeff_Tho, 1) + Round(Cells(i, 14).Value, 4) * Round(Coeff_Abd, 1) + Cste
Next i
Range("P1") = "Volume Prédit"


Set rngVolPredit = Range(Cells(2, 16), Cells(2, 16).End(xlDown))



End Sub
Function DetectEmptyCells(Ind As Integer) As Boolean
'Test la présence ou non de valeurs
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
'Déclaration des variables
Dim size As Integer, Rep As Integer, x As Integer
Dim CheckItTho As Boolean, CheckItAbd As Boolean, CheckItVol As Boolean
Dim TxtError As String
Dim ThoOutput As Output  ', ThoOutput2 As Output 'Caractéristiques du signal électrique du thorax
Dim TableMinTho() As Single, TableMaxTho() As Single
Dim ThoError As Boolean
Dim AbdOutput As Output  ', AbdOutput2 As Output 'Caractéristiques du signal électrique de l'abdomen
Dim TableMinAbd() As Single, TableMaxAbd() As Single
Dim AbdError As Boolean
Dim VolumeOutput As Output  ', VolumeOutput2 As Output 'Caractéristiques du signal volume
Dim TableMinVol() As Single, TableMaxVol() As Single
Dim VolError As Boolean, NoVolume As Boolean

Dim Sh As Worksheet
If Worksheets.Count < 2 Then
    Set WS = Sheets.Add(After:=Sheets(Worksheets.Count)) 'Dans certaines versions d'Excel, un seul fixhier Excel est ouvert. Il en faut deux pour réaliser l'algorithme
     
End If

Set Sh = ActiveWorkbook.Sheets(2)

ActiveWorkbook.Sheets(1).Activate
'Colonnes où introduire les variables: A,B,C,D,E
'Message d'indication à l'utilisateur de l'utilisation du programme et de l'agencement des variables
CheckItVol = False
CheckItTho = False
CheckItAbd = False
ThoError = False
AbdError = False
VolError = False
NoVolume = False
Rep = MsgBox("Avant de débuter l'algorithme de détection des extrema, merci de vérifier l'ordre des variables introduites" & vbNewLine & "Colonne A: Time, Colonne B: Tho, Colonne C: Abd, Colonne D: Volume" & vbNewLine & "Si le volume n'est pas disponible, merci de laisser la colonne D vierge" & vbNewLine & "Appuyer sur Oui si les variables ont été correctement agencées" & vbNewLine & vbNewLine & "Vérifier d'autre part qu'aucun autre fichier Excel n'est ouvert", vbYesNo + vbInformation + vbDefaultButton1)
'Range("Q1") = Rep
If Rep = 7 Then
    Exit Sub
End If

'Test de la présence des données des signaux Tho
If DetectEmptyCells(2) Then
        
    Call MsgBox("Pas de données détectées en colonne B (Tho)" & vbNewLine & "Assurez-vous que vous avez bien vous même déposé dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne B vide!")
    Exit Sub
End If

'Test de la présence des signaux Abd
If DetectEmptyCells(3) Then
        
    Call MsgBox("Pas de données détectées en colonne C (Abd)" & vbNewLine & "Assurez-vous que vous avez bien vous même déposé dans la colonne vos propres valeurs", vbCritical + vbOKOnly, "Colonne C vide!")
    Exit Sub
End If

Cells.Interior.ColorIndex = 0 'Retirer les cases de couleurs
Sheets(2).Cells.ClearContents 'Effacer toutes les données de la feuille de calcul 2
size = WorksheetFunction.CountA(Worksheets(1).Columns(1)) 'Calcul de la longueur du signal en colonne A

Range("E1") = "Taille des échantillions"
Range("E2") = size
'************
'Détection des Extrema des signaux électriques du Thorax
ReDim TableMinTho(5, 3)
ReDim TableMaxTho(5, 3)

ThoOutput = Test(1, False, size, TableMinTho(), TableMaxTho(), 50)
CheckItTho = ThoOutput.Bool

'Détection plus robuste des extrema
If CheckItTho Then
    TableMinTho = ThoOutput.OutMatMin
    TableMaxTho = ThoOutput.OutMatMax
    'ThoOutput2 = test(1, True, size, TableMinTho, TableMaxTho)
    Call Lunch_Test(1, size, TableMinTho, TableMaxTho)
End If

'*****************
'Détection des Extrema des signaux électriques de l'Abdomen
ReDim TableMinAbd(5, 3)
ReDim TableMaxAbd(5, 3)

AbdOutput = Test(2, False, size, TableMinAbd(), TableMaxAbd(), 50)
CheckItAbd = AbdOutput.Bool

'Détection plus robuste des extrema
If CheckItAbd Then
    TableMinAbd = AbdOutput.OutMatMin
    TableMaxAbd = AbdOutput.OutMatMax
    Call Lunch_Test(2, size, TableMinAbd, TableMaxAbd)
    'AbdOutput2 = test(2, True, size, TableMinAbd, TableMaxAbd)
End If

'*****************
'Détection des Extrema du volume

ReDim TableMin(5, 3)
ReDim TableMax(5, 3)
    
'Détection de la présence de cases vides dans la colonne D : il y a t'il des valeurs de volume?
x = 0
For Each cell In Range(Cells(1, 4), Cells(10, 4))
    If IsEmpty(cell) Then
 
    Else
        x = x + 1
 End If
 Next cell
Rep = 0
If x = 0 Then
Rep = MsgBox("Aucune donnée n'a été détectée dans la colonne D correspondant au volume" & vbNewLine & "Continuer sans calculer les Extrema du volume?", vbYesNo + vbExclamation, "Données Manquante en colonne D")
End If

If Rep <> 6 Then
    VolumeOutput = Test(3, False, size, TableMinVol(), TableMaxVol(), 50)
'Utilisation de la détection d'extrema standard
    CheckItVol = VolumeOutput.Bool

'Détection plus robuste des extrema
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

'Si il n'y a pas eu de problèmes, le nombre de  extremas détectés doivent être égaux
'Les lignes de codes suivantes permettent de vérifier ce fait
TxtError = ""
If Abs(Range("E4").Value - Range("E8").Value) > 1 And Abs(Range("E4").Value - Range("E12").Value) > 1 Then
    ThoError = True
    TxtError = TxtError & "Signaux électrique du thorax_"
End If
If Abs(Range("E4").Value - Range("E12").Value) > 1 And Abs(Range("E8").Value - Range("E12").Value) > 1 Then
    
    VolError = True
    TxtError = TxtError & "Signaux du volume_"
End If
If Abs(Range("E8").Value - Range("E12").Value) > 1 And Abs(Range("E8").Value - Range("E4").Value) > 1 Then
    
    AbdError = True
    TxtError = TxtError & "Signaux électrique de l'abdomen_"
End If

If (ThoError Or VolError Or AbdError) And NoVolume = False Then
    Call MsgBox("Un problème de détection des extréma semble survenir pour les signaux suivant:" & vbNewLine & TxtError, vbOKOnly + vbExclamation, "Attention!")
    
End If

'Vérification de possibles erreurs



End Sub
Sub Lunch_Test(Signal_Type As Integer, size As Integer, TableMin() As Single, TableMax() As Single)
Dim Out As Output
    
Out = Test(Signal_Type, True, size, TableMin, TableMax, 50)

End Sub
Sub Detect_Advanced()
'****************
'Cet algorithme permet une détection plus aboutie des maxima en proposant de choisir l'intervalle de détection entre deux maxima ou minima (fixé à 50 dans la macro mainCalib())

'Déclaration des variables
Dim Rep As Integer, Rep2 As Integer, Rep3 As Integer, Ind As Integer
Dim Fs As Single, size As Integer
Dim TableMin() As Single, TableMax() As Single
Dim Out As Output, Out2 As Output

Rep3 = False

Dim Sh As Worksheet
If Worksheets.Count < 2 Then
    Set WS = Sheets.Add(After:=Sheets(Worksheets.Count)) 'Dans certaines versions d'Excel, un seul fixhier Excel est ouvert. Il en faut deux pour réaliser l'algorithme
     
End If


If Cells(4, 1).Value - Cells(3, 1).Value <> 0 Then
    Fs = 1 / (Cells(4, 1).Value - Cells(3, 1).Value) ':calculer la fréquence d'échantillionnage
Else
    Fs = 50 'Valeur par défaut
End If

On Error Resume Next
Rep = InputBox("Vous avez choisi d'utiliser l'algorithme de détection des extrema avancé (Detect_Advanced)" & vbNewLine & "Veuillez fixer l'intervalle de détection entre deux Maxima ou Minima:", "Insérer Intervalle de détection", Fs / 3)
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
Rep2 = MsgBox("La détéction des Extrema vous semble t'elle maintentant plus adaptée?" & vbNewLine & "'Ok' : Continuer en choisissant un nouvel intervalle de détection" & vbNewLine & "'Annuler': Arrêter la Macro", vbOKCancel)
If Rep2 = 2 Then
    Rep3 = True
    Else
    Rep = InputBox("Veuillez fixer un nouvel intervalle de détection entre deux Maxima ou Minima:", "Insérer Intervalle de détection", Rep)

End If
Wend

End Sub
 
Function Test(ByVal Signal_Type As Integer, ByRef Advanced As Boolean, ByVal size As Integer, TableMin() As Single, TableMax() As Single, Interval As Integer) As Output
'Signal_Type: 1 -> Tho
'___________: 2 -> Abd
'___________: 3 -> volume
'Advanced : False par defaut, True si l'utilisateur souhaite des résultats plus précis
' size: taille des valeurs


'Déclaration des variables
Dim MaxDetect() As Single, MinDetect() As Single, i As Integer, var As Integer, cell As Range, Txt As String
Dim j As Integer, k As Integer, l As Integer, IndiceMin As Integer, IndiceMax As Integer, Taille1 As Integer, Taille2 As Integer, Rep As Integer, Taillef As Integer, Rep2 As Integer
Dim Title As String, yLegend As String, SerieName As String
'Title: Nom du titre du graphique,  yLegend: nom de l'axe des ordonnées, SerieName: nom de la série étudiée
Dim Out As Output
Dim MaxTrace() As Single, MinTrace() As Single
Dim Prb As Boolean, Prb2 As Boolean, NewPicDetected As Boolean
'La variable Prb indique si il y a un probleme en ce qui concerne la détection des extréma
'Dim rngMin As Range
'Dim rngMax As Range
Dim cht As Object
Dim rng As Range, rng2 As Range, r As Range 'rng sert à tracer le graphique, tandis que r et rng 2 servent à copier-coller les données précedemment calculées
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
'Colonne F : reservée pour Maxima Detectés de Tho
'Colonne G: reservée pour Minima Détectés de Tho

        'Set r = ActiveSheet.Range("F" & 2 & ":G" & 100)
        Sh1.Range("F1") = "Max Tho"
        Sh1.Range("G1") = "Min Tho"
        Sh2.Range("B1") = "Max Tho"
        Sh2.Range("C1") = "Min Tho"
        IndiceMax = 6
        IndiceMin = 7
        
        
        'Colone des données de Tho pour  chart
        'Set rng = ActiveSheet.Range("B" & 2 & ":B" & size)
        Set rng = Sh1.Range(Sh1.Cells(2, 2), Sh1.Cells(size, 2))
        'Titres et axes
        Title = "Détection des Extrema des signaux électriques du Thorax"
        yLegend = "Voltage (V)"
        SerieName = "Signaux du Thorax"
        
    Case Is = 2
 'Colonne H laissée vide
 'Colonne I : reservée pour Maxima Détectés de Abd
 'Colonne J : reservée pour Minima Détcetés de Abd
        'Set r = ActiveSheet.Range("I" & 2 & ":J" & 100)
        
        IndiceMax = 9
        IndiceMin = 10
        Sh1.Range("I1") = "Max Abd"
        Sh1.Range("J1") = "Min Abd"
        Sh2.Range("E1") = "Max Abd"
        Sh2.Range("F1") = "Min Abd"
        
        'Colone des données de Tho pour  chart
        'Set rng = ActiveSheet.Range("C" & 2 & ":C" & size)
        Set rng = Sh1.Range(Sh1.Cells(2, 3), Sh1.Cells(size, 3))
        'Titres et axes
        Title = "Détection des Extrema des signaux électriques de L'abdomen"
        yLegend = "Voltage (V)"
        SerieName = "Signaux de l'abdomen"
        
    Case Is = 3
  'Colonne K laissée vide
  'Colonne L : reservée pour Maxima Détectés de Volume
  'Colonne M : reservée pour Minima Détectés de Volume
        
        Sh1.Range("L1") = "Max Volume"
        Sh1.Range("M1") = "Min Volume"
        Sh2.Range("H1") = "Max Volume"
        Sh2.Range("I1") = "Min Volume"
        IndiceMax = 12
        IndiceMin = 13
        
        
        'Colone des données de Tho pour  chart
        'Set rng = ActiveSheet.Range("D" & 2 & ":D" & size)
        Set rng = Sh1.Range(Sh1.Cells(2, 4), Sh1.Cells(size, 4))
        'Titres et axes
        Title = "Détection des Extrema des signaux du volume"
        yLegend = "Volume (mL)"
        SerieName = "Volume"
    Case Else
    
        MsgBox ("Erreur sur la variable 'Signal_Type'" & vbNewLine & "Arrêt du programme ! ")
        
        Exit Function
        
End Select

Taille1 = WorksheetFunction.CountA(Worksheets(1).Columns(IndiceMin))
Taille2 = WorksheetFunction.CountA(Worksheets(1).Columns(IndiceMax))
Taillef = Application.Max(Taille1, Taille2)

Set r = ActiveSheet.Range(Cells(1, IndiceMax), Cells(Taillef, IndiceMin))
'(En cas de ré-execution de l'algorithme) conserver les valeurs précédentes? (copier coller?)
If Advanced Then

    
    Rep2 = MsgBox("Voulez-vous conserver les valeurs trouvées précedemment?" & vbNewLine & "(Elles seront copiés-collées plus bas, sinon elles seront effacées)", vbYesNo + vbDefaultButton2)
        If Rep2 = 6 Then
        'Copier-Coller les résultats précédents
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


'Effacer les données contenues dans la matrice (IndiceMax,IndiceMin)
   Range(Cells(3, IndiceMax), Cells(Taillef, IndiceMin)).ClearContents
' Remmettre les Cases des colonnes pour les min et max détectés vides
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
Prb = False 'Prb indique si il y a un risque de mauvaise détéction d'extremum
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
    
        
        Prb = True 'Une anomalie est détectée: deux maximum se suivent trop près
        
        'Robustesse face aux oscillations (n'est activé que lorsque Advanced est Vrai)
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
        
            
            Range(Cells(k, IndiceMin), Cells(k, IndiceMin)).Interior.ColorIndex = 22 'Colorie en rouge les cases où son présent les anomalies
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

' Détection de maximum
If Cells(i, Signal_Type + 1) > Cells(i - 1, Signal_Type + 1) And Cells(i + 1, Signal_Type + 1) < Cells(i, Signal_Type + 1) And k > 2 Then

'Cells(i, 3) = Cells(i, 2).Value
MaxDetect(j, 1) = Cells(i, Signal_Type + 1).Value
MaxDetect(j, 2) = i
NewPicDetected = True
        'Detection de possibles anomalies
    'If MaxDetect(j, 1) < 0 Then
        'Prb2 = True 'Il n'est pas possible d'avoir un maximum négatif sauf dans des cas particuliers
        'Range(Cells(j, IndiceMax), Cells(j, IndiceMax)).Interior.ColorIndex = 33 'Colorie en  les cases en bleu où sont présentes les anomalies
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
            Range(Cells(j, IndiceMax), Cells(j, IndiceMax)).Interior.ColorIndex = 22 'Colorie en rouge les cases où son présent les anomalies
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

'Rcopie les données des extremum pour chaque courbe sur la feuille 2 du fichier Excel
For i = 1 To size
Sheets(2).Cells(i + 2, IndiceMax - 4).Value = MaxTrace(i)
Sheets(2).Cells(i + 1, IndiceMin - 4).Value = MinTrace(i - 1)
Next i

'Détection des Maxima négatifs, existant probablement à cause d'une mauvaise détéction)

i = 1

While IsEmpty(Range(Cells(i, IndiceMax), Cells(i, IndiceMax))) = False
    If Sh1.Cells(i, IndiceMax).Value < 0.0001 Then
        Cells(i, IndiceMax).Interior.ColorIndex = 33
        
        'Colorie en  les cases en bleu où sont présentes les anomalies
        
        Prb2 = True
    End If
    i = 1 + i
Wend

'Call Color_Blue(IndiceMax)
'Annonce de la détection d'une possible Erreur
If Prb2 Then
    MsgBox ("Il semble avoir des problèmes quant à la détection des Extrema: sont surlignés en bleu les Maxima reconnus comme négatifs")
End If

'Impression des résultats
'Tailles des vecteurs contenant les extrema détectés
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


' Création d'un diagramme
' Sélection des Max

If Advanced Then
    Range(Cells(35, IndiceMax), Cells(35, IndiceMax)).Select 'Selectione une zone sur le fichier Excel où afficher la courbe
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
  
  'Propriétés du graphique
  If Advanced Then
    Title = Title & "(après application du correctif)"
    
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
    Rep = MsgBox("Il semblerait qu'il y ait un ou plusieurs Extremum (a) mal détéctés" & vbNewLine & "Les Extrema suceptibles d'être mal détectés apparaissent en rouge dans la colone des extrema" & vbNewLine & "Appuyer sur Retry ré évaluera les extrema en reconnaissant les éventuelles ondulations", vbRetryCancel + vbExclamation)
'Rep=4 -> retry/ Rep=2 -> annule

End If

'If Prb2 Then
   ' MsgBox ("Les Valeurs Surlignées en bleu semblent erronnées")
'End If

If Advanced = True Then
    MsgBox ("Extrema Ré-évalués" & vbNewLine & "Si des problèmes de détection persistent, vous pouvez Appliquer l'algorithme de détection avancée, Detect_Advanced()" & vbNewLine & "proposant de changer l'intervalle de détection entre deux extrema successifs, trop rapprochés à cause des oscillations")
End If

If Rep = 4 Then
Advanced = True
Else
Advanced = False
End If

'Range("R1") = Rep


'Génération des Outputs
ReDim Out.OutMatMax(Taillef, 3)
ReDim Out.OutMatMin(Taillef, 3)

Out.OutMatMax = MaxDetect
Out.OutMatMin = MinDetect
Out.Bool = Advanced

Test = Out



End Function





