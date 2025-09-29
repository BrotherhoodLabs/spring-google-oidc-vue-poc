# Backlog: spring-google-oidc-vue-poc

**PoC Google Login OIDC (PKCE) avec Vue 3 (SPA) + Spring Boot API**

Organisation: https://github.com/BrotherhoodLabs/  
Repo cible: BrotherhoodLabs/spring-google-oidc-vue-poc (SSH)

## 1) Création du repository GitHub via SSH
- [x] Nom du repo: spring-google-oidc-vue-poc (public ou privé)
- [ ] Vérifier/ajouter la clé SSH GitHub
- [x] Arborescence: backend/, frontend/, docs/, infra/, .github/workflows/, .gitignore, LICENSE, README.md
- [ ] Protection de la branche main + PR template
- [ ] **[RÈGLE] Après CHAQUE ticket: commit + push (Conventional/Google: <type>(scope): message)**

## 2) Vision & portée (docs/vision.md)
- [ ] Objectif: permettre à un utilisateur de se connecter avec son compte Google (OpenID Connect + PKCE) via une SPA Vue 3
- [ ] Backend Spring Boot sert d'API protégée par jeton (Resource Server JWT)
- [ ] Portée PoC: OIDC Authorization Code + PKCE sur le front, vérification du jeton côté backend, endpoints de test
- [ ] Hors scope: RBAC avancé, refresh token offline (facultatif), SSO multi-IdP

## 3) Pré-requis Google Cloud (docs/google-setup.md)
- [ ] Créer un projet GCP ou utiliser un existant
- [ ] Activer "OAuth consent screen" (External), scopes: openid, email, profile
- [ ] Créer un OAuth 2.0 Client ID (type: Web application)
- [ ] Authorized JavaScript origins: http://localhost:5173 (Vue dev), http://localhost:8080 (option reverse proxy)
- [ ] Authorized redirect URIs: http://localhost:5173/callback
- [ ] Récupérer CLIENT_ID (pas de secret requis pour SPA PKCE)
- [ ] Noter issuer Google: https://accounts.google.com

## 4) Backend — Initialisation Spring Boot (backend/)
- [x] Spring Boot 3.x (Java 21). Dépendances: Web, Security, OAuth2 Resource Server, Actuator
- [x] application.yml:
  - [x] spring.security.oauth2.resourceserver.jwt.issuer-uri=https://accounts.google.com
  - [x] CORS permissif pour http://localhost:5173
- [x] Exposer endpoints:
  - [x] GET /api/public (public)
  - [x] GET /api/me (protégé) → renvoie claims (sub, email, name, picture)
  - [x] GET /api/secure-data (protégé) → payload fictif
- [x] Health: /actuator/health (public)

## 5) Backend — Sécurité (Resource Server)
- [x] Configurer SecurityFilterChain: authorizeHttpRequests (permitAll /api/public, /actuator/** ; authenticated /api/**)
- [x] Activer jwt() avec issuer Google (JWKS auto)
- [x] Mapper claims → principal (sub, email, name) via JwtAuthenticationConverter (option)

## 6) Frontend — Initialisation Vue 3 (frontend/)
- [ ] Vue 3 + Vite + TypeScript
- [ ] Installer: vue-router, pinia (ou vueuse), axios
- [ ] Créer pages: Home (/), Callback (/callback), Profile (/profile), Secure (/secure)
- [ ] .env: VITE_GOOGLE_CLIENT_ID, VITE_OIDC_ISSUER=https://accounts.google.com, VITE_API_BASE=http://localhost:8080

## 7) Frontend — Auth OIDC + PKCE
- [ ] Utiliser **oidc-client-ts** (ou équivalent) pour Authorization Code + PKCE
- [ ] Config OIDC:
  - [ ] authority: https://accounts.google.com
  - [ ] client_id: VITE_GOOGLE_CLIENT_ID
  - [ ] redirect_uri: http://localhost:5173/callback
  - [ ] response_type: code
  - [ ] scope: openid email profile
  - [ ] prompt: consent (option dev)
- [ ] Démarrer le flux: bouton "Sign in with Google" → createSigninRequest → redirection
- [ ] Callback: traiter code + state, échanger contre tokens (token endpoint Google), persister en **mémoire** (éviter localStorage)
- [ ] Ajouter un intercepteur axios: Authorization: Bearer <id_token ou access_token> (choix PoC: **ID Token** pour simplicité)

## 8) Frontend — Guards & état
- [ ] Route guard: si pas de token → rediriger vers /
- [ ] Store (Pinia): { isAuthenticated, idToken, accessToken, userInfo }
- [ ] Charger /userinfo (optional) via Google ou décoder ID token (claims)

## 9) Intégration API backend
- [ ] Appeler GET /api/me et /api/secure-data avec Authorization: Bearer <id_token>
- [ ] Afficher résultat dans /profile et /secure
- [ ] Gérer erreurs 401/403 (toast + redirection login)

## 10) Déconnexion
- [ ] Bouton Logout: clear store + revoke token Google (optionnelle, via endpoint revocation) + redirection Home
- [ ] Documenter que logout ne révoque pas la session Google globale (limite OIDC)

## 11) Observabilité & logs
- [ ] Backend: logs JSON, correlation-id (filter simple), /actuator/health
- [ ] Frontend: simple logger (console) + affichage état auth (dev)

## 12) Sécurité (PoC)
- [x] CORS strict: origins autorisés (localhost:5173)
- [ ] Ne pas stocker tokens en localStorage/sessionStorage (mémoire uniquement)
- [ ] Limiter scopes côté Google à openid email profile
- [ ] CSRF: non applicable pour API stateless (documenter)

## 13) Tests
- [ ] Backend: tests MVC pour endpoints public/protégé, validation JWT (mock avec clé JWKS de test)
- [ ] Frontend: tests unitaires pour store/guards (vitest), test e2e léger (Cypress) pour flux login→profile

## 14) Infra — Docker & Compose
- [ ] Dockerfile backend (JVM)
- [ ] Dockerfile frontend (nginx + build Vite)
- [ ] docker-compose: backend (8080), frontend (5173→80) (ou 8081), réseau commun
- [ ] docs/run.md: variables d'env, démarrage, URLs

## 15) CI GitHub Actions
- [ ] Backend: mvn -B verify (tests)
- [ ] Frontend: npm ci && npm run build && npm run test
- [ ] Artefacts: rapports tests, SBOM (Syft) optionnel

## 16) Documentation
- [ ] README.md: objectif, prérequis Google, config, démarrage, endpoints, captures
- [ ] docs/google-setup.md: pas à pas création OAuth Client + redirect URIs
- [ ] docs/architecture.md: schéma OIDC PKCE (SPA) + validation JWT côté API

## 17) Démo End-to-End
- [ ] Lancer compose
- [ ] Sur Home, cliquer "Sign in with Google" → consent → /callback → /profile
- [ ] Vérifier /api/me et /api/secure-data renvoient des données avec le jeton
- [ ] Tester logout puis accès protégé (redirigé)

## 18) Extensions (roadmap.md)
- [ ] Utiliser **access_token** côté API (Resource Server "opaque" ou Introspection) au lieu de l'ID token
- [ ] Backend BFF (session secure) pour éviter exposition tokens au front
- [ ] Ajout d'un refresh flow côté front (prompt=consent + approval_prompt=force) si nécessaire
- [ ] Multi-IdP (Google + Microsoft + GitHub), RBAC, PKCE avec vueuse/oauth
