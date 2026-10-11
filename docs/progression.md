# Progression du durcissement

## OpenSCAP, profil ANSSI-BP-028 intermediary (200 règles évaluées)
| Étape | Pass | Fail | Conformité brute |
|---|---|---|---|
| État initial | 87 | 113 | 43,5 % |
| Vague 1 : sysctl (52 règles) | 139 | 61 | 69,5 % |
| Vague 2A : mots de passe (13 règles) et droits du dossier personnel | 153 | 47 | 76,5 % |
| Vague 2B : faillock (4 règles) | 157 | 43 | 78,5 % |
| Vague 3A : SSH, sudo use_pty, audit sudo (4 règles) | 161 | 39 | 80,5 % |
| Vague 4 : AIDE, dnf-automatic, root console (8 règles) | 169 | 31 | 84,5 % |
| Vague 5 : options noyau GRUB (11 règles) | 180 | 20 | 90 % |
| Audit final | 180 | 20 | 90 % |

## Script d'audit Bash (16 contrôles choisis par l'auditeur)
Mesuré après les vagues OpenSCAP, pas sur l'état initial : ce n'est pas un avant / après du durcissement.
| Étape | Pass | Fail | Brute | Pondérée |
|---|---|---|---|---|
| Premier audit | 13 | 3 | 81,2 % | 87,0 % |
| Après correction SSH-03 et SSH-04 | 15 | 1 | 93,8 % | 93,5 % |
| Après correction SSH-02 (clé SSH, mot de passe désactivé) | 16 | 0 | 100 % | 100 % |

## Autres mesures
| Mesure | Avant | Final |
|---|---|---|
| Score pondéré OpenSCAP (ANSSI) | 60,8 | 88,2 |
| Indice Lynis | 67 | 71 |
| Suggestions Lynis | 40 | 37 |
| Services en écoute | 4 (sshd, chronyd, avahi, cups) | 2 (sshd, chronyd en local) |
| CIS niveau 1 | non mesuré | voir docs/scores-openscap.md |

## Observations
- Après la vague 2A, deux règles d'ownership (home_files_ownership, home_files_groupownership) sont passées de PASS à FAIL, corrigées par chown.
- home_files_permissions échouait à cause de gvfs-metadata (interface graphique GNOME), recréé en mode 644.
- Un premier scan final a donné 177 pass / 23 fail : les rapports CSV du script, écrits par root dans ~/rhel-audit/reports, faisaient échouer trois règles sur le dossier personnel. audit.sh corrige maintenant les droits de ses rapports, et le scan final est à 180 / 20.
- ip_forward = 0 appliqué : la VM n'est pas un routeur.
- faillock : deny = 3, fail_interval = 900, unlock_time = 900, even_deny_root.
- dnf-automatic a installé un nouveau noyau (5.14.0-687.54.1 puis 687.56.1), openssl et glibc entre deux mesures.
- Le score pondéré d'OpenSCAP progresse moins que le taux brut : les règles pèsent selon leur sévérité.
