# Guide de Distribution - TB Virtual Controller

Ce guide explique comment créer une version distribuable (.dmg) signée de TB Virtual Controller pour la mettre à disposition sur la landing page de TandaBuilder.

## 📋 Prérequis

1. **Compte développeur Apple** actif (vous avez déjà `DEVELOPMENT_TEAM = 7Y62ULM2MB`)
2. **Certificat de distribution** configuré dans votre compte développeur
3. **Xcode** à jour

## 🔧 Étape 1 : Configuration du Code Signing

### 1.1 Vérifier les certificats

1. Ouvrez **Xcode > Settings (ou Preferences) > Accounts**
2. Sélectionnez votre compte Apple
3. Cliquez sur **Manage Certificates...**
4. Vérifiez qu'un certificat **"Apple Distribution"** est présent
5. Si absent, cliquez sur **+** et ajoutez **"Apple Distribution"**

### 1.2 Configurer le projet pour la distribution

1. Ouvrez le projet dans Xcode
2. Sélectionnez le projet **TBVirtualController** dans le navigateur
3. Sélectionnez la cible **TBVirtualController**
4. Allez dans l'onglet **Signing & Capabilities**

**Configuration Release :**
- ✅ **Automatically manage signing** : DÉCOCHÉ (pour plus de contrôle)
- **Team** : Sélectionnez votre équipe (7Y62ULM2MB)
- **Signing Certificate** : **Apple Distribution**
- **Provisioning Profile** : Sélectionnez ou créez un profil de distribution

**Important :** Pour la distribution en dehors de l'App Store, vous devez utiliser **"Developer ID Application"** au lieu de "Apple Distribution" si vous voulez que les utilisateurs puissent installer sans passer par l'App Store.

### 1.3 Modifier les Build Settings (si nécessaire)

Dans **Build Settings**, pour la configuration **Release** :

- `CODE_SIGN_IDENTITY` : `Developer ID Application` (pour distribution hors App Store)
- `CODE_SIGN_STYLE` : `Manual` (si vous utilisez un profil spécifique)
- `ENABLE_HARDENED_RUNTIME` : `YES` ✅ (déjà configuré)
- `ENABLE_APP_SANDBOX` : `NO` ✅ (déjà configuré - nécessaire pour l'accessibilité)

## 📦 Étape 2 : Créer un fichier Entitlements (si nécessaire)

Créez un fichier `TBVirtualController.entitlements` si vous avez besoin de permissions spécifiques :

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.app-sandbox</key>
    <false/>
    <key>com.apple.security.cs.allow-jit</key>
    <false/>
    <key>com.apple.security.cs.allow-unsigned-executable-memory</key>
    <false/>
    <key>com.apple.security.cs.disable-library-validation</key>
    <false/>
</dict>
</plist>
```

Ajoutez-le au projet et dans **Build Settings > Code Signing Entitlements**, ajoutez : `TBVirtualController/TBVirtualController.entitlements`

## 🏗️ Étape 3 : Archiver l'application

1. Dans Xcode, sélectionnez **Any Mac (Apple Silicon, Intel)** ou votre Mac spécifique dans le sélecteur de schéma
2. Menu **Product > Archive**
3. Xcode va compiler et créer une archive
4. Une fois terminé, la fenêtre **Organizer** s'ouvre automatiquement

## 📤 Étape 4 : Exporter pour la distribution

1. Dans **Organizer**, sélectionnez votre archive
2. Cliquez sur **Distribute App**
3. Choisissez **"Developer ID"** (pour distribution hors App Store) ou **"App Store Connect"** (pour l'App Store)
4. Sélectionnez **"Export"** (pour créer un fichier local)
5. Choisissez les options :
   - ✅ **Include bitcode for macOS content** (optionnel)
   - ✅ **Upload your app's symbols** (recommandé)
6. Choisissez un emplacement pour l'export
7. Xcode va signer et exporter l'application

L'application exportée sera dans : `[Emplacement]/TBVirtualController.app`

## 💿 Étape 5 : Créer un DMG

### 5.1 Préparer le contenu

Créez un dossier temporaire avec :
- `TBVirtualController.app` (l'application exportée)
- Optionnel : Un lien vers le dossier Applications

### 5.2 Créer le DMG avec le script

Créez un script `create_dmg.sh` :

```bash
#!/bin/bash

APP_NAME="TBVirtualController"
VERSION="1.0"
DMG_NAME="${APP_NAME}-${VERSION}.dmg"
APP_PATH="./${APP_NAME}.app"
DMG_TEMP="temp_dmg"
DMG_DIR="${DMG_TEMP}/${APP_NAME}"

# Nettoyer les anciens fichiers
rm -rf "${DMG_TEMP}"
rm -f "${DMG_NAME}"

# Créer le dossier temporaire
mkdir -p "${DMG_DIR}"

# Copier l'application
cp -R "${APP_PATH}" "${DMG_DIR}/"

# Créer un lien vers Applications
ln -s /Applications "${DMG_DIR}/Applications"

# Créer le DMG
hdiutil create -srcfolder "${DMG_TEMP}" -volname "${APP_NAME}" -fs HFS+ -fsargs "-c c=64,a=16,e=16" -format UDRW -size 200M "${DMG_NAME}.temp.dmg"

# Monter le DMG
DEVICE=$(hdiutil attach -readwrite -noverify -noautoopen "${DMG_NAME}.temp.dmg" | egrep '^/dev/' | sed 1q | awk '{print $1}')

# Attendre que le volume soit monté
sleep 2

# Démonter
hdiutil detach "${DEVICE}"

# Convertir en DMG final (compressé)
hdiutil convert "${DMG_NAME}.temp.dmg" -format UDZO -imagekey zlib-level=9 -o "${DMG_NAME}"

# Nettoyer
rm -f "${DMG_NAME}.temp.dmg"
rm -rf "${DMG_TEMP}"

echo "DMG créé : ${DMG_NAME}"
```

### 5.3 Alternative : Utiliser create-dmg (outil tiers)

Installez `create-dmg` :
```bash
brew install create-dmg
```

Puis créez le DMG :
```bash
create-dmg \
  --volname "TB Virtual Controller" \
  --volicon "icon.icns" \
  --window-pos 200 120 \
  --window-size 600 400 \
  --icon-size 100 \
  --icon "TBVirtualController.app" 150 190 \
  --hide-extension "TBVirtualController.app" \
  --app-drop-link 450 190 \
  "TBVirtualController-1.0.dmg" \
  "TBVirtualController.app"
```

## ✍️ Étape 6 : Signer et notariser le DMG

### 6.1 Signer le DMG

```bash
codesign --sign "Developer ID Application: [Votre Nom] ([TEAM_ID])" \
  --options runtime \
  --timestamp \
  "TBVirtualController-1.0.dmg"
```

### 6.2 Vérifier la signature

```bash
codesign --verify --verbose "TBVirtualController-1.0.dmg"
spctl -a -t open --context context:primary-signature -v "TBVirtualController-1.0.dmg"
```

### 6.3 Notariser avec Apple (optionnel mais recommandé)

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

4. Vérifiez le statut :
```bash
xcrun notarytool history --keychain-profile "notary-profile"
```

5. Une fois notarisé, attachez le ticket :
```bash
xcrun stapler staple "TBVirtualController-1.0.dmg"
```

## ✅ Vérification finale

Avant de distribuer, testez :

1. **Sur un autre Mac** (si possible) : Montez le DMG et installez l'application
2. **Vérifiez la signature** :
```bash
codesign -dv --verbose=4 TBVirtualController.app
spctl -a -vv TBVirtualController.app
```

3. **Vérifiez la notarisation** (si applicable) :
```bash
spctl -a -t install --context context:primary-signature -v TBVirtualController-1.0.dmg
```

## 📝 Notes importantes

- **Developer ID vs Apple Distribution** : Utilisez "Developer ID Application" pour la distribution hors App Store
- **Notarisation** : Fortement recommandée pour éviter les avertissements de sécurité
- **Version** : Mettez à jour `MARKETING_VERSION` dans les Build Settings avant chaque release
- **Bundle ID** : Assurez-vous que `JanTango.TBVirtualController` est bien enregistré dans votre compte développeur

## 🚀 Distribution

Une fois le DMG créé, signé et notarisé, vous pouvez :
1. Le téléverser sur votre serveur
2. Le mettre à disposition sur la landing page de TandaBuilder
3. Fournir un lien de téléchargement direct

---

**Besoin d'aide ?** Consultez la [documentation Apple sur la distribution](https://developer.apple.com/distribute/) ou ouvrez une issue sur GitHub.

