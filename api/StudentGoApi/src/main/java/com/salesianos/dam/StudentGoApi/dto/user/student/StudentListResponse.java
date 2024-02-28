package com.salesianos.dam.StudentGoApi.dto.user.student;

import com.salesianos.dam.StudentGoApi.model.Student;

public record StudentListResponse(
        String id,
        String username,
        String name
){
    public static StudentListResponse of(Student student){
        return new StudentListResponse(
                student.getId().toString(),
                student.getUsername(),
                student.getName()
        );
    }
}
