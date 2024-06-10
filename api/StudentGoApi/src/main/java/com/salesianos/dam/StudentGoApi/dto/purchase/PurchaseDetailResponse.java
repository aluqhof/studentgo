package com.salesianos.dam.StudentGoApi.dto.purchase;

import com.salesianos.dam.StudentGoApi.dto.event.EventShortResponse;
import com.salesianos.dam.StudentGoApi.dto.user.student.StudentShortResponse;
import com.salesianos.dam.StudentGoApi.model.Purchase;
import com.salesianos.dam.StudentGoApi.model.Student;

import java.time.LocalDateTime;

public record PurchaseDetailResponse(
        String purchaseId,
        EventShortResponse event,
        Double price,
        LocalDateTime dateTime,
        StudentShortResponse student

) {

    public static PurchaseDetailResponse of(Purchase p, Student s) {
        return new PurchaseDetailResponse(
                p.getUuid().toString(),
                EventShortResponse.of(p.getEvent()),
                p.getTotalPrice(),
                p.getDateTime(),
                StudentShortResponse.of(s)
        );
    }

}
