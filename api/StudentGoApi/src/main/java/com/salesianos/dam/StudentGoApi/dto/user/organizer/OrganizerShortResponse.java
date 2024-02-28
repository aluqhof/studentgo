package com.salesianos.dam.StudentGoApi.dto.user.organizer;

import com.salesianos.dam.StudentGoApi.model.Organizer;

import java.util.UUID;

public record OrganizerShortResponse(
        UUID id,
        String name,
        String username
) {

    public static OrganizerShortResponse of (Organizer o){
        return new OrganizerShortResponse(
                o.getId(),
                o.getName(),
                o.getUsername()
        );
    }

}
