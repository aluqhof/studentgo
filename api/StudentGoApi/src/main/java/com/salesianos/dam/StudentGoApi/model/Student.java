package com.salesianos.dam.StudentGoApi.model;

import jakarta.persistence.Entity;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Getter
@Setter
@ToString
@NoArgsConstructor
public class Student extends UserDefault {

    private String description;

    public Student(UUID id, String username, String password, String email, String name,
                       boolean accountNonExpired, boolean accountNonLocked, boolean credentialsNonExpired, boolean enabled,
                       LocalDateTime createdAt, LocalDateTime lastPasswordChangeAt, String description) {
        super(id, username, password, email, name, accountNonExpired, accountNonLocked, credentialsNonExpired,
                enabled, createdAt, lastPasswordChangeAt);
        this.description = description;

    }
}
