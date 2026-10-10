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
