#!/bin/bash
cd "$(dirname "$0")" || exit 1
[ "$EUID" -eq 0 ] || { echo "Lance avec sudo"; exit 1; }
mkdir -p reports
export CSV="reports/audit-$(date +%Y%m%d-%H%M%S).csv"
echo "ID,Controle,Criticite,Statut,Detail" > "$CSV"
source ./lib.sh
for f in checks/*.sh; do source "$f"; done
echo; echo "Résultats : $CSV"
./score.sh "$CSV"
