#!/bin/bash

# Script de configuration des hooks Git pour le projet

echo "🔧 Configuration des hooks Git..."

# Créer le dossier hooks s'il n'existe pas
mkdir -p .git/hooks

# Copier le script de validation comme hook commit-msg
cp scripts/validate-commit.sh .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg

# Créer un hook pre-commit pour les vérifications de base
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

echo "🔍 Exécution des vérifications pre-commit..."

# Vérifier les fichiers Java
if [ -d "backend/src" ]; then
    echo "📝 Vérification du code Java..."
    cd backend
    if [ -f "mvnw" ]; then
        ./mvnw compile -q
        if [ $? -ne 0 ]; then
            echo "❌ Erreur de compilation Java"
            exit 1
        fi
    fi
    cd ..
fi

# Vérifier les fichiers TypeScript/Vue
if [ -d "frontend/src" ]; then
    echo "📝 Vérification du code TypeScript..."
    cd frontend
    if [ -f "package.json" ]; then
        npm run lint --silent
        if [ $? -ne 0 ]; then
            echo "❌ Erreur de linting TypeScript"
            exit 1
        fi
    fi
    cd ..
fi

echo "✅ Vérifications pre-commit réussies!"
EOF

chmod +x .git/hooks/pre-commit

echo "✅ Hooks Git configurés avec succès!"
echo ""
echo "Hooks disponibles:"
echo "  - commit-msg: Validation des messages de commit"
echo "  - pre-commit: Vérifications de compilation et linting"
echo ""
echo "Pour désactiver temporairement: git commit --no-verify"
