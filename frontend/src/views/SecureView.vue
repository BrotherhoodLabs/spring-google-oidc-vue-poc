<template>
  <div class="secure">
    <div class="secure-header">
      <h1>Données sécurisées</h1>
      <p>Cette page contient des données protégées accessibles uniquement avec un token JWT valide.</p>
    </div>

    <div v-if="isLoading" class="loading">
      <div class="spinner"></div>
      <p>Chargement des données sécurisées...</p>
    </div>

    <div v-else-if="error" class="error">
      <h3>Erreur</h3>
      <p>{{ error }}</p>
      <button @click="loadSecureData" class="retry-btn">Réessayer</button>
    </div>

    <div v-else class="secure-content">
      <div class="data-section">
        <h2>Données de l'API sécurisée</h2>
        <div class="api-response">
          <h3>Endpoint /api/secure-data</h3>
          <pre class="json-display">{{ JSON.stringify(secureData, null, 2) }}</pre>
        </div>
      </div>

      <div class="token-info">
        <h2>Informations du token JWT</h2>
        <div class="token-details">
          <div class="token-item">
            <label>Token utilisé:</label>
            <code class="token-preview">{{ tokenPreview }}</code>
          </div>
          <div class="token-item">
            <label>Expiration:</label>
            <span :class="{ 'expired': isTokenExpired }">
              {{ formatDate(authStore.userInfo?.exp) }}
              <span v-if="isTokenExpired" class="expired-badge">EXPIRÉ</span>
            </span>
          </div>
          <div class="token-item">
            <label>Utilisateur:</label>
            <span>{{ authStore.userInfo?.email }}</span>
          </div>
        </div>
      </div>

      <div class="security-info">
        <h2>Informations de sécurité</h2>
        <div class="security-grid">
          <div class="security-item">
            <h3>🔐 Authentification</h3>
            <p>Token JWT validé par Spring Boot OAuth2 Resource Server</p>
          </div>
          <div class="security-item">
            <h3>🌐 CORS</h3>
            <p>Origines autorisées: localhost:5173 uniquement</p>
          </div>
          <div class="security-item">
            <h3>⚡ PKCE</h3>
            <p>Protocole PKCE utilisé pour l'authentification OIDC</p>
          </div>
          <div class="security-item">
            <h3>🔑 JWT</h3>
            <p>Token signé par Google et vérifié côté serveur</p>
          </div>
        </div>
      </div>

      <div class="actions">
        <button @click="loadSecureData" class="btn">Actualiser les données</button>
        <router-link to="/profile" class="btn secondary">Retour au profil</router-link>
        <button @click="handleLogout" class="btn danger">Se déconnecter</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { api } from '@/services/api'

const router = useRouter()
const authStore = useAuthStore()

const isLoading = ref(false)
const error = ref<string | null>(null)
const secureData = ref<any>(null)

const tokenPreview = computed(() => {
  const token = authStore.idToken
  if (!token) return 'Aucun token'
  return `${token.substring(0, 20)}...${token.substring(token.length - 20)}`
})

const isTokenExpired = computed(() => {
  if (!authStore.userInfo?.exp) return false
  return Date.now() >= authStore.userInfo.exp * 1000
})

const loadSecureData = async () => {
  try {
    isLoading.value = true
    error.value = null
    
    if (!authStore.isAuthenticated) {
      router.push('/')
      return
    }
    
    const response = await api.getSecureData()
    secureData.value = response.data
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Erreur lors du chargement des données sécurisées'
    console.error('Erreur API sécurisée:', err)
  } finally {
    isLoading.value = false
  }
}

const handleLogout = async () => {
  await authStore.logout()
}

const formatDate = (timestamp: number) => {
  if (!timestamp) return 'N/A'
  return new Date(timestamp * 1000).toLocaleString()
}

onMounted(() => {
  if (!authStore.isAuthenticated) {
    router.push('/')
  } else {
    loadSecureData()
  }
})
</script>

<style scoped>
.secure {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.secure-header {
  text-align: center;
  margin-bottom: 3rem;
  padding: 2rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 1rem;
}

.secure-header h1 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
  font-weight: 700;
}

.secure-header p {
  font-size: 1.1rem;
  opacity: 0.9;
  max-width: 600px;
  margin: 0 auto;
}

.loading {
  text-align: center;
  padding: 3rem;
}

.spinner {
  width: 50px;
  height: 50px;
  border: 5px solid #f3f3f3;
  border-top: 5px solid #667eea;
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
  padding: 2rem;
  border-radius: 1rem;
  margin-bottom: 2rem;
  border: 1px solid #ffcccc;
  text-align: center;
}

.error h3 {
  margin: 0 0 1rem 0;
  color: #e74c3c;
}

.retry-btn {
  background: #667eea;
  color: white;
  border: none;
  padding: 0.8rem 1.5rem;
  border-radius: 0.5rem;
  cursor: pointer;
  font-weight: 600;
  margin-top: 1rem;
}

.secure-content {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.data-section,
.token-info,
.security-info {
  background: white;
  padding: 2rem;
  border-radius: 1rem;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.data-section h2,
.token-info h2,
.security-info h2 {
  margin: 0 0 1.5rem 0;
  color: #333;
  font-size: 1.8rem;
}

.api-response h3 {
  margin: 0 0 1rem 0;
  color: #666;
  font-size: 1.2rem;
}

.json-display {
  background: #f8f9fa;
  padding: 1.5rem;
  border-radius: 0.5rem;
  border: 1px solid #e9ecef;
  font-family: 'Courier New', monospace;
  font-size: 0.9rem;
  overflow-x: auto;
  max-height: 400px;
  overflow-y: auto;
  white-space: pre-wrap;
}

.token-details {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
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

.token-preview {
  background: #f8f9fa;
  padding: 0.5rem;
  border-radius: 0.3rem;
  font-family: 'Courier New', monospace;
  font-size: 0.9rem;
  word-break: break-all;
  border: 1px solid #e9ecef;
}

.expired {
  color: #e74c3c;
  font-weight: 600;
}

.expired-badge {
  background: #e74c3c;
  color: white;
  padding: 0.2rem 0.5rem;
  border-radius: 0.3rem;
  font-size: 0.8rem;
  margin-left: 0.5rem;
}

.security-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-top: 1rem;
}

.security-item {
  padding: 1.5rem;
  background: #f8f9fa;
  border-radius: 0.5rem;
  border: 1px solid #e9ecef;
}

.security-item h3 {
  margin: 0 0 0.5rem 0;
  color: #333;
  font-size: 1.1rem;
}

.security-item p {
  margin: 0;
  color: #666;
  font-size: 0.9rem;
  line-height: 1.5;
}

.actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
  margin-top: 2rem;
}

.btn {
  background: #667eea;
  color: white;
  padding: 0.8rem 1.5rem;
  border: none;
  border-radius: 0.5rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  text-decoration: none;
  display: inline-block;
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

.btn.danger {
  background: #e74c3c;
}

.btn.danger:hover {
  background: #c0392b;
}

@media (max-width: 768px) {
  .secure-header h1 {
    font-size: 2rem;
  }
  
  .actions {
    flex-direction: column;
    align-items: center;
  }
  
  .btn {
    width: 200px;
  }
  
  .token-details {
    grid-template-columns: 1fr;
  }
  
  .security-grid {
    grid-template-columns: 1fr;
  }
}
</style>
