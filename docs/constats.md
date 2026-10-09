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
