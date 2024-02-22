package com.salesianos.dam.StudentGoApi.dto.event;

import com.salesianos.dam.StudentGoApi.model.Event;

import java.util.List;

public record ListEventsResponse(
        String name,
        List<EventResponse> result
) {

    public static ListEventsResponse of(List<Event> e, String name){
        return new ListEventsResponse(
                name,
                e.stream().map(EventResponse::of).toList()
        );
    }

}
