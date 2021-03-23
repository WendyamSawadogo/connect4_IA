/* ----- MÉCANIQUES DU JEU ----- */


% Fonction récursive qui replace un élément dans une liste.
/* Paramètres : L la liste, I l'index, E l'élment à remplacer, NL : nouvelle liste*/
remplacer(L, I, E, NL) :- nth1(I, L, _, T), nth1(I, NL, E, T).


% Fonction indiquant que la colonne est pleine.
/* Paramètres : C la colonne, M le nombre d'élément maximum. */
colonnePleine(C,M) :- length(C,L),L@>=M.


% Fonction qui ajoute un jeton dans une grille.
/* Paramètres : G la grille initiale, J le jeton du joueur (x ou o), C la colonne choisie, NG : la grille avec le jeton ajouté*/
ajouterJeton(G,J,C,NG) :- nth1(C,G,X), append(X,[J],R), remplacer(G,C,R,NG), not(colonnePleine(R,7)).


% Fonction récursive qui permet de vérifier si une ligne de 4 jetons est formée.
/*
* On retourne vrai si on obtient 4 jetons de la même valeur de suite en horizontal.
* [param] PE = Premier élément
* [param] RC = Reste de la colonne
* [param] AC = Autre colonnes
* [param] RL = Reste de la ligne
* [param] RG = Reste de la grille
* [param] G = Grille reçu
* [param] NRG = Nouveau reste de grille
* [param] NL = Nouvelle ligne
*/
verifierLigne(_,_,4).
verifierLigne(PE, [PE|RL], N):-N1 is N+1, PE\==v, verifierLigne(PE, RL, N1). % Si l'élément actuel est similaire au prochain élément.
verifierLigne(X, [Y|RL], _):- X\==Y, verifierLigne(Y, RL, 1). % Si l'élément actuel est différent du prochain élément.
verifierLigne(v, [v|RL], _):-verifierLigne(v, RL, 1). % Si l'élément est un v, il faut l'ignorer et passer à l'élément suivant.
verifierLignes(G):-G\==[[],[],[],[],[],[],[]], construireLigne(G,[],[]). % Vérification des lignes, on arrête lorsqu'on a tous vérifier ce qui était possible de vérifier.


% Fonction récursive utilisée dans la fonction verifierLigne, qui permet de construire les lignes qui seront vérifiées.
/* Paramètres : G la grille contenant les lignes. */
construireLigne([[]|AC],L,RG):-append(L,[v],NL),append(RG,[[]], NRG),construireLigne(AC,NL,NRG). % Si le prochain élément de la ligne est vide.
construireLigne([[PE|RC]|AC],L,RG):-append(L,[PE],NL),append(RG,[RC], NRG),construireLigne(AC,NL,NRG). % S'il y a un jeton.
construireLigne([],[PE|RL],RG):-verifierLigne(PE, RL, 1); verifierLignes(RG). % Une fois que l'on a fini l'extraction de la ligne.


% Fonction récursive qui permet de vérifier si une colonne de 4 jetons est formée.
/*
* On retourne vrai si on obtient 4 jetons de la même valeurs de suite en vertical.
* [param] PE = Premier élément
* [param] ED = Élément différent
* [param] RC = Reste de la colonne
* [param] AC = Autre colonnes
* [param] PC = Première colonne
* [param] N et N1 = Valeur incrémental, représente le nombre de jetons similaires que l'on a trouvé dans une colonne
*/
verifierColonne(_,_,4). % Retourne vrai si on a trouvé 4 jetons similaires de suite.
verifierColonne(PE, [PE|RC], N):-N1 is N+1, verifierColonne(PE, RC, N1). % Si l'élément actuel est similaire au prochain élément.
verifierColonne(X, [Y|RC], _):- X\==Y, verifierColonne(Y, RC, 1). % Si l'élément actuel est différent du prochain élément.
verifierColonnes([[]|AC]):-verifierColonnes(AC). % Si on a une colonne vide.
verifierColonnes([[PE|PC]|AC]):-verifierColonne(PE, PC, 1); verifierColonnes(AC). % Fonction récursive.


% Fonction qui utilise les fonction verifierColonnes et verifierLignes pour vérifier si un état final est atteint (connection de 4 jetons à l'horizontale ou à la verticale).
/* Paramètres : G grille à vérifier */
verifierEtatFinal(G):-verifierColonnes(G);verifierLignes(G).


/* ----- AFFICHAGE ET EXÉCUTION DU JEU ----- */

% Fonction qui permet la saisie d'un jeton dans la grille par l'utilisateur.
/* Paramètres : X, la valeur retournée par l'utilisateur */
choixColonneJeton(X) :- write("Choix colonne : \n"), read(X).

% Fonction qui retourne dans 'E' l'élément à l'index N de la liste L.
/* Paramètres : N l'index de la liste, L la liste, 'E' caractère à l'index N */
returnElm(N,L,E):- length(L, N1), N1>=N, nth1(N, L, E).


% Fonction qui retourne un caractère d'espacement lorsque l'index N depasse la longueure de la liste L.
/* Paramètres : N l'index de la liste, L la liste, ' ' caractère d'espacement */
returnElm(N,L,' '):- length(L, N1), N1<N.


% Fonctions qui affiche l'élément E dans la console.
/* Paramètres : E élément à afficher, C l'index de la colonne de la grille */
afficherElm(E,C):- C=:=1, write('|'),write(E),write('|').
afficherElm(E,C):- C>1, write(E),write('|').


% Fonction récursive qui affiche une ligne de la grille.
/* Paramètres : G la grille, N,N0 les longueures des listes intérieures, C le nombre de colonne  */
afficherCouche(_,_,_,0).
afficherCouche(G,N,N0,C):- N>0,C>0, C1 is C-1,afficherCouche(G,N,N0,C1), nth1(C, G, L),N3 is (N0+1)-N, returnElm(N3,L,E), afficherElm(E,C).


% Fonction récursive qui affiche la grille.
/* Paramètres : G la grille, N,N0 les longueures des listes intérieures  */
afficherGrille(_,0,_).
afficherGrille(G,N,N0):- N>0, N1 is N-1, afficherGrille(G,N1,N0), length(G,C), afficherCouche(G,N,N0,C), write('\n').
afficherGrille(G):-afficherGrille(G,6,6).

% Fonction récursive qui indique que la grille est rempli
/* Paramètres : G la grille */                
grilleRemplie([C|[]]):- length(C, L), L =:=6. %condition d'arret lorsque toutes les colonnes de la grille ont été lues
grilleRemplie([C|AC]) :- length(C, L), L =:=6, grilleRemplie(AC). %vérification de la longueur de chaque colonne de la grille

/* VALEUR HEURISTIQUE */


% Fonctions permettant de calculer la valeur heuristique horizontale.
/*
* On retourne la somme de toutes les valeurs heuristiques horizontales.
* [param] PE = Premier élément
* [param] DE = Deuxième élément
* [param] TE = Troisième élément
* [param] QE = Quatrième élément
* [param] NJ = Nombre de jetons similaires consécutifs
* [param] V, V1 et V2 = Valeur heuristique
* [param] RL = Reste de la ligne
* [param] RG = Reste de la grille
* [param] NL = Reste de la ligne
* [param] J = Type de jeton
* [param] L = Ligne
* [param] G = Grille
* [param] NC et NC1 = Numéro de colonne
*/
valeurConteneur([],_,NJ,V):-NJ=<1, V is 0. %Fin du conteneur, si on a un jeton ou moins de suite, valeur heuristique de 0
valeurConteneur([],_,NJ,V):-NJ==2, V is 5. %Fin du conteneur, si on a 2 jetons de suite, valeur heuristique de 5
valeurConteneur([],_,NJ,V):-NJ==3, V is 50. %Fin du conteneur, si on a 3 jetons de suite, valeur heuristique de 50
valeurConteneur([],_,NJ,V):-NJ==4, V is 5000. %Fin du conteneur, si on a 4 jetons de suite, victoire donc valeur heuristique de 5000
valeurConteneur([J|RL],J,NJ,V):-NJ1 is NJ+1, valeurConteneur(RL,J, NJ1,V). % On incrémente le nombre de jeton du joueur actuel dans le conteneur
valeurConteneur([v|RL],J,NJ,V):-valeurConteneur(RL, J, NJ,V). %Si nous avons un 'v' (pour vide), on ignore et passe à l'élément suivant
valeurConteneur([X|_],J,_,V):-X\==J, V is 0. % Si notre conteneur contient un jeton de l'adversaire, il n'est pas possible d'avoir une suite de 4 jetons et donc la valeur heuristique est de 0

valeurLigne([PE|[DE|[TE|QE]]],NC,J,V):-NC==4, valeurConteneur([PE|[DE|[TE|[QE]]]],J,0,V). %Si nous calculons la valeur du dernier conteneur de 4 éléments de la ligne
valeurLigne([PE|[DE|[TE|[QE|RL]]]],NC,J,V):-valeurConteneur([PE|[DE|[TE|[QE]]]],J,0,V1),NC1 is NC+1, valeurLigne([DE|[TE|[QE|RL]]],NC1,J,V2), V is V1+V2. %On calcule chaque groupe de 4 éléments dans une ligne

construireLigne([[]|AC],L,RG,J,V):-append(L,[v],NL),append(RG,[[]], NRG),construireLigne(AC,NL,NRG,J,V). %Si le prochain élément de la ligne est vide, on ajoute une jeton "v" pour signifier que c'est un élément vide
construireLigne([[PE|RC]|AC],L,RG,J,V):-append(L,[PE],NL),append(RG,[RC], NRG),construireLigne(AC,NL,NRG,J,V). %S'il y a un jeton 
construireLigne([],L,RG,J,V):-valeurLigne(L,1,J,V1), valeurLignes(RG,J,V2), V is V1+V2. %Une fois que l'on a fini l'extraction de la ligne

/*
* Pour calculer la valeur heuristique horizontale, nous devons construire chaque ligne une à une et ensuite calculer individuellement la valeur heuristique de chaque ligne construite.
*/
valeurLignes(G,J,V):-G\==[[],[],[],[],[],[],[]], construireLigne(G,[],[],J,V). 
valeurLignes(_,_,V):-V is 0. %Si on reçoit une grille vide, la valeur heuristique est de 0


% Fonctions permettant de calculer la valeur heuristique verticales.
/*
* [param] PE = Premier élément
* [param] NJ = Nombre de jetons similaires consécutifs
* [param] V, V1 et V2 = Valeur heuristique
* [param] RC = Reste de la colonne
* [param] AC = Autres colonnes
* [param] RG = Reste de la grille
* [param] NL = Reste de la grille
* [param] J = Type de jeton
* [param] JA = Type de jeton adversaire
* [param] N et N1 = Nombre de jetons similaires consécutifs
* [param] G = Grille
*/

/*
* Si, lors de l'analyse d'une colonne, on tombe sur un jeton adversaire, alors il faut l'ignorer et passer au prochain élément jusqu'à qu'on revienne à notre propre jeton/
*/
passerJetonAdversaire(_, [], V, _):- V is 0. %Si on arrive à la fin de la colonne, alors on retourne une valeur heuristique de 0 car on a aucun jeton de suite.
passerJetonAdversaire(JA, [J|RC], V, _):-JA\==J, valeurColonne(J, RC, V, 1). %Si le prochain élément n'est pas le jeton adversaire, alors on revient au calcule de notre valeur heuristique
passerJetonAdversaire(JA, [JA|RC], V, _):-passerJetonAdversaire(JA, RC, V, 1). %On passe au prochain élément si c'est encore le jeton adversaire qui suit.

valeurColonne(_,[],V,N):-N==1, V is 0. %Fin de la colonne, si on a un jeton de suite, valeur heuristique de 0
valeurColonne(_,[],V,N):-N==2, V is 5. %Fin de la colonne, si on a 2 jeton de suite, valeur heuristique de 5
valeurColonne(_,[],V,N):-N==3, V is 500. %Fin de la colonne, si on a 3 jeton de suite, valeur heuristique de 500
valeurColonne(_,[],V,N):-N==4, V is 5000. %Fin de la colonne, si on a 4 jeton de suite, victoire et valeur heuristique de 5000
valeurColonne(J,[J|RC],V,N):-N1 is N+1, valeurColonne(J, RC, V, N1). %On incrémente le nombre de jeton de suite si c'est le même jeton
valeurColonne(J,[Y|RC],V,_):-J\==Y,passerJetonAdversaire(Y, RC, V, 1). %Si le prochain jeton est un jeton adversaire, on cesse de calculer la valeur heuristique et on retire tout les jetons adversaires qui suivent

valeurColonnes([],_,V):-V is 0. %Si la prochaine colonne est vide et qu'on est à la fin de la grille, on retourne une valeur heuristique de 0
valeurColonnes([[]|AC],J,V):-valeurColonnes(AC,J,V1), V is V1. %Si la prochaine colonne est vide, on passe à la prochaine colonne
valeurColonnes([[J|RC]|AC],J,V):-valeurColonne(J, RC, V1, 1), valeurColonnes(AC,J,V2), V is V1+V2. %Si la colonne commence par notre jeton, alors on calcule la valeur de la colonne et on passe à la colonne suivante
valeurColonnes([[_|RC]|AC],J,V):-valeurColonnes([RC|AC], J, V). %Si la colonne commence par le jeton de l'adversaire, alors on le retire afin de ne pas l'inclure dans notre analyse de la colonne.
    
valeurHeuristique(G,J,V):-valeurColonnes(G,J,V1),valeurLignes(G,J,V2),V is V1+V2. %Calcule de la valeur heuristique d'un joueur avec un jeton J, on calcule la valeur heuristique des colonnes et ensuite des lignes et on additionne.
valeurHeuristiqueTotal(G,V):-valeurHeuristique(G,x,V1),valeurHeuristique(G,o,V2),V is V1-V2. %Calcule la valeur heuristique totale d'un état, on calcule la valeur heuristique du joueur MAX (x) et ensuite du joueur MIN (o) et on soustrait.

/* GÉNÉRATION ARBRE */


% Fonctions permettant la génération de l'arbre de décision et l'obtention de la colonne à jouer.
/*
* [param] G = Grille
* [param] NG = Nouvelle grille
* [param] VH = Valeur heuristique
* [param] EA = Étage de l'arbre où l'on est actuellement
* [param] EF & E = Étage final de l'arbre
* [param] NE = Nouvel étage
* [param] J = Type de jeton
* [param] C = Le numéro de colonne
* [param] CJ = Colonne à jouer par l'IA
* [param] VH1, VH2.....VH7 = Valeurs heuristiques obtenues des noeuds suivants
*
*
* [param] CL, CL1 et CL2 = Colonnes a vérifier
* [param] RL = Reste de la ligne
* [param] G = Grille
*/


generationNoeudMin(G,_,_,EA,EA,VH):-valeurHeuristiqueTotal(G,VH). %Si on est dans une feuille, on calcule simplement la valeur heuristique de l'état

%Si on ne peut pas ajouter un jeton, il n'est pas possible de générer plus de noeuds. On retourne une valeur heuristique -inf afin que celui-ci soit ignorer par MAX
generationNoeudMin(G,J,C,_,_,VH):-not(ajouterJeton(G,J,C,_)), VH is -inf. 

%Si on tombe sur un état final, alors on arrête de générer des noeuds et on retourne la valeur heuristique total de l'état.
generationNoeudMin(G,J,C,_,_,VH):-ajouterJeton(G,J,C,NG), verifierEtatFinal(NG), valeurHeuristiqueTotal(NG,VH).

%Génération des noeuds de l'état MIN. On génère les prochains noeuds pour chaque colonne, et on retourne ensuite la plus petite valeur heuristique possible (puisque cela représente un coup de MIN)
generationNoeudMin(G,J,C,EA,EF,VH):-EA\==EF, NE is EA+1,ajouterJeton(G,J,C,NG),  generationNoeudMax(NG,o,1,NE,EF,VH1),
                                                                                        generationNoeudMax(NG,o,2,NE,EF,VH2),
                                                                                        generationNoeudMax(NG,o,3,NE,EF,VH3),
                                                                                        generationNoeudMax(NG,o,4,NE,EF,VH4),
                                                                                        generationNoeudMax(NG,o,5,NE,EF,VH5),
                                                                                        generationNoeudMax(NG,o,6,NE,EF,VH6),
                                                                                        generationNoeudMax(NG,o,7,NE,EF,VH7),
                                                                                        min_list([VH1,VH2,VH3,VH4,VH5,VH6,VH7], VH).

generationNoeudMax(G,_,_,EA,EA,VH):-valeurHeuristiqueTotal(G,VH). %Si on est dans une feuille, on calcule simplement la valeur heuristique de l'état

%Si on ne peut pas ajouter un jeton, il n'est pas possible de générer plus de noeuds. On retourne une valeur heuristique inf afin que celui-ci soit ignorer par MIN
generationNoeudMax(G,J,C,_,_,VH):-not(ajouterJeton(G,J,C,_)), VH is inf.

%Si on tombe sur un état final, alors on arrête de générer des noeuds et on retourne la valeur heuristique total de l'état.
generationNoeudMax(G,J,C,_,_,VH):-ajouterJeton(G,J,C,NG), verifierEtatFinal(NG), valeurHeuristiqueTotal(NG,VH).

%Génération des noeuds de l'état MAX. On génère les prochains noeuds pour chaque colonne, et on retourne ensuite la plus grande valeur heuristique possible (puisque cela représente un coup de MAX)
generationNoeudMax(G,J,C,EA,EF,VH):-EA\==EF, NE is EA+1,ajouterJeton(G,J,C,NG), generationNoeudMin(NG,x,1,NE,EF,VH1),
                                                                                        generationNoeudMin(NG,x,2,NE,EF,VH2),
                                                                                        generationNoeudMin(NG,x,3,NE,EF,VH3),
                                                                                        generationNoeudMin(NG,x,4,NE,EF,VH4),
                                                                                        generationNoeudMin(NG,x,5,NE,EF,VH5),
                                                                                        generationNoeudMin(NG,x,6,NE,EF,VH6),
                                                                                        generationNoeudMin(NG,x,7,NE,EF,VH7),
                                                                                        max_list([VH1,VH2,VH3,VH4,VH5,VH6,VH7], VH).


/*
* Une méthode simple qui nous permet de récupérer la plus haute valeur heuristique à partir d'une liste de clés valeurs [colonne, valeur heuristique].
* On garde simplement la valeur la plus haute jusqu'à la fin de la fonction récursive, de manière similaire à un tri bulle.
* Une fois qu'on arrive à la condition de fin, on unifie la colonne avec la valeur heuristique la plus élevé avec la colonne à retourner.
*/
colonneAJouer([[CL,_]],C):-C is CL.
colonneAJouer([[CL1,VH1] |[[_,VH2]|RL]] ,C):-VH1 >= VH2, colonneAJouer([[CL1,VH1]|RL],C).
colonneAJouer([[_,VH1]|[[CL2,VH2]|RL]],C):-VH1 < VH2, colonneAJouer([[CL2,VH2]|RL],C).
                            

/*
* Début de génération de l'arbre. On génère un arbre de E étages, ce qui nous retourne une valeur heuristique pour chaque colonne possible (VH1, VH2, etc).
* CJ représente la colonne optimal à jouer pour l'IA, est récupéré à partir de la valeur heuristique maximale qui est possible de jouer à partir de tous les coups possible.
*/
generationArbre(G,E,CJ):-   generationNoeudMin(G,x,1,1,E,VH1),
                            generationNoeudMin(G,x,2,1,E,VH2),
                            generationNoeudMin(G,x,3,1,E,VH3),
                            generationNoeudMin(G,x,4,1,E,VH4),
                            generationNoeudMin(G,x,5,1,E,VH5),
                            generationNoeudMin(G,x,6,1,E,VH6),
                            generationNoeudMin(G,x,7,1,E,VH7),
                            colonneAJouer([[1,VH1],[2,VH2],[3,VH3],[4,VH4],[5,VH5],[6,VH6],[7,VH7]],CJ).

% Fonction qui permet la saisie de la difficulté par l'utilisateur.
/* Paramètres : C, la valeur retournée par l'utilisateur */
connect4Difficulte(C) :- write("Choisir la difficulté (1 - Facile, 2 - Difficile) : \n"), read(D), (D = 1 -> C is 2; D = 2 -> C is 3; connect4Difficulte(C)).


% Fonctions qui permettent le lancement du jeu et l'alternance entre joueur et IA.
/* Paramètres : ne prends pas de paramètres à l'entrée, les fonctions d'exécution alternent en fonction des entrées reçues. */
connect4JoueurO(G,CMax) :-  verifierEtatFinal(G), write("Vous avez été battu par l'IA!"); %Si le coup précédent de l'ordinateur a amené vers un état final
                            grilleRemplie(G),write("La partie est nulle!"); %Si la grille est remplie
                            choixColonneJeton(C),(not(ajouterJeton(G,o,C,_)),write("Veuillez choisir une autre colonne.\n"),connect4JoueurO(G,CMax); %On demande au joueur humain de faire un coup dans le jeu. Si la colonne choisie est remplie, on redemande.
                            ajouterJeton(G,o,C,NG),afficherGrille(NG),write("\n"),connect4JoueurX(NG,CMax)). %on ajoute le jeton, on affiche la grille et on passe la main à l'IA

connect4JoueurX(G,CMax) :-  verifierEtatFinal(G), write("Vous avez battu l'IA!"); %Si le coup précédent du joueur humain a amené vers un état final
                            grilleRemplie(G),write("La partie est nulle!"); %Si la grille est remplie
                            write("Joueur ordinateur: \n"), generationArbre(G,CMax,C), ajouterJeton(G,x,C,NG),afficherGrille(NG),write("\n"), connect4JoueurO(NG,CMax). %L'ordinateur joue son coup et passe la main au joueur humain

connect4() :- connect4Difficulte(C),connect4JoueurX([[],[],[],[],[],[],[]],C).

















