<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { onMounted } from 'vue'

const authStore = useAuthStore()

onMounted(() => {
  authStore.checkAuth()
})
</script>

<template>
  <div id="app">
    <header v-if="!$route.meta.hideHeader">
      <div class="header-content">
        <div class="logo">
          <h1>🔐 OIDC PoC</h1>
        </div>
        
        <nav v-if="authStore.isAuthenticated">
          <RouterLink to="/">Accueil</RouterLink>
          <RouterLink to="/profile">Profil</RouterLink>
          <RouterLink to="/secure">Sécurisé</RouterLink>
        </nav>
      </div>
    </header>

    <main>
      <RouterView />
    </main>

    <footer v-if="!$route.meta.hideHeader">
      <div class="footer-content">
        <p>&copy; 2025 BrotherhoodLabs - PoC Google OIDC avec Vue 3 + Spring Boot</p>
      </div>
    </footer>
  </div>
</template>

<style scoped>
#app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

header {
  background: #2c3e50;
  color: white;
  padding: 1rem 0;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logo h1 {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 700;
}

nav {
  display: flex;
  gap: 2rem;
}

nav a {
  color: white;
  text-decoration: none;
  padding: 0.5rem 1rem;
  border-radius: 0.5rem;
  transition: all 0.3s ease;
  font-weight: 500;
}

nav a:hover {
  background: rgba(255, 255, 255, 0.1);
}

nav a.router-link-active {
  background: #667eea;
}

main {
  flex: 1;
  background: #f8f9fa;
}

footer {
  background: #2c3e50;
  color: white;
  padding: 1rem 0;
  text-align: center;
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

.footer-content p {
  margin: 0;
  font-size: 0.9rem;
  opacity: 0.8;
}

@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    gap: 1rem;
    text-align: center;
  }
  
  nav {
    gap: 1rem;
  }
  
  nav a {
    padding: 0.4rem 0.8rem;
    font-size: 0.9rem;
  }
}
</style>
