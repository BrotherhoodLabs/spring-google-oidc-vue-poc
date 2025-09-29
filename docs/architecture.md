# Architecture technique

Ce document décrit l'architecture technique de la PoC Google OIDC avec Vue 3 et Spring Boot.

## 🏗️ Vue d'ensemble

```mermaid
graph TB
    User[👤 Utilisateur] --> Frontend[🌐 Vue 3 SPA]
    Frontend --> Google[🔐 Google OAuth]
    Frontend --> Backend[☕ Spring Boot API]
    Google --> Frontend
    Backend --> Frontend
    
    subgraph "Frontend (Vue 3)"
        Router[Vue Router]
        Store[Pinia Store]
        OIDC[oidc-client-ts]
        API[Axios Client]
    end
    
    subgraph "Backend (Spring Boot)"
        Security[Spring Security]
        OAuth2[OAuth2 Resource Server]
        JWT[JWT Validation]
        Controllers[REST Controllers]
    end
    
    subgraph "Google Cloud"
        Auth[OAuth 2.0]
        JWKS[JWKS Endpoint]
        UserInfo[UserInfo Endpoint]
    end
```

## 🔄 Flux d'authentification

### 1. Initialisation
```mermaid
sequenceDiagram
    participant U as Utilisateur
    participant F as Frontend (Vue)
    participant G as Google OAuth
    participant B as Backend (Spring Boot)
    
    U->>F: Accède à l'application
    F->>F: Vérifie l'état d'authentification
    F->>U: Affiche le bouton de connexion
```

### 2. Connexion OIDC + PKCE
```mermaid
sequenceDiagram
    participant U as Utilisateur
    participant F as Frontend (Vue)
    participant G as Google OAuth
    participant B as Backend (Spring Boot)
    
    U->>F: Clique sur "Se connecter"
    F->>F: Génère code_verifier et code_challenge
    F->>G: Redirection vers Google avec PKCE
    G->>U: Demande d'autorisation
    U->>G: Autorise l'application
    G->>F: Redirection avec code d'autorisation
    F->>G: Échange code contre tokens (PKCE)
    G->>F: Retourne ID token + Access token
    F->>F: Stocke les tokens en mémoire
    F->>U: Redirige vers le profil
```

### 3. Appels API sécurisés
```mermaid
sequenceDiagram
    participant U as Utilisateur
    participant F as Frontend (Vue)
    participant B as Backend (Spring Boot)
    
    U->>F: Accède à une page protégée
    F->>B: GET /api/me (avec JWT)
    B->>B: Valide le JWT avec Google JWKS
    B->>F: Retourne les données utilisateur
    F->>U: Affiche les informations
```

## 🛠️ Composants techniques

### Frontend (Vue 3)

#### Technologies utilisées
- **Vue 3** : Framework JavaScript réactif
- **TypeScript** : Typage statique
- **Vite** : Build tool et serveur de développement
- **Vue Router** : Routage côté client
- **Pinia** : Gestion d'état
- **oidc-client-ts** : Client OIDC avec support PKCE
- **Axios** : Client HTTP avec intercepteurs

#### Structure des composants
```
src/
├── components/          # Composants réutilisables
├── views/              # Pages de l'application
│   ├── HomeView.vue    # Page d'accueil
│   ├── CallbackView.vue # Gestion du callback OAuth
│   ├── ProfileView.vue  # Profil utilisateur
│   └── SecureView.vue   # Données sécurisées
├── stores/             # Stores Pinia
│   └── auth.ts         # Store d'authentification
├── services/           # Services API
│   └── api.ts          # Client Axios configuré
├── config/             # Configuration
│   └── oidc.ts         # Configuration OIDC
└── router/             # Configuration du routage
    └── index.ts        # Routes et guards
```

#### Gestion de l'état d'authentification
```typescript
// Store Pinia pour l'authentification
interface AuthState {
  user: User | null
  isLoading: boolean
  error: string | null
  isAuthenticated: ComputedRef<boolean>
  idToken: ComputedRef<string | null>
  accessToken: ComputedRef<string | null>
  userInfo: ComputedRef<any>
}
```

### Backend (Spring Boot)

#### Technologies utilisées
- **Spring Boot 3.x** : Framework Java
- **Spring Security** : Sécurité et authentification
- **OAuth2 Resource Server** : Validation des tokens JWT
- **Java 21** : Version LTS de Java
- **Maven** : Gestion des dépendances

#### Configuration de sécurité
```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) {
        return http
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .csrf(csrf -> csrf.disable())
            .sessionManagement(session -> session.sessionCreationPolicy(STATELESS))
            .authorizeHttpRequests(authz -> authz
                .requestMatchers("/api/public", "/actuator/**").permitAll()
                .requestMatchers("/api/**").authenticated()
            )
            .oauth2ResourceServer(oauth2 -> oauth2.jwt(Customizer.withDefaults()))
            .build();
    }
}
```

#### Endpoints API
```java
@RestController
@RequestMapping("/api")
public class ApiController {
    
    @GetMapping("/public")
    public Map<String, Object> publicEndpoint() {
        // Endpoint public
    }
    
    @GetMapping("/me")
    public Map<String, Object> me(@AuthenticationPrincipal Jwt jwt) {
        // Informations utilisateur depuis le JWT
    }
    
    @GetMapping("/secure-data")
    public Map<String, Object> secureData(@AuthenticationPrincipal Jwt jwt) {
        // Données sécurisées
    }
}
```

## 🔐 Sécurité

### PKCE (Proof Key for Code Exchange)
- **code_verifier** : Chaîne aléatoire générée côté client
- **code_challenge** : Hash SHA256 du code_verifier
- **Protection** : Empêche les attaques par interception de code

### JWT (JSON Web Token)
- **Signature** : Vérifiée avec les clés publiques Google (JWKS)
- **Validation** : Côté serveur Spring Boot
- **Claims** : `sub`, `email`, `name`, `picture`, `exp`, `iat`

### CORS (Cross-Origin Resource Sharing)
- **Origines autorisées** : `http://localhost:5173` uniquement
- **Méthodes** : GET, POST, PUT, DELETE, OPTIONS
- **Headers** : Authorization, Content-Type

### Stockage des tokens
- **Mémoire uniquement** : Pas de localStorage/sessionStorage
- **Sécurité** : Évite la persistance des tokens sensibles
- **Durée de vie** : Gérée par l'application

## 🌐 Communication inter-services

### Frontend → Backend
```http
GET /api/me HTTP/1.1
Host: localhost:8080
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
```

### Backend → Google
```http
GET https://www.googleapis.com/oauth2/v3/certs HTTP/1.1
Host: www.googleapis.com
```

## 📊 Observabilité

### Logs backend
- **Format JSON** : Structure des logs
- **Correlation ID** : Traçabilité des requêtes
- **Niveaux** : DEBUG, INFO, WARN, ERROR

### Health checks
- **Backend** : `/actuator/health`
- **Frontend** : Vérification de la connectivité
- **Docker** : Health checks intégrés

## 🚀 Déploiement

### Environnement de développement
```yaml
# docker-compose.yml
services:
  backend:
    build: ./backend
    ports: ["8080:8080"]
  frontend:
    build: ./frontend
    ports: ["5173:80"]
```

### Environnement de production
```yaml
# infra/docker-compose.prod.yml
services:
  backend:
    environment:
      - SPRING_PROFILES_ACTIVE=prod
  frontend:
    environment:
      - VITE_API_BASE=${API_BASE_URL}
```

## 🔄 Flux de données

### État de l'authentification
```typescript
// État initial
{
  user: null,
  isLoading: false,
  error: null,
  isAuthenticated: false
}

// Après connexion
{
  user: { id_token: "...", access_token: "...", profile: {...} },
  isLoading: false,
  error: null,
  isAuthenticated: true
}
```

### Validation JWT côté serveur
```java
// Spring Boot valide automatiquement :
// 1. Signature du token avec JWKS Google
// 2. Expiration du token
// 3. Audience et issuer
// 4. Structure du token
```

## 🧪 Tests

### Tests unitaires
- **Frontend** : Vitest pour les composants Vue
- **Backend** : JUnit 5 pour les contrôleurs

### Tests d'intégration
- **E2E** : Cypress pour le flux complet
- **API** : Tests des endpoints avec tokens mockés

## 📈 Métriques et monitoring

### Métriques applicatives
- Nombre de connexions
- Temps de réponse des APIs
- Erreurs d'authentification

### Monitoring infrastructure
- Santé des conteneurs Docker
- Utilisation des ressources
- Logs centralisés

## 🔧 Configuration

### Variables d'environnement
```bash
# Frontend
VITE_GOOGLE_CLIENT_ID=your_client_id
VITE_OIDC_ISSUER=https://accounts.google.com
VITE_API_BASE=http://localhost:8080

# Backend
SPRING_SECURITY_OAUTH2_RESOURCESERVER_JWT_ISSUER_URI=https://accounts.google.com
```

### Configuration Spring Boot
```yaml
# application.yml
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: https://accounts.google.com
```

Cette architecture garantit une séparation claire des responsabilités, une sécurité robuste et une maintenabilité optimale.
