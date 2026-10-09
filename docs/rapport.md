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
| Mots de passe (13 règles) | 153 | 47 | 76,5 % |
| faillock (4 règles) | 157 | 43 | 78,5 % |
| SSH et sudo (4 règles) | 161 | 39 | 80,5 % |
| AIDE, dnf-automatic (8 règles) | 169 | 31 | 84,5 % |
| Options noyau GRUB (11 règles) | 180 | 20 | 90 % |

## 7. Résultats
- OpenSCAP : 87/113 puis 180/20 (EV-001). Lynis : 67 puis 71 (EV-002).
- Ports : avant, sshd, chronyd, avahi et cups en écoute, cockpit autorisé dans le pare-feu. Après, sshd et chronyd (local) seulement, pare-feu limité à ssh et dhcpv6-client, scan externe : 22/tcp ouvert (EV-003).
- Script Bash : 13/3 puis 16/0 sur 16 contrôles choisis par l'auditeur. Ce score ne représente pas tout le système.

## 8. Constats
Voir docs/constats.md (C-01 à C-07).

## 9. Recommandations et plan d'actions
Voir docs/plan-actions.md (AC-01 à AC-05) et docs/EV-007-ecarts-priorises.md.

## 10. Limites
- Scan nmap initial invalide (0 hôte détecté, option -Pn absente) : état initial des ports établi par ss et firewall-cmd.
- Interface graphique installée malgré le choix « Serveurs ».
- Le système a évolué entre les mesures (dnf-automatic : nouveau noyau, openssl, glibc).
- Les rapports du script d'audit ont dégradé trois règles OpenSCAP (droits des fichiers), corrigé dans audit.sh.
- Notes de priorisation et classifications : jugement de l'auditeur.
- OpenSCAP et Lynis mesurent des points différents : l'indice Lynis a peu bougé malgré un fort gain OpenSCAP.

## 11. Conclusion
Le durcissement a corrigé 93 règles du profil et réduit la surface d'attaque à un seul port. Les écarts restants (partitions, services graphiques, timeouts, GRUB) sont planifiés dans le plan d'actions.

## 12. Annexes
evidence/avant/, evidence/apres/, reports/, audit.sh, checks/, docs/.
