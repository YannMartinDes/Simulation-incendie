;extensions [array]

globals[
  x-setup-cor
  y-setup-cor
  liste-setup-turtles
  SORTIE1 ;; contient le patch du milieu de la sortie 1
  SORTIE2 ;; "" de la sortie 2
  SORTIEM ;; "" de la sortie du millieu
  nombre_de_personnes
  MAX_CAP ;; capacité totale des sièges
  STEP ;; distance parcourue par les turtles à chaque tick
  BEGIN
  FILENAME
  NBMORT
]


;; -------------------------------------------------- SETUP -------------------------------------------------
;; ----------------------------------------------------------------------------------------------------------

to Setup
 set NBMORT 0
 clear-all
 set MAX_CAP 120
 set STEP 1
 set BEGIN 1
 set nombre_de_personnes round (densité * MAX_CAP)
 print "Setting Up Model"
 Setup-patches
 Setup-turtles
 if(FireOn = true)[SpawnFire]
 if(TerroristOn = True)[SpawnTerro]
 ;;ask patches with [pycor = 17 and pxcor = 28] [set pcolor 65]
 reset-ticks
end

to Setup-patches
  ask patches [ set pcolor grey]
  Setup-patches-walls
  ifelse(CenterExit)[Setup-center-exit]
  [Setup-patches-exits
  Setup-patches-scene]
  Setup-patches-chairs
  Setup-patches-way
end


to Setup-center-exit
  set SORTIEM (patch 14 30)
  ask patch 13 30 [set pcolor 45]
  ask patch 14 30 [set pcolor 45]
  ask patch 15 30 [set pcolor 45]

if(wall)[

  ask patch 14 26 [set pcolor black]
  ask patch 14 27 [set pcolor black]

  ask patch 15 26 [set pcolor black]
  ask patch 15 27 [set pcolor black]


  ask patch 13 26 [set pcolor black]
  ask patch 13 27 [set pcolor black]

  ]

end

to Setup-patches-chairs
  let x-cor 4
  let y-cor 2
  while [y-cor < 20]
  [
    while [x-cor < 27]
    [
        if (x-cor < 13) or (x-cor > 15) [
           ask patch x-cor y-cor [set pcolor red]
        ]
        set x-cor x-cor + 1
    ]
    set y-cor y-cor + 3
    set x-cor 4
  ]
end

to Setup-patches-scene
  let x-cor 1
  let y-cor 25
  while[y-cor < 30]
  [
    while[x-cor < 30]
    [
      ifelse (y-cor < 29) and (y-cor > 25)
          [ifelse (x-cor < 4) or (x-cor > 26)
              [ask patch x-cor y-cor [set pcolor black]]
            [ask patch x-cor y-cor [set pcolor 9.2]]

      ]
          [ask patch x-cor y-cor [set pcolor black]]
      set x-cor x-cor + 1
    ]
    set y-cor y-cor + 1
    set x-cor 1
  ]
end

to setup-patches-walls
 ; draw left and right walls
  ask patches with [(pxcor = max-pxcor) or (pxcor = 0)]
    [ set pcolor 2 ]
  ; draw top and bottom walls
  ask patches with [(pycor = max-pycor) or (pycor = 0)]
    [ set pcolor 2 ]
end


to Setup-patches-exits
  ask patch 0 20 [set pcolor 45]
  ask patch 0 21 [set pcolor 45]
  set SORTIE1 (patch 0 21)
  ask patch 0 22 [set pcolor 45]

  if(NB_EXIT > 1)
     [ ask patch max-pxcor 20 [set pcolor 45]
       ask patch max-pxcor 21 [set pcolor 45]
       set SORTIE2 (patch max-pxcor 21)
       ask patch max-pxcor 22 [set pcolor 45]
     ]

end

to Setup-patches-way
  ask patches with [(pxcor > 0) and (pxcor < 4) and (pycor > 0) and ( pycor < 18)]
    [ set pcolor 4]
  ask patches with [(pxcor > 12) and (pxcor < 16) and (pycor > 0) and ( pycor < 18)]
    [ set pcolor 4]
  ask patches with [(pxcor > 26) and (pxcor < 30) and (pycor > 0) and ( pycor < 18)]
    [ set pcolor 4]

  ;ask patches with [pxcor = 2 and (pycor > 0) and ( pycor < 18)]
  ;  [ set pcolor 43]
  ;ask patches with [pxcor = 14 and (pycor > 0) and ( pycor < 18)]
  ;  [ set pcolor 43]
  ;ask patches with [pxcor = 28 and (pxcor < 30) and (pycor > 0) and ( pycor < 18)]
  ;  [ set pcolor 43]
end

to Setup-turtles

  create-turtles nombre_de_personnes
  ;; creation d'une liste de 6 liste de 20 objets pour representer les 6 rangées de 20 sièges
  ;; on initialise à 0 pour place vide, et 1 si occupée
  set liste-setup-turtles n-values 6 [0]
  foreach n-values 6 [i -> i ] [i -> set liste-setup-turtles (replace-item i liste-setup-turtles n-values 27 [0])]

  ask turtles [
    Setup-turtles-random-cors
    while [(item x-setup-cor (item round((y-setup-cor / 3) - 1) liste-setup-turtles)) = 1]
    [
      Setup-turtles-random-cors
    ]
    ;;la case est maintenant occupée
    set liste-setup-turtles (replace-item round((y-setup-cor / 3) - 1) liste-setup-turtles (replace-item x-setup-cor (item round((y-setup-cor / 3) - 1) liste-setup-turtles) 1))
    set size 0.95
    set shape "person"
    setxy x-setup-cor y-setup-cor
    set color blue
  ]
    if(surpopulation)[
    ask patches with [(pycor = 3) or (pycor = 6) or (pycor = 9)
      or (pycor = 12) or (pycor = 15) and (pcolor = grey)] [
      sprout 1 [set color blue set shape "person" set size 0.95]
    ]
  ]
end

to Setup-turtles-random-cors
  let x-cor 0
  let y-cor 0
  while [(x-cor > 12) and (x-cor < 16) or (x-cor < 4) or (x-cor > 26) or (x-cor = 0)]
  [
    set x-cor random(30)
  ]
  while [(y-cor mod 3 != 2) or (y-cor > 17) or (y-cor = 0)]
  [
    set y-cor random(30)
  ]
  set x-setup-cor x-cor
  set y-setup-cor y-cor
end

;; cette fonction va calculer la distance entre une turtle et chaque exit pour trouver la plus proche
to-report GetDistanceExit[exit]
  report (distance exit)
end



;; ------------------------------------------------------------------------------ MOUVEMENT TURTLE ----------------------------------------------------------
;; ----------------------------------------------------------------------------------------------------------------------------------------------------------


;; Renvoie 1 si la turtle est plus proche de la sortie 1
;; Rebvoie 2 si la turtle est plus proche de la sortie 2
to-report Get-Closest-Exit
  ifelse(CenterExit)[
  report SORTIEM]

  [let min_d 100
  let sortie nobody

  if([pcolor] of  SORTIE1 != orange)[
    set sortie SORTIE1
    set min_d GetDistanceExit SORTIE1]

  if (NB_EXIT > 1 and [pcolor] of SORTIE2 != orange )
      [let t GetDistanceExit SORTIE2
        if (t < min_d)
            [set sortie SORTIE2]
      ]
    report sortie]



end


;; Renvoie 1 si il n'y a personne dans son premier champ de vision
;; Renvoie 2 si il n'y a personne dans le champ de gauche, 3 si personne dans le champ de droite
;; Renvoie -1 si pas mouvement
to-report Accessible
 ;; utiliser in-radius // in-cone
  let res count(turtles in-cone 1.5 50)
  if(res < 2)[report 1]
  report -1
end


to-report IsObstacleFree
  ;;Renvoie 0 si le patch visé est libre sinon 1
  ;;show ([pcolor] of patch-ahead STEP)
  ifelse(patch-ahead STEP != nobody)[
  ifelse (([pcolor] of patch-ahead STEP = 15) or ([pcolor] of patch-ahead STEP = 2) or ([pcolor] of patch-ahead STEP = orange)
    or ([pcolor] of patch-ahead STEP = black))
    [report 1] [report 0]
  ][report 1]

end

to ChangeDir;; change the direction of turtle is there is an obstacle
  let i 0
 while[IsObstacleFree != 0 and i < 100 and (((count neighbors4 with [pcolor = orange]) != 4) or
    (((count neighbors4 with [pcolor = orange]) != 3) and ((count neighbors4 with [pcolor = red]) != 1)))]
 [
  set heading heading + ((random 40) - 20)
   set i i + 1 ;;Fait que personne ne se retrouver bloque a l'infini
  ;; while there is an obstacle in the direction of turtle, try again with header +- 10, depending on exit direction
  ;; TODO, if faster, change direction in the opposit direction of exit (if next to the center corridor typically)
  ;;ifelse (heading > 0 and heading < 180) [set heading heading + 10]
  ;;[set heading heading - 10]
  ]
end

to Circumvent  ;; change the turtle's direction to avoid another turtle ---------- TODO c'est cette fonction qui marche pas si jamais
  let i 5
  let flag 0
  let exit Get-Closest-Exit
  let r random 2

  While[(flag = 0) and (i < 90)]  ;; i > 180 pour eviter les boucles infinies
  [
    ifelse(r = 1)[
      set heading heading - i]
    [ set heading heading + i]
    ifelse(Accessible != 1) [
      ifelse(r = 1)[
        set heading heading + (i * 2)]
      [ set heading heading - (i * 2)]
      ifelse(Accessible != 1) [
        set i (i + 5)
      ][
        set flag 1
      ]
    ][
      set flag 1
    ]
  ]
  if(flag = 0)[ face exit]
end

to TryMovement
  ifelse(IsObstacleFree = 0)
  [ifelse(Accessible = 1) [fd STEP] [
     Circumvent if((Accessible = 1) and (IsObstacleFree = 0))[fd STEP]]] ;; pas de siège devant: on tente d'avancer si personne devant
    [ChangeDir if(Accessible = 1) [fd STEP]] ;;Is obstacle free plutot ?
end


;; En fonction de la sortie la plus proche (obtenue avec Get-Closest-Exit-Distance), fait avancer les turtles en prennant en compte les cases inacessibles.
to Move
  ask turtles [
    let exit Get-Closest-Exit

    if(exit = SORTIE1)[EstArrivé SORTIE1]
    if(exit = SORTIE2) [EstArrivé SORTIE2]
    if(exit = SORTIEM) [EstArrivé SORTIEM]

    ;;show(exit)
    ask turtles-on patches with [pcolor = 4] [if(([pcolor] of patch-ahead STEP != orange))[set heading 0]]
    ask turtles with [ycor > 17] [face exit]
    TryMovement

    ]
end

to EstArrivé [exit]
  if((distance exit) < 0.5)[die] ;; marge d'erreur: distance inférieur à 1xy
end

to Better-way
  let min-d 60
  let way1 (distancexy 2 17)
  let way2 (distancexy 14 17)
  let way3 (distancexy 28 17)

  if(way1 < min-d)[set min-d way1]
  if(way2 < min-d)[set min-d way2]
  if(way3 < min-d)[set min-d way3]

  if(min-d = way1)[facexy 2 17]
  if(min-d = way2)[facexy 14 17]
  if(min-d = way3)[facexy 28 17]

end

;; ------------------------------------------------------------------------------- OBSTACLES -----------------------------------------------------
;; -----------------------------------------------------------------------------------------------------------------------------------------------
to SpawnFire
  ifelse(fire_start = 1)
  [let x-cor (random 29) + 1
    let y-cor (random 7) + 17
    while[([pcolor] of patch x-cor y-cor)!= grey][
      set x-cor (random 29) + 1
      set y-cor (random 7) + 17
    ]
    ask patch x-cor y-cor [set pcolor orange]]
  [
    ifelse(fire_start = 2)[let x-cor (random 29) + 1
      let y-cor (random 17) + 1
      while[([pcolor] of patch x-cor y-cor)!= grey][
        set x-cor (random 29) + 1
        set y-cor (random 17) + 1
      ]
      ask patch x-cor y-cor [set pcolor orange]
    ]

    [let x-cor (random 29) + 1
      let y-cor (random 29) + 1
      while[([pcolor] of patch x-cor y-cor)!= grey][
        set x-cor (random 29) + 1
        set y-cor (random 29) + 1
      ]
      ask patch x-cor y-cor [set pcolor orange]]
  ]

end

to SpreadFire
  ask patches with[pcolor = orange][
    ask neighbors4 [ if((random 15) = 3)[ set pcolor orange ]]
  ]

end

to SpawnTerro ;; MARCHE PAS SI TERRO SUR PREMIER RANG
  let t (random nombre_de_personnes)
  ask turtle t [set color pink]
end

to TerroristMove    ;; Move to the middle of the cinema and blow himself when in position
  ask turtles with[color = pink][
    ifelse(patch-here != patch 14 10)[
      face patch 14 10
      TryMovement
    ][
      ask patches in-radius 4
      [ set pcolor orange ]
      ask turtles in-radius 5
      [die]
      die
    ]
  ]
end
;; -------------------------------------------------------------------------------- STATS ---------------------------------------------------------
;; ------------------------------------------------------------------------------------------------------------------------------------------------

;; setupFile pour le temps total d'évacuation
to SetupFile1
  set FILENAME "cine_data1.csv"
  if(file-exists? FILENAME)[file-delete FILENAME]
  file-open FILENAME
end

to SetupFile2
  set FILENAME "cine_data2.csv"
  if(file-exists? FILENAME)[file-delete FILENAME]
  file-open FILENAME
end

to SetupFile3
  set FILENAME "cine_data3.csv"
  if(file-exists? FILENAME)[file-delete FILENAME]
  file-open FILENAME
end

;; Ecrit dans
to DataExport1 [simuNumber]
  print simuNumber
  if(count turtles = 0) [print ticks
    file-type simuNumber file-type "," file-print ticks]
end

to DataExport2
  let surpop 0
  let reste (count turtles)
  if(surpopulation)[set surpop 100]
  let nb-evac (nombre_de_personnes + surpop - reste - NBMORT)
  file-type ticks file-type "," file-type NBMORT file-type "," file-print nb-evac
end

to DataExport3 [simuNumber]
  file-type simuNumber file-type "," file-print NBMORT
end

to DataExport4
  file-type densité file-type "," file-print ticks
end

to I_want_you_to_die_in_fire
  ask turtles-on patches with [pcolor = orange] [
    set NBMORT (NBMORT + 1)
    die]
end


;; ------------------------------------------------------------------------------------ GO -----------------------------------------------------------
;; ---------------------------------------------------------------------------------------------------------------------------------------------------

to Go
  if(BEGIN = 1)[ask turtles with[ycor < 16] [Better-way]
    ask turtles with[ycor = 17] [set heading 0]
    set BEGIN 0]

  ifelse(TerroristOn = True) [
    ifelse(count turtles with[color = pink] = 0)[
      Move
      tick
    ][
      TerroristMove
    ]
    ;;if no terrorist
  ]
  [
    Move
    tick
  ]
  SpreadFire
  I_want_you_to_die_in_fire

end

to Go-record
  SetupFile3
  while[count turtles > 0][
    Go
    DataExport2
  ]
  file-close
end

to simuloop
  let NBXP 20 ;; repeat NBXP simulations
  let simuNumber 1
  SetupFile1
  repeat NBXP[
    Setup
    while[count turtles > 0][Go]
    ;1 ou 3
    DataExport3 simuNumber
    set simuNumber simuNumber + 1
  ]
  file-close

end

to simuloop2
  let simuNumber 1
  set densité 0
  SetupFile2
  while[densité < 1][
    print simuNumber
    set densité (densité + 0.02)
    setup
    while[count turtles > 0][Go]
    DataExport4
    set simuNumber simuNumber + 1
  ]

  file-close

end






































to Test
  ;let liste [1 2 3]
  ;foreach liste show
  ;set liste replace-item 1 liste 5
  ;foreach liste show
  ;show round ((2 / 3) -  1)
  ; remplacer dans la liste la troisième ligne, 2ème colone par 50
  ;set liste-setup-turtles (replace-item 3 liste-setup-turtles (replace-item 2 (item 3 liste-setup-turtles) 50))

end
@#$#@#$#@
GRAPHICS-WINDOW
222
10
633
422
-1
-1
13.0
1
10
1
1
1
0
0
0
1
0
30
0
30
0
0
1
ticks
30.0

BUTTON
11
10
75
43
Setup
Setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
6
117
178
150
densité
densité
0
1
0.68
0.01
1
NIL
HORIZONTAL

SLIDER
6
152
178
185
NB_EXIT
NB_EXIT
1
2
2.0
1
1
NIL
HORIZONTAL

BUTTON
81
11
144
44
NIL
Go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
6
60
61
93
Simuloop
Simuloop
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
112
192
215
225
FireOn
FireOn
1
1
-1000

SWITCH
5
194
103
227
CenterExit
CenterExit
1
1
-1000

SWITCH
4
230
103
263
wall
wall
1
1
-1000

BUTTON
64
61
157
94
Simuloop graphe 
Simuloop2\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
161
61
216
94
Go record
Go-record
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
106
229
220
262
surpopulation
surpopulation
1
1
-1000

SLIDER
4
279
176
312
fire_start
fire_start
0
2
2.0
1
1
NIL
HORIZONTAL

SWITCH
11
340
130
373
TerroristOn
TerroristOn
1
1
-1000

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
