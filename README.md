# Projet-Scientifique-Informatique-L2
### Ce projet est fait en [Netlogo](https://fr.wikipedia.org/wiki/NetLogo). Il a consisté a créer une simulation d'un incendie dans une salle de spectale.

Le **rapport de projet** ([pdf](https://github.com/Mentra20/Projet-Scientifique-Informatique-L2/blob/master/Rapport/Rapport.pdf) / [latex](https://github.com/Mentra20/Projet-Scientifique-Informatique-L2/blob/master/Rapport/Rapport.tex)) fait en [Latex](https://fr.wikipedia.org/wiki/LaTeX). Ainsi que mon [**rapport personnel**](https://github.com/Mentra20/Projet-Scientifique-Informatique-L2/blob/master/journal_perso_Martin-dEscrienne.pdf).  

Le projet a eu une **pré-soutenance** ([fichier latex](https://github.com/Mentra20/Projet-Scientifique-Informatique-L2/blob/master/Presentation1/Presentation.tex) / [fichier pdf](https://github.com/Mentra20/Projet-Scientifique-Informatique-L2/blob/master/Presentation1/Presentation.pdf)) puis une **présentation finale** ([fichier latex](https://github.com/Mentra20/Projet-Scientifique-Informatique-L2/blob/master/Presentation2/Presentation_finale.tex) / [fichier pdf](https://github.com/Mentra20/Projet-Scientifique-Informatique-L2/blob/master/Presentation2/Presentation_finale.pdf)).  

[**Le fichier Netlogo.**](https://github.com/Mentra20/Projet-Scientifique-Informatique-L2/blob/master/Projet.nlogo)  
[Le dossier](https://github.com/Mentra20/Projet-Scientifique-Informatique-L2/tree/master/csv) contenant les **fichiers .csv** du projet. (créés automatiquement par le fichier netlogo du projet).

## FONCTIONNEMENT DE LA SIMULATION : 
![](https://github.com/Mentra20/Projet-Scientifique-Informatique-L2/blob/master/Screen.PNG)
*Vous pouvez ralentir a tout moment la simulation grace a la barre de controle de vitesse en haut de netlogo.* 

* **Setup** permet de mettre en place la scene (ne pas appuyer sur setup pendant une simulation).  

* **Go** permet de lancer la simulation pas par pas (appuyer sur go record pour une simulation continue).  

* **Simuloop , Simuloop graphe et Go record** servent pour les fichiers .csv.  

* **Densité** augmente ou diminue le nombre de personne dans le cinéma.  

* **NB_EXIT** correspond au nombre de sortie du cinéma.  

* **CenterExit** met une seule sortie au millieu de la salle et **wall** place un mur devant ou non.  

* **Fire on** place ou non un feu qui se propage dans la salle. 

* **fire_start** place le feu a certain endroit selon sa valeur (0 démarre n'importe où dans la salle, 1 seulement en bas de la salle, 2 seulement dans les bancs de la salle).  

* **surpopulation** ajoute encore plus de personne dans la simulation (utile pour les effets d'une unique entrée au centre).  

* **TerrosistOn** Un bonus (non present dans la presentation et rapport) qui transforme un personnage en terroriste (rose) qui se place au centre et explose provoquant alors un incendie. 

