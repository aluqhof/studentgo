package com.salesianos.dam.StudentGoApi.dto.purchase;

import com.salesianos.dam.StudentGoApi.dto.user.student.StudentShortResponse;
import com.salesianos.dam.StudentGoApi.model.Purchase;
import com.salesianos.dam.StudentGoApi.model.Student;

import java.time.LocalDateTime;

public record PurchaseItemResponse(
            String purchaseId,
            String eventId,
            String eventName,
            String city,
            LocalDateTime dateTime,
            StudentShortResponse student

    ) {

        public static PurchaseItemResponse of(Purchase p, Student s) {
            return new PurchaseItemResponse(
                    p.getUuid().toString(),
                    p.getEvent().getId().toString(),
                    p.getEvent().getName(),
                    p.getEvent().getCity().getName(),
                    p.getDateTime(),
                    StudentShortResponse.of(s)
            );
        }
}
