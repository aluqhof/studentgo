package com.salesianos.dam.StudentGoApi.dto.purchase;

import com.salesianos.dam.StudentGoApi.dto.eventType.EventTypeResponse;
import com.salesianos.dam.StudentGoApi.model.Purchase;

import java.time.LocalDateTime;
import java.util.List;

public record PurchaseOverviewResponse(
        String purchaseId,
        String eventId,
        String name,
        double latitude,
        double longitude,

        String cityId,
        LocalDateTime dateTime,
        List<EventTypeResponse> eventType,
        List<String> urlPhotos
) {

    public static PurchaseOverviewResponse of(Purchase p) {
        return new PurchaseOverviewResponse(
                p.getUuid().toString(),
                p.getEvent().getId().toString(),
                p.getEvent().getName(),
                p.getEvent().getLatitude(),
                p.getEvent().getLongitude(),
                p.getEvent().getCity().getName(),
                p.getEvent().getDateTime(),
                p.getEvent().getEventTypes().stream().map(EventTypeResponse::of).toList(),
                p.getEvent().getUrlPhotos()
        );
    }
}
