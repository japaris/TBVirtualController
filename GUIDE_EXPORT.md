# Guide Rapide - Exporter l'Application Indépendante

## 🚀 Étapes Rapides

### 1. Vérifier la Configuration dans Xcode

1. Ouvrez le projet dans Xcode
2. Sélectionnez le projet **TBVirtualController** → Cible **TBVirtualController**
3. Onglet **Signing & Capabilities**
4. Pour la configuration **Release** :
   - **Team** : Votre équipe (7Y62ULM2MB)
   - **Signing Certificate** : **Developer ID Application** (pour distribution hors App Store)
   - Vérifiez que **Code Signing Entitlements** pointe vers : `TBVirtualController/TBVirtualController.entitlements`

### 2. Archiver l'Application

1. Dans Xcode, sélectionnez **Any Mac (Apple Silicon, Intel)** dans le sélecteur de schéma
2. Menu **Product > Archive**
3. Attendez la fin de la compilation (peut prendre quelques minutes)

### 3. Exporter pour la Distribution

1. La fenêtre **Organizer** s'ouvre automatiquement
2. Sélectionnez votre archive (la plus récente)
3. Cliquez sur **Distribute App**
4. Choisissez **"Developer ID"** (pour distribution hors App Store)
5. Cliquez sur **Next**
6. Sélectionnez **"Export"** (pour créer un fichier local)
7. Cliquez sur **Next**
8. Choisissez un emplacement pour l'export (ex: Bureau)
9. Cliquez sur **Export**
10. Xcode va signer et exporter l'application

L'application exportée sera dans : `[Emplacement]/TBVirtualController.app`

### 4. Créer le DMG

Utilisez le script `create_dmg.sh` :

```bash
cd /Users/jan/Projets/TBVirtualController
./create_dmg.sh 1.0 /chemin/vers/TBVirtualController.app
```

Ou manuellement avec `create-dmg` (si installé via Homebrew) :

```bash
create-dmg \
  --volname "TB Virtual Controller" \
  --window-pos 200 120 \
  --window-size 600 400 \
  --icon-size 100 \
  --icon "TBVirtualController.app" 150 190 \
  --hide-extension "TBVirtualController.app" \
  --app-drop-link 450 190 \
  "TBVirtualController-1.0.dmg" \
  "TBVirtualController.app"
```

### 5. Notariser le DMG

1. Créez un **App-Specific Password** sur [appleid.apple.com](https://appleid.apple.com)
2. Stockez-le dans le Keychain :
```bash
xcrun notarytool store-credentials "notary-profile" \
  --apple-id "votre@email.com" \
  --team-id "7Y62ULM2MB" \
  --password "app-specific-password"
```

3. Soumettez le DMG pour notarisation :
```bash
xcrun notarytool submit "TBVirtualController-1.0.dmg" \
  --keychain-profile "notary-profile" \
  --wait
```

4. Une fois notarisé, attachez le ticket :
```bash
xcrun stapler staple "TBVirtualController-1.0.dmg"
```

### 6. Vérifier

```bash
# Vérifier la signature
codesign -dv --verbose=4 TBVirtualController.app
spctl -a -vv TBVirtualController.app

# Vérifier la notarisation
spctl -a -t install --context context:primary-signature -v TBVirtualController-1.0.dmg
```

## ⚠️ Important pour l'Application Notarisée

L'application notarisée est considérée comme une **application différente** par macOS. Les utilisateurs devront :
1. Accorder les permissions d'accessibilité à cette nouvelle application
2. L'application les guidera automatiquement vers les Réglages Système

## 📝 Notes

- Le fichier `TBVirtualController.entitlements` doit être inclus dans le build
- Les entitlements doivent être signés avec l'application
- L'application fonctionnera exactement comme dans Xcode une fois les permissions accordées

