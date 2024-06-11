package com.salesianos.dam.StudentGoApi.dto.eventType;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public record EventTypeRequest (
        @NotBlank(message = "{eventTypeRequest.name.notblank}")
        String name,

        @NotBlank(message = "{eventTypeRequest.iconRef.notblank}")
        @Pattern(regexp = "^0x[0-9A-Fa-f]{4}$", message = "{eventTypeRequest.iconRef.pattern}")
        String iconRef,

        @NotBlank(message = "{eventTypeRequest.colorCode.notblank}")
        @Pattern(regexp = "^0x[0-9A-Fa-f]{8}$", message = "{eventTypeRequest.colorCode.pattern}")
        String colorCode
) {
}
