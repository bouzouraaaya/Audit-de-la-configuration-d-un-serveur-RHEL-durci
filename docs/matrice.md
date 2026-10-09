# Matrice critère, test, preuve, constat (L-02)
Profil scanné : ANSSI-BP-028 intermediary (à confirmer avec l'enseignant à la place du CIS).

| Critère | Question d'audit | Test | Preuve | Résultat | Constat |
|---|---|---|---|---|---|
| A.8.9 ; CIS RHEL | Conformité au profil retenu ? | T-01 | EV-001 | 87 pass / 113 fail puis 180 / 20 | Non-conformité mineure (final) |
| A.8.9 | Lynis confirme ou complète OpenSCAP ? | T-02 | EV-002 | Indice 67 puis 71, 37 suggestions | Observation |
| A.8.9 | Services nécessaires seuls actifs et exposés ? | T-03 | EV-003 | SSH seul exposé, 37 services actifs | Non-conformité mineure |
| A.8.9 ; CIS RHEL | Politique de mots de passe conforme ? | T-04 | EV-004 | minlen 15, 4 classes, verrouillage 3 échecs, PASS_MAX_DAYS 99999 | Conforme + observation |
| A.8.19 | Système à jour ? | T-05 | EV-005 | 0 mise à jour de sécurité en attente, 33 autres | Conforme + observation |
| A.8.9 ; CIS RHEL | Paramètres noyau appliqués ? | T-06 | EV-006 | rp_filter 1, ASLR 2, 11 options GRUB | Conforme |
| A.8.9 | Écarts priorisés ? | T-07 | EV-007 | 3 P1, 9 P2, 8 P3 | Conforme |
