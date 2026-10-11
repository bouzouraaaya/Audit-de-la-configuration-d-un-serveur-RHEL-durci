# EV-007 : Tableau des écarts priorisés (test T-07)

Source : evidence/apres/final-anssi.xml (OpenSCAP, profil ANSSI-BP-028 intermediary), 180 pass / 20 fail.

## Critère de priorisation (impact / effort)
- Impact : gain de sécurité (1 faible, 2 moyen, 3 fort)
- Effort / risque : travail et risque de casser le système (1 simple, 2 moyen, 3 lourd)
- P1 : bon gain pour un effort simple. P2 : à planifier. P3 : risque accepté ou règle non pertinente.
Les notes sont un jugement d'auditeur, à valider avec l'enseignant.

| Priorité | Règle | Impact | Effort | Décision proposée |
|---|---|---|---|---|
| P1 | systemd_tmp_mount_enabled | 2 | 1 | Activer tmp.mount |
| P1 | accounts_tmout | 1 | 1 | Déconnexion des shells inactifs |
| P1 | logind_session_timeout | 1 | 1 | Déconnexion des sessions inactives |
| P2 | grub2_password | 2 | 2 | Définir un mot de passe GRUB |
| P2 | mount_option_boot_noexec, mount_option_boot_nosuid | 1 | 2 | Modifier /etc/fstab |
| P2 | sudo_add_noexec, sudo_add_requiretty | 2 | 2 | À tester (peut gêner dnf et les outils d'audit) |
| P2 | partition_for_home, _var, _var_log, _var_tmp | 2 | 3 | Réinstallation avec partitionnement dédié |
| P3 | partition_for_srv | 1 | 3 | Risque accepté (/srv inutilisé) |
| P3 | accounts_polyinstantiated_tmp, _var_tmp, sebool_polyinstantiation_enabled | 1 | 3 | Risque accepté (peut casser les sessions) |
| P3 | sudoers_explicit_command_args | 1 | 2 | Contrôle manuel |
| P3 | service_sssd_enabled, sssd_enable_pam_services | 1 | 2 | Non pertinent (aucun annuaire) |
| P3 | postfix_client_configure_mail_alias | 1 | 1 | Non pertinent (aucun serveur mail) |

Total : 20 écarts (3 en P1, 9 en P2, 8 en P3).

## Consolidation Lynis (source : evidence/apres/lynis-suggestions.txt, 30 suggestions distinctes)
| Priorité | Thème | Codes Lynis | Lien OpenSCAP |
|---|---|---|---|
| P1 | Expiration et umask des mots de passe | AUTH-9282, AUTH-9286, AUTH-9328 | PASS_MAX_DAYS = 99999 (AC-02) |
| P1 | Bannières légales | BANN-7126, BANN-7130 | Hors profil ANSSI |
| P2 | Options SSH supplémentaires | SSH-7408 (8 occurrences) | Hors profil |
| P2 | Protocoles rares (dccp, rds, sctp, tipc) | NETW-3200 | Hors profil |
| P2 | Partitions séparées | FILE-6310 | partition_for_* (confirme OpenSCAP) |
| P2 | Services, core dumps, sysctl | BOOT-5264, KRNL-5820, KRNL-6000 | Partiel |
| P3 | USB et FireWire, compilateurs, antivirus | USB-1000, STRG-1846, HRDN-7222, HRDN-7230 | Hors périmètre labo |
| P3 | DNS, journalisation externe, outils | NETW-2705, NAME-4406, LOGG-2154, LOGG-2190, TOOL-5002, ACCT-9626, AUTH-9229, AUTH-9288, FILE-7524 | Environnement de labo |
Priorités proposées par l'auditeur selon le critère impact / effort.

## Consolidation CIS niveau 1 (91 écarts, source : evidence/apres/cis-l1-fail.txt)
Priorités proposées par l'auditeur (impact / effort).
| Priorité | Thème | Total | Action |
|---|---|---|---|
| P1 | Authentification (accounts, account, ensure, no, use) | 21 | AC-06, AC-07, AC-08 |
| P1 | Interface graphique (dconf, gnome) | 11 | AC-10 |
| P1 | Bannières et core dumps | 4 | Correction simple |
| P2 | SSH | 11 | AC-09 |
| P2 | Fichiers, montages, partition | 14 | À détailler |
| P2 | Noyau (sysctl, kernel) | 12 | À détailler |
| P2 | Services, pare-feu, sudo, journalisation, AIDE | 14 | À détailler |
| P3 | Autres (grub2, package, disable, configure) | 4 | À détailler |
Total : 91.
