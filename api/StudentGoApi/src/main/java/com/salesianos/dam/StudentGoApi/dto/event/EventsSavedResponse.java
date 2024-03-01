package com.salesianos.dam.StudentGoApi.dto.event;

import com.salesianos.dam.StudentGoApi.model.Event;

public record EventsSavedResponse(
        String eventId
) {

    public static EventsSavedResponse of(Event event){
        return new EventsSavedResponse(
                event.getId().toString()
        );
    }

}
