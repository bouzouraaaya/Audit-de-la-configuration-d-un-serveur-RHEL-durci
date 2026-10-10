# Audit de la configuration d'un serveur RHEL durci
Cahier des charges n° 13, classe 2, sujet 1. Cible : RHEL 9.8 (VM VMware, laboratoire isolé).

## Problématique
Un serveur RHEL durci respecte-t-il les critères A.8.9 et A.8.19 et un profil de durcissement ? Quels écarts restent, et dans quel ordre les traiter ?

## Référentiels
- Cahier des charges : A.8.9, A.8.19 et référentiel CIS RHEL.
- Profil scanné : ANSSI-BP-028 intermediary (référentiel français couvert par scap-security-guide). Le résultat d'un scan CIS niveau 1, s'il a été exécuté, figure dans docs/scores-openscap.md.
- A.8.9 et A.8.19 sont des reformulations d'aide à l'audit, à confirmer avec la norme.

## Outils
OpenSCAP, Lynis, scripts Bash (audit.sh, 16 contrôles, score pondéré), nmap (depuis une seconde VM), Git. Ansible n'a pas été utilisé : la remédiation a été appliquée avec oscap --remediate, règle par règle.

## Contenu
- docs/programme-audit.md : programme et plan d'audit
- docs/grille-audit.md, docs/matrice.md : grille et matrice
- docs/constats.md, docs/plan-actions.md, docs/EV-007-ecarts-priorises.md
- docs/rapport.md, docs/presentation-5min.md, docs/guides.md, docs/scenarios.md
- docs/index-preuves.md, docs/scores-openscap.md, docs/inventaire.md, docs/revue-documentaire.md, docs/entretien-cloture.md
- docs/correspondance-dossier-cdc.md : lien avec l'arborescence du cahier des charges
- evidence/avant, evidence/apres : preuves brutes. reports/ : sorties du script. checks/ : contrôles.

## Résultats clés
OpenSCAP : 87 puis 180 règles conformes sur 200 évaluées. Lynis : 67 puis 71. Un seul port TCP exposé (22).

## Limites
Voir docs/rapport.md, sections 10 et 10 bis.
