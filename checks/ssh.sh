# Lecture de la configuration SSH effective (sshd -T)
cfg=$(sshd -T 2>/dev/null)
get() { echo "$cfg" | awk -v k="$1" '$1==k {print $2}'; }

v=$(get permitrootlogin)
[ "$v" = "no" ] && s=PASS || s=FAIL
record SSH-01 "Connexion root SSH désactivée" Critique $s "permitrootlogin=$v"

v=$(get passwordauthentication)
[ "$v" = "no" ] && s=PASS || s=FAIL
record SSH-02 "Authentification par mot de passe désactivée" Élevée $s "passwordauthentication=$v"

v=$(get maxauthtries)
[ -n "$v" ] && [ "$v" -le 4 ] && s=PASS || s=FAIL
record SSH-03 "Tentatives d'authentification limitées (<=4)" Moyenne $s "maxauthtries=$v"

v=$(get x11forwarding)
[ "$v" = "no" ] && s=PASS || s=FAIL
record SSH-04 "Redirection X11 désactivée" Faible $s "x11forwarding=$v"
