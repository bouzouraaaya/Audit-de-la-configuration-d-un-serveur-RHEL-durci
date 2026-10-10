# Audit de la configuration d'un serveur RHEL durci (L-03)
Auteurs : [NOMS DU BINÔME]. Date : [DATE]. Enseignant : [NOM].

## 1. Résumé exécutif
Une VM RHEL 9.8 a été auditée avec OpenSCAP (profil ANSSI-BP-028 intermediary), Lynis, des commandes de lecture et 16 contrôles Bash. La conformité OpenSCAP est passée de 43,5 % (87/200) à 90 % (180/200) après durcissement, l'indice Lynis de 67 à 71. Un seul port est exposé (SSH, authentification par clé). Il reste 20 écarts, priorisés (3 P1, 9 P2, 8 P3), sans service exposé inutilement.

## 2. Contexte et objectifs
Un serveur RHEL par défaut expose une surface d'attaque inutile. Objectif : établir si les critères A.8.9 et A.8.19 et le profil de durcissement sont respectés, puis recommander et planifier des actions (démarche ISO 19011).

## 3. Périmètre
Une VM VMware en laboratoire isolé. Services, comptes, pare-feu local, mises à jour, noyau, mots de passe. Hors périmètre : [À PRÉCISER PAR L'ENSEIGNANT].

## 4. Référentiels
A.8.9, A.8.19 (reformulations à confirmer avec la norme). Profil scanné : ANSSI-BP-028 intermediary (CIS RHEL cité dans le cahier des charges : [À CONFIRMER]).

## 5. Méthodologie
Programme d'audit : docs/programme-audit.md. Tests T-01 à T-07, preuves EV-001 à EV-007, grille et matrice : docs/grille-audit.md, docs/matrice.md.

## 6. Démarche suivie
1. Audit initial de la cible installée par défaut (OpenSCAP, Lynis, ports, pare-feu).
2. Préparation de la cible : durcissement en vagues avec snapshot et nouveau scan à chaque étape.
3. Audit final avec les mêmes outils.

| Étape | Pass | Fail | Conformité brute |
|---|---|---|---|
| État initial | 87 | 113 | 43,5 % |
| Vague 1 : sysctl (52 règles) | 139 | 61 | 69,5 % |
| Mots de passe (13 règles) et droits du dossier personnel | 153 | 47 | 76,5 % |
| faillock (4 règles) | 157 | 43 | 78,5 % |
| SSH et sudo (4 règles) | 161 | 39 | 80,5 % |
| AIDE, dnf-automatic (8 règles) | 169 | 31 | 84,5 % |
| Options noyau GRUB (11 règles) | 180 | 20 | 90 % |

## 7. Résultats
- OpenSCAP : 87/113 puis 180/20 (EV-001). Lynis : 67 puis 71 (EV-002).
- Ports : avant, sshd, chronyd, avahi et cups en écoute, cockpit autorisé dans le pare-feu. Après, sshd et chronyd (local) seulement, pare-feu limité à ssh et dhcpv6-client, scan externe : 22/tcp ouvert (EV-003).
- Script Bash (mesuré après les vagues OpenSCAP, pas sur l'état initial) : 13/3 puis 16/0 sur 16 contrôles choisis par l'auditeur. Ce score ne représente pas tout le système.

## 8. Constats
Voir docs/constats.md (C-01 à C-07).

## 9. Recommandations et plan d'actions
Voir docs/plan-actions.md (AC-01 à AC-05) et docs/EV-007-ecarts-priorises.md.

## 10. Limites
- Scan nmap initial invalide (0 hôte détecté, option -Pn absente) : état initial des ports établi par ss et firewall-cmd.
- Interface graphique installée (service gdm actif).
- Le système a évolué entre les mesures (dnf-automatic : nouveau noyau, openssl, glibc).
- Les rapports du script d'audit ont dégradé trois règles OpenSCAP (droits des fichiers), corrigé dans audit.sh.
- Notes de priorisation et classifications : jugement de l'auditeur.
- OpenSCAP et Lynis mesurent des points différents : l'indice Lynis a peu bougé malgré un fort gain OpenSCAP.

## 11. Conclusion
Le durcissement a corrigé 93 règles du profil et réduit la surface d'attaque à un seul port. Les écarts restants (partitions, services graphiques, timeouts, GRUB) sont planifiés dans le plan d'actions.

## 12. Annexes
evidence/avant/, evidence/apres/, reports/, audit.sh, checks/, docs/.

## 10 bis. Précisions de méthode
- Le script Bash n'a pas été exécuté sur l'état initial : son score ne mesure pas le gain du durcissement. Les trois réglages SSH qu'il testait ont ensuite été corrigés, donc son 100 % final est en partie circulaire.
- La cible et le poste auditeur sont la même VM. Le scan externe vient d'une seconde VM Ubuntu.
- Le compte auditeur dispose d'un sudo complet, alors que le cahier des charges prévoit une lecture et un diagnostic.
- Le scan externe ne couvre que le TCP. L'UDP n'est connu que par ss (chronyd, en local).
- Référentiel : le cahier des charges cite le CIS RHEL, le profil ANSSI-BP-028 a été scanné. Le scan CIS L1 est documenté dans docs/scores-openscap.md s'il a été exécuté.
- A.8.19 : le cahier des charges rattache T-05 (correctifs) à A.8.19. La gestion des vulnérabilités relève plutôt de A.8.8 : à confirmer avec le texte de la norme.
- Scores pondérés OpenSCAP : docs/scores-openscap.md. Index des preuves : docs/index-preuves.md.

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

## Scores pondérés
Score pondéré OpenSCAP : 60,8 avant, 88,2 final (conformité brute : 43,5 % puis 90 %). Les deux mesures sont données car la pondération par sévérité réduit l'écart. Détail : docs/scores-openscap.md.
