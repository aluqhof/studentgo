package com.salesianos.dam.StudentGoApi.model;

import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Entity
@Getter
@Setter
@ToString
@NoArgsConstructor
public class Student extends UserDefault {

    private String description;

    @ManyToMany
    @JoinTable(
            name = "student_event_type",
            joinColumns = @JoinColumn(name = "student_id"),
            inverseJoinColumns = @JoinColumn(name = "event_type_id")
    )
    @ToString.Exclude
    private List<EventType> interests;

    public Student(UUID id, String username, String password, String email, String name,
                       boolean accountNonExpired, boolean accountNonLocked, boolean credentialsNonExpired, boolean enabled,
                       LocalDateTime createdAt, LocalDateTime lastPasswordChangeAt, String description) {
        super(id, username, password, email, name, accountNonExpired, accountNonLocked, credentialsNonExpired,
                enabled, createdAt, lastPasswordChangeAt);
        this.description = description;

    }
}
