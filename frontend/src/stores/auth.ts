import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { userManager } from '@/config/oidc'
import type { User } from 'oidc-client-ts'

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(null)
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  const isAuthenticated = computed(() => !!user.value && !user.value.expired)
  const idToken = computed(() => user.value?.id_token || null)
  const accessToken = computed(() => user.value?.access_token || null)
  const userInfo = computed(() => user.value?.profile || null)

  const login = async () => {
    try {
      isLoading.value = true
      error.value = null
      await userManager.signinRedirect()
    } catch (err) {
      error.value = err instanceof Error ? err.message : 'Erreur de connexion'
      console.error('Erreur de connexion:', err)
    } finally {
      isLoading.value = false
    }
  }

  const handleCallback = async () => {
    try {
      isLoading.value = true
      error.value = null
      const userData = await userManager.signinRedirectCallback()
      user.value = userData
      return userData
    } catch (err) {
      error.value = err instanceof Error ? err.message : 'Erreur de callback'
      console.error('Erreur de callback:', err)
      throw err
    } finally {
      isLoading.value = false
    }
  }

  const logout = async () => {
    try {
      isLoading.value = true
      error.value = null
      user.value = null
      await userManager.signoutRedirect()
    } catch (err) {
      error.value = err instanceof Error ? err.message : 'Erreur de déconnexion'
      console.error('Erreur de déconnexion:', err)
    } finally {
      isLoading.value = false
    }
  }

  const checkAuth = async () => {
    try {
      isLoading.value = true
      const userData = await userManager.getUser()
      if (userData && !userData.expired) {
        user.value = userData
      } else {
        user.value = null
      }
    } catch (err) {
      error.value = err instanceof Error ? err.message : 'Erreur de vérification'
      console.error('Erreur de vérification:', err)
      user.value = null
    } finally {
      isLoading.value = false
    }
  }

  const clearError = () => {
    error.value = null
  }

  return {
    user,
    isLoading,
    error,
    isAuthenticated,
    idToken,
    accessToken,
    userInfo,
    login,
    handleCallback,
    logout,
    checkAuth,
    clearError
  }
})
