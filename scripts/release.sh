#!/bin/bash

# Script de release suivant les normes Google

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Vérifier que nous sommes sur la branche develop
current_branch=$(git branch --show-current)
if [ "$current_branch" != "develop" ]; then
    error "Vous devez être sur la branche 'develop' pour créer une release"
    exit 1
fi

# Vérifier que le working directory est propre
if [ -n "$(git status --porcelain)" ]; then
    error "Le working directory n'est pas propre. Committez ou stashez vos changements."
    exit 1
fi

# Récupérer la dernière version
last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
log "Dernière version: $last_tag"

# Demander la nouvelle version
read -p "Nouvelle version (ex: v1.0.0): " new_version

if [ -z "$new_version" ]; then
    error "Version requise"
    exit 1
fi

# Vérifier que la version n'existe pas déjà
if git tag -l | grep -q "^$new_version$"; then
    error "La version $new_version existe déjà"
    exit 1
fi

log "Création de la release $new_version..."

# Mettre à jour le CHANGELOG (si il existe)
if [ -f "CHANGELOG.md" ]; then
    log "Mise à jour du CHANGELOG.md..."
    # Ajouter la nouvelle version au début du CHANGELOG
    sed -i "1i\\# $new_version ($(date +%Y-%m-%d))\\n" CHANGELOG.md
fi

# Committer les changements
git add .
git commit -m "chore(release): bump version to $new_version"

# Créer le tag
git tag -a "$new_version" -m "Release $new_version

- Nouvelle version majeure de la PoC Google OIDC
- Améliorations de sécurité et performance
- Documentation mise à jour"

# Pousser vers GitHub
log "Poussage vers GitHub..."
git push origin develop
git push origin "$new_version"

# Créer une Pull Request vers main
log "Création de la Pull Request..."
gh pr create --title "Release $new_version" --body "Release $new_version

## Changements
- Voir le CHANGELOG.md pour les détails

## Checklist
- [ ] Tests passent
- [ ] Documentation mise à jour
- [ ] Version taggée: $new_version" --base main --head develop

success "Release $new_version créée avec succès!"
log "Prochaines étapes:"
log "1. Attendre l'approbation de la PR"
log "2. Merger la PR vers main"
log "3. Créer un GitHub Release depuis le tag $new_version"
