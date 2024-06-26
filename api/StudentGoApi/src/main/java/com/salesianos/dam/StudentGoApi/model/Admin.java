package com.salesianos.dam.StudentGoApi.model;

import jakarta.persistence.Entity;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Getter
@Setter
@ToString
@NoArgsConstructor
public class Admin extends UserDefault {

    public Admin(UUID id, String username, String password, String email, String urlPhoto, String name,
                     boolean accountNonExpired, boolean accountNonLocked, boolean credentialsNonExpired, boolean enabled,
                     LocalDateTime createdAt, LocalDateTime lastPasswordChangeAt) {
        super(id, username, password, email, urlPhoto, name, accountNonExpired, accountNonLocked, credentialsNonExpired,
                enabled, createdAt, lastPasswordChangeAt);

    }
}
