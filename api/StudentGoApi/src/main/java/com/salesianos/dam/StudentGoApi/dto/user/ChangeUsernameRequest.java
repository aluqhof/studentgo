package com.salesianos.dam.StudentGoApi.dto.user;

import com.salesianos.dam.StudentGoApi.validation.annotation.UniqueUsername;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record ChangeUsernameRequest(
        @NotBlank(message = "{changeUsernameRequest.username.notblank}")
        @UniqueUsername
        @Size(min = 3, message = "{changeUsernameRequest.username.min}")
        @Size(max = 20, message = "{changeUsernameRequest.username.max}")
        String username
) {
}
