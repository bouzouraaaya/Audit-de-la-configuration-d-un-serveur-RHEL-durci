# record ID "Contrôle" Criticité STATUT "Détail"
record() {
  printf '%s,%s,%s,%s,%s\n' "$1" "$2" "$3" "$4" "$5" >> "$CSV"
  printf '[%s] %s - %s\n' "$4" "$1" "$2"
}
