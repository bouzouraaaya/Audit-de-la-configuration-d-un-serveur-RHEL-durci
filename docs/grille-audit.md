# Grille d'audit renseignée (L-02)

Cible : RHEL 9.8 (VM VMware). Profil OpenSCAP : ANSSI-BP-028 intermediary. Classification proposée, à valider avec l'enseignant.

| ID | Question d'audit | Résultat observé | Classification | Preuve |
|---|---|---|---|---|
| G-01 | Conformité au profil retenu ? | Initial : 87 pass / 113 fail (43,5 %). Final : 180 pass / 20 fail (90 %) | État initial : non-conformité majeure. État final : non-conformité mineure (20 écarts, voir EV-007) | EV-001 |
| G-02 | Lynis confirme-t-il ou complète-t-il OpenSCAP ? | Indice 67 puis 71. Suggestions 40 puis 37. Avertissement NETW-2705 (un seul DNS) avant et après | Observation : Lynis complète OpenSCAP (à confirmer avec lynis-suggestions.txt) | EV-002 |
| G-03 | Seuls les services nécessaires sont-ils actifs et exposés ? | Exposé : SSH seul (nmap : 22/tcp ouvert, 65 534 ports filtrés). Actifs : 37 services dont gdm, bluetooth, ModemManager | Non-conformité mineure : services inutiles actifs mais non exposés | EV-003 |
| G-04 | Politique de mots de passe conforme ? | minlen 15, 4 classes, verrouillage 3 échecs / 900 s, root inclus. PASS_MAX_DAYS = 99999 | Conforme, avec observation sur l'expiration | EV-004 |
| G-05 | Système à jour via le canal officiel ? | 33 mises à jour en attente, aucune de sécurité. dnf-automatic applique les correctifs de sécurité | Conforme, avec observation (33 mises à jour hors sécurité) | EV-005 |
| G-06 | Paramètres noyau appliqués ? | 52 règles sysctl corrigées. 11 options GRUB actives sur le noyau 5.14.0-687.56.1 | Conforme (valeurs sysctl à confirmer avec EV-006-sysctl.txt) | EV-006 |
| G-07 | Écarts priorisés selon un critère explicite ? | Critère impact / effort : 3 en P1, 9 en P2, 8 en P3 | Conforme | EV-007 |
