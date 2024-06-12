package com.salesianos.dam.StudentGoApi.dto.event;

import com.salesianos.dam.StudentGoApi.dto.user.organizer.OrganizerShortResponse;
import com.salesianos.dam.StudentGoApi.dto.user.student.StudentListResponse;
import com.salesianos.dam.StudentGoApi.model.*;
import com.salesianos.dam.StudentGoApi.repository.EventRepository;

import java.time.LocalDateTime;
import java.util.List;

public record EventDetailsResponse (
        String uuid,
        String name,
        double latitude,
        double longitude,
        String description,

        String cityId,
        double price,
        String place,
        LocalDateTime dateTime,
        OrganizerShortResponse organizer,
        List<String> eventType,
        List<StudentListResponse> students,

        List<String> urlPhotos,
        int maxCapacity
){
    public static EventDetailsResponse of(Event e, List<Student> students, Organizer organizer){
        return new EventDetailsResponse(
                e.getId().toString(),
                e.getName(),
                e.getLatitude(),
                e.getLongitude(),
                e.getDescription(),
                e.getCity().getName(),
                e.getPrice(),
                e.getPlace(),
                e.getDateTime(),
                OrganizerShortResponse.of(organizer),
                e.getEventTypes().stream().map(EventType::getName).toList(),
                students.stream().map(StudentListResponse::of).toList(),
                e.getUrlPhotos(),
                e.getMaxCapacity()
        );
    }
}
