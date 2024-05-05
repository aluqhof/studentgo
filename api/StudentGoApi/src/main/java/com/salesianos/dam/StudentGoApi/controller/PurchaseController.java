package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.dto.purchase.PurchaseOverviewResponse;
import com.salesianos.dam.StudentGoApi.dto.purchase.PurchaseDoneResponse;
import com.salesianos.dam.StudentGoApi.dto.purchase.PurchaseTicket;
import com.salesianos.dam.StudentGoApi.model.Purchase;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.service.PurchaseService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.List;

@RestController
@RequiredArgsConstructor
@Tag(name = "Purchase", description = "The purchase handler has different methods" +
        "to get information about them or even to create, edit or delete them.")
@RequestMapping("/purchase")
public class PurchaseController {

    private final PurchaseService purchaseService;

    @PostMapping("/{eventId}")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<PurchaseDoneResponse> buyTicketsForAnEvent(@AuthenticationPrincipal Student student,
                                                                     @PathVariable("eventId") String eventId){
        Purchase purchase = purchaseService.buyEventTicket(student, eventId);

        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(purchase.getUuid()).toUri();

        return ResponseEntity
                .created(createdURI)
                .body(PurchaseDoneResponse.of(purchase));
    }

    @GetMapping("/all-by-student")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<List<PurchaseOverviewResponse>> getAllPurchasesByStudent(@AuthenticationPrincipal Student student){
        return ResponseEntity.ok(purchaseService.findEventsPurchasedByUser(student).stream().map(PurchaseOverviewResponse::of).toList());
    }

    @GetMapping("/purchase-details/{id}")
    public ResponseEntity<PurchaseTicket> getPurchaseTicket(@PathVariable("id") String purchaseId){
        return ResponseEntity.ok(purchaseService.getPurchase(purchaseId));
    }
}
