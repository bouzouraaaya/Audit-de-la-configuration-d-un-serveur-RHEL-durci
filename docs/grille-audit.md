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

## Compléments (preuves vérifiées)
- G-06 : EV-006-sysctl.txt confirme net.ipv4.conf.all.rp_filter = 1 et kernel.randomize_va_space = 2. Lynis (KRNL-6000) signale que d'autres valeurs sysctl diffèrent de son propre profil : observation.
- G-02 : Lynis confirme OpenSCAP sur les partitions séparées (FILE-6310) et l'expiration des mots de passe (AUTH-9286). Il complète sur des points hors profil ANSSI : bannières légales, protocoles rares (dccp, rds, sctp, tipc), USB et FireWire, compilateurs, antivirus, journalisation externe, sysstat, options SSH supplémentaires (SSH-7408). Aucun écart majeur de Lynis n'est absent d'OpenSCAP sans explication.
- Lynis : 37 suggestions au total, 30 lignes distinctes (SSH-7408 apparaît 8 fois).

## Compléments (preuves vérifiées)
- G-06 : EV-006-sysctl.txt confirme net.ipv4.conf.all.rp_filter = 1 et kernel.randomize_va_space = 2. Lynis (KRNL-6000) signale que d'autres valeurs sysctl diffèrent de son propre profil : observation.
- G-02 : Lynis confirme OpenSCAP sur les partitions séparées (FILE-6310) et l'expiration des mots de passe (AUTH-9286). Il complète sur des points hors profil ANSSI : bannières légales, protocoles rares (dccp, rds, sctp, tipc), USB et FireWire, compilateurs, antivirus, journalisation externe, sysstat, options SSH supplémentaires (SSH-7408). Aucun écart majeur de Lynis n'est absent d'OpenSCAP sans explication.
- Lynis : 37 suggestions au total, 30 lignes distinctes (SSH-7408 apparaît 8 fois).

## Compléments (preuves vérifiées)
- G-06 : EV-006-sysctl.txt confirme net.ipv4.conf.all.rp_filter = 1 et kernel.randomize_va_space = 2. Lynis (KRNL-6000) signale que d'autres valeurs sysctl diffèrent de son propre profil : observation.
- G-02 : Lynis confirme OpenSCAP sur les partitions séparées (FILE-6310) et l'expiration des mots de passe (AUTH-9286). Il complète sur des points hors profil ANSSI : bannières légales, protocoles rares (dccp, rds, sctp, tipc), USB et FireWire, compilateurs, antivirus, journalisation externe, sysstat, options SSH supplémentaires (SSH-7408). Aucun écart majeur de Lynis n'est absent d'OpenSCAP sans explication.
- Lynis : 37 suggestions au total, 30 lignes distinctes (SSH-7408 apparaît 8 fois).

## Révision après le scan CIS niveau 1 (état final)
- G-01 : profil CIS L1 serveur, 184 pass / 91 fail / 20 non applicables, soit 66,9 % de règles conformes sur 275 évaluées (EV-001, evidence/apres/final-cis-l1.xml). Profil ANSSI : 180 pass / 20 fail (90 %).
- Le durcissement visait le profil ANSSI. Le résultat CIS est présenté tel que mesuré, sans scan CIS à l'état initial.
- Classification de G-01 : ANSSI, non-conformité mineure. CIS L1 : à finaliser après analyse de evidence/apres/cis-l1-fail.txt. Choix du référentiel à valider avec l'enseignant.
- G-04 : à réexaminer avec les écarts CIS liés aux mots de passe.

## Classification finale proposée (après analyse des écarts CIS)
Jugement d'auditeur (critère + preuve + analyse), à valider avec l'enseignant, ainsi que le référentiel retenu.

| ID | Profil ANSSI-BP-028 | CIS RHEL 9 niveau 1 |
|---|---|---|
| G-01 | Non-conformité mineure (180 pass / 20 fail, 90 %) | Non-conformité majeure (184 pass / 91 fail, 66,9 %) |
| G-02 | Observation | Observation : Lynis recoupe OpenSCAP sur plusieurs thèmes (docs/constats.md, C-08) |
| G-03 | Non-conformité mineure | Non-conformité mineure : dont 11 écarts dconf et gnome liés à l'interface graphique |
| G-04 | Conforme, avec observation | Non-conformité mineure : expiration, historique et dictionnaire des mots de passe absents |
| G-05 | Inchangé | À confirmer avec evidence/apres/cis-l1-fail.txt |
| G-06 | Conforme (rp_filter, ASLR, options GRUB) | Non-conformité mineure : 12 écarts sysctl et kernel, à détailler |
| G-07 | Conforme | Conforme |

Justification de G-01 selon le CIS : 66,9 % de règles conformes et 91 écarts répartis sur l'authentification, SSH, l'interface graphique, les permissions et le noyau. Le cahier des charges définit la non-conformité majeure comme un écart significatif nécessitant une action corrective importante. Facteurs atténuants : un seul port exposé (22/tcp, authentification par clé) et un pare-feu limité à SSH.
