package com.salesianos.dam.StudentGoApi.dto.event;

import com.salesianos.dam.StudentGoApi.dto.eventType.EventTypeResponse;
import com.salesianos.dam.StudentGoApi.dto.user.student.StudentListResponse;
import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.EventType;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.repository.EventRepository;

import java.time.LocalDateTime;
import java.util.List;

public record EventViewResponse(
        String uuid,
        String name,
        double latitude,
        double longitude,

        String cityId,
        LocalDateTime dateTime,
        int maxCapacity,
        List<EventTypeResponse> eventType,
        List<StudentListResponse> students
) {

    public static EventViewResponse of(Event e, List<Student> students){
        return new EventViewResponse(
                e.getId().toString(),
                e.getName(),
                e.getLatitude(),
                e.getLongitude(),
                e.getCity().getName(),
                e.getDateTime(),
                e.getMaxCapacity(),
                e.getEventTypes().stream().map(EventTypeResponse::of).toList(),
                students.stream().map(StudentListResponse::of).toList()
        );
    }

}
