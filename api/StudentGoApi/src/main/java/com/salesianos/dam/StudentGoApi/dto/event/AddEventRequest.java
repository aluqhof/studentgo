package com.salesianos.dam.StudentGoApi.dto.event;

import com.salesianos.dam.StudentGoApi.validation.annotation.ValidCoordinates;
import jakarta.validation.constraints.*;

import java.time.LocalDateTime;
import java.util.List;

//Repasarrrrrrr hay que agregarle más cosas
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

        @NotNull(message = "{addEventRequest.cityId.notnull}")
        Long cityId,

        @NotEmpty(message = "{addEventRequest.eventTypeIds.notempty}")
        List<Long> eventTypesIds,

        @NotNull(message = "{addEventRequest.maxCapacity.notnull}")
        @Min(value = 0, message = "{addEventRequest.maxCapacity.min}")
        int maxCapacity
) {
}
