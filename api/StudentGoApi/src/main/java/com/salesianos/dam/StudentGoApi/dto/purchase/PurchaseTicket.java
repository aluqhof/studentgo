package com.salesianos.dam.StudentGoApi.dto.purchase;

import com.salesianos.dam.StudentGoApi.dto.eventType.EventTypeResponse;
import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.Purchase;
import com.salesianos.dam.StudentGoApi.model.Student;

import java.time.LocalDateTime;
import java.util.List;

public record PurchaseTicket(
        String id,
        String eventName,
        double latitude,
        double longitude,
        LocalDateTime eventDate,
        List<EventTypeResponse> eventType,
        double price,
        String participant,
        String qrCode
) {

    public static PurchaseTicket of(Purchase p, Student student){
        return new PurchaseTicket(
                p.getUuid().toString(),
                p.getEvent().getName(),
                p.getEvent().getLatitude(),
                p.getEvent().getLongitude(),
                p.getEvent().getDateTime(),
                p.getEvent().getEventTypes().stream().map(EventTypeResponse::of).toList(),
                p.getTotalPrice(),
                student.getName(),
                p.getQrCode()
        );
    }
}
