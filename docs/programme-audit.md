# Programme et plan d'audit (L-01)

## 1. Objectif
Évaluer la conformité de la configuration d'un serveur RHEL 9.8 durci aux critères A.8.9 (gestion de la configuration) et A.8.19 (installation de logiciels), avec un profil de durcissement SCAP. Démarche : ISO 19011.

## 2. Périmètre
- Inclus : une VM RHEL 9.8 (VMware) en laboratoire isolé. Services, comptes, pare-feu local, mises à jour, paramètres noyau, politique de mots de passe.
- Organisationnel : administrateur système (simulé), binôme auditeur.
- Hors périmètre : [À PRÉCISER PAR L'ENSEIGNANT]. Aucune donnée métier réelle.

## 3. Référentiel et critères
- Profil scanné : ANSSI-BP-028 intermediary (scap-security-guide 0.1.82). Le cahier des charges cite le CIS RHEL : [À CONFIRMER AVEC L'ENSEIGNANT].
- A.8.9 et A.8.19 : reformulations d'aide à l'audit, à confirmer avec le texte de la norme.

## 4. Méthode
Audit technique : scans OpenSCAP et Lynis, commandes de lecture (systemctl, ss, dnf, sysctl), 16 contrôles Bash maison (audit.sh). Tests T-01 à T-07, preuves EV-001 à EV-007.

## 5. Échantillonnage
- OpenSCAP : 200 règles évaluées sur 1 540 présentes dans le fichier (le reste est hors profil : 1 313 notselected, 26 non applicables, 1 non vérifiée).
- Contrôles Bash : 16, choisis par l'auditeur. Leur score ne représente pas tout le système.

## 6. Critère de priorisation des écarts
Impact (1 à 3) et effort/risque (1 à 3). P1 : bon gain, effort simple. P2 : à planifier. P3 : risque accepté ou non pertinent. Détail : docs/EV-007-ecarts-priorises.md.

## 7. Classification des constats
Conforme, non-conformité majeure, non-conformité mineure, observation. Chaque classification est justifiée par critère + preuve + analyse.

## 8. Planning
Trois séances, dates à fixer par l'enseignant : [À PRÉCISER].
1. Cadrage et préparation (snapshot, référentiel, programme, grille).
2. Exécution des tests T-01 à T-07 et collecte des preuves.
3. Rapport, plan d'actions, présentation de 5 minutes maximum.

## 9. Responsabilités
Auditeur 1 (technique) : [NOM]. Auditeur 2 (conformité) : [NOM].

## 10. Règles de sécurité
Laboratoire isolé, snapshots avant chaque vague de modification, données fictives, preuves versionnées dans Git.

## 11. Limites connues
- Le scan nmap initial est invalide (0 hôte détecté, option -Pn absente). L'état initial des ports s'appuie sur ss et firewall-cmd (evidence/avant/).
- L'installation contient une interface graphique (service gdm actif).
- Le système a évolué entre les mesures : dnf-automatic a installé un nouveau noyau (687.54.1 puis 687.56.1) et mis à jour openssl et glibc.
- Les rapports du script d'audit ont temporairement dégradé trois règles OpenSCAP (droits des fichiers). Corrigé dans audit.sh.
- Profil ANSSI scanné à la place du CIS : à valider.
