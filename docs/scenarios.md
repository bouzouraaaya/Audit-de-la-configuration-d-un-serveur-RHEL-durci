# Scénarios d'audit (section 18)
Ces scénarios n'ont pas été rejoués séparément : chacun est rapproché d'une mesure existante.

| ID | Situation | Observé | Preuve | Conclusion |
|---|---|---|---|---|
| SC-01 | Profil appliqué avant remise | État final : 180 pass / 20 fail avec le profil ANSSI. CIS : voir docs/scores-openscap.md | EV-001 | Conformité élevée au profil ANSSI |
| SC-02 | Service inutile actif | À l'état initial, avahi (5353/UDP), cups (631, local) et cockpit (autorisé dans le pare-feu) sont détectés par ss et firewall-cmd. Ils étaient présents par défaut, non activés volontairement | EV-003 (avant) | Écart détecté et priorisé |
| SC-03 | Politique de mots de passe absente | À l'état initial, OpenSCAP signale en échec minlen, dcredit, ucredit, faillock et rounds (valeurs par défaut) | EV-001 (avant) | Non-conformité relevée |
