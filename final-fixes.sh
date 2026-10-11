#!/bin/bash
# final-fixes.sh : à lancer à la racine du dépôt, APRÈS fix-docs.sh. Ne modifie aucune preuve. Ne fait ni commit ni push.
# Les chiffres CIS viennent des sorties que tu m'as données : 184 pass / 91 fail / 20 non applicables.
set -u
if [ ! -d docs ] || [ ! -f evidence/apres/final-cis-l1.xml ]; then
  echo "Lance fix-docs.sh d'abord, depuis la racine du dépôt (final-cis-l1.xml doit être dans evidence/apres)."
  exit 1
fi

# 1. Grille : classification finale proposée
if [ -f docs/grille-audit.md ] && ! grep -q "Classification finale proposée" docs/grille-audit.md; then
cat >> docs/grille-audit.md << 'EOF_G'

## Classification finale proposée (après analyse des écarts CIS)
Jugement d'auditeur (critère + preuve + analyse), à valider avec l'enseignant, ainsi que le référentiel retenu.

| ID | Profil ANSSI-BP-028 | CIS RHEL 9 niveau 1 |
|---|---|---|
| G-01 | Non-conformité mineure (180 pass / 20 fail, 90 %) | Non-conformité majeure (184 pass / 91 fail, 66,9 %) |
| G-02 | Observation | Observation : Lynis recoupe OpenSCAP sur plusieurs thèmes (docs/constats.md, C-08) |
| G-03 | Non-conformité mineure | Non-conformité mineure : dont 11 écarts dconf et gnome liés à l'interface graphique |
| G-04 | Conforme, avec observation | Non-conformité mineure : expiration, historique et dictionnaire des mots de passe absents |
| G-05 | Inchangé | À confirmer avec evidence/apres/cis-l1-fail.txt |
| G-06 | Conforme (rp_filter, ASLR, options GRUB) | Non-conformité mineure : 12 écarts sysctl et kernel, à détailler |
| G-07 | Conforme | Conforme |

Justification de G-01 selon le CIS : 66,9 % de règles conformes et 91 écarts répartis sur l'authentification, SSH, l'interface graphique, les permissions et le noyau. Le cahier des charges définit la non-conformité majeure comme un écart significatif nécessitant une action corrective importante. Facteurs atténuants : un seul port exposé (22/tcp, authentification par clé) et un pare-feu limité à SSH.
EOF_G
fi

# 2. Constats : C-04 révisé et C-08 (écarts CIS)
if [ -f docs/constats.md ] && ! grep -q "C-04 (révision CIS)" docs/constats.md; then
cat >> docs/constats.md << 'EOF_C4'

## C-04 (révision CIS) : mots de passe, non-conformité mineure selon le CIS
- Critère : politique conforme au référentiel. Le cahier des charges qualifie de non conforme une politique plus faible que le référentiel.
- Preuve : EV-004 et final-cis-l1.xml. Longueur 15, 4 classes de caractères et verrouillage après 3 échecs sont en place. PASS_MAX_DAYS = 99999, et les règles CIS d'expiration, d'historique (pwhistory), de dictionnaire et de séquences sont en échec.
- Analyse : la politique est plus faible que le CIS sur l'expiration, l'historique et les contrôles de dictionnaire : non-conformité mineure, car la complexité et le verrouillage existent. Selon le profil ANSSI intermediary, elle reste conforme avec observation.
EOF_C4
fi
if [ -f docs/constats.md ] && ! grep -q "C-08 : écarts CIS" docs/constats.md; then
cat >> docs/constats.md << 'EOF_C8'

## C-08 : écarts CIS niveau 1 (91), non-conformité majeure vis-à-vis du CIS
- Critère : benchmark CIS RHEL 9 niveau 1 (référentiel cité par le cahier des charges, C-03).
- Preuve : EV-001, evidence/apres/final-cis-l1.xml et evidence/apres/cis-l1-fail.txt. Aucun scan CIS à l'état initial : aucun gain CIS n'est affirmé.
- Analyse : le durcissement visait le profil ANSSI. Les 91 écarts par famille de règles :

| Thème | Familles (nombre) | Total | Lecture |
|---|---|---|---|
| Authentification | accounts 15, account 1, ensure 3, no 1, use 1 | 21 | Expiration, historique, dictionnaire, umask, délai de session, restriction de su, mots de passe vides. ensure_root_password_configured : root est volontairement inutilisable, à justifier plutôt qu'à corriger |
| Interface graphique | dconf 10, gnome 1 | 11 | Disparaissent si l'interface graphique est retirée |
| SSH | sshd 11 | 11 | Options supplémentaires |
| Fichiers et montages | file 10, mount 3, partition 1 | 14 | Permissions, options de montage, /tmp |
| Noyau | sysctl 6, kernel 6 | 12 | À détailler avec cis-l1-fail.txt |
| Services et journalisation | service 5, firewalld 2, sudo 2, journald 2, rsyslog 1, aide 2 | 14 | À détailler |
| Bannières et core dumps | banner 2, coredump 2 | 4 | Correction simple |
| Autres | grub2 1, package 1, disable 1, configure 1 | 4 | À détailler |

Recoupements avec Lynis, par thème (la correspondance règle à règle n'a pas été vérifiée) :
| Lynis | CIS (OpenSCAP) |
|---|---|
| AUTH-9286 (âge des mots de passe) | accounts_maximum_age_login_defs, accounts_password_set_max_life_existing |
| AUTH-9328 (umask 027) | accounts_umask_etc_login_defs, _etc_profile, _etc_bashrc |
| BANN-7126, BANN-7130 | famille banner |
| KRNL-5820 (core dumps) | famille coredump |
| SSH-7408 (8 occurrences) | famille sshd |
| FILE-6310 (partitions) | partition, et partition_for_* côté ANSSI |
EOF_C8
fi

# 3. Plan d'actions : actions issues du CIS (lignes ajoutées à la suite du tableau)
if [ -f docs/plan-actions.md ] && ! grep -q "| AC-06 |" docs/plan-actions.md; then
cat >> docs/plan-actions.md << 'EOF_PA'
| AC-06 | Mots de passe : pas d'expiration, d'historique ni de contrôle de dictionnaire (CIS) | Mot de passe compromis valable indéfiniment, réutilisation | Valeurs par défaut, PASS_MAX_DAYS = 99999 | Fixer l'âge maximum selon le benchmark, activer pwhistory, dictcheck, difok, maxrepeat et maxsequence, appliquer chage aux comptes existants | P1 | Règles accounts_* et pam_* en PASS au scan CIS suivant |
| AC-07 | umask non strict dans login.defs, profile et bashrc | Fichiers créés lisibles par d'autres | Valeurs par défaut | umask 027 dans les trois fichiers | P1 | Règles accounts_umask_*, Lynis AUTH-9328 |
| AC-08 | su non restreint, mots de passe vides acceptés par PAM et SSH (CIS) | Élévation de privilèges, comptes sans mot de passe | PAM et SSH par défaut | Restreindre su au groupe wheel (pam_wheel), retirer nullok de PAM, PermitEmptyPasswords no explicite | P1 | use_pam_wheel_group_for_su, no_empty_passwords, sshd_disable_empty_passwords en PASS |
| AC-09 | 11 écarts CIS sur la configuration SSH | Surface d'attaque SSH | Options par défaut | Appliquer les options du profil CIS dans sshd_config.d, avec session de secours et snapshot | P2 | Famille sshd en PASS, Lynis SSH-7408 |
| AC-10 | Interface graphique installée (gdm actif, 11 écarts dconf et gnome) | Surface d'attaque, écarts CIS | Environnement installé avec interface graphique | Passer en multi-user.target puis retirer les paquets graphiques, ou réinstaller en Serveur (complète AC-01) | P1 | systemctl list-units sans gdm, famille dconf absente du scan |
EOF_PA
fi

# 4. Matrice : compléments CIS
if [ -f docs/matrice.md ] && ! grep -q "Compléments après scan CIS" docs/matrice.md; then
cat >> docs/matrice.md << 'EOF_M'

## Compléments après scan CIS
| Test | Résultat CIS | Constat CIS |
|---|---|---|
| T-01 | 184 pass / 91 fail / 20 non applicables (66,9 %) | Non-conformité majeure |
| T-04 | Expiration, historique et dictionnaire des mots de passe en échec | Non-conformité mineure |
| T-06 | 12 écarts sysctl et kernel | Non-conformité mineure, à détailler |
EOF_M
fi

# 5. EV-007 : consolidation CIS
if [ -f docs/EV-007-ecarts-priorises.md ] && ! grep -q "Consolidation CIS" docs/EV-007-ecarts-priorises.md; then
cat >> docs/EV-007-ecarts-priorises.md << 'EOF_E7'

## Consolidation CIS niveau 1 (91 écarts, source : evidence/apres/cis-l1-fail.txt)
Priorités proposées par l'auditeur (impact / effort).
| Priorité | Thème | Total | Action |
|---|---|---|---|
| P1 | Authentification (accounts, account, ensure, no, use) | 21 | AC-06, AC-07, AC-08 |
| P1 | Interface graphique (dconf, gnome) | 11 | AC-10 |
| P1 | Bannières et core dumps | 4 | Correction simple |
| P2 | SSH | 11 | AC-09 |
| P2 | Fichiers, montages, partition | 14 | À détailler |
| P2 | Noyau (sysctl, kernel) | 12 | À détailler |
| P2 | Services, pare-feu, sudo, journalisation, AIDE | 14 | À détailler |
| P3 | Autres (grub2, package, disable, configure) | 4 | À détailler |
Total : 91.
EOF_E7
fi

# 6. Rapport : ligne obsolète et section finale
if [ -f docs/rapport.md ]; then
  sed -i "s|Le scan CIS L1 est documenté dans docs/scores-openscap.md s'il a été exécuté\.|Un scan CIS L1 a été exécuté sur l'état final : 184 pass / 91 fail (66,9 %), voir docs/scores-openscap.md.|" docs/rapport.md
fi
if [ -f docs/rapport.md ] && ! grep -q "## 13. Résultats CIS et classification finale" docs/rapport.md; then
cat >> docs/rapport.md << 'EOF_R'

## 13. Résultats CIS et classification finale
Complément au résumé exécutif : le scan CIS niveau 1, référentiel cité par le cahier des charges, donne 184 pass / 91 fail / 20 non applicables sur l'état final (66,9 %), sans mesure à l'état initial. Le durcissement visait le profil ANSSI (90 %).

| Question | ANSSI-BP-028 | CIS niveau 1 |
|---|---|---|
| G-01 conformité au profil | Non-conformité mineure | Non-conformité majeure |
| G-03 services | Non-conformité mineure | Non-conformité mineure |
| G-04 mots de passe | Conforme avec observation | Non-conformité mineure |
| G-06 noyau | Conforme | Non-conformité mineure |

Classifications proposées par l'auditeur : détail et justification dans docs/grille-audit.md et docs/constats.md (C-04, C-08). Le référentiel retenu est à valider avec l'enseignant.

Recommandations prioritaires : AC-10 (retirer l'interface graphique), AC-06 à AC-08 (mots de passe, umask, su), puis AC-09 (SSH). Voir docs/plan-actions.md.
EOF_R
fi

# 7. README : mention du scan CIS
[ -f README.md ] && sed -i "s|Le résultat d'un scan CIS niveau 1, s'il a été exécuté, figure|Le résultat du scan CIS niveau 1 (état final) figure|" README.md

# 8. Présentation de 5 minutes (total 300 s)
cat > docs/presentation-5min.md << 'EOF_P'
# Présentation de 5 minutes (L-05)
1. (30 s) Sujet, cible RHEL 9.8, référentiels (ANSSI-BP-028, CIS), outils.
2. (40 s) Méthode : audit initial, durcissement en vagues avec snapshots, audit final.
3. (60 s) Résultats : OpenSCAP ANSSI 43,5 % puis 90 % (pondéré 60,8 puis 88,2), Lynis 67 puis 71, CIS L1 66,9 % (aucune mesure initiale).
4. (45 s) Surface d'attaque : 4 services en écoute puis 2, un seul port ouvert (22/tcp, clé SSH).
5. (45 s) Démo en direct : sudo ./audit.sh (16 contrôles, score pondéré). Limite : mesuré après le durcissement.
6. (50 s) Constats : ANSSI non-conformité mineure, CIS non-conformité majeure, 20 écarts ANSSI priorisés en P1, P2 et P3.
7. (20 s) Plan d'actions : retirer l'interface graphique, politique de mots de passe, options SSH.
8. (10 s) Limites : nmap initial invalide, système évolutif (dnf-automatic), score du script non comparable.
EOF_P

# 9. Index : ajouter les nouvelles preuves CIS
if [ -f docs/index-preuves.md ]; then
  for f in evidence/apres/final-cis-l1.html evidence/apres/cis-l1-fail.txt; do
    if [ -f "$f" ] && ! grep -q "$f" docs/index-preuves.md; then
      echo "| EV-001 final CIS L1 | $f | non commité | $(sha256sum "$f" | cut -c1-64) |" >> docs/index-preuves.md
    fi
  done
fi

echo
echo "Champs encore à remplir par toi (aucun n'est inventé) :"
grep -rnE "\[(À PRÉCISER|À CONFIRMER|À renseigner|NOM|NOMS|DATE|À FIXER)" docs README.md | cut -c1-110
echo
git status --short
echo
echo "Si tout est correct : git add -A && git commit -m \"Analyse CIS, classification finale, plan d'actions, présentation\" && git push"
