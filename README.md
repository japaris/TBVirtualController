# TB Virtual Controller

Une application macOS qui convertit les touches média de votre clavier en messages MIDI, créant un périphérique MIDI virtuel pour contrôler vos logiciels de musique.

## 🎹 Fonctionnalités

- **Interception système** : Capture les touches média **avant** que macOS ne les traite, permettant d'envoyer les messages MIDI tout en conservant le contrôle système
- **Détection en temps réel** : Capture automatique des touches média (lecture/pause, suivant, précédent, volume, mute)
- **Périphérique MIDI virtuel** : Crée un port MIDI virtuel "TB Virtual Knob" visible par toutes vos applications
- **Interface moderne** : Interface SwiftUI élégante avec visualisation en direct des événements et indicateurs de statut
- **Vérification automatique des permissions** : Détection automatique des permissions d'accessibilité avec mise à jour en temps réel
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

L'application nécessite des **permissions d'accessibilité** pour intercepter les touches média au niveau système. 

**Configuration des permissions :**

1. Lors du premier lancement, l'application vous guidera vers les Réglages Système
2. Ouvrez **Réglages Système > Confidentialité et sécurité > Accessibilité**
3. Ajoutez **TB Virtual Controller** à la liste des applications autorisées
4. L'application détectera automatiquement les permissions accordées (vérification toutes les 2 secondes)
5. Un bouton "Vérifier les permissions maintenant" est disponible dans l'interface si nécessaire

**Note** : Pour un usage personnel, vous pouvez désactiver le sandboxing dans les paramètres du projet Xcode pour simplifier la configuration.

## 💻 Utilisation

1. **Lancez l'application** TB Virtual Controller
2. **Vérifiez les statuts** dans l'interface :
   - ✅ **Port virtuel** : Doit afficher "MIDI prêt" en vert
   - ✅ **Permissions** : Doit afficher "Accessibilité activée" en vert
   - 📊 **Dernier événement** : Affichera les touches détectées
3. Le périphérique MIDI virtuel **"TB Virtual Knob"** apparaît automatiquement dans vos applications MIDI
4. **Configurez votre application MIDI** (ex: Tandabuilder, Ableton, etc.) pour recevoir les messages depuis "TB Virtual Knob"
5. **Appuyez sur les touches média** de votre clavier
6. Les messages MIDI sont envoyés en temps réel vers vos applications

**Note importante** : L'application intercepte les touches média avant macOS, donc les actions système (volume, lecture, etc.) continuent de fonctionner normalement tout en envoyant les messages MIDI.

## 🎛️ Architecture

Le projet est structuré en plusieurs composants :

- **`TBVirtualControllerApp.swift`** : Point d'entrée de l'application, initialisation des composants
- **`ContentView.swift`** : Interface utilisateur principale avec visualisation en temps réel
- **`MediaKeyListener.swift`** : Interception des touches média via CGEvent tap, vérification automatique des permissions
- **`VirtualMIDIDevice.swift`** : Gestion du périphérique MIDI virtuel via CoreMIDI avec gestion d'erreurs et logging

## 🔧 Technologies

- **SwiftUI** : Interface utilisateur moderne et réactive
- **CoreMIDI** : Gestion des périphériques MIDI virtuels et envoi de messages
- **CoreGraphics (CGEvent)** : Interception des événements système au niveau bas niveau
- **AppKit** : Intégration avec le système macOS
- **Combine** : Gestion réactive de l'état et des événements
- **os.log** : Logging structuré pour le débogage

## 🐛 Dépannage

### Les touches média ne sont pas détectées

1. Vérifiez que les permissions d'accessibilité sont accordées (carte "Permissions" doit être verte)
2. Utilisez le bouton "Vérifier les permissions maintenant" dans l'interface
3. Redémarrez l'application après avoir accordé les permissions
4. Vérifiez les logs dans la Console (recherchez "com.tbvirtualcontroller")

### Le périphérique MIDI n'apparaît pas

1. Vérifiez que la carte "Port virtuel" affiche "MIDI prêt" en vert
2. Redémarrez votre application MIDI pour qu'elle détecte le nouveau périphérique
3. Vérifiez les logs pour les erreurs d'initialisation MIDI

### Messages MIDI non reçus

1. Vérifiez que votre application MIDI est configurée pour recevoir depuis "TB Virtual Knob"
2. Testez avec une application comme MIDI Monitor pour vérifier l'envoi des messages
3. Consultez les logs pour confirmer l'envoi des messages MIDI

## 📝 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une issue ou une pull request.

## 📧 Contact

Pour toute question ou suggestion, ouvrez une issue sur GitHub.

---

**Note** : Cette application nécessite macOS et des permissions d'accessibilité pour fonctionner correctement.

