package com.salesianos.dam.StudentGoApi.dto.event;

import com.salesianos.dam.StudentGoApi.validation.annotation.ValidCoordinates;
import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;

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

        @Future(message = "{addEventRequest.dateTime.future}")
        LocalDateTime dateTime,

        @NotEmpty(message = "{addEventRequest.eventTypeIds.notempty}")
        List<Long> eventTypesIds
) {
}
