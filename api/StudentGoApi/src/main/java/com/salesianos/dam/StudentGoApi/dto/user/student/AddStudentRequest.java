package com.salesianos.dam.StudentGoApi.dto.user.student;

import com.salesianos.dam.StudentGoApi.validation.annotation.FieldsValueMatch;
import com.salesianos.dam.StudentGoApi.validation.annotation.UniqueEmail;
import com.salesianos.dam.StudentGoApi.validation.annotation.UniqueUsername;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@FieldsValueMatch(
        field = "password", fieldMatch = "verifyPassword",
        message = "{addStudentRequest.password.nomatch}"
)
public record AddStudentRequest(
        @NotBlank(message = "{addStudentRequest.username.notblank}")
        @UniqueUsername
        String username,

        @NotBlank(message = "{addStudentRequest.password.notblank}")
        @Size(min = 6, message = "{addStudentRequest.password.size}")
        String password,

        @NotBlank(message = "{addStudentRequest.verifyPassword.notblank}")
        String verifyPassword,

        @NotBlank(message = "{addStudentRequest.email.notblank}")
        @Email(message = "{addStudentRequest.email.email}")
        @UniqueEmail
        String email,

        @NotBlank(message = "{addStudentRequest.name.notblank}")
        String name
) {
}