package com.salesianos.dam.StudentGoApi.dto.user.organizer;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record OrganizerRequest(
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
        String business
) {
}
