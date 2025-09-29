package com.brotherhoodlabs.oidc.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class ApiController {

    @GetMapping("/public")
    public Map<String, Object> publicEndpoint() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Ceci est un endpoint public accessible sans authentification");
        response.put("timestamp", LocalDateTime.now());
        response.put("status", "success");
        return response;
    }

    @GetMapping("/me")
    public Map<String, Object> me(@AuthenticationPrincipal Jwt jwt) {
        Map<String, Object> response = new HashMap<>();
        response.put("sub", jwt.getSubject());
        response.put("email", jwt.getClaimAsString("email"));
        response.put("name", jwt.getClaimAsString("name"));
        response.put("picture", jwt.getClaimAsString("picture"));
        response.put("email_verified", jwt.getClaimAsBoolean("email_verified"));
        response.put("iss", jwt.getIssuer());
        response.put("aud", jwt.getAudience());
        response.put("exp", jwt.getExpiresAt());
        response.put("iat", jwt.getIssuedAt());
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    @GetMapping("/secure-data")
    public Map<String, Object> secureData(@AuthenticationPrincipal Jwt jwt) {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Données sécurisées accessibles uniquement avec un token JWT valide");
        response.put("user", jwt.getSubject());
        response.put("data", Map.of(
            "secret_key", "valeur_secrete_123",
            "user_role", "authenticated_user",
            "access_level", "premium"
        ));
        response.put("timestamp", LocalDateTime.now());
        return response;
    }
}
