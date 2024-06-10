package com.salesianos.dam.StudentGoApi.dto.user.student;

import com.salesianos.dam.StudentGoApi.dto.event.EventShortResponse;
import com.salesianos.dam.StudentGoApi.dto.eventType.EventTypeResponse;
import com.salesianos.dam.StudentGoApi.model.Student;

import java.time.LocalDateTime;
import java.util.List;

public record StudentItemResponse(
        String id,
        String username,
        String email,
        String name,
        String description,
        String userPhoto,
        LocalDateTime created,
        List<EventTypeResponse> interests
) {

    public static  StudentItemResponse of(Student student){
        return new StudentItemResponse(
                student.getId().toString(),
                student.getUsername(),
                student.getEmail(),
                student.getName(),
                student.getDescription(),
                student.getUrlPhoto(),
                student.getCreatedAt(),
                student.getInterests().stream().map(EventTypeResponse::of).toList()
        );
    }
}