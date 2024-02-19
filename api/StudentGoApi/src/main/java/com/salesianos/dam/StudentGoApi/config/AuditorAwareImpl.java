package com.salesianos.dam.StudentGoApi.config;

import com.salesianos.dam.StudentGoApi.model.User;
import org.springframework.data.domain.AuditorAware;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.Optional;


public class AuditorAwareImpl implements AuditorAware<String> {
    @Override
    public Optional<String> getCurrentAuditor() {
        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        return Optional.ofNullable(authentication)
                .map(auth -> (User) auth.getPrincipal())
                .map(User::getId)
                .map(java.util.UUID::toString);
    }
}