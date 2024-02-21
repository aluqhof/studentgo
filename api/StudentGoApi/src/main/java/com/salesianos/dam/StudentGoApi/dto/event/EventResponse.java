package com.salesianos.dam.StudentGoApi.dto.event;

import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.EventType;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public record EventResponse(
        String uuid,
        String name,
        double latitude,
        double longitude,
        String description,
        LocalDateTime dateTime,
        String organizer,
        List<String> eventTypes
) {

    public static EventResponse of(Event e){
        return new EventResponse(
                e.getId().toString(),
                e.getName(),
                e.getLongitude(),
                e.getLatitude(),
                e.getDescription(),
                e.getDateTime(),
                e.getAuthor(),
                e.getEventTypes().stream().map(EventType::getName).toList()
        );
    }

}
