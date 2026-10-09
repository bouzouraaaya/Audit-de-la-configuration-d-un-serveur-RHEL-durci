# Plan d'actions correctives (L-04)
Responsable : administrateur système (simulé). Échéances à fixer avec l'enseignant.

| ID | Constat | Risque | Cause | Action corrective | Priorité | Preuve de clôture |
|---|---|---|---|---|---|---|
| AC-01 | 37 services actifs dont gdm, bluetooth, ModemManager | Surface d'attaque inutile | Installation avec interface graphique | Passer en multi-user.target et désactiver les services inutiles, ou réinstaller en Serveurs | P1 | systemctl list-units après action |
| AC-02 | PASS_MAX_DAYS = 99999, umask non strict | Mots de passe sans expiration | Valeurs par défaut | Fixer PASS_MAX_DAYS et PASS_MIN_DAYS selon le référentiel, umask 027 | P2 | /etc/login.defs, Lynis AUTH-9286 |
| AC-03 | tmp.mount et timeouts de session absents | Fichiers temporaires et sessions ouvertes | Non appliqués | Activer tmp.mount, accounts_tmout, logind_session_timeout | P1 | Nouveau scan OpenSCAP |
| AC-04 | 5 partitions non séparées | Impact d'un disque plein | Partitionnement par défaut | Réinstaller avec /home, /var, /var/log, /var/tmp séparés | P2 | lsblk, règles partition_for_* |
| AC-05 | Pas de mot de passe GRUB | Modification du démarrage | Non défini | Définir un mot de passe GRUB | P2 | Règle grub2_password |
