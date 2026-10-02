# Audit automatisé de la configuration et de la conformité de sécurité d'un serveur RHEL durci

## 1. Contexte
Un serveur Linux installé par défaut n'est pas sécurisé de façon optimale.
Le durcissement réduit la surface d'attaque, mais il faut pouvoir vérifier
qu'il est réellement appliqué et qu'il le reste dans le temps.

## 2. Problématique
Comment vérifier automatiquement qu'un serveur RHEL durci respecte les
bonnes pratiques de sécurité, et identifier les écarts et mauvaises
configurations restantes ?

## 3. Objectifs
- Mettre en place un serveur RHEL 9 de laboratoire.
- Réaliser un audit initial (état « avant »).
- Appliquer un durcissement documenté et reproductible.
- Réaliser un audit final (état « après ») avec les mêmes outils.
- Comparer les résultats, analyser les écarts restants et proposer
  des recommandations.

## 4. Périmètre
- Inclus : 1 serveur RHEL 9 (VM), configuration système, SSH, pare-feu,
  SELinux, comptes, journalisation, services, noyau, réseau.
- Exclus : applications métier, tests d'intrusion applicatifs,
  sécurité physique, infrastructure réseau externe.

## 5. Référentiels
- Principal : ANSSI-BP-028 (niveau intermediary).
- Comparaison (optionnel) : CIS Level 1.
- Justification : [à compléter : référentiel français, couvert par
  OpenSCAP / scap-security-guide, adapté à un serveur GNU/Linux]

## 6. Outils
| Outil | Rôle |
|---|---|
| OpenSCAP | Audit de conformité par rapport au référentiel |
| Lynis | Seconde analyse indépendante |
| Scripts Bash | Contrôles personnalisés, rapport CSV/HTML |
| Nmap | Mesure de la surface d'attaque depuis l'extérieur |
| Ansible | Durcissement reproductible |
| Git | Traçabilité et preuves |

## 7. Méthodologie
Préparation → Audit initial → Analyse → Durcissement → Audit final
→ Comparaison → Recommandations

## 8. Méthode de scoring
- Statuts : PASS, FAIL, N/A, MANUEL
- Criticité : Critique (x4), Élevée (x3), Moyenne (x2), Faible (x1)
- Score = somme des poids des PASS / somme des poids des contrôles applicables

## 9. Livrables
- Rapport d'audit (avant / après / comparaison)
- Dépôt Git (scripts, playbooks, preuves)
- Démonstration en direct


