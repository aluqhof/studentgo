package com.salesianos.dam.StudentGoApi.dto.user.organizer;

import com.salesianos.dam.StudentGoApi.model.Organizer;

import java.time.LocalDateTime;

public record OrganizerDetailsResponse(
        String id,
        String username,
        String email,
        String name,
        String userPhoto,
        LocalDateTime created,
        String business,
        String description
) {
    public static OrganizerDetailsResponse of(Organizer organizer){
        return new OrganizerDetailsResponse(
                organizer.getId().toString(),
                organizer.getUsername(),
                organizer.getEmail(),
                organizer.getName(),
                organizer.getUrlPhoto(),
                organizer.getCreatedAt(),
                organizer.getBusiness(),
                organizer.getDescription()
        );
    }
}
