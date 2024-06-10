package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.MyPage;
import com.salesianos.dam.StudentGoApi.dto.purchase.*;
import com.salesianos.dam.StudentGoApi.model.Purchase;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.service.PurchaseService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.query.Param;
import org.springframework.data.web.PageableDefault;
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

    @GetMapping("/all")
    @PreAuthorize("hasRole('ADMIN')")
    public MyPage<PurchaseItemResponse> getAllPurchases(@PageableDefault(size = 10, page = 0) Pageable pageable){
        return purchaseService.findAllPurchases(pageable);
    }

    @GetMapping("/details/{id}")
    @PreAuthorize("hasAnyRole('ORGANIZER', 'ADMIN')")
    public ResponseEntity<PurchaseDetailResponse> getPurchaseDetails(@PathVariable("id") String id){
        return ResponseEntity.ok(purchaseService.getPurchaseById(id));
    }

    @PostMapping("/create")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<PurchaseDoneResponse> makePurchase(@RequestBody @Valid PurchaseRequest purchaseRequest){
        Purchase purchase = purchaseService.makePurchase(purchaseRequest);

        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(purchase.getUuid()).toUri();

        return ResponseEntity
                .created(createdURI)
                .body(PurchaseDoneResponse.of(purchase));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public PurchaseDoneResponse editPurchase(@PathVariable("id") String purchaseId, @RequestBody @Valid PurchaseRequest purchaseRequest){
        return PurchaseDoneResponse.of(purchaseService.editPurchase(purchaseId, purchaseRequest));
    }

}
