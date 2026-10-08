# Progression du durcissement

| Étape | Pass | Fail | Conformité brute |
|---|---|---|---|
| État initial | 87 | 113 | 43,5 % |
| Vague 1 : sysctl (52 règles) | 139 | 61 | 69,5 % |
| Vague 2A : mots de passe (13 règles) | 153 | 47 | 76,5 % |

## Observations
- Après la vague 2A, deux règles d'ownership (`home_files_ownership`, `home_files_groupownership`) sont passées de PASS à FAIL, corrigées par `chown`.
- `home_files_permissions` échouait à cause de `gvfs-metadata` (interface graphique GNOME), recréé en mode 644. Un serveur sans GUI évite ce problème.
- `ip_forward = 0` appliqué : la VM n'est pas un routeur.

| Vague 2B : faillock (4 règles) | 157 | 43 | 78,5 % |

- faillock : deny=3, fail_interval=900, unlock_time=900, even_deny_root.

| Vague 3A : SSH, sudo use_pty, audit sudo (4 règles) | 161 | 39 | 80,5 % |

| Vague 4 : AIDE, dnf-automatic, root console (8 règles) | 169 | 31 | 84,5 % |
