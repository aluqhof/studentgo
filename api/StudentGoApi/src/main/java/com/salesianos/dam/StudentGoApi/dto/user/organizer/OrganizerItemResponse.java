package com.salesianos.dam.StudentGoApi.dto.user.organizer;

import com.salesianos.dam.StudentGoApi.model.Organizer;

import java.time.LocalDateTime;

public record OrganizerItemResponse(
        String id,
        String username,
        String email,
        String name,
        String userPhoto,
        LocalDateTime created,
        String business
) {

    public static OrganizerItemResponse of(Organizer organizer){
        return new OrganizerItemResponse(
                organizer.getId().toString(),
                organizer.getUsername(),
                organizer.getEmail(),
                organizer.getName(),
                organizer.getUrlPhoto(),
                organizer.getCreatedAt(),
                organizer.getBusiness()
        );
    }

}
