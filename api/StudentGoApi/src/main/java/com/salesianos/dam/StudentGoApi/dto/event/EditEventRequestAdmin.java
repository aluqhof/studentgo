package com.salesianos.dam.StudentGoApi.dto.event;

import jakarta.validation.constraints.*;

import java.util.List;

public record EditEventRequestAdmin(
        @Size(min = 3, max = 50, message = "{editEventRequest.name.size}")
        String name,

        @Pattern(regexp = "^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}$", message = "{editEventRequest.dateTime.pattern}")
        String dateTime,

        @Size(min = 10, max = 250, message = "{editEventRequest.description.size}")
        String description,

        @DecimalMin(value = "0.0", inclusive = true, message = "{editEventRequest.price.min}")
        @DecimalMax(value = "1000.0", inclusive = true, message = "{editEventRequest.price.max}")
        Double price,

        @Min(value = 0, message = "{editEventRequest.maxCapacity.min}")
        Integer maxCapacity,

        String cityId,

        @DecimalMin(value = "-90.0", inclusive = true, message = "{editEventRequest.latitude.min}")
        @DecimalMax(value = "90.0", inclusive = true, message = "{editEventRequest.latitude.max}")
        Double latitude,

        @DecimalMin(value = "-180.0", inclusive = true, message = "{editEventRequest.longitude.min}")
        @DecimalMax(value = "180.0", inclusive = true, message = "{editEventRequest.longitude.max}")
        Double longitude,

        @NotEmpty(message = "{editEventRequest.eventTypes.notempty}")
        List<String> eventTypes,
        @NotBlank(message = "{editEventRequest.author.notblank}")
        String author
) {
}
