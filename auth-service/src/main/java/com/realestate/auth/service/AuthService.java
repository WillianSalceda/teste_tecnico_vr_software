package com.realestate.auth.service;

import com.realestate.auth.dto.LoginResponse;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class AuthService {

    private static final Map<String, String> USERS = Map.of(
            "admin", "admin123"
    );

    private final JwtService jwtService;

    public AuthService(JwtService jwtService) {
        this.jwtService = jwtService;
    }

    public LoginResponse login(String username, String password) {
        String expectedPassword = USERS.get(username);
        if (expectedPassword == null || !expectedPassword.equals(password)) {
            throw new InvalidCredentialsException("Invalid username or password");
        }
        String token = jwtService.createToken(username);
        return new LoginResponse(token, username);
    }

    public static class InvalidCredentialsException extends RuntimeException {
        public InvalidCredentialsException(String message) {
            super(message);
        }
    }
}
