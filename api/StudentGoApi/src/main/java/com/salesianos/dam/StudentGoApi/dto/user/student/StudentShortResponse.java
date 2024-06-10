package com.salesianos.dam.StudentGoApi.dto.user.student;

import com.salesianos.dam.StudentGoApi.model.Student;

public record StudentShortResponse(
        String id,
        String username,
        String name
) {
    public static StudentShortResponse of(Student s){
        return new StudentShortResponse(
                s.getId().toString(),
                s.getUsername(),
                s.getName()
        );
    }
}
