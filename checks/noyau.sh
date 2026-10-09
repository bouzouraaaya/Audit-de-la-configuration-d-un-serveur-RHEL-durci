v=$(sysctl -n net.ipv4.ip_forward)
[ "$v" = "0" ] && s=PASS || s=FAIL
record NET-01 "Routage IPv4 désactivé" Moyenne $s "ip_forward=$v"

v=$(sysctl -n kernel.randomize_va_space)
[ "$v" = "2" ] && s=PASS || s=FAIL
record KER-01 "ASLR activé (valeur 2)" Élevée $s "randomize_va_space=$v"

v=$(sysctl -n kernel.kptr_restrict)
[ "$v" -ge 1 ] && s=PASS || s=FAIL
record KER-02 "Adresses noyau masquées" Moyenne $s "kptr_restrict=$v"

s=PASS; rpm -q telnet-server >/dev/null 2>&1 && s=FAIL
record SVC-02 "telnet-server absent" Élevée $s "installe=$([ $s = FAIL ] && echo oui || echo non)"
