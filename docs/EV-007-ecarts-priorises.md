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
