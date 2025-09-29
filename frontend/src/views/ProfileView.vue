<template>
  <div class="profile">
    <div class="profile-header">
      <h1>Profil utilisateur</h1>
      <button @click="handleLogout" :disabled="authStore.isLoading" class="logout-btn">
        Se déconnecter
      </button>
    </div>

    <div v-if="authStore.isLoading" class="loading">
      <div class="spinner"></div>
      <p>Chargement...</p>
    </div>

    <div v-else-if="error" class="error">
      <h3>Erreur</h3>
      <p>{{ error }}</p>
      <button @click="loadUserData" class="retry-btn">Réessayer</button>
    </div>

    <div v-else class="profile-content">
      <div class="user-info">
        <div class="avatar">
          <img 
            v-if="authStore.userInfo?.picture" 
            :src="authStore.userInfo.picture" 
            :alt="authStore.userInfo.name"
            class="avatar-img"
          >
          <div v-else class="avatar-placeholder">
            {{ getInitials(authStore.userInfo?.name || authStore.userInfo?.email) }}
          </div>
        </div>
        
        <div class="user-details">
          <h2>{{ authStore.userInfo?.name || 'Utilisateur' }}</h2>
          <p class="email">{{ authStore.userInfo?.email }}</p>
          <p v-if="authStore.userInfo?.email_verified" class="verified">
            ✓ Email vérifié
          </p>
        </div>
      </div>

      <div class="tokens-info">
        <h3>Informations des tokens</h3>
        <div class="token-grid">
          <div class="token-item">
            <label>Subject ID:</label>
            <code>{{ authStore.userInfo?.sub }}</code>
          </div>
          <div class="token-item">
            <label>Issuer:</label>
            <code>{{ authStore.userInfo?.iss }}</code>
          </div>
          <div class="token-item">
            <label>Audience:</label>
            <code>{{ authStore.userInfo?.aud }}</code>
          </div>
          <div class="token-item">
            <label>Expiration:</label>
            <code>{{ formatDate(authStore.userInfo?.exp) }}</code>
          </div>
        </div>
      </div>

      <div class="api-data">
        <h3>Données de l'API</h3>
        <div v-if="apiLoading" class="loading">
          <div class="spinner"></div>
          <p>Chargement des données API...</p>
        </div>
        <div v-else-if="apiError" class="error">
          <p>{{ apiError }}</p>
          <button @click="loadApiData" class="retry-btn">Réessayer</button>
        </div>
        <div v-else class="api-content">
          <div class="api-section">
            <h4>Endpoint /api/me</h4>
            <pre class="json-display">{{ JSON.stringify(apiData.me, null, 2) }}</pre>
          </div>
        </div>
      </div>

      <div class="actions">
        <router-link to="/secure" class="btn">Voir les données sécurisées</router-link>
        <router-link to="/" class="btn secondary">Retour à l'accueil</router-link>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { api } from '@/services/api'

const router = useRouter()
const authStore = useAuthStore()

const error = ref<string | null>(null)
const apiLoading = ref(false)
const apiError = ref<string | null>(null)
const apiData = ref<any>({})

const loadUserData = async () => {
  try {
    error.value = null
    await authStore.checkAuth()
    if (!authStore.isAuthenticated) {
      router.push('/')
    }
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Erreur de chargement'
  }
}

const loadApiData = async () => {
  try {
    apiLoading.value = true
    apiError.value = null
    
    const [meResponse] = await Promise.all([
      api.getMe()
    ])
    
    apiData.value = {
      me: meResponse.data
    }
  } catch (err) {
    apiError.value = err instanceof Error ? err.message : 'Erreur API'
    console.error('Erreur API:', err)
  } finally {
    apiLoading.value = false
  }
}

const handleLogout = async () => {
  await authStore.logout()
}

const getInitials = (name: string) => {
  return name
    .split(' ')
    .map(word => word.charAt(0))
    .join('')
    .toUpperCase()
    .slice(0, 2)
}

const formatDate = (timestamp: number) => {
  if (!timestamp) return 'N/A'
  return new Date(timestamp * 1000).toLocaleString()
}

onMounted(() => {
  loadUserData()
  if (authStore.isAuthenticated) {
    loadApiData()
  }
})
</script>

<style scoped>
.profile {
  max-width: 1000px;
  margin: 0 auto;
  padding: 2rem;
}

.profile-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  padding-bottom: 1rem;
  border-bottom: 2px solid #eee;
}

.profile-header h1 {
  color: #333;
  margin: 0;
}

.logout-btn {
  background: #e74c3c;
  color: white;
  border: none;
  padding: 0.8rem 1.5rem;
  border-radius: 0.5rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.logout-btn:hover:not(:disabled) {
  background: #c0392b;
  transform: translateY(-2px);
}

.logout-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.loading {
  text-align: center;
  padding: 2rem;
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
  background: #ffe6e6;
  color: #e74c3c;
  padding: 1rem;
  border-radius: 0.5rem;
  margin-bottom: 1rem;
  border: 1px solid #ffcccc;
}

.retry-btn {
  background: #667eea;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 0.3rem;
  cursor: pointer;
  margin-top: 0.5rem;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 2rem;
  background: white;
  padding: 2rem;
  border-radius: 1rem;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  margin-bottom: 2rem;
}

.avatar {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  overflow: hidden;
  flex-shrink: 0;
}

.avatar-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatar-placeholder {
  width: 100%;
  height: 100%;
  background: #667eea;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 2rem;
  font-weight: bold;
}

.user-details h2 {
  margin: 0 0 0.5rem 0;
  color: #333;
  font-size: 1.8rem;
}

.email {
  color: #666;
  margin: 0 0 0.5rem 0;
  font-size: 1.1rem;
}

.verified {
  color: #27ae60;
  font-weight: 600;
  margin: 0;
}

.tokens-info,
.api-data {
  background: white;
  padding: 2rem;
  border-radius: 1rem;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  margin-bottom: 2rem;
}

.tokens-info h3,
.api-data h3 {
  margin: 0 0 1.5rem 0;
  color: #333;
  font-size: 1.5rem;
}

.token-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
}

.token-item {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.token-item label {
  font-weight: 600;
  color: #666;
  font-size: 0.9rem;
}

.token-item code {
  background: #f8f9fa;
  padding: 0.5rem;
  border-radius: 0.3rem;
  font-family: 'Courier New', monospace;
  font-size: 0.9rem;
  word-break: break-all;
  border: 1px solid #e9ecef;
}

.api-section h4 {
  margin: 0 0 1rem 0;
  color: #333;
}

.json-display {
  background: #f8f9fa;
  padding: 1rem;
  border-radius: 0.5rem;
  border: 1px solid #e9ecef;
  font-family: 'Courier New', monospace;
  font-size: 0.9rem;
  overflow-x: auto;
  max-height: 300px;
  overflow-y: auto;
}

.actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
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
  border: none;
  cursor: pointer;
}

.btn:hover {
  background: #5a6fd8;
  transform: translateY(-2px);
}

.btn.secondary {
  background: #6c757d;
}

.btn.secondary:hover {
  background: #5a6268;
}

@media (max-width: 768px) {
  .user-info {
    flex-direction: column;
    text-align: center;
  }
  
  .profile-header {
    flex-direction: column;
    gap: 1rem;
    text-align: center;
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
