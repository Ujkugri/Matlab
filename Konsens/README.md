Matlabimplementierung mit Eulervorwärtsverfahren zum Paper "HETEROPHILIOUS  DYNAMICS  ENHANCES  CONSENSUS" 
von SEBASTIEN MOTSCH und EITAN TADMOR, welches man [hier](https://arxiv.org/pdf/1301.4123.pdf) lesen kann.


**Das zugrunde liegende Problem**

Nach einer Filmvorstellung wird von allen Zuschauern eine Bewertung des Films auf einer Skala von 0 bis 10 abgegeben.
Danach werden die Zuschauer in einen Raum gebeten und sollen sich über diesen Film unterhalten. 
Nach einiger Zeit werden die Zuschauer wieder um eine Bewertung des Films gebeten.
Frage: Ist nun ein Konsens entstanden, d.h. geben alle Zuschauer die gleiche Bewertung ab?


**Mathematische Grundlage**

![](http://latex.codecogs.com/gif.latex?%5Cfrac%7Bd%7D%7Bdt%7D%5Ctextbf%7Bp%7D_i%20%3D%20%5Calpha%20%5Csum%5Climits_%7Bj%5Cneq%20i%7D%20a_%7Bij%7D%28%5Ctextbf%7Bp%7D_j-%5Ctextbf%7Bp%7D_i%29)


Sie besteht aus drei Programmen:



Konsens_v1 ist die erste Version.
Ziel dieses Codes war es, den Unterschied der Schrittweite zu visualisieren.


Das Ergebnis sieht so aus:


![Konsens_v1](https://github.com/GentianRrafshi/Matlab/blob/master/Konsens/docs/Konsens1_110s.png)

Wobei die obere Reihe eine Schrittweite von h=0.1 und die untere Reihe eine Schrittweite von h=1.
