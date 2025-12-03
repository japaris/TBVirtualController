# Correction du problème avec l'application notarisée

## Problème

L'application notarisée ne capture pas les touches média même si les permissions d'accessibilité sont accordées.

## Solutions

### 1. Ajouter le fichier Entitlements au projet Xcode

1. Ouvrez le projet dans Xcode
2. Faites un clic droit sur le dossier `TBVirtualController` dans le navigateur
3. Sélectionnez **Add Files to "TBVirtualController"...**
4. Sélectionnez `TBVirtualController.entitlements`
5. Cochez **Copy items if needed** et **Add to targets: TBVirtualController**
6. Cliquez sur **Add**

### 2. Configurer les Build Settings

1. Sélectionnez le projet **TBVirtualController** dans le navigateur
2. Sélectionnez la cible **TBVirtualController**
3. Allez dans l'onglet **Build Settings**
4. Recherchez **Code Signing Entitlements**
5. Pour les configurations **Debug** et **Release**, ajoutez :
   ```
   TBVirtualController/TBVirtualController.entitlements
   ```

### 3. Vérifier les permissions

1. **Réglages Système > Confidentialité et sécurité > Accessibilité**
2. Vérifiez que **TB Virtual Controller** est bien dans la liste
3. Si présent mais non coché, cochez-le
4. Si absent, ajoutez-le manuellement

### 4. Redémarrer l'application

**IMPORTANT** : Après avoir accordé les permissions, vous devez **redémarrer complètement l'application** (pas juste la fermer et la rouvrir, mais quitter complètement).

1. Quittez l'application (⌘Q)
2. Attendez quelques secondes
3. Relancez l'application

### 5. Vérifier les logs

Ouvrez la Console (Applications > Utilitaires > Console) et recherchez :
- `com.tbvirtualcontroller`
- Vérifiez les messages d'erreur ou de succès concernant l'event tap

### 6. Recompiler et renotariser

Après avoir ajouté le fichier entitlements :

1. **Product > Clean Build Folder** (⇧⌘K)
2. **Product > Archive**
3. **Distribute App > Developer ID > Export**
4. **Re-notariser** le DMG si nécessaire

## Vérification

Une fois ces étapes terminées, l'application devrait :
- ✅ Afficher "Accessibilité activée" en vert dans l'interface
- ✅ Afficher "Event tap actif et prêt" dans les logs
- ✅ Capturer les touches média et envoyer les messages MIDI

## Diagnostic

Si le problème persiste, vérifiez dans les logs :

1. **"Event tap créé avec succès"** → L'event tap est créé
2. **"Event tap activé"** → L'event tap est activé
3. **"Event tap actif et prêt"** → Tout fonctionne
4. **"CGEvent.tapCreate retourne nil"** → Problème de permissions ou entitlements

## Notes importantes

- Les applications notarisées nécessitent des entitlements explicites
- Le sandboxing doit être désactivé (`com.apple.security.app-sandbox = false`)
- L'application doit être relancée après l'ajout des permissions
- Les entitlements doivent être inclus dans le build et la signature

