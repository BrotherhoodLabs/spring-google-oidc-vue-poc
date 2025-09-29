<template>
  <div class="home">
    <div class="hero">
      <h1>PoC Google OIDC avec Vue 3</h1>
      <p>Démonstration d'authentification OpenID Connect avec PKCE</p>
      
      <div v-if="!authStore.isAuthenticated" class="auth-section">
        <button 
          @click="handleLogin" 
          :disabled="authStore.isLoading"
          class="login-btn"
        >
          <span v-if="authStore.isLoading">Connexion...</span>
          <span v-else>Se connecter avec Google</span>
        </button>
        
        <div v-if="authStore.error" class="error">
          {{ authStore.error }}
        </div>
      </div>
      
      <div v-else class="welcome-section">
        <h2>Bienvenue {{ authStore.userInfo?.name || authStore.userInfo?.email }} !</h2>
        <p>Vous êtes connecté avec succès.</p>
        <div class="actions">
          <router-link to="/profile" class="btn">Voir le profil</router-link>
          <router-link to="/secure" class="btn">Données sécurisées</router-link>
        </div>
      </div>
    </div>
    
    <div class="features">
      <h2>Fonctionnalités</h2>
      <div class="feature-grid">
        <div class="feature-card">
          <h3>🔐 OIDC + PKCE</h3>
          <p>Authentification sécurisée avec OpenID Connect et PKCE</p>
        </div>
        <div class="feature-card">
          <h3>⚡ Vue 3 + TypeScript</h3>
          <p>Interface moderne avec Vue 3 et TypeScript</p>
        </div>
        <div class="feature-card">
          <h3>🚀 Spring Boot API</h3>
          <p>Backend robuste avec Spring Boot et OAuth2 Resource Server</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()

const handleLogin = async () => {
  await authStore.login()
}

onMounted(() => {
  authStore.checkAuth()
})
</script>

<style scoped>
.home {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.hero {
  text-align: center;
  padding: 4rem 0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 1rem;
  margin-bottom: 3rem;
}

.hero h1 {
  font-size: 3rem;
  margin-bottom: 1rem;
  font-weight: 700;
}

.hero p {
  font-size: 1.2rem;
  margin-bottom: 2rem;
  opacity: 0.9;
}

.auth-section {
  margin-top: 2rem;
}

.login-btn {
  background: white;
  color: #667eea;
  border: none;
  padding: 1rem 2rem;
  font-size: 1.1rem;
  font-weight: 600;
  border-radius: 0.5rem;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

.login-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
}

.login-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.welcome-section h2 {
  font-size: 2rem;
  margin-bottom: 1rem;
}

.welcome-section p {
  font-size: 1.1rem;
  margin-bottom: 2rem;
}

.actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
}

.btn {
  background: rgba(255, 255, 255, 0.2);
  color: white;
  padding: 0.8rem 1.5rem;
  text-decoration: none;
  border-radius: 0.5rem;
  font-weight: 600;
  transition: all 0.3s ease;
  border: 2px solid rgba(255, 255, 255, 0.3);
}

.btn:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
}

.error {
  background: rgba(255, 0, 0, 0.1);
  color: #ff6b6b;
  padding: 1rem;
  border-radius: 0.5rem;
  margin-top: 1rem;
  border: 1px solid rgba(255, 0, 0, 0.2);
}

.features {
  margin-top: 3rem;
}

.features h2 {
  text-align: center;
  font-size: 2.5rem;
  margin-bottom: 2rem;
  color: #333;
}

.feature-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  margin-top: 2rem;
}

.feature-card {
  background: white;
  padding: 2rem;
  border-radius: 1rem;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  text-align: center;
  transition: transform 0.3s ease;
}

.feature-card:hover {
  transform: translateY(-5px);
}

.feature-card h3 {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  color: #667eea;
}

.feature-card p {
  color: #666;
  line-height: 1.6;
}

@media (max-width: 768px) {
  .hero h1 {
    font-size: 2rem;
  }
  
  .hero p {
    font-size: 1rem;
  }
  
  .actions {
    flex-direction: column;
    align-items: center;
  }
  
  .btn {
    width: 200px;
  }
}
</style>