package com.salesianos.dam.StudentGoApi.dto.event;

import com.salesianos.dam.StudentGoApi.dto.eventType.EventTypeResponse;
import com.salesianos.dam.StudentGoApi.dto.user.student.StudentListResponse;
import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.Student;

import java.time.LocalDateTime;
import java.util.List;

public record EventOverviewResponse(
        String uuid,
        String name,
        double latitude,
        double longitude,

        String cityId,
        LocalDateTime dateTime,
        List<EventTypeResponse> eventType
) {

    public static EventOverviewResponse of(Event e) {
        return new EventOverviewResponse(
                e.getId().toString(),
                e.getName(),
                e.getLatitude(),
                e.getLongitude(),
                e.getCity().getName(),
                e.getDateTime(),
                e.getEventTypes().stream().map(EventTypeResponse::of).toList()
        );
    }
}
