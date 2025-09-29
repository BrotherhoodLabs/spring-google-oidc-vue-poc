import axios from 'axios'
import { useAuthStore } from '@/stores/auth'

const API_BASE_URL = import.meta.env.VITE_API_BASE || 'http://localhost:8080'

export const apiClient = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// Intercepteur pour ajouter le token d'authentification
apiClient.interceptors.request.use(
  (config) => {
    const authStore = useAuthStore()
    if (authStore.idToken) {
      config.headers.Authorization = `Bearer ${authStore.idToken}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Intercepteur pour gérer les erreurs d'authentification
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401 || error.response?.status === 403) {
      const authStore = useAuthStore()
      authStore.logout()
    }
    return Promise.reject(error)
  }
)

export const api = {
  // Endpoint public
  getPublicData: () => apiClient.get('/api/public'),
  
  // Endpoints protégés
  getMe: () => apiClient.get('/api/me'),
  getSecureData: () => apiClient.get('/api/secure-data')
}
