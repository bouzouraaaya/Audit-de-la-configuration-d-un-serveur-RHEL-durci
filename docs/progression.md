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
