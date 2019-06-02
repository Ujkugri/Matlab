**Konsensbestimmung mit Eulervorwärtsverfahren**

Matlabimplementierung mit Eulervorwärtsverfahren zum Paper "HETEROPHILIOUS  DYNAMICS  ENHANCES  CONSENSUS" 
von SEBASTIEN MOTSCH und EITAN TADMOR, welches man [hier](https://arxiv.org/pdf/1301.4123.pdf) lesen kann.
<br>
<br>
<br>
**Das zugrunde liegende Problem**
<br>
<br>
Nach einer Filmvorstellung wird von allen Zuschauern eine Bewertung des Films auf einer Skala von 0 bis 10 abgegeben.
Danach werden die Zuschauer in einen Raum gebeten und sollen sich über diesen Film unterhalten. 
Nach einiger Zeit werden die Zuschauer wieder um eine Bewertung des Films gebeten.
Frage: Ist nun ein Konsens entstanden, d.h. geben alle Zuschauer die gleiche Bewertung ab?
<br>
<br>
<br>
**Mathematische Grundlage**
<br>
<br>
Wir betrachten folgendes Differentialgleichungssystem:

<p align="center">
  <img src="http://latex.codecogs.com/gif.latex?%5Cfrac%7Bd%7D%7Bdt%7D%5Ctextbf%7Bp%7D_i%20%3D%20%5Csum%5Climits_%7Bj%5Cneq%20i%7Da_%7Bij%7D%28%5Ctextbf%7Bp%7D_j%20-%20%5Ctextbf%7Bp%7D_i%29%20%5Cqquad%20a_%7Bij%7D%5Cgeq%200">

  
Hierbei ist p_i(t) die Meinung der Person i zum Zeitpunkt t, ![](http://latex.codecogs.com/gif.latex?%5Calpha) ein Skalierungsfaktor und ![](http://latex.codecogs.com/gif.latex?a_%7Bij%7D) der Einflussfaktor zwischen Person i und j.
Nun ist es möglich, dieses Modell durch einsetzen von Einflussfunktion mit Hilfe des Eulervorwärtsverfahren zu lösen.
Dafür wurden drei Programme erstellt:
<br>
<br>
<br>
**Implementierung**
<br>
<br>
Konsens_v1 ist die erste Version.
Ziel dieses Codes war es, den Unterschied der Schrittweite zu visualisieren.
Hierfür wurde

<p align="center">
  <img src="http://latex.codecogs.com/gif.latex?a_%7Bij%7D%20%3D%20%5Cfrac%7B%5CPhi%28%5Cvert%20%5Ctextbf%7Bp%7D_j%20-%20%5Ctextbf%7Bp%7D_i%20%5Cvert%29%29%7D%7BN%7D">

gesetzt, mit ![](http://latex.codecogs.com/gif.latex?%5CPhi%28%20%5Ccdot%20%29) als Einflussfunktion und N als Gesamtzahl der Zuschauer. 

Das Ergebnis sieht dann wie folgt aus:

![Konsens_v1](https://github.com/GentianRrafshi/Matlab/blob/master/Konsens/docs/Konsens1_110s.png)

Wobei die obere Reihe eine Schrittweite von h=0.1 und die untere Reihe eine Schrittweite von h=1.
