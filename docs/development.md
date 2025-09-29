# Guide de développement

Ce guide contient les instructions pour développer et contribuer au projet.

## 🛠️ Environnement de développement

### Prérequis
- Java 21+
- Node.js 20+
- Maven 3.8+
- Git
- IDE (IntelliJ IDEA, VS Code, Eclipse)

### Configuration de l'IDE

#### IntelliJ IDEA
1. Installez les plugins :
   - Vue.js
   - TypeScript
   - Spring Boot
2. Configurez le formatage automatique
3. Activez l'auto-import des dépendances

#### VS Code
1. Installez les extensions :
   - Vue Language Features (Volar)
   - TypeScript Vue Plugin (Volar)
   - Spring Boot Extension Pack
   - Java Extension Pack

## 🚀 Démarrage du projet

### 1. Cloner le repository
```bash
git clone <repository-url>
cd spring-google-oidc-vue-poc
```

### 2. Configuration Google Cloud
Suivez le guide [Configuration Google Cloud](google-setup.md)

### 3. Variables d'environnement
```bash
# Frontend
cp frontend/env.example frontend/.env.local
# Éditez frontend/.env.local avec votre CLIENT_ID
```

### 4. Démarrage en mode développement

#### Backend
```bash
cd backend
./mvnw spring-boot:run
# ou
mvn spring-boot:run
```

#### Frontend
```bash
cd frontend
npm install
npm run dev
```

## 🧪 Tests

### Backend
```bash
cd backend
./mvnw test
./mvnw test -Dtest=ApiControllerTest
```

### Frontend
```bash
cd frontend
npm run test:unit
npm run test:e2e
```

### Tests E2E complets
```bash
# Démarrer l'application
docker-compose up --build

# Lancer les tests E2E
cd frontend
npm run test:e2e:run
```

## 📝 Standards de code

### Java (Backend)
- **Formatage** : Google Java Style
- **Annotations** : Utiliser `@Valid`, `@NotNull`, etc.
- **Documentation** : JavaDoc pour les méthodes publiques
- **Tests** : Couverture minimale de 80%

### TypeScript (Frontend)
- **Formatage** : Prettier + ESLint
- **Types** : Toujours typer les variables et fonctions
- **Composants** : Composition API avec `<script setup>`
- **Tests** : Tests unitaires pour les stores et composants

### Git
- **Commits** : Convention [Conventional Commits](https://www.conventionalcommits.org/)
- **Branches** : `feature/`, `fix/`, `docs/`, `refactor/`
- **Messages** : `<type>(<scope>): <description>`

Exemples :
```bash
git commit -m "feat(auth): add OIDC login flow"
git commit -m "fix(api): resolve CORS configuration"
git commit -m "docs(readme): update installation guide"
```

## 🔧 Scripts utiles

### Backend
```bash
# Nettoyer et compiler
./mvnw clean compile

# Lancer les tests
./mvnw test

# Générer le rapport de couverture
./mvnw jacoco:report

# Analyser les dépendances
./mvnw dependency:tree

# Vérifier les vulnérabilités
./mvnw org.owasp:dependency-check-maven:check
```

### Frontend
```bash
# Installation des dépendances
npm install

# Serveur de développement
npm run dev

# Build de production
npm run build

# Preview du build
npm run preview

# Tests unitaires
npm run test:unit

# Tests E2E
npm run test:e2e

# Linting
npm run lint

# Formatage
npm run format
```

### Docker
```bash
# Build et démarrage
docker-compose up --build

# Logs en temps réel
docker-compose logs -f

# Arrêt des services
docker-compose down

# Nettoyage des volumes
docker-compose down -v
```

## 🐛 Débogage

### Backend
1. **Logs** : Activer le niveau DEBUG dans `application.yml`
2. **Breakpoints** : Utiliser l'IDE pour débugger
3. **Actuator** : `/actuator/health` pour la santé de l'application

### Frontend
1. **DevTools** : Utiliser les DevTools du navigateur
2. **Vue DevTools** : Extension pour inspecter l'état Vue
3. **Console** : Logs détaillés dans la console

### Problèmes courants

#### Erreur CORS
```bash
# Vérifier la configuration CORS dans SecurityConfig.java
# S'assurer que l'origine frontend est autorisée
```

#### Token JWT invalide
```bash
# Vérifier le CLIENT_ID dans .env.local
# Vérifier que l'issuer est correct
# Vérifier l'expiration du token
```

#### Erreur de redirection
```bash
# Vérifier les URIs de redirection dans Google Console
# S'assurer que l'URL correspond exactement
```

## 📦 Gestion des dépendances

### Backend (Maven)
```xml
<!-- Ajouter une dépendance -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
</dependency>
```

### Frontend (npm)
```bash
# Ajouter une dépendance de production
npm install package-name

# Ajouter une dépendance de développement
npm install -D package-name

# Mettre à jour les dépendances
npm update
```

## 🔄 Workflow de développement

### 1. Créer une branche
```bash
git checkout -b feature/nouvelle-fonctionnalite
```

### 2. Développer
- Écrire le code
- Ajouter des tests
- Vérifier les tests
- Formater le code

### 3. Commiter
```bash
git add .
git commit -m "feat(scope): description"
```

### 4. Pousser
```bash
git push origin feature/nouvelle-fonctionnalite
```

### 5. Pull Request
- Créer une PR sur GitHub
- Attendre la review
- Corriger les commentaires
- Merger après approbation

## 📊 Métriques de qualité

### Backend
- **Couverture de tests** : > 80%
- **Complexité cyclomatique** : < 10
- **Duplication de code** : < 3%
- **Vulnérabilités** : 0 critique, 0 haute

### Frontend
- **Couverture de tests** : > 80%
- **Complexité cyclomatique** : < 10
- **Accessibilité** : WCAG 2.1 AA
- **Performance** : Lighthouse > 90

## 🚀 Déploiement

### Environnement de test
```bash
# Build et test
docker-compose -f docker-compose.test.yml up --build

# Tests d'intégration
npm run test:integration
```

### Environnement de production
```bash
# Build de production
docker-compose -f infra/docker-compose.prod.yml up --build

# Vérification
curl http://localhost/actuator/health
```

## 📚 Ressources

### Documentation
- [Vue 3 Documentation](https://vuejs.org/)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [OIDC Client TS](https://github.com/authts/oidc-client-ts)

### Outils
- [Google Cloud Console](https://console.cloud.google.com/)
- [JWT.io](https://jwt.io/) - Décodeur JWT
- [OAuth 2.0 Playground](https://developers.google.com/oauthplayground/)

### Standards
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- [Vue Style Guide](https://vuejs.org/style-guide/)

## 🤝 Contribution

1. **Fork** le projet
2. **Clone** votre fork
3. **Créez** une branche feature
4. **Développez** votre fonctionnalité
5. **Testez** votre code
6. **Commitez** avec des messages clairs
7. **Poussez** vers votre fork
8. **Créez** une Pull Request

### Checklist avant PR
- [ ] Code formaté et linté
- [ ] Tests ajoutés et passants
- [ ] Documentation mise à jour
- [ ] Pas de vulnérabilités
- [ ] Messages de commit conformes
