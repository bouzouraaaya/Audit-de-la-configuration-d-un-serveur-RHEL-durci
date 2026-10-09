#!/bin/bash
# Usage : ./score.sh fichier.csv
awk -F, 'NR>1 {
  w=1; if($3=="Critique")w=4; else if($3=="Élevée")w=3; else if($3=="Moyenne")w=2
  if($4=="PASS"){p++; pw+=w; tw+=w}
  else if($4=="FAIL"){f++; tw+=w}
}
END {
  printf "Contrôles : %d | PASS : %d | FAIL : %d\n", p+f, p, f
  printf "Conformité brute    : %.1f %%\n", 100*p/(p+f)
  printf "Conformité pondérée : %.1f %%\n", 100*pw/tw
}' "$1"
