s=FAIL; systemctl is-active --quiet firewalld && s=PASS
record FW-01 "firewalld actif" Élevée $s "$(systemctl is-active firewalld)"

v=$(getenforce)
[ "$v" = "Enforcing" ] && s=PASS || s=FAIL
record SEL-01 "SELinux en mode enforcing" Critique $s "getenforce=$v"

s=FAIL; systemctl is-active --quiet auditd && s=PASS
record AUD-01 "auditd actif" Élevée $s "$(systemctl is-active auditd)"

s=FAIL; systemctl is-active --quiet sshd && s=PASS
record SVC-01 "sshd actif" Faible $s "$(systemctl is-active sshd)"
