package com.salesianos.dam.StudentGoApi.dto.user.student;

import com.salesianos.dam.StudentGoApi.dto.event.EventShortResponse;
import com.salesianos.dam.StudentGoApi.dto.event.EventViewResponse;
import com.salesianos.dam.StudentGoApi.dto.eventType.EventTypeResponse;
import com.salesianos.dam.StudentGoApi.model.Student;

import java.util.List;

public record StudentInfoResponse(
        String id,
        String username,
        String name,
        String description,
        String userPhoto,
        List<EventTypeResponse> interests,
        List<EventShortResponse> events
) {

    public static  StudentInfoResponse of(Student student){
        return new StudentInfoResponse(
                student.getId().toString(),
                student.getUsername(),
                student.getName(),
                student.getDescription(),
                student.getUrlPhoto(),
                student.getInterests().stream().map(EventTypeResponse::of).toList(),
                student.getSaved().stream().map(EventShortResponse::of).toList()
        );
    }
}
