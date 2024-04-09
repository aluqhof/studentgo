package com.salesianos.dam.StudentGoApi.dto.purchase;

import com.salesianos.dam.StudentGoApi.model.Purchase;

import java.time.LocalDateTime;

public record PurchaseDoneResponse (
        String id,
        LocalDateTime dateTime,
        int numberOfTickets,
        double totalPrice,
        String eventId,
        String author
) {
    public static PurchaseDoneResponse of(Purchase purchase){
        return new PurchaseDoneResponse(
                purchase.getUuid().toString(),
                purchase.getDateTime(),
                purchase.getNumberOfTickets(),
                purchase.getTotalPrice(),
                purchase.getEvent().getId().toString(),
                purchase.getAuthor()
        );
    }
}
