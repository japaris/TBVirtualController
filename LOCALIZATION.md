# Guide de Localisation - TB Virtual Controller

Ce guide explique comment ajouter le support multilingue (français et anglais) à l'application.

## 📋 Méthode : String Catalogs (recommandé)

Xcode 15+ supporte les **String Catalogs** qui sont plus modernes et faciles à gérer que les fichiers `.strings` traditionnels.

## 🔧 Étape 1 : Configurer les langues dans Xcode

1. Ouvrez le projet dans Xcode
2. Sélectionnez le projet **TBVirtualController** dans le navigateur
3. Sélectionnez la cible **TBVirtualController**
4. Allez dans l'onglet **Info**
5. Dans la section **Localizations**, cliquez sur **+**
6. Ajoutez **English** (si pas déjà présent)
7. Ajoutez **French**

## 📝 Étape 2 : Créer le String Catalog

1. Dans Xcode, faites **File > New > File...**
2. Sélectionnez **Resource > String Catalog**
3. Nommez-le **Localizable.xcstrings**
4. Assurez-vous qu'il est ajouté à la cible **TBVirtualController**
5. Cliquez sur **Create**

## 🌐 Étape 3 : Ajouter les traductions

Le fichier `Localizable.xcstrings` s'ouvre avec une interface graphique. Ajoutez les clés et leurs traductions :

### Structure recommandée

| Key | French | English |
|-----|--------|---------|
| `app.title` | TB Virtual Controller | TB Virtual Controller |
| `app.subtitle` | Visualise en direct les appuis sur les touches média et envoie-les sur le port MIDI « TB Virtual Knob ». | Visualizes media key presses in real-time and sends them to the MIDI port "TB Virtual Knob". |
| `status.virtual_port` | Port virtuel | Virtual Port |
| `status.permissions` | Permissions | Permissions |
| `status.last_event` | Dernier événement | Last Event |
| `status.midi_ready` | MIDI prêt | MIDI Ready |
| `status.midi_not_initialized` | MIDI non initialisé | MIDI Not Initialized |
| `status.accessibility_enabled` | Accessibilité activée | Accessibility Enabled |
| `status.accessibility_required` | Accessibilité requise | Accessibility Required |
| `status.capture_active` | Capture active | Capture Active |
| `status.activate_in_settings` | Activez dans Réglages Système | Activate in System Settings |
| `status.no_press_detected` | Aucun appui détecté | No Press Detected |
| `status.awaiting` | En attente… | Awaiting… |
| `button.check_permissions` | Vérifier les permissions maintenant | Check Permissions Now |
| `section.live_keys` | Touches en direct | Live Keys |
| `section.event_feed` | Flux d'événements | Event Feed |
| `section.event_feed_empty` | En attente… | Awaiting… |
| `section.event_feed_last` | Derniers {count} | Last {count} |
| `section.event_feed_instruction` | Appuie sur une touche média (lecture, suivant, volume…) pour voir l'activité en temps réel. | Press a media key (play, next, volume…) to see real-time activity. |
| `control.volume_down` | Volume - | Volume - |
| `control.volume_up` | Volume + | Volume + |
| `control.play_pause` | Lecture / Pause | Play / Pause |
| `control.previous` | Précédent | Previous |
| `control.next` | Suivant | Next |
| `control.mute` | Muet | Mute |
| `control.awaiting` | En attente | Awaiting |
| `control.last_press` | Dernier appui | Last Press |

## 💻 Étape 4 : Modifier le code pour utiliser la localisation

Dans SwiftUI, utilisez `Text()` avec des clés de localisation ou `String(localized:)` :

```swift
// Au lieu de :
Text("Port virtuel")

// Utilisez :
Text("status.virtual_port", tableName: "Localizable")
// Ou simplement (si le fichier s'appelle Localizable) :
Text("status.virtual_port")
```

## 🎯 Exemple de modification

### Avant :
```swift
Text("Port virtuel")
```

### Après :
```swift
Text("status.virtual_port")
```

## 📦 Étape 5 : Tester la localisation

1. Dans Xcode, changez le schéma de build pour tester différentes langues
2. Ou utilisez le simulateur avec différentes langues système
3. Ou modifiez temporairement la langue dans **Product > Scheme > Edit Scheme > Run > Options > App Language**

## 🔍 Vérification

Après avoir ajouté toutes les traductions, vérifiez que :
- ✅ Tous les textes de l'interface sont localisés
- ✅ Les deux langues (français et anglais) fonctionnent
- ✅ L'application détecte automatiquement la langue du système
- ✅ Aucun texte en dur ne reste dans le code

## 📝 Notes

- Les String Catalogs supportent les variables avec `{variable}` dans les traductions
- Vous pouvez ajouter des commentaires pour chaque clé dans le String Catalog
- Les traductions manquantes afficheront la clé par défaut (généralement en anglais)

