# Dépannage - Event Tap ne fonctionne pas après notarisation

## Problème
L'application fonctionnait avant la notarisation mais ne reçoit plus les événements maintenant.

## Diagnostic immédiat

### 1. Vérifier les logs au démarrage

Dans la Console, recherchez `com.tbvirtualcontroller` et vérifiez ces messages au démarrage :

**Si vous voyez :**
- ✅ "Event tap créé avec succès"
- ✅ "Event tap actif et prêt" → L'event tap est créé et actif
- ❌ "Event tap créé mais NON ACTIF" → macOS bloque l'event tap

### 2. Si l'event tap est INACTIF

**Causes possibles :**

1. **Permissions d'accessibilité** :
   - Réglages Système > Confidentialité et sécurité > Accessibilité
   - L'application doit être présente ET cochée
   - **Important** : Après avoir coché, QUITTEZ complètement l'application (⌘Q) et relancez-la

2. **Entitlements non signés** :
   - L'application notarisée doit avoir les entitlements signés
   - Vérifiez que le fichier entitlements est bien inclus dans le build
   - Vérifiez que `CODE_SIGN_ENTITLEMENTS` est correctement configuré

3. **Application signée différemment** :
   - L'application de développement vs l'application notarisée peuvent avoir des comportements différents
   - Testez avec l'application de développement (⌘R dans Xcode) pour comparer

### 3. Si l'event tap est ACTIF mais aucun événement n'est reçu

**Causes possibles :**

1. **L'application notarisée bloque les event taps** :
   - Certaines restrictions de sécurité peuvent bloquer les event taps même avec les permissions
   - Essayez de désactiver temporairement Gatekeeper pour tester

2. **Le run loop n'est pas actif** :
   - Vérifiez que l'application est bien au premier plan
   - Vérifiez que le run loop principal est actif

## Solution de contournement : Tester avec l'application de développement

1. Dans Xcode, lancez l'application directement (⌘R)
2. Vérifiez si les événements sont reçus
3. Si oui → Le problème vient de la notarisation/signature
4. Si non → Le problème est ailleurs

## Vérification des entitlements dans l'application notarisée

Vérifiez que les entitlements sont bien inclus dans l'application exportée :

```bash
codesign -d --entitlements - /chemin/vers/TBVirtualController.app
```

Vous devriez voir :
```
com.apple.security.app-sandbox = false
com.apple.security.cs.allow-dyld-environment-variables = true
com.apple.security.cs.disable-library-validation = true
```

## Solution alternative : Recompiler depuis Xcode

Si l'application notarisée ne fonctionne pas, essayez de :
1. Recompiler depuis Xcode (⌘R)
2. Vérifier si ça fonctionne
3. Si oui, re-exporter et re-notariser

