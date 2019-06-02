Matlabimplementierung mit Eulervorwärtsverfahren zum Paper "HETEROPHILIOUS  DYNAMICS  ENHANCES  CONSENSUS" 
von SEBASTIEN MOTSCH und EITAN TADMOR, welches man [hier](https://arxiv.org/pdf/1301.4123.pdf) lesen kann.


**Das zugrunde liegende Problem**

Nach einer Filmvorstellung wird von allen Zuschauern eine Bewertung des Films auf einer Skala von 0 bis 10 abgegeben.
Danach werden die Zuschauer in einen Raum gebeten und sollen sich über diesen Film unterhalten. 
Nach einiger Zeit werden die Zuschauer wieder um eine Bewertung des Films gebeten.
Frage: Ist nun ein Konsens entstanden, d.h. geben alle Zuschauer die gleiche Bewertung ab?


**Mathematische Grundlage**



Sie besteht aus drei Programmen:



Konsens_v1 ist die erste Version.
Ziel dieses Codes war es, den Unterschied der Schrittweite zu visualisieren.


Das Ergebnis sieht so aus:


![Konsens_v1](https://github.com/GentianRrafshi/Matlab/blob/master/Konsens/docs/Konsens1_110s.png)

Wobei die obere Reihe eine Schrittweite von h=0.1 und die untere Reihe eine Schrittweite von h=1.