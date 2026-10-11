#!/bin/bash
# fix-docs.sh : à lancer à la racine du dépôt. Ne modifie aucune preuve. Ne fait ni commit ni push.
set -u
if [ ! -d docs ] || [ ! -d evidence ]; then
  echo "Lance ce script depuis la racine du dépôt (dossier rhel-audit)."
  exit 1
fi

# 1. progression.md : réécriture propre (valeurs relevées pendant les scans)
cat > docs/progression.md << 'EOF_PROG'
# Progression du durcissement

## OpenSCAP, profil ANSSI-BP-028 intermediary (200 règles évaluées)
| Étape | Pass | Fail | Conformité brute |
|---|---|---|---|
| État initial | 87 | 113 | 43,5 % |
| Vague 1 : sysctl (52 règles) | 139 | 61 | 69,5 % |
| Vague 2A : mots de passe (13 règles) et droits du dossier personnel | 153 | 47 | 76,5 % |
| Vague 2B : faillock (4 règles) | 157 | 43 | 78,5 % |
| Vague 3A : SSH, sudo use_pty, audit sudo (4 règles) | 161 | 39 | 80,5 % |
| Vague 4 : AIDE, dnf-automatic, root console (8 règles) | 169 | 31 | 84,5 % |
| Vague 5 : options noyau GRUB (11 règles) | 180 | 20 | 90 % |
| Audit final | 180 | 20 | 90 % |

## Script d'audit Bash (16 contrôles choisis par l'auditeur)
Mesuré après les vagues OpenSCAP, pas sur l'état initial : ce n'est pas un avant / après du durcissement.
| Étape | Pass | Fail | Brute | Pondérée |
|---|---|---|---|---|
| Premier audit | 13 | 3 | 81,2 % | 87,0 % |
| Après correction SSH-03 et SSH-04 | 15 | 1 | 93,8 % | 93,5 % |
| Après correction SSH-02 (clé SSH, mot de passe désactivé) | 16 | 0 | 100 % | 100 % |

## Autres mesures
| Mesure | Avant | Final |
|---|---|---|
| Score pondéré OpenSCAP (ANSSI) | 60,8 | 88,2 |
| Indice Lynis | 67 | 71 |
| Suggestions Lynis | 40 | 37 |
| Services en écoute | 4 (sshd, chronyd, avahi, cups) | 2 (sshd, chronyd en local) |
| CIS niveau 1 | non mesuré | voir docs/scores-openscap.md |

## Observations
- Après la vague 2A, deux règles d'ownership (home_files_ownership, home_files_groupownership) sont passées de PASS à FAIL, corrigées par chown.
- home_files_permissions échouait à cause de gvfs-metadata (interface graphique GNOME), recréé en mode 644.
- Un premier scan final a donné 177 pass / 23 fail : les rapports CSV du script, écrits par root dans ~/rhel-audit/reports, faisaient échouer trois règles sur le dossier personnel. audit.sh corrige maintenant les droits de ses rapports, et le scan final est à 180 / 20.
- ip_forward = 0 appliqué : la VM n'est pas un routeur.
- faillock : deny = 3, fail_interval = 900, unlock_time = 900, even_deny_root.
- dnf-automatic a installé un nouveau noyau (5.14.0-687.54.1 puis 687.56.1), openssl et glibc entre deux mesures.
- Le score pondéré d'OpenSCAP progresse moins que le taux brut : les règles pèsent selon leur sévérité.
EOF_PROG

# 2. resultats-avant.md : valeurs réelles à la place de « à compléter »
if [ -f docs/resultats-avant.md ]; then
  sed -i 's|Score OpenSCAP pondéré (rapport HTML) : à compléter|Score OpenSCAP pondéré (champ score du XML) : 60,8|' docs/resultats-avant.md
  sed -i 's|Hardening index Lynis : à compléter|Hardening index Lynis : 67|' docs/resultats-avant.md
fi

# 3. Régénérer index et scores (inclut le scan CIS s'il est dans le dépôt)
[ -f apply-fixes.sh ] && bash apply-fixes.sh > /dev/null

# 4. Scan CIS : liste des écarts et mise à jour des documents
CIS=evidence/apres/final-cis-l1.xml
if [ -f "$CIS" ]; then
  count() { grep -o "<result>$2</result>" "$1" | wc -l; }
  P=$(count "$CIS" pass); F=$(count "$CIS" fail); N=$(count "$CIS" notapplicable)
  PCT=$(awk -v p="$P" -v f="$F" 'BEGIN{printf "%.1f", 100*p/(p+f)}' | sed 's/\./,/')
  awk '/<rule-result /{match($0,/idref="[^"]*"/); id=substr($0,RSTART+7,RLENGTH-8)} /<result>fail<\/result>/{print id}' "$CIS" \
    | sed 's/xccdf_org.ssgproject.content_rule_//' | sort > evidence/apres/cis-l1-fail.txt
  if ! grep -q "Conformité brute CIS" docs/scores-openscap.md 2>/dev/null; then
    printf '\nConformité brute CIS L1 (pass / (pass + fail)) : %s %%, soit %s sur %s règles évaluées. Aucun scan CIS n'"'"'a été fait à l'"'"'état initial : aucun gain CIS ne peut être affirmé. Liste des écarts : evidence/apres/cis-l1-fail.txt.\n' "$PCT" "$P" "$((P+F))" >> docs/scores-openscap.md
  fi
  if [ -f docs/grille-audit.md ] && ! grep -q "Révision après le scan CIS niveau 1" docs/grille-audit.md; then
    cat >> docs/grille-audit.md << EOF_G

## Révision après le scan CIS niveau 1 (état final)
- G-01 : profil CIS L1 serveur, $P pass / $F fail / $N non applicables, soit $PCT % de règles conformes sur $((P+F)) évaluées (EV-001, evidence/apres/final-cis-l1.xml). Profil ANSSI : 180 pass / 20 fail (90 %).
- Le durcissement visait le profil ANSSI. Le résultat CIS est présenté tel que mesuré, sans scan CIS à l'état initial.
- Classification de G-01 : ANSSI, non-conformité mineure. CIS L1 : à finaliser après analyse de evidence/apres/cis-l1-fail.txt. Choix du référentiel à valider avec l'enseignant.
- G-04 : à réexaminer avec les écarts CIS liés aux mots de passe.
EOF_G
  fi
  if [ -f docs/constats.md ] && ! grep -q "C-01 (révision)" docs/constats.md; then
    cat >> docs/constats.md << EOF_C

## C-01 (révision) : scan CIS niveau 1
- Preuve : EV-001, final-cis-l1.xml. $P pass / $F fail / $N non applicables ($PCT % sur $((P+F)) règles).
- Analyse : l'écart avec le profil ANSSI (90 %) s'explique par le périmètre du durcissement, qui visait l'ANSSI. La classification finale du constat selon le CIS dépend de la nature des $F écarts (cis-l1-fail.txt) et du référentiel retenu avec l'enseignant.
EOF_C
  fi
  echo "Scan CIS : pass=$P fail=$F notapplicable=$N brut=$PCT %"
  echo "Écarts CIS par famille de règles :"
  sed 's/_.*//' evidence/apres/cis-l1-fail.txt | sort | uniq -c | sort -rn
  echo "Écarts CIS liés aux mots de passe et sessions :"
  grep -E "password|pam_|faillock|pwquality|umask|tmout|accounts_" evidence/apres/cis-l1-fail.txt || echo "aucun"
else
  echo "Scan CIS absent du dépôt (evidence/apres/final-cis-l1.xml) : étape CIS ignorée."
fi

echo
git status --short
echo
echo "Si tout est correct : git add -A && git commit -m \"Corrections : progression, résultats avant, scan CIS\" && git push"
