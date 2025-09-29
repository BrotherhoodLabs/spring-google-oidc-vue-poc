import { UserManager, UserManagerSettings } from 'oidc-client-ts'

const oidcConfig: UserManagerSettings = {
  authority: import.meta.env.VITE_OIDC_ISSUER || 'https://accounts.google.com',
  client_id: import.meta.env.VITE_GOOGLE_CLIENT_ID || '',
  redirect_uri: `${window.location.origin}/callback`,
  response_type: 'code',
  scope: 'openid email profile',
  automaticSilentRenew: false,
  loadUserInfo: true,
  prompt: 'consent',
  post_logout_redirect_uri: window.location.origin,
  metadata: {
    issuer: import.meta.env.VITE_OIDC_ISSUER || 'https://accounts.google.com',
    authorization_endpoint: 'https://accounts.google.com/o/oauth2/v2/auth',
    token_endpoint: 'https://oauth2.googleapis.com/token',
    userinfo_endpoint: 'https://www.googleapis.com/oauth2/v2/userinfo',
    jwks_uri: 'https://www.googleapis.com/oauth2/v3/certs',
    end_session_endpoint: 'https://accounts.google.com/o/oauth2/v2/revoke'
  }
}

export const userManager = new UserManager(oidcConfig)
