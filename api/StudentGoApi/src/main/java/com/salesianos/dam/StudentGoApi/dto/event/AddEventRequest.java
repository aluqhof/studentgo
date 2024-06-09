package com.salesianos.dam.StudentGoApi.dto.event;

import com.salesianos.dam.StudentGoApi.validation.annotation.ValidCoordinates;
import jakarta.validation.constraints.*;

import java.time.LocalDateTime;
import java.util.List;

public record AddEventRequest(
        @NotBlank(message = "{addEventRequest.name.notblank}")
        String name,

        @ValidCoordinates
        double latitude,
        @ValidCoordinates
        double longitude,
        @NotBlank(message = "{addEventRequest.description.notblank}")
        String description,

        @Pattern(regexp = "^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}$", message = "{editEventRequest.dateTime.pattern}")
        String dateTime,

        @NotNull(message = "{addEventRequest.cityId.notnull}")
        String cityId,

        @NotEmpty(message = "{addEventRequest.eventTypeIds.notempty}")
        List<String> eventTypesIds,

        @NotNull(message = "{addEventRequest.maxCapacity.notnull}")
        @Min(value = 0, message = "{addEventRequest.maxCapacity.min}")
        int maxCapacity,

        @DecimalMin(value = "0.0", inclusive = true, message = "{editEventRequest.price.min}")
        @DecimalMax(value = "1000.0", inclusive = true, message = "{editEventRequest.price.max}")
        Double price
) {
}
