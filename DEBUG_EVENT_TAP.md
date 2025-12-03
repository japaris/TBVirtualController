# Debug de l'Event Tap

## Problème
L'application compile mais n'intercepte pas les touches média - macOS les traite toujours.

## Diagnostic

### 1. Vérifier les logs dans la Console

Ouvrez la Console (Applications > Utilitaires > Console) et recherchez `com.tbvirtualcontroller`.

**Logs attendus au démarrage :**
- ✅ "Event tap créé avec succès"
- ✅ "Event tap actif et prêt"

**Logs attendus lors d'un appui sur une touche média :**
- 📥 "Événement système reçu"
- 📋 "Événement système - Type: X, Subtype: Y"
- ✅ "Événement système détecté (subtype 8 = touches média)"
- 🎹 "Touche média détectée: [key] - Consommation de l'événement"

### 2. Si aucun log n'apparaît lors des appuis

**Problème :** L'event tap ne reçoit pas les événements.

**Solutions possibles :**
1. **Vérifier les permissions** : Réglages Système > Confidentialité et sécurité > Accessibilité
   - L'application doit être présente ET cochée
   - Redémarrer l'application après avoir accordé les permissions

2. **Vérifier que l'event tap est actif** :
   - Les logs doivent montrer "Event tap actif et prêt"
   - Si "Event tap créé mais non actif", il y a un problème de permissions

3. **Vérifier les entitlements** :
   - Le fichier `TBVirtualController.entitlements` doit être présent
   - `com.apple.security.app-sandbox` doit être `false`

### 3. Si les logs montrent que les événements sont reçus mais macOS les traite quand même

**Problème :** L'événement n'est pas correctement consommé.

**Solutions :**
1. Vérifier que `return nil` est bien exécuté dans `handleEvent`
2. Vérifier que l'event tap utilise `.headInsertEventTap` (déjà fait)
3. Essayer avec `.cgAnnotatedSessionEventTap` au lieu de `.cgSessionEventTap`

### 4. Test manuel

1. Lancez l'application
2. Ouvrez la Console et filtrez par `com.tbvirtualcontroller`
3. Appuyez sur une touche média (volume, play, etc.)
4. Observez les logs :
   - **Aucun log** → L'event tap ne fonctionne pas (problème de permissions/entitlements)
   - **Logs mais macOS traite quand même** → Problème de consommation d'événement
   - **Logs et événement consommé** → Ça fonctionne !

## Solution alternative : Utiliser IOKit

Si l'event tap ne fonctionne toujours pas, il faudra peut-être utiliser IOKit directement pour intercepter les touches média au niveau du driver, mais c'est beaucoup plus complexe.

