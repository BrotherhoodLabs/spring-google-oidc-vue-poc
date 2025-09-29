<template>
  <div class="callback">
    <div class="loading-container">
      <div v-if="isLoading" class="loading">
        <div class="spinner"></div>
        <h2>Traitement de la connexion...</h2>
        <p>Veuillez patienter pendant que nous finalisons votre authentification.</p>
      </div>
      
      <div v-else-if="error" class="error">
        <h2>Erreur de connexion</h2>
        <p>{{ error }}</p>
        <router-link to="/" class="btn">Retour à l'accueil</router-link>
      </div>
      
      <div v-else class="success">
        <h2>Connexion réussie !</h2>
        <p>Redirection en cours...</p>
        <div class="spinner"></div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const isLoading = ref(true)
const error = ref<string | null>(null)

onMounted(async () => {
  try {
    await authStore.handleCallback()
    // Redirection vers le profil après connexion réussie
    setTimeout(() => {
      router.push('/profile')
    }, 1500)
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Une erreur est survenue'
    isLoading.value = false
  }
})
</script>

<style scoped>
.callback {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.loading-container {
  background: white;
  padding: 3rem;
  border-radius: 1rem;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
  text-align: center;
  max-width: 500px;
  width: 90%;
}

.loading h2,
.success h2,
.error h2 {
  color: #333;
  margin-bottom: 1rem;
  font-size: 1.8rem;
}

.loading p,
.success p,
.error p {
  color: #666;
  margin-bottom: 2rem;
  line-height: 1.6;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #667eea;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 1rem;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error {
  color: #e74c3c;
}

.error h2 {
  color: #e74c3c;
}

.btn {
  background: #667eea;
  color: white;
  padding: 0.8rem 1.5rem;
  text-decoration: none;
  border-radius: 0.5rem;
  font-weight: 600;
  transition: all 0.3s ease;
  display: inline-block;
}

.btn:hover {
  background: #5a6fd8;
  transform: translateY(-2px);
}

.success {
  color: #27ae60;
}

.success h2 {
  color: #27ae60;
}
</style>
