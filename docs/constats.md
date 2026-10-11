# Constats (L-03) : critère + preuve + analyse
Classification proposée par l'auditeur, à valider avec l'enseignant.

## C-01 : Conformité au profil (A.8.9, CIS RHEL) : non-conformité mineure
- Critère : taux de conformité calculé, écarts listés.
- Preuve : EV-001. Initial 87 pass / 113 fail (43,5 %). Final 180 pass / 20 fail (90 %).
- Analyse : l'état initial était une non-conformité majeure. Après durcissement, 20 écarts demeurent (EV-007) : aucun n'expose un service au réseau.

## C-02 : Complément Lynis : observation
- Critère : rapport recoupé avec OpenSCAP, sans écart majeur inexpliqué.
- Preuve : EV-002. Indice 67 puis 71, suggestions 40 puis 37, avertissement NETW-2705 (un seul DNS) avant et après.
- Analyse : Lynis confirme OpenSCAP (partitions, expiration des mots de passe) et complète sur des points hors profil ANSSI (bannières, protocoles rares, USB, compilateurs, journalisation externe).

## C-03 : Services actifs et exposés : non-conformité mineure
- Critère : seuls les services nécessaires sont actifs.
- Preuve : EV-003. Exposé : SSH seul (nmap : 22/tcp ouvert, 65 534 ports filtrés). Actifs : 37 services dont gdm, bluetooth, ModemManager.
- Analyse : l'installation contient une interface graphique. Les services inutiles ne sont pas exposés, d'où mineure.

## C-04 : Mots de passe et verrouillage : conforme, avec observation
- Critère : politique conforme au référentiel.
- Preuve : EV-004. minlen 15, 4 classes, verrouillage après 3 échecs pendant 900 s (root inclus). PASS_MAX_DAYS = 99999.
- Analyse : la complexité et le verrouillage sont conformes. Les mots de passe n'expirent pas (observation, AC-02).

## C-05 : Mises à jour : conforme, avec observation
- Critère : système à jour ou écart justifié.
- Preuve : EV-005. Aucune mise à jour de sécurité en attente, 33 autres (firmware, samba, tzdata). dnf-automatic applique les correctifs de sécurité.
- Analyse : critère respecté. Le système a changé entre deux mesures (nouveau noyau, openssl, glibc).

## C-06 : Paramètres noyau : conforme
- Critère : valeurs conformes au profil.
- Preuve : EV-006. rp_filter = 1, randomize_va_space = 2, 11 options GRUB actives sur le noyau 5.14.0-687.56.1.
- Analyse : 52 règles sysctl corrigées. Lynis (KRNL-6000) signale des écarts avec son propre profil : observation.

## C-07 : Priorisation : conforme
- Critère : écarts priorisés selon un critère explicite.
- Preuve : EV-007. 3 P1, 9 P2, 8 P3 (impact / effort).
- Analyse : le critère est défini dans le programme d'audit.

## C-01 (révision) : scan CIS niveau 1
- Preuve : EV-001, final-cis-l1.xml. 184 pass / 91 fail / 20 non applicables (66,9 % sur 275 règles).
- Analyse : l'écart avec le profil ANSSI (90 %) s'explique par le périmètre du durcissement, qui visait l'ANSSI. La classification finale du constat selon le CIS dépend de la nature des 91 écarts (cis-l1-fail.txt) et du référentiel retenu avec l'enseignant.

## C-04 (révision CIS) : mots de passe, non-conformité mineure selon le CIS
- Critère : politique conforme au référentiel. Le cahier des charges qualifie de non conforme une politique plus faible que le référentiel.
- Preuve : EV-004 et final-cis-l1.xml. Longueur 15, 4 classes de caractères et verrouillage après 3 échecs sont en place. PASS_MAX_DAYS = 99999, et les règles CIS d'expiration, d'historique (pwhistory), de dictionnaire et de séquences sont en échec.
- Analyse : la politique est plus faible que le CIS sur l'expiration, l'historique et les contrôles de dictionnaire : non-conformité mineure, car la complexité et le verrouillage existent. Selon le profil ANSSI intermediary, elle reste conforme avec observation.

## C-08 : écarts CIS niveau 1 (91), non-conformité majeure vis-à-vis du CIS
- Critère : benchmark CIS RHEL 9 niveau 1 (référentiel cité par le cahier des charges, C-03).
- Preuve : EV-001, evidence/apres/final-cis-l1.xml et evidence/apres/cis-l1-fail.txt. Aucun scan CIS à l'état initial : aucun gain CIS n'est affirmé.
- Analyse : le durcissement visait le profil ANSSI. Les 91 écarts par famille de règles :

| Thème | Familles (nombre) | Total | Lecture |
|---|---|---|---|
| Authentification | accounts 15, account 1, ensure 3, no 1, use 1 | 21 | Expiration, historique, dictionnaire, umask, délai de session, restriction de su, mots de passe vides. ensure_root_password_configured : root est volontairement inutilisable, à justifier plutôt qu'à corriger |
| Interface graphique | dconf 10, gnome 1 | 11 | Disparaissent si l'interface graphique est retirée |
| SSH | sshd 11 | 11 | Options supplémentaires |
| Fichiers et montages | file 10, mount 3, partition 1 | 14 | Permissions, options de montage, /tmp |
| Noyau | sysctl 6, kernel 6 | 12 | À détailler avec cis-l1-fail.txt |
| Services et journalisation | service 5, firewalld 2, sudo 2, journald 2, rsyslog 1, aide 2 | 14 | À détailler |
| Bannières et core dumps | banner 2, coredump 2 | 4 | Correction simple |
| Autres | grub2 1, package 1, disable 1, configure 1 | 4 | À détailler |

Recoupements avec Lynis, par thème (la correspondance règle à règle n'a pas été vérifiée) :
| Lynis | CIS (OpenSCAP) |
|---|---|
| AUTH-9286 (âge des mots de passe) | accounts_maximum_age_login_defs, accounts_password_set_max_life_existing |
| AUTH-9328 (umask 027) | accounts_umask_etc_login_defs, _etc_profile, _etc_bashrc |
| BANN-7126, BANN-7130 | famille banner |
| KRNL-5820 (core dumps) | famille coredump |
| SSH-7408 (8 occurrences) | famille sshd |
| FILE-6310 (partitions) | partition, et partition_for_* côté ANSSI |
