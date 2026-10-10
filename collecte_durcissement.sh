#!/bin/bash
# Collecte services, ports, mots de passe et sysctl dans un fichier horodaté.
# Usage sur la cible : sudo ./collecte_durcissement.sh
[ "$EUID" -eq 0 ] || { echo "Lance avec sudo"; exit 1; }
U="${SUDO_USER:-root}"
D="$(getent passwd "$U" | cut -d: -f6)/evidence/apres"
mkdir -p "$D"
OUT="$D/collecte-$(date +%Y%m%d-%H%M%S).txt"
{
echo "== $(date -Is) $(hostname) =="; uname -r
echo "== services actifs =="; systemctl list-units --type=service --state=running --no-pager
echo "== ports en écoute =="; ss -tulpn
echo "== mots de passe =="
grep -v '^#' /etc/security/pwquality.conf | grep -v '^$'
grep -E '^(PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_MIN_LEN)' /etc/login.defs
grep -v '^#' /etc/security/faillock.conf | grep -v '^$'
echo "== sysctl =="; sysctl net.ipv4.conf.all.rp_filter kernel.randomize_va_space
} > "$OUT"
chown "$U:$U" "$OUT"; chmod 640 "$OUT"
echo "Écrit : $OUT"
