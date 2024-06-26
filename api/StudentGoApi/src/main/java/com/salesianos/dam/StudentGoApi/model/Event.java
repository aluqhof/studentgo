package com.salesianos.dam.StudentGoApi.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.UuidGenerator;
import org.springframework.data.annotation.CreatedBy;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Event {

    @Id
    @GeneratedValue(generator = "UUID")
    @UuidGenerator
    @Column(columnDefinition = "uuid")
    private UUID id;

    private String name;

    private double latitude;

    private double longitude;
    private double price;
    private String place;

    @ManyToOne
    @JoinColumn(name = "city_id")
    private City city;

    private String description;

    private LocalDateTime dateTime;

    @ElementCollection
    @CollectionTable(name = "event_photos", joinColumns = @JoinColumn(name = "event_id"))
    @Column(name = "url_photo")
    private List<String> urlPhotos;

    private int maxCapacity;

    @OneToMany(mappedBy = "event", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<Purchase> purchaseList;

    @ManyToMany
    @JoinTable(
            name = "event_event_type",
            joinColumns = @JoinColumn(name = "event_id"),
            inverseJoinColumns = @JoinColumn(name = "event_type_id")
    )
    private List<EventType> eventTypes;

    @CreatedBy
    private String author;

    public void removeEventType(EventType eventType) {
        if (eventTypes != null) {
            eventTypes.remove(eventType);
        }
    }

}
