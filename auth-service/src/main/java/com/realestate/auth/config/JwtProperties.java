package com.realestate.auth.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.jwt")
public class JwtProperties {

    private String secret = "h+JrHn3a6SzFYRgt+hqElt2DaEZT+TQambLjOtr2qNg=";
    private long expirationMs = 86400000; // 24 hours

    public String getSecret() {
        return secret;
    }

    public void setSecret(String secret) {
        this.secret = secret != null && !secret.isBlank() ? secret : this.secret;
    }

    public long getExpirationMs() {
        return expirationMs;
    }

    public void setExpirationMs(long expirationMs) {
        this.expirationMs = expirationMs > 0 ? expirationMs : this.expirationMs;
    }
}
