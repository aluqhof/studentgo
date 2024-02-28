package com.salesianos.dam.StudentGoApi.dto.event;

import com.salesianos.dam.StudentGoApi.model.Event;

import java.time.LocalDateTime;

public record EventShortResponse(
        String uuid,
        String name,
        double latitude,
        double longitude,

        String cityId,
        LocalDateTime dateTime
) {

    public static EventShortResponse of(Event e){
        return new EventShortResponse(
                e.getId().toString(),
                e.getName(),
                e.getLatitude(),
                e.getLongitude(),
                e.getCity().getName(),
                e.getDateTime()
        );
    }
}
