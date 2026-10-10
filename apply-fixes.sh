#!/bin/bash
# apply-fixes.sh : à lancer à la racine du dépôt (Git Bash, dossier rhel-audit).
# Ne modifie aucune preuve existante. Ne fait ni commit ni push.
set -u
if [ ! -d docs ] || [ ! -d evidence ]; then
  echo "Lance ce script depuis la racine du dépôt (dossier rhel-audit)."
  exit 1
fi

# 0. Fichier de travail qui n'est pas une preuve
git rm -q --ignore-unmatch evidence/apres/tmp.xml 2>/dev/null

# 1. Index des preuves avec SHA-256
files=(
"EV-001 initial|evidence/avant/avant-anssi.xml"
"EV-001 initial|evidence/avant/avant-anssi.html"
"EV-001 final|evidence/apres/final-anssi.xml"
"EV-001 final|evidence/apres/final-anssi.html"
"EV-001 final CIS L1 (si exécuté)|evidence/apres/final-cis-l1.xml"
"EV-002 initial|evidence/avant/lynis-report.dat"
"EV-002 initial|evidence/avant/lynis.log"
"EV-002 final|evidence/apres/lynis-final-report.dat"
"EV-002 final|evidence/apres/lynis-final.log"
"EV-002 final|evidence/apres/lynis-suggestions.txt"
"EV-003 initial|evidence/avant/ports-ecoute.txt"
"EV-003 initial|evidence/avant/firewall.txt"
"EV-003 initial (invalide, 0 hôte détecté)|evidence/avant/nmap-avant.txt"
"EV-003 final|evidence/apres/EV-003-services.txt"
"EV-003 final|evidence/apres/EV-003-ports.txt"
"EV-003 final|evidence/apres/firewall.txt"
"EV-003 final|evidence/apres/nmap-apres.txt"
"EV-004|evidence/apres/EV-004-pwquality.txt"
"EV-004|evidence/apres/EV-004-logindefs.txt"
"EV-004|evidence/apres/EV-004-faillock.txt"
"EV-005|evidence/apres/EV-005-check-update.txt"
"EV-005|evidence/apres/EV-005-history.txt"
"EV-005|evidence/apres/EV-005-history10.txt"
"EV-005|evidence/apres/EV-005-security.txt"
"EV-006|evidence/apres/EV-006-cmdline.txt"
"EV-006|evidence/apres/EV-006-sysctl.txt"
"EV-007|docs/EV-007-ecarts-priorises.md"
)
{
echo "# Index des preuves EV-001 à EV-007"
echo "Date = date du dernier commit du fichier. SHA-256 calculé sur la copie du dépôt."
echo
echo "| EV | Fichier | Date | SHA-256 |"
echo "|---|---|---|---|"
for e in "${files[@]}"; do
  ev="${e%%|*}"; f="${e#*|}"
  if [ -f "$f" ]; then
    d=$(git log -1 --format=%ad --date=short -- "$f" 2>/dev/null)
    [ -z "$d" ] && d="non commité"
    echo "| $ev | $f | $d | $(sha256sum "$f" | cut -c1-64) |"
  else
    echo "| $ev | $f | - | FICHIER ABSENT |"
  fi
done
} > docs/index-preuves.md

# 2. Scores OpenSCAP (relevés dans les XML, jamais saisis à la main)
get_score() { grep -o '<score [^>]*>[0-9.]*' "$1" 2>/dev/null | head -1 | sed 's/.*>//'; }
count() { grep -o "<result>$2</result>" "$1" 2>/dev/null | wc -l; }
S_AV=$(get_score evidence/avant/avant-anssi.xml);  [ -z "$S_AV" ]  && S_AV="non relevé"
S_FIN=$(get_score evidence/apres/final-anssi.xml); [ -z "$S_FIN" ] && S_FIN="non relevé"
{
echo "# Scores OpenSCAP"
echo
echo "## Profil ANSSI-BP-028 intermediary"
echo "| Mesure | Avant | Final |"
echo "|---|---|---|"
echo "| Pass / fail (200 règles évaluées) | 87 / 113 | 180 / 20 |"
echo "| Conformité brute (pass / 200) | 43,5 % | 90 % |"
echo "| Score pondéré calculé par OpenSCAP (champ score du XML) | $S_AV | $S_FIN |"
echo
echo "Le score pondéré est celui d'OpenSCAP : chaque règle pèse selon sa sévérité, d'où l'écart avec le taux brut."
echo
echo "## Profil CIS niveau 1 serveur (état final)"
if [ -f evidence/apres/final-cis-l1.xml ]; then
  C_P=$(count evidence/apres/final-cis-l1.xml pass); C_F=$(count evidence/apres/final-cis-l1.xml fail); C_N=$(count evidence/apres/final-cis-l1.xml notapplicable)
  C_S=$(get_score evidence/apres/final-cis-l1.xml); [ -z "$C_S" ] && C_S="non relevé"
  echo "| Pass | Fail | Non applicable | Score pondéré |"
  echo "|---|---|---|---|"
  echo "| $C_P | $C_F | $C_N | $C_S |"
  echo
  echo "Le durcissement visait le profil ANSSI : ce résultat CIS est présenté tel que mesuré, sans correction."
else
  echo "Scan CIS non exécuté à la date de ce document (evidence/apres/final-cis-l1.xml absent)."
fi
} > docs/scores-openscap.md

# 3. Documents manquants du cahier des charges
cat > docs/inventaire.md << 'EOF_INV'
# Inventaire technique (section 8)
| Composant | Version relevée | Rôle |
|---|---|---|
| RHEL (cible) | 9.8, noyau 5.14.0-687.54.1 puis 687.56.1 | Cible auditée |
| OpenSCAP | 1.3.14 | Scan de conformité |
| scap-security-guide | 0.1.82 | Profils ANSSI-BP-028 et CIS |
| Lynis | 3.1.7 | Audit complémentaire |
| AIDE | 0.19.2 | Intégrité des fichiers (durcissement) |
| OpenSSH (serveur) | 9.9 | Accès distant |
| nmap (VM Ubuntu) | 7.98 | Scan externe |
| Hyperviseur | VMware Workstation | VM cible et VM Ubuntu |
EOF_INV

cat > docs/revue-documentaire.md << 'EOF_REV'
# Revue documentaire (section 4.2, phase 3)
| Document | Statut |
|---|---|
| Profil ANSSI-BP-028 intermediary (scap-security-guide 0.1.82) | Examiné : scans OpenSCAP, 200 règles évaluées |
| Benchmark CIS RHEL 9 | Version à confirmer avec l'enseignant. Scan CIS L1 : voir docs/scores-openscap.md |
| Rapport de durcissement antérieur | Sans objet : aucune cible fournie, la cible a été préparée par l'auditeur |
| Politique de configuration de l'établissement | [À PRÉCISER PAR L'ENSEIGNANT] |
EOF_REV

cat > docs/entretien-cloture.md << 'EOF_ENT'
# Entretien et réunion de clôture (section 11, phases 5 et 9)
Entretien avec l'administrateur système (simulé : le binôme). À remplir avec les réponses réelles.
Date : [DATE]. Participants : [NOMS].

## Questions préparées
1. Quels services sont nécessaires à la mission de ce serveur ?
2. Pourquoi une interface graphique est-elle installée ?
3. Qui décide des mises à jour, et dnf-automatic est-il voulu ?
4. Quelle durée de vie des mots de passe est attendue ?
5. Quelle politique de partitionnement est attendue ?

Réponses : [À renseigner]

## Réunion de clôture (simulation)
Constats présentés : docs/constats.md.
Réactions et décisions : [À renseigner]
EOF_ENT

cat > docs/correspondance-dossier-cdc.md << 'EOF_COR'
# Correspondance avec l'arborescence de la section 20
| Dossier du cahier des charges | Contenu dans ce dépôt |
|---|---|
| 01_Cadrage | README.md |
| 02_Programme_Audit | docs/programme-audit.md, docs/revue-documentaire.md |
| 03_Grille_Audit | docs/grille-audit.md, docs/matrice.md |
| 04_Architecture, 05_Installation, 06_Configuration | docs/guides.md, docs/inventaire.md |
| 07_Tests | checks/, audit.sh, score.sh, lib.sh, reports/ (et collecte_durcissement.sh s'il est ajouté) |
| 08_Preuves | evidence/avant, evidence/apres (index : docs/index-preuves.md) |
| 09_Resultats | docs/scores-openscap.md, docs/progression.md, docs/resultats-avant.md |
| 10_Constats | docs/constats.md |
| 11_Rapport | docs/rapport.md |
| 12_Plan_Actions | docs/plan-actions.md, docs/EV-007-ecarts-priorises.md |
| 13_Presentation | docs/presentation-5min.md |
| 14_Annexes | evidence/, reports/ |
EOF_COR

cat > docs/guides.md << 'EOF_GUI'
# Guides techniques

## 1. Architecture
Poste hôte Windows (Git Bash, PowerShell, dépôt Git)
  |-- VMware, réseau 192.168.127.0/24
  |-- VM cible RHEL 9.8 : 192.168.127.135 (scans OpenSCAP et Lynis, script audit.sh)
  |-- VM Ubuntu : 192.168.127.129 (nmap, scan externe)
La cible est aussi le poste auditeur pour OpenSCAP, Lynis et les commandes de lecture.

## 2. Installation de la cible
- VMware Workstation, 2 vCPU, environ 4 Go de RAM, disque NVMe de 40 Go, démarrage UEFI.
- RHEL 9.8, partitionnement automatique : /boot/efi 600 Mo, /boot 1 Go, / environ 34 Go, swap 4 Go (LVM).
- Le compte root est inutilisable (su refusé). L'utilisateur eya a été ajouté au groupe wheel après l'installation par la procédure rd.break (incident de mot de passe documenté).
- Système enregistré chez Red Hat. Le service gdm est actif (interface graphique présente).
- Outils : openscap-scanner 1.3.14, scap-security-guide 0.1.82, Lynis 3.1.7 (EPEL), AIDE 0.19.2, dnf-automatic.

## 3. Collecte des preuves
- Dossier de travail sur la cible : ~/evidence/avant et ~/evidence/apres, copié par scp dans evidence/ du dépôt.
- Les rapports écrits avec sudo doivent être rendus à l'utilisateur (chown, chmod 640) avant tout scan, car trois règles OpenSCAP contrôlent le dossier personnel.
- Chaque preuve est indexée avec son SHA-256 dans docs/index-preuves.md, puis commitée dans un dépôt Git privé.

## 4. Remise à zéro (snapshots VMware)
Un snapshot est pris avant chaque vague de modifications. Pour revenir en arrière : VM, Snapshot, Snapshot Manager, choisir le snapshot, Go To. Prendre un snapshot final avant de remettre le projet.
EOF_GUI

cat > docs/scenarios.md << 'EOF_SCE'
# Scénarios d'audit (section 18)
Ces scénarios n'ont pas été rejoués séparément : chacun est rapproché d'une mesure existante.

| ID | Situation | Observé | Preuve | Conclusion |
|---|---|---|---|---|
| SC-01 | Profil appliqué avant remise | État final : 180 pass / 20 fail avec le profil ANSSI. CIS : voir docs/scores-openscap.md | EV-001 | Conformité élevée au profil ANSSI |
| SC-02 | Service inutile actif | À l'état initial, avahi (5353/UDP), cups (631, local) et cockpit (autorisé dans le pare-feu) sont détectés par ss et firewall-cmd. Ils étaient présents par défaut, non activés volontairement | EV-003 (avant) | Écart détecté et priorisé |
| SC-03 | Politique de mots de passe absente | À l'état initial, OpenSCAP signale en échec minlen, dcredit, ucredit, faillock et rounds (valeurs par défaut) | EV-001 (avant) | Non-conformité relevée |
EOF_SCE

# 4. Complément Lynis dans EV-007 (T-07 : consolider OpenSCAP et Lynis)
if [ -f docs/EV-007-ecarts-priorises.md ] && ! grep -q "Consolidation Lynis" docs/EV-007-ecarts-priorises.md; then
cat >> docs/EV-007-ecarts-priorises.md << 'EOF_E7'

## Consolidation Lynis (source : evidence/apres/lynis-suggestions.txt, 30 suggestions distinctes)
| Priorité | Thème | Codes Lynis | Lien OpenSCAP |
|---|---|---|---|
| P1 | Expiration et umask des mots de passe | AUTH-9282, AUTH-9286, AUTH-9328 | PASS_MAX_DAYS = 99999 (AC-02) |
| P1 | Bannières légales | BANN-7126, BANN-7130 | Hors profil ANSSI |
| P2 | Options SSH supplémentaires | SSH-7408 (8 occurrences) | Hors profil |
| P2 | Protocoles rares (dccp, rds, sctp, tipc) | NETW-3200 | Hors profil |
| P2 | Partitions séparées | FILE-6310 | partition_for_* (confirme OpenSCAP) |
| P2 | Services, core dumps, sysctl | BOOT-5264, KRNL-5820, KRNL-6000 | Partiel |
| P3 | USB et FireWire, compilateurs, antivirus | USB-1000, STRG-1846, HRDN-7222, HRDN-7230 | Hors périmètre labo |
| P3 | DNS, journalisation externe, outils | NETW-2705, NAME-4406, LOGG-2154, LOGG-2190, TOOL-5002, ACCT-9626, AUTH-9229, AUTH-9288, FILE-7524 | Environnement de labo |
Priorités proposées par l'auditeur selon le critère impact / effort.
EOF_E7
fi

# 5. Corrections de formulations non vérifiées ou trompeuses
for f in docs/programme-audit.md docs/rapport.md; do
  [ -f "$f" ] && sed -i -E 's/,? malgré le choix « Serveurs »/ (service gdm actif)/' "$f"
done
if [ -f docs/rapport.md ]; then
  sed -i 's|Script Bash : 13/3 puis 16/0|Script Bash (mesuré après les vagues OpenSCAP, pas sur l'"'"'état initial) : 13/3 puis 16/0|' docs/rapport.md
  grep -q "droits du dossier personnel" docs/rapport.md || \
    sed -i 's/Mots de passe (13 règles)/Mots de passe (13 règles) et droits du dossier personnel/' docs/rapport.md
fi

# 6. Compléments du rapport (sections 29 et limites), une seule fois
if [ -f docs/rapport.md ] && ! grep -q "## 10 bis. Précisions de méthode" docs/rapport.md; then
cat >> docs/rapport.md << 'EOF_R1'

## 10 bis. Précisions de méthode
- Le script Bash n'a pas été exécuté sur l'état initial : son score ne mesure pas le gain du durcissement. Les trois réglages SSH qu'il testait ont ensuite été corrigés, donc son 100 % final est en partie circulaire.
- La cible et le poste auditeur sont la même VM. Le scan externe vient d'une seconde VM Ubuntu.
- Le compte auditeur dispose d'un sudo complet, alors que le cahier des charges prévoit une lecture et un diagnostic.
- Le scan externe ne couvre que le TCP. L'UDP n'est connu que par ss (chronyd, en local).
- Référentiel : le cahier des charges cite le CIS RHEL, le profil ANSSI-BP-028 a été scanné. Le scan CIS L1 est documenté dans docs/scores-openscap.md s'il a été exécuté.
- A.8.19 : le cahier des charges rattache T-05 (correctifs) à A.8.19. La gestion des vulnérabilités relève plutôt de A.8.8 : à confirmer avec le texte de la norme.
- Scores pondérés OpenSCAP : docs/scores-openscap.md. Index des preuves : docs/index-preuves.md.
EOF_R1
fi
if [ -f docs/rapport.md ] && ! grep -q "## Compléments conformes à la section 29" docs/rapport.md; then
cat >> docs/rapport.md << 'EOF_R2'

## Compléments conformes à la section 29
Page de garde : titre, auteurs, date et enseignant figurent en tête de ce fichier (à compléter).

### Architecture
Voir docs/guides.md (schéma) et docs/inventaire.md (versions).

### Tests réalisés
| Test | Commande ou outil | Preuve |
|---|---|---|
| T-01 | oscap xccdf eval, profil ANSSI-BP-028 intermediary | EV-001 |
| T-02 | lynis audit system, rapports copiés depuis /var/log (sans les options --logfile et --report-file du cahier des charges) | EV-002 |
| T-03 | systemctl list-units, ss -tulnp, firewall-cmd, nmap externe | EV-003 |
| T-04 | pwquality.conf, login.defs, faillock.conf | EV-004 |
| T-05 | dnf check-update, dnf history, dnf updateinfo --security | EV-005 |
| T-06 | sysctl, /proc/cmdline | EV-006 |
| T-07 | critère impact / effort, OpenSCAP et Lynis consolidés | EV-007 |

### Preuves
Index et empreintes SHA-256 : docs/index-preuves.md. Dépôt Git privé (accès restreint).

### Analyse des risques
| Constat | Risque |
|---|---|
| Services inutiles actifs (gdm, bluetooth...) | Surface d'attaque, aujourd'hui non exposée au réseau |
| Partitions non séparées | Un disque plein peut interrompre le système |
| Mots de passe sans expiration | Un mot de passe compromis reste valable indéfiniment |
| Pas de mot de passe GRUB | Modification possible du démarrage |
| Mises à jour automatiques | Changement du système entre deux mesures |

### Références
ISO/IEC 27001:2022 (annexe A, A.8.9 et A.8.19), ISO 19011, ANSSI-BP-028, CIS Benchmark RHEL 9 [version à confirmer], documentation OpenSCAP, scap-security-guide et Lynis.
EOF_R2
fi

# 7. README cohérent avec le projet
cat > README.md << 'EOF_README'
# Audit de la configuration d'un serveur RHEL durci
Cahier des charges n° 13, classe 2, sujet 1. Cible : RHEL 9.8 (VM VMware, laboratoire isolé).

## Problématique
Un serveur RHEL durci respecte-t-il les critères A.8.9 et A.8.19 et un profil de durcissement ? Quels écarts restent, et dans quel ordre les traiter ?

## Référentiels
- Cahier des charges : A.8.9, A.8.19 et référentiel CIS RHEL.
- Profil scanné : ANSSI-BP-028 intermediary (référentiel français couvert par scap-security-guide). Le résultat d'un scan CIS niveau 1, s'il a été exécuté, figure dans docs/scores-openscap.md.
- A.8.9 et A.8.19 sont des reformulations d'aide à l'audit, à confirmer avec la norme.

## Outils
OpenSCAP, Lynis, scripts Bash (audit.sh, 16 contrôles, score pondéré), nmap (depuis une seconde VM), Git. Ansible n'a pas été utilisé : la remédiation a été appliquée avec oscap --remediate, règle par règle.

## Contenu
- docs/programme-audit.md : programme et plan d'audit
- docs/grille-audit.md, docs/matrice.md : grille et matrice
- docs/constats.md, docs/plan-actions.md, docs/EV-007-ecarts-priorises.md
- docs/rapport.md, docs/presentation-5min.md, docs/guides.md, docs/scenarios.md
- docs/index-preuves.md, docs/scores-openscap.md, docs/inventaire.md, docs/revue-documentaire.md, docs/entretien-cloture.md
- docs/correspondance-dossier-cdc.md : lien avec l'arborescence du cahier des charges
- evidence/avant, evidence/apres : preuves brutes. reports/ : sorties du script. checks/ : contrôles.

## Résultats clés
OpenSCAP : 87 puis 180 règles conformes sur 200 évaluées. Lynis : 67 puis 71. Un seul port TCP exposé (22).

## Limites
Voir docs/rapport.md, sections 10 et 10 bis.
EOF_README

echo
echo "Terminé. Vérifications :"
echo -n "Preuves absentes dans l'index (attendu : 1 si le scan CIS n'a pas été fait, sinon 0) : "
grep -c "FICHIER ABSENT" docs/index-preuves.md
echo "Phrases à supprimer encore présentes :"
grep -rn "malgré le choix" docs || echo "aucune"
echo
git status --short
echo
echo "Si tout est correct : git add -A && git commit -m \"Révision finale\" && git push"
