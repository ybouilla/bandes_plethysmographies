# Scripts pour le l'étude de la respiration aux moyen de bandes de pléthysmographies.

ce projet contient :
- [les scripts permettant de calibrer les bandes de pléthysmographie pour la](excel_tool/)
- [les scripts permettant de calculer l'angle de phase (Konno & Mead)](matlab_tools)

# Calibrations de bandes_plethysmographies
Calibrations de bandes de plethysmographies

Scripts pour la calibration de bandes de pléthysmographies.
Après acquisition des signaux; un script vba a été produit pour la segmentation de signaux respiratoires (detection de pics) pour la mesure du volume courant

## Bandes de pléthysmographies

![img0](img/bande_de_plethy.png)

**Necessite Microsoft Excel**

## Importer les données d’Acqknowledge à Excel :quelques recommandations …

- Appliquer des filtres passe bas de fréquence de coupure 1 Hz (FIR) pour les signaux du Thorax et de l’Abdomen

- Eliminer une éventuelle ligne de base en soustrayant les signaux à leurs moyennes

- Ré-échantillonner les données à une fréquence de 100 – 150 Hz pour pouvoir les sauver sur un fichier Excel

## Méthode de calibration des bandes de pléthysmographie : Régression Linéaire Multiple

eq. 𝑉_𝑇=𝛼×𝑇_𝑎𝑏𝑑+𝜏× 𝑇_𝑡ℎ𝑜+𝐶𝑠𝑡𝑒

1. Etape 1 : Détermination des variables 𝛼, 𝜏 et 𝐶𝑠𝑡𝑒 pour construire le modèle
2. Etape 2 : Utiliser le modèle pour calculer le volume courant prédit (𝑉_𝑇) au moyen de 𝑇_𝑎𝑏𝑑 et 𝑇_𝑡ℎ𝑜 uniquement. 


![img1](img/img1.jpg)

![img2](img/img2.jpg)

![img3](img/img3.jpg)

## Protocole

### 1. Calibration des bandes de pléthysmographies
![img4](img/img4.jpg)
### 2. Utilisation des bandes de pléthysmographies
![img5](img/img5.jpg)

## Résultats

Representation des signaux du thorax et de l'abdomen 

### Regression lineaire

![img4_linear_plan](img/img4_linear_plan.jpg)


### Comparaison avec un réseaux de neurones

![img_ann](img/img_bayesian.jpg)

![img_nn](img/img_neural_net.jpg)

### Résultats des prédictions

![img_res](img/prediction_res.jpg)

## Calcul de l'angle de phase

Mesure du déphasage moyen entre les sisgnaux du thorax et de l'abdomen.
L'angle de phase est un indicateur de la qualité de la respiration.
Plus l'angle de déphasage est grand plus la détresse respiratoire est importante.
![img6](img/km-illustration.png)

Exemple de signaux obtenus:

![img7](img/km-plot1.tif)

![img8](img/km-plot2.png)
