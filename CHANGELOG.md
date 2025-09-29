# Changelog

Toutes les modifications notables de ce projet seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Configuration initiale du projet avec Spring Boot et Vue 3
- Intégration Google OIDC avec PKCE
- Documentation complète et guides de configuration
- Pipeline CI/CD avec GitHub Actions
- Configuration Docker pour développement et production

### Security
- Implémentation PKCE pour la sécurité OAuth
- Validation JWT côté serveur avec Google JWKS
- CORS strict avec origines autorisées limitées
- Stockage des tokens en mémoire uniquement

## [v0.1.0] - 2025-09-30

### Added
- 🎉 Version initiale de la PoC Google OIDC
- Backend Spring Boot 3.x avec OAuth2 Resource Server
- Frontend Vue 3 avec TypeScript et OIDC + PKCE
- Endpoints API sécurisés (/api/public, /api/me, /api/secure-data)
- Configuration Docker et docker-compose
- Documentation complète (README, guides, architecture)
- Pipeline CI/CD avec tests et scans de sécurité
- Templates GitHub (PR, issues, workflows)

### Technical Details
- **Backend**: Spring Boot 3.3.0, Java 21, OAuth2 Resource Server
- **Frontend**: Vue 3, TypeScript, Vite, Pinia, oidc-client-ts
- **Security**: PKCE, JWT validation, CORS strict
- **Infrastructure**: Docker, Nginx, GitHub Actions
- **Documentation**: Markdown, architecture diagrams, setup guides

### Breaking Changes
- Initial commit - new project structure
