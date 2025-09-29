#!/bin/bash

# Script de validation des messages de commit selon les normes Google/Conventional Commits

commit_regex='^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .{1,50}'

if ! grep -qE "$commit_regex" "$1"; then
    echo "❌ Message de commit invalide!"
    echo ""
    echo "Format attendu: <type>(<scope>): <subject>"
    echo ""
    echo "Types autorisés:"
    echo "  feat     - Nouvelle fonctionnalité"
    echo "  fix      - Correction de bug"
    echo "  docs     - Documentation"
    echo "  style    - Formatage, point-virgules manquants, etc."
    echo "  refactor - Refactoring de code"
    echo "  test     - Ajout ou modification de tests"
    echo "  chore    - Maintenance, dépendances, etc."
    echo ""
    echo "Exemples:"
    echo "  feat(backend): add OAuth2 Resource Server"
    echo "  fix(frontend): resolve CORS configuration"
    echo "  docs(readme): update installation guide"
    echo "  chore(deps): update Spring Boot to 3.3.1"
    echo ""
    echo "Votre message: $(cat "$1")"
    exit 1
fi

echo "✅ Message de commit valide!"
exit 0
