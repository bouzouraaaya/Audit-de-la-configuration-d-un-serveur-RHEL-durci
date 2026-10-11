# Plan d'actions correctives (L-04)
Responsable : administrateur système (simulé). Échéances à fixer avec l'enseignant.

| ID | Constat | Risque | Cause | Action corrective | Priorité | Preuve de clôture |
|---|---|---|---|---|---|---|
| AC-01 | 37 services actifs dont gdm, bluetooth, ModemManager | Surface d'attaque inutile | Installation avec interface graphique | Passer en multi-user.target et désactiver les services inutiles, ou réinstaller en Serveurs | P1 | systemctl list-units après action |
| AC-02 | PASS_MAX_DAYS = 99999, umask non strict | Mots de passe sans expiration | Valeurs par défaut | Fixer PASS_MAX_DAYS et PASS_MIN_DAYS selon le référentiel, umask 027 | P2 | /etc/login.defs, Lynis AUTH-9286 |
| AC-03 | tmp.mount et timeouts de session absents | Fichiers temporaires et sessions ouvertes | Non appliqués | Activer tmp.mount, accounts_tmout, logind_session_timeout | P1 | Nouveau scan OpenSCAP |
| AC-04 | 5 partitions non séparées | Impact d'un disque plein | Partitionnement par défaut | Réinstaller avec /home, /var, /var/log, /var/tmp séparés | P2 | lsblk, règles partition_for_* |
| AC-05 | Pas de mot de passe GRUB | Modification du démarrage | Non défini | Définir un mot de passe GRUB | P2 | Règle grub2_password |
| AC-06 | Mots de passe : pas d'expiration, d'historique ni de contrôle de dictionnaire (CIS) | Mot de passe compromis valable indéfiniment, réutilisation | Valeurs par défaut, PASS_MAX_DAYS = 99999 | Fixer l'âge maximum selon le benchmark, activer pwhistory, dictcheck, difok, maxrepeat et maxsequence, appliquer chage aux comptes existants | P1 | Règles accounts_* et pam_* en PASS au scan CIS suivant |
| AC-07 | umask non strict dans login.defs, profile et bashrc | Fichiers créés lisibles par d'autres | Valeurs par défaut | umask 027 dans les trois fichiers | P1 | Règles accounts_umask_*, Lynis AUTH-9328 |
| AC-08 | su non restreint, mots de passe vides acceptés par PAM et SSH (CIS) | Élévation de privilèges, comptes sans mot de passe | PAM et SSH par défaut | Restreindre su au groupe wheel (pam_wheel), retirer nullok de PAM, PermitEmptyPasswords no explicite | P1 | use_pam_wheel_group_for_su, no_empty_passwords, sshd_disable_empty_passwords en PASS |
| AC-09 | 11 écarts CIS sur la configuration SSH | Surface d'attaque SSH | Options par défaut | Appliquer les options du profil CIS dans sshd_config.d, avec session de secours et snapshot | P2 | Famille sshd en PASS, Lynis SSH-7408 |
| AC-10 | Interface graphique installée (gdm actif, 11 écarts dconf et gnome) | Surface d'attaque, écarts CIS | Environnement installé avec interface graphique | Passer en multi-user.target puis retirer les paquets graphiques, ou réinstaller en Serveur (complète AC-01) | P1 | systemctl list-units sans gdm, famille dconf absente du scan |
