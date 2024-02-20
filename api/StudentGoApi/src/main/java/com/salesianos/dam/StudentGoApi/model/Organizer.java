package com.salesianos.dam.StudentGoApi.model;

import jakarta.persistence.Entity;
import lombok.*;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Getter
@Setter
@ToString
@NoArgsConstructor
@SuperBuilder
public class Organizer extends UserDefault {


    private String description;

    private String business;

    public Organizer(UUID id, String username, String password, String email, String name,
                      boolean accountNonExpired, boolean accountNonLocked, boolean credentialsNonExpired, boolean enabled,
                      LocalDateTime createdAt, LocalDateTime lastPasswordChangeAt, String description, String business) {
        super(id, username, password, email, name, accountNonExpired, accountNonLocked, credentialsNonExpired,
                enabled, createdAt, lastPasswordChangeAt);
        this.description = description;
        this.business = business;
    }
}
