# Scores OpenSCAP

## Profil ANSSI-BP-028 intermediary
| Mesure | Avant | Final |
|---|---|---|
| Pass / fail (200 règles évaluées) | 87 / 113 | 180 / 20 |
| Conformité brute (pass / 200) | 43,5 % | 90 % |
| Score pondéré calculé par OpenSCAP (champ score du XML) | 60.820496 | 88.151711 |

Le score pondéré est celui d'OpenSCAP : chaque règle pèse selon sa sévérité, d'où l'écart avec le taux brut.

## Profil CIS niveau 1 serveur (état final)
| Pass | Fail | Non applicable | Score pondéré |
|---|---|---|---|
| 184 | 91 | 20 | 72.719261 |

Le durcissement visait le profil ANSSI : ce résultat CIS est présenté tel que mesuré, sans correction.

Conformité brute CIS L1 (pass / (pass + fail)) : 66,9 %, soit 184 sur 275 règles évaluées. Aucun scan CIS n'a été fait à l'état initial : aucun gain CIS ne peut être affirmé. Liste des écarts : evidence/apres/cis-l1-fail.txt.
