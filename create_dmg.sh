#!/bin/bash

# Script pour créer un DMG signé de TB Virtual Controller
# Usage: ./create_dmg.sh [version] [path_to_app]

set -e

# Configuration
APP_NAME="TBVirtualController"
VERSION="${1:-1.0}"
APP_PATH="${2:-./TBVirtualController.app}"
DMG_NAME="${APP_NAME}-${VERSION}.dmg"
DMG_TEMP="temp_dmg"
DMG_DIR="${DMG_TEMP}/${APP_NAME}"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Création du DMG pour ${APP_NAME} v${VERSION} ===${NC}"

# Vérifier que l'application existe
if [ ! -d "${APP_PATH}" ]; then
    echo -e "${RED}Erreur: L'application n'existe pas à ${APP_PATH}${NC}"
    echo "Usage: $0 [version] [path_to_app]"
    exit 1
fi

# Nettoyer les anciens fichiers
echo -e "${YELLOW}Nettoyage des anciens fichiers...${NC}"
rm -rf "${DMG_TEMP}"
rm -f "${DMG_NAME}"

# Créer le dossier temporaire
echo -e "${YELLOW}Préparation du contenu du DMG...${NC}"
mkdir -p "${DMG_DIR}"

# Copier l'application
cp -R "${APP_PATH}" "${DMG_DIR}/"

# Créer un lien vers Applications
ln -s /Applications "${DMG_DIR}/Applications"

# Créer le DMG
echo -e "${YELLOW}Création du DMG...${NC}"
hdiutil create -srcfolder "${DMG_TEMP}" \
    -volname "${APP_NAME}" \
    -fs HFS+ \
    -fsargs "-c c=64,a=16,e=16" \
    -format UDRW \
    -size 200M \
    "${DMG_NAME}.temp.dmg" > /dev/null

# Monter le DMG
echo -e "${YELLOW}Configuration du DMG...${NC}"
DEVICE=$(hdiutil attach -readwrite -noverify -noautoopen "${DMG_NAME}.temp.dmg" | \
    egrep '^/dev/' | sed 1q | awk '{print $1}')

# Attendre que le volume soit monté
sleep 2

# Démonter
hdiutil detach "${DEVICE}" > /dev/null

# Convertir en DMG final (compressé)
echo -e "${YELLOW}Compression du DMG...${NC}"
hdiutil convert "${DMG_NAME}.temp.dmg" \
    -format UDZO \
    -imagekey zlib-level=9 \
    -o "${DMG_NAME}" > /dev/null

# Nettoyer
rm -f "${DMG_NAME}.temp.dmg"
rm -rf "${DMG_TEMP}"

echo -e "${GREEN}✓ DMG créé : ${DMG_NAME}${NC}"

# Demander si l'utilisateur veut signer
read -p "Voulez-vous signer le DMG maintenant ? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Signature du DMG...${NC}"
    echo "Assurez-vous d'avoir un certificat 'Developer ID Application' dans votre Keychain"
    
    # Trouver le certificat Developer ID
    CERT_NAME=$(security find-identity -v -p codesigning | grep "Developer ID Application" | head -1 | sed 's/.*"\(.*\)".*/\1/')
    
    if [ -z "$CERT_NAME" ]; then
        echo -e "${RED}Erreur: Aucun certificat 'Developer ID Application' trouvé${NC}"
        echo "Le DMG a été créé mais n'est pas signé."
        exit 1
    fi
    
    echo "Utilisation du certificat: ${CERT_NAME}"
    
    codesign --sign "${CERT_NAME}" \
        --options runtime \
        --timestamp \
        "${DMG_NAME}"
    
    # Vérifier la signature
    if codesign --verify --verbose "${DMG_NAME}" 2>&1 | grep -q "valid on disk"; then
        echo -e "${GREEN}✓ DMG signé avec succès${NC}"
    else
        echo -e "${RED}Erreur lors de la vérification de la signature${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}=== Terminé ===${NC}"
echo "DMG disponible : ${DMG_NAME}"

