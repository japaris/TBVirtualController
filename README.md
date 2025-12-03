# TB Virtual Controller

Une application macOS qui convertit les touches média de votre clavier en messages MIDI, créant un périphérique MIDI virtuel pour contrôler vos logiciels de musique.

## 🎹 Fonctionnalités

- **Détection en temps réel** : Capture automatique des touches média (lecture/pause, suivant, précédent, volume, mute)
- **Périphérique MIDI virtuel** : Crée un port MIDI virtuel "TB Virtual Knob" visible par toutes vos applications
- **Interface moderne** : Interface SwiftUI élégante avec visualisation en direct des événements
- **Mapping MIDI** : Chaque touche média est mappée sur une note MIDI spécifique :
  - Lecture/Pause → Note 60
  - Suivant → Note 61
  - Précédent → Note 62
  - Volume + → Note 63
  - Volume - → Note 64
  - Mute → Note 65

## 📋 Prérequis

- macOS (version compatible avec SwiftUI)
- Xcode (pour compiler le projet)
- Applications MIDI capables de recevoir des messages depuis un périphérique virtuel

## 🚀 Installation

### Compilation depuis les sources

1. Clonez le dépôt :
```bash
git clone https://github.com/votre-username/TBVirtualController.git
cd TBVirtualController
```

2. Ouvrez le projet dans Xcode :
```bash
open TBVirtualController/TBVirtualController.xcodeproj
```

3. Compilez et exécutez le projet (⌘R)

### Permissions requises

L'application nécessite des permissions d'accessibilité pour capturer les événements système. Lors du premier lancement, macOS vous demandera d'autoriser l'application dans :
**Réglages Système > Confidentialité et sécurité > Accessibilité**

## 💻 Utilisation

1. Lancez l'application TB Virtual Controller
2. Vérifiez que le statut "MIDI prêt" s'affiche en vert dans l'interface
3. Le périphérique MIDI virtuel "TB Virtual Knob" apparaît automatiquement dans vos applications MIDI
4. Appuyez sur les touches média de votre clavier
5. Les messages MIDI sont envoyés en temps réel vers vos applications

## 🎛️ Architecture

Le projet est structuré en plusieurs composants :

- **`TBVirtualControllerApp.swift`** : Point d'entrée de l'application
- **`ContentView.swift`** : Interface utilisateur principale
- **`MediaKeyListener.swift`** : Capture des touches média système
- **`VirtualMIDIDevice.swift`** : Gestion du périphérique MIDI virtuel via CoreMIDI

## 🔧 Technologies

- **SwiftUI** : Interface utilisateur moderne
- **CoreMIDI** : Gestion des périphériques MIDI virtuels
- **AppKit** : Capture des événements système
- **Combine** : Gestion réactive de l'état

## 📝 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une issue ou une pull request.

## 📧 Contact

Pour toute question ou suggestion, ouvrez une issue sur GitHub.

---

**Note** : Cette application nécessite macOS et des permissions d'accessibilité pour fonctionner correctement.

