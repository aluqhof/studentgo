package com.salesianos.dam.StudentGoApi.repository;

import com.salesianos.dam.StudentGoApi.model.UserDefault;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;
@Repository

public interface UserRepository extends JpaRepository<UserDefault, UUID> {

    Optional<UserDefault> findFirstByUsername(String username);
    boolean existsByUsernameIgnoreCase(String username);

}