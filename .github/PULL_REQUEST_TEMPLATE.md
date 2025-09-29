# Pull Request

## 📝 Description

Décrivez brièvement les changements apportés dans cette PR.

## 🔗 Issue liée

Fixes #(issue_number)

## 🧪 Type de changement

- [ ] 🐛 Bug fix (changement non-breaking qui corrige un problème)
- [ ] ✨ Nouvelle fonctionnalité (changement non-breaking qui ajoute une fonctionnalité)
- [ ] 💥 Breaking change (fix ou fonctionnalité qui causerait un changement breaking)
- [ ] 📚 Documentation (changements uniquement dans la documentation)
- [ ] 🔧 Refactoring (changements de code qui ne corrigent pas de bug ni n'ajoutent de fonctionnalité)
- [ ] ⚡ Performance (changements qui améliorent les performances)
- [ ] 🧪 Tests (ajout ou modification de tests)
- [ ] 🏗️ Build (changements dans le système de build ou dépendances externes)

## 🧪 Tests

- [ ] Tests unitaires ajoutés/mis à jour
- [ ] Tests d'intégration ajoutés/mis à jour
- [ ] Tests E2E ajoutés/mis à jour
- [ ] Tous les tests passent localement

### Backend
- [ ] `./mvnw test` passe
- [ ] `./mvnw jacoco:report` génère un rapport de couverture
- [ ] Aucune vulnérabilité détectée par OWASP

### Frontend
- [ ] `npm run test:unit` passe
- [ ] `npm run test:e2e` passe
- [ ] `npm run lint` passe
- [ ] `npm run build` réussit

## 🔍 Checklist

### Code
- [ ] Mon code suit les standards de style du projet
- [ ] J'ai effectué une auto-review de mon code
- [ ] J'ai commenté mon code, particulièrement dans les zones difficiles à comprendre
- [ ] Mes changements ne génèrent pas de nouveaux warnings
- [ ] J'ai ajouté des tests qui prouvent que mon fix est efficace ou que ma fonctionnalité fonctionne
- [ ] Les tests unitaires nouveaux et existants passent localement avec mes changements
- [ ] Toute dépendance nouvelle ou modifiée a été documentée

### Documentation
- [ ] J'ai mis à jour la documentation correspondante
- [ ] J'ai mis à jour le README si nécessaire
- [ ] J'ai mis à jour les commentaires dans le code si nécessaire

### Sécurité
- [ ] Aucune information sensible n'est exposée
- [ ] Les tokens et secrets sont gérés de manière sécurisée
- [ ] Les validations d'entrée sont appropriées
- [ ] Aucune vulnérabilité de sécurité n'est introduite

## 📸 Screenshots (si applicable)

Ajoutez des captures d'écran pour illustrer vos changements.

## 🚀 Déploiement

- [ ] Les changements sont compatibles avec l'environnement de production
- [ ] Les variables d'environnement nécessaires sont documentées
- [ ] Les migrations de base de données sont incluses si nécessaire

## 📋 Notes additionnelles

Ajoutez toute information supplémentaire qui pourrait être utile pour les reviewers.

## 👥 Reviewers

@username1 @username2

## 🔗 Liens utiles

- [Documentation du projet](link)
- [Issue liée](link)
- [Design/Prototype](link)
