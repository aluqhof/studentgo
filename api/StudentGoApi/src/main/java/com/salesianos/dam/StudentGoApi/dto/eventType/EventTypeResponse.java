package com.salesianos.dam.StudentGoApi.dto.eventType;

import com.salesianos.dam.StudentGoApi.model.EventType;

public record EventTypeResponse(
        Long id,
        String name,
        String iconRef,
        String colorCode
) {

    public static EventTypeResponse of(EventType e){
        return new EventTypeResponse(
                e.getId(),
                e.getName(),
                e.getIconRef(),
                e.getColorCode()
        );
    }
}
