n=$(awk -F: '$3==0 && $1!="root"' /etc/passwd | wc -l)
[ "$n" -eq 0 ] && s=PASS || s=FAIL
record USR-01 "Aucun autre compte UID 0 que root" Critique $s "autres_uid0=$n"

n=$(awk -F: '$2==""' /etc/shadow | wc -l)
[ "$n" -eq 0 ] && s=PASS || s=FAIL
record USR-02 "Aucun compte sans mot de passe" Critique $s "comptes_vides=$n"

p=$(stat -c %a /etc/shadow)
[ "$p" -le 640 ] && s=PASS || s=FAIL
record PERM-01 "Permissions de /etc/shadow" Critique $s "mode=$p"

p=$(stat -c %a /etc/passwd)
[ "$p" -le 644 ] && s=PASS || s=FAIL
record PERM-02 "Permissions de /etc/passwd" Élevée $s "mode=$p"
