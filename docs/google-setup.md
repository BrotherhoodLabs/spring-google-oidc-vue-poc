# Configuration Google Cloud Platform

Ce guide vous accompagne dans la configuration de Google Cloud Platform pour l'authentification OIDC.

## 📋 Prérequis

- Compte Google (Gmail, Google Workspace, etc.)
- Accès à [Google Cloud Console](https://console.cloud.google.com/)

## 🚀 Étapes de configuration

### 1. Créer un projet Google Cloud

1. Rendez-vous sur [Google Cloud Console](https://console.cloud.google.com/)
2. Cliquez sur "Sélectionner un projet" en haut à gauche
3. Cliquez sur "Nouveau projet"
4. Nommez votre projet (ex: `oidc-vue-poc`)
5. Cliquez sur "Créer"

### 2. Activer les APIs nécessaires

1. Dans le menu latéral, allez dans "APIs et services" > "Bibliothèque"
2. Recherchez et activez :
   - **Google+ API** (pour les informations de profil)
   - **Google OAuth2 API** (pour l'authentification)

### 3. Configurer l'écran de consentement OAuth

1. Allez dans "APIs et services" > "Écran de consentement OAuth"
2. Sélectionnez "Externe" (pour les utilisateurs externes)
3. Cliquez sur "Créer"

#### Informations de l'application
- **Nom de l'application** : `OIDC Vue PoC`
- **Email de support utilisateur** : Votre email
- **Email de contact du développeur** : Votre email

#### Scopes
1. Cliquez sur "Ajouter ou supprimer des scopes"
2. Ajoutez les scopes suivants :
   - `../auth/userinfo.email`
   - `../auth/userinfo.profile`
   - `openid`

#### Utilisateurs de test (optionnel pour le développement)
1. Dans "Utilisateurs de test", ajoutez les emails des utilisateurs qui pourront tester l'application
2. Cela évite la vérification de l'application pour les tests

### 4. Créer les identifiants OAuth 2.0

1. Allez dans "APIs et services" > "Identifiants"
2. Cliquez sur "Créer des identifiants" > "ID client OAuth 2.0"
3. Sélectionnez "Application web"

#### Configuration de l'application web

**Nom** : `OIDC Vue Frontend`

**Origines JavaScript autorisées** :
```
http://localhost:5173
http://localhost:3000
http://127.0.0.1:5173
```

**URIs de redirection autorisées** :
```
http://localhost:5173/callback
http://localhost:3000/callback
http://127.0.0.1:5173/callback
```

### 5. Récupérer les identifiants

1. Après création, vous verrez votre **ID client**
2. Copiez cette valeur (pas de secret client nécessaire pour SPA)
3. Notez l'**URI de l'émetteur** : `https://accounts.google.com`

## 🔧 Configuration dans l'application

### Frontend

Créez le fichier `frontend/.env.local` :

```bash
VITE_GOOGLE_CLIENT_ID=votre_client_id_ici
VITE_OIDC_ISSUER=https://accounts.google.com
VITE_API_BASE=http://localhost:8080
```

### Backend

Le backend est déjà configuré pour utiliser Google comme émetteur JWT.

## 🧪 Test de la configuration

1. Démarrez le backend : `cd backend && ./mvnw spring-boot:run`
2. Démarrez le frontend : `cd frontend && npm run dev`
3. Ouvrez `http://localhost:5173`
4. Cliquez sur "Se connecter avec Google"
5. Vous devriez être redirigé vers Google pour l'authentification

## 🔍 Vérification des paramètres

### Vérifier les origines autorisées
- L'URL de votre application frontend doit être dans "Origines JavaScript autorisées"
- L'URL de callback doit être dans "URIs de redirection autorisées"

### Vérifier les scopes
- `openid` : Obligatoire pour OpenID Connect
- `email` : Pour accéder à l'email de l'utilisateur
- `profile` : Pour accéder au nom et à la photo de profil

## 🚨 Dépannage

### Erreur "redirect_uri_mismatch"
- Vérifiez que l'URI de redirection dans Google Console correspond exactement à celle utilisée dans l'application
- L'URI doit inclure le protocole (`http://` ou `https://`)

### Erreur "invalid_client"
- Vérifiez que le `CLIENT_ID` est correct
- Assurez-vous que l'application est de type "Web application"

### Erreur CORS
- Vérifiez que l'origine de votre frontend est dans "Origines JavaScript autorisées"
- Redémarrez le backend après modification de la configuration CORS

### L'écran de consentement ne s'affiche pas
- Vérifiez que l'application est en mode "Externe"
- Ajoutez des utilisateurs de test si nécessaire
- Vérifiez que les scopes sont correctement configurés

## 📝 Notes importantes

- **Pas de secret client** : Les SPA n'utilisent pas de secret client pour des raisons de sécurité
- **HTTPS en production** : En production, utilisez toujours HTTPS
- **Origines strictes** : Limitez les origines autorisées aux domaines de production uniquement
- **Scopes minimaux** : N'ajoutez que les scopes nécessaires à votre application

## 🔄 Mise à jour de la configuration

Pour modifier la configuration :

1. Allez dans Google Cloud Console > APIs et services > Identifiants
2. Cliquez sur votre ID client OAuth 2.0
3. Modifiez les origines ou URIs de redirection
4. Sauvegardez les modifications
5. Redémarrez votre application

## 📚 Ressources supplémentaires

- [Documentation Google OAuth 2.0](https://developers.google.com/identity/protocols/oauth2)
- [OpenID Connect avec Google](https://developers.google.com/identity/protocols/oauth2/openid-connect)
- [PKCE pour les applications publiques](https://developers.google.com/identity/protocols/oauth2/native-app)
