#!/bin/bash
# format-cdc.sh : à lancer à la racine du dépôt. Ne modifie aucune preuve. Ne fait ni commit ni push.
# 1. Grille : colonnes de la section 15 (ID, Critère, Question, Méthode, Preuve attendue, Résultat, Classification, Réf. preuve)
# 2. Plan d'actions : colonnes Responsable et Échéance de la section 25
set -u
[ -d docs ] || { echo "Lance ce script depuis la racine du dépôt (dossier rhel-audit)."; exit 1; }

# --- Grille ---
if [ -f docs/grille-audit.md ] && grep -q '^| ID | Question d.audit | Résultat observé | Classification | Preuve |$' docs/grille-audit.md; then
awk -F'|' '
function trim(s){ gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
BEGIN {
  crit["G-01"]="A.8.9 ; CIS RHEL"; q["G-01"]="La configuration du serveur est-elle conforme au profil CIS/SCAP retenu ?"; m["G-01"]="T-01 — OpenSCAP"; pa["G-01"]="report.html, results.xml"
  crit["G-02"]="A.8.9"; q["G-02"]="Lynis confirme-t-il ou complète-t-il les écarts d'"'"'OpenSCAP ?"; m["G-02"]="T-02 — Lynis"; pa["G-02"]="lynis-report.dat, lynis.log"
  crit["G-03"]="A.8.9"; q["G-03"]="Seuls les services nécessaires sont-ils actifs et exposés ?"; m["G-03"]="T-03 — Poste auditeur RHEL"; pa["G-03"]="Sorties de commandes"
  crit["G-04"]="A.8.9 ; CIS RHEL"; q["G-04"]="La politique de mots de passe respecte-t-elle le référentiel retenu ?"; m["G-04"]="T-04 — OpenSCAP"; pa["G-04"]="Extraits de configuration"
  crit["G-05"]="A.8.19"; q["G-05"]="Le système est-il à jour selon le canal de mise à jour officiel ?"; m["G-05"]="T-05 — Poste auditeur RHEL"; pa["G-05"]="Sorties de commandes"
  crit["G-06"]="A.8.9 ; CIS RHEL"; q["G-06"]="Les paramètres de durcissement noyau du profil sont-ils appliqués ?"; m["G-06"]="T-06 — OpenSCAP"; pa["G-06"]="Sorties de commandes"
  crit["G-07"]="A.8.9"; q["G-07"]="Les écarts constatés sont-ils priorisés selon un critère explicite ?"; m["G-07"]="T-07 — Rapport de scan"; pa["G-07"]="Tableau d'"'"'écarts priorisés"
  inT=0
}
{
  line=$0
  if (line == "| ID | Question d'"'"'audit | Résultat observé | Classification | Preuve |") {
    print "| ID | Critère | Question d'"'"'audit | Méthode | Preuve attendue | Résultat | Classification | Réf. preuve |"
    print "|---|---|---|---|---|---|---|---|"
    inT=1; skipsep=1; next
  }
  if (inT && skipsep && line ~ /^\|---/) { skipsep=0; next }
  if (inT && line ~ /^\| G-/ && NF==7) {
    id=trim($2)
    print "| " id " | " crit[id] " | " q[id] " | " m[id] " | " pa[id] " | " trim($4) " | " trim($5) " | " trim($6) " |"
    next
  }
  if (inT && line !~ /^\|/) inT=0
  print line
}' docs/grille-audit.md > docs/grille-audit.tmp && mv docs/grille-audit.tmp docs/grille-audit.md
echo "Grille : colonnes de la section 15 appliquées."
else
echo "Grille : déjà au format, ou en-tête introuvable (rien modifié)."
fi

# --- Plan d'actions ---
if [ -f docs/plan-actions.md ] && grep -q '^| ID | Constat | Risque | Cause | Action corrective | Priorité | Preuve de clôture |$' docs/plan-actions.md; then
awk -F'|' '
function trim(s){ gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
{
  line=$0
  if (line == "| ID | Constat | Risque | Cause | Action corrective | Priorité | Preuve de clôture |") {
    print "| ID | Constat | Risque | Cause | Action corrective | Priorité | Responsable | Échéance | Preuve de clôture |"; next
  }
  if (line == "|---|---|---|---|---|---|---|") { print "|---|---|---|---|---|---|---|---|---|"; next }
  if (line ~ /^\| AC-/ && NF==9) {
    print "|" $2 "|" $3 "|" $4 "|" $5 "|" $6 "|" $7 "| Administrateur système (simulé) | [À FIXER] |" $8 "|"
    next
  }
  print line
}' docs/plan-actions.md > docs/plan-actions.tmp && mv docs/plan-actions.tmp docs/plan-actions.md
echo "Plan d'actions : colonnes Responsable et Échéance ajoutées."
else
echo "Plan d'actions : déjà au format, ou en-tête introuvable (rien modifié)."
fi

echo
echo "Aperçu de la grille :"
grep -E '^\| (ID|G-0[1-7]) ' docs/grille-audit.md | head -9 | cut -c1-150
echo
echo "Aperçu du plan d'actions :"
grep -E '^\| (ID|AC-)' docs/plan-actions.md | cut -c1-120
echo
git status --short
echo
echo "Si tout est correct : git add -A && git commit -m \"Grille et plan d'actions au format du cahier des charges\" && git push"
