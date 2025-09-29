# PoC Google OIDC avec Vue 3 + Spring Boot

![Vue 3](https://img.shields.io/badge/Vue-3.x-4FC08D?style=flat-square&logo=vue.js)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.x-6DB33F?style=flat-square&logo=spring)
![TypeScript](https://img.shields.io/badge/TypeScript-5.x-3178C6?style=flat-square&logo=typescript)
![Docker](https://img.shields.io/badge/Docker-Enabled-2496ED?style=flat-square&logo=docker)

Une démonstration complète d'authentification OpenID Connect (OIDC) avec PKCE utilisant Vue 3 (SPA) et Spring Boot (API Resource Server).

## 🎯 Objectif

Permettre à un utilisateur de se connecter avec son compte Google via OpenID Connect + PKCE dans une Single Page Application Vue 3, avec un backend Spring Boot servant d'API protégée par des tokens JWT.

## 🏗️ Architecture

```
┌─────────────────┐    OIDC + PKCE    ┌─────────────────┐
│   Vue 3 SPA     │◄─────────────────►│   Google OAuth  │
│   (Frontend)    │                   │   Provider      │
└─────────────────┘                   └─────────────────┘
         │
         │ JWT Token (Authorization: Bearer)
         ▼
┌─────────────────┐
│ Spring Boot API │
│ (Resource Server)│
└─────────────────┘
```

## 🚀 Démarrage rapide

### Prérequis

- Java 21+
- Node.js 20+
- Docker & Docker Compose (optionnel)
- Compte Google Cloud Platform

### 1. Configuration Google Cloud

1. Créez un projet sur [Google Cloud Console](https://console.cloud.google.com/)
2. Activez l'API Google+ et OAuth2
3. Configurez l'écran de consentement OAuth (Externe)
4. Créez un OAuth 2.0 Client ID (Type: Application web)
5. Configurez les URIs autorisées :
   - **Origines JavaScript autorisées** : `http://localhost:5173`
   - **URIs de redirection autorisées** : `http://localhost:5173/callback`

### 2. Configuration des variables d'environnement

```bash
# Frontend
cp frontend/env.example frontend/.env.local
# Éditez frontend/.env.local et ajoutez votre CLIENT_ID Google

# Backend (optionnel pour développement local)
# Les paramètres par défaut fonctionnent avec Google
```

### 3. Démarrage avec Docker (Recommandé)

```bash
# Cloner le repository
git clone <repository-url>
cd spring-google-oidc-vue-poc

# Démarrer avec Docker Compose
docker-compose up --build

# L'application sera disponible sur :
# - Frontend: http://localhost:5173
# - Backend API: http://localhost:8080
```

### 4. Démarrage en développement

#### Backend (Spring Boot)
```bash
cd backend
./mvnw spring-boot:run
# ou
mvn spring-boot:run
```

#### Frontend (Vue 3)
```bash
cd frontend
npm install
npm run dev
```

## 📋 Endpoints API

### Public
- `GET /api/public` - Endpoint public accessible sans authentification
- `GET /actuator/health` - Santé de l'application

### Protégés (nécessitent un token JWT)
- `GET /api/me` - Informations de l'utilisateur connecté
- `GET /api/secure-data` - Données sécurisées fictives

## 🔧 Configuration

### Backend (Spring Boot)

Le backend est configuré pour :
- Valider les tokens JWT émis par Google
- Autoriser CORS pour `http://localhost:5173`
- Exposer des endpoints publics et protégés
- Logger les requêtes et erreurs

### Frontend (Vue 3)

Le frontend utilise :
- **oidc-client-ts** pour l'authentification OIDC + PKCE
- **Pinia** pour la gestion d'état
- **Vue Router** avec guards d'authentification
- **Axios** avec intercepteurs pour les tokens

## 🛡️ Sécurité

- ✅ **PKCE** : Protection contre les attaques par interception de code
- ✅ **CORS strict** : Origines autorisées limitées
- ✅ **Tokens en mémoire** : Pas de stockage persistant des tokens
- ✅ **Validation JWT** : Tokens vérifiés côté serveur
- ✅ **Scopes limités** : `openid email profile` uniquement

## 🧪 Tests

### Backend
```bash
cd backend
./mvnw test
```

### Frontend
```bash
cd frontend
npm run test:unit
npm run test:e2e
```

## 📦 Déploiement

### Production avec Docker
```bash
# Utiliser la configuration de production
docker-compose -f infra/docker-compose.prod.yml up --build

# Avec variables d'environnement
export GOOGLE_CLIENT_ID=your_client_id
export API_BASE_URL=https://your-api-domain.com
docker-compose -f infra/docker-compose.prod.yml up --build
```

## 📚 Documentation détaillée

- [Configuration Google Cloud](docs/google-setup.md)
- [Architecture technique](docs/architecture.md)
- [Guide de développement](docs/development.md)

## 🔄 Flux d'authentification

1. L'utilisateur clique sur "Se connecter avec Google"
2. Redirection vers Google OAuth avec PKCE
3. L'utilisateur s'authentifie et autorise l'application
4. Google redirige vers `/callback` avec un code d'autorisation
5. L'application échange le code contre des tokens (ID + Access)
6. Les tokens sont stockés en mémoire
7. Les requêtes API incluent le token JWT dans l'en-tête Authorization

## 🐛 Dépannage

### Erreur CORS
Vérifiez que l'origine `http://localhost:5173` est autorisée dans la configuration CORS du backend.

### Erreur de token JWT
Vérifiez que le `CLIENT_ID` Google est correct et que l'issuer est bien `https://accounts.google.com`.

### Redirection après connexion
Assurez-vous que l'URI de redirection `http://localhost:5173/callback` est configurée dans Google Cloud Console.

## 🤝 Contribution

1. Fork le projet
2. Créez une branche feature (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👥 Équipe

Développé par [BrotherhoodLabs](https://github.com/BrotherhoodLabs/)

---

**Note** : Ce projet est une démonstration (PoC) et ne doit pas être utilisé en production sans audit de sécurité approprié.
