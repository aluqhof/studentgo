package com.salesianos.dam.StudentGoApi.dto.purchase;

import com.salesianos.dam.StudentGoApi.model.Purchase;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

public record PurchaseRequest(

        @NotNull(message = "{purchaseRequest.eventId.notnull}")
        @Pattern(regexp = "[a-f0-9]{8}-[a-f0-9]{4}-[1-5][a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}",
                message = "{purchaseRequest.eventId.pattern}")
        String eventId,

        @NotNull(message = "{purchaseRequest.studentId.notnull}")
        @Pattern(regexp = "[a-f0-9]{8}-[a-f0-9]{4}-[1-5][a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}",
                message = "{purchaseRequest.eventId.pattern}")
        String studentId,

        @NotNull(message = "{purchaseRequest.price.notnull}")
        @Min(value = 0, message = "{purchaseRequest.price.min}")
        Double price
) {
}
