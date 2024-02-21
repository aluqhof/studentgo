package com.salesianos.dam.StudentGoApi.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.UuidGenerator;
import org.springframework.data.annotation.CreatedBy;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Purchase {

    @Id
    @GeneratedValue(generator = "UUID")
    @UuidGenerator
    @Column(columnDefinition = "uuid")
    private UUID uuid;

    private int numberOfTickets;

    private double totalPrice;

    private LocalDateTime dateTime;

    @ManyToOne
    @JoinColumn(name = "event_id")
    private Event event;

    @CreatedBy
    private String author;
}
