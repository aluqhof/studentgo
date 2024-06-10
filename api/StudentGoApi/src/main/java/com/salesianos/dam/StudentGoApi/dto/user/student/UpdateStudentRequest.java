package com.salesianos.dam.StudentGoApi.dto.user.student;

import com.salesianos.dam.StudentGoApi.validation.annotation.UniqueEmail;
import com.salesianos.dam.StudentGoApi.validation.annotation.UniqueUsername;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;

import java.util.List;

public record UpdateStudentRequest(
        @NotBlank(message = "{changeUsernameRequest.username.notblank}")
        @Size(min = 3, message = "{changeUsernameRequest.username.min}")
        @Size(max = 20, message = "{changeUsernameRequest.username.max}")
        String username,

        @NotBlank(message = "{updateProfileRequest.name.notblank}")
        @Size(min = 3, message = "{updateProfileRequest.name.min}")
        @Size(max = 30, message = "{updateProfileRequest.name.max}")
        String name,
        @NotBlank(message = "{updateProfileRequest.description.notblank}")
        @Size(max = 250, message = "{updateProfileRequest.description.size}")
        String description,

        @Email(message = "{updateStudentRequest.email.emailFormat}")
        @NotBlank(message = "{updateStudentRequest.email.notblank}")
        String email,
        @Size(min = 1, message = "{updateProfileRequest.interests.minSize}")
        @NotEmpty(message = "{updateProfileRequest.interests.notempty}")
        List<String> eventTypes
) {
}
