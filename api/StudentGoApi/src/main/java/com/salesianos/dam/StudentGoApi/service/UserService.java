package com.salesianos.dam.StudentGoApi.service;

import com.salesianos.dam.StudentGoApi.model.UserDefault;
import com.salesianos.dam.StudentGoApi.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository usuarioRepository;

    public Optional<UserDefault> findById(UUID id){
        return usuarioRepository.findById(id);
    }

    public boolean userExists(String username) {
        return usuarioRepository.existsByUsernameIgnoreCase(username);
    }


}