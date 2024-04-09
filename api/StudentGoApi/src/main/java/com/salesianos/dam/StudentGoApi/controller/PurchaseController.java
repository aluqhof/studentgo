package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.dto.event.EventOverviewResponse;
import com.salesianos.dam.StudentGoApi.dto.event.EventViewResponse;
import com.salesianos.dam.StudentGoApi.dto.purchase.BuyTickets;
import com.salesianos.dam.StudentGoApi.dto.purchase.PurchaseDoneResponse;
import com.salesianos.dam.StudentGoApi.model.Purchase;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.service.PurchaseService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.jetbrains.annotations.NotNull;
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

    @PostMapping("/")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<PurchaseDoneResponse> buyTicketsForAnEvent(@AuthenticationPrincipal Student student,
                                                                     @RequestBody @NotNull /*VALIDAR*/ BuyTickets buyTickets){
        Purchase purchase = purchaseService.buyEventTicket(student, buyTickets.eventId(), buyTickets.numberOfTickets());

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
    public ResponseEntity<List<EventOverviewResponse>> getAllEventsPurchaseByStudent(@AuthenticationPrincipal Student student){
        return ResponseEntity.ok(purchaseService.findEventsPurchasedByUser(student).stream().map(EventOverviewResponse::of).toList());
    }
}
