package com.salesianos.dam.StudentGoApi.dto.user;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;

import java.util.List;

public record UpdateProfileRequest (
        @NotBlank(message = "{updateProfileRequest.name.notblank}")
        @Size(min = 3, message = "{updateProfileRequest.name.min}")
        @Size(max = 30, message = "{updateProfileRequest.name.max}")
        String name,

        @NotBlank(message = "{updateProfileRequest.description.notblank}")
        @Size(max = 250, message = "{updateProfileRequest.description.size}")
        String description,
        @Size(min = 1, message = "{updateProfileRequest.interests.minSize}")
        @NotEmpty(message = "{updateProfileRequest.interests.notempty}")
        List<Long> interests
){
}
