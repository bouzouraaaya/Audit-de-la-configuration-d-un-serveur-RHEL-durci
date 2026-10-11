# Présentation de 5 minutes (L-05)
1. (30 s) Sujet, cible RHEL 9.8, référentiels (ANSSI-BP-028, CIS), outils.
2. (40 s) Méthode : audit initial, durcissement en vagues avec snapshots, audit final.
3. (60 s) Résultats : OpenSCAP ANSSI 43,5 % puis 90 % (pondéré 60,8 puis 88,2), Lynis 67 puis 71, CIS L1 66,9 % (aucune mesure initiale).
4. (45 s) Surface d'attaque : 4 services en écoute puis 2, un seul port ouvert (22/tcp, clé SSH).
5. (45 s) Démo en direct : sudo ./audit.sh (16 contrôles, score pondéré). Limite : mesuré après le durcissement.
6. (50 s) Constats : ANSSI non-conformité mineure, CIS non-conformité majeure, 20 écarts ANSSI priorisés en P1, P2 et P3.
7. (20 s) Plan d'actions : retirer l'interface graphique, politique de mots de passe, options SSH.
8. (10 s) Limites : nmap initial invalide, système évolutif (dnf-automatic), score du script non comparable.
