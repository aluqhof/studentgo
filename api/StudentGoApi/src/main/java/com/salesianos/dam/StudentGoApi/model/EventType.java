package com.salesianos.dam.StudentGoApi.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.NaturalId;

@Entity
@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EventType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private String name;

    private String iconRef;

    private String colorCode;
}
