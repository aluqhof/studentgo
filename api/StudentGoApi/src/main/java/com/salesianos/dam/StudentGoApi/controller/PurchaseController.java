package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.MyPage;
import com.salesianos.dam.StudentGoApi.dto.event.EventDetailsResponse;
import com.salesianos.dam.StudentGoApi.dto.event.EventViewResponse;
import com.salesianos.dam.StudentGoApi.dto.purchase.*;
import com.salesianos.dam.StudentGoApi.model.Purchase;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.model.UserDefault;
import com.salesianos.dam.StudentGoApi.service.PurchaseService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
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

    @Operation(summary = "Buy a ticket for an event (Only Student)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201 Created", description = "The ticket was purchased successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = PurchaseDoneResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "id": "4b7f16d5-fb10-4c82-ae9c-c247cf827d2d",
                                        "dateTime": "2024-06-12T15:18:11.7196313",
                                        "totalPrice": 20.5,
                                        "eventId": "f13a8a04-afe2-4b12-a279-91b3e365073b",
                                        "author": "04d0595e-45d5-4f63-8b53-1d79e9d84a5d"
                                    }
                                                                        """)})}),
            @ApiResponse(responseCode = "400 Bad Request", description = "Error in the purchase process", content = @Content),
            @ApiResponse(responseCode = "404 Not Found", description = "The event provided does not exist", content = @Content),
    })
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

    @Operation(summary = "Get all purchases by student (Only Student)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = PurchaseOverviewResponse[].class)), examples = {
                            @ExampleObject(value = """
                                    [
                                         {
                                             "purchaseId": "4b7f16d5-fb10-4c82-ae9c-c247cf827d2d",
                                             "eventId": "f13a8a04-afe2-4b12-a279-91b3e365073b",
                                             "name": "Degustación en grupo",
                                             "latitude": 37.3824023,
                                             "longitude": -5.99631554987113,
                                             "cityId": "Sevilla",
                                             "dateTime": "2024-06-19T08:00:00",
                                             "eventType": [
                                                 {
                                                     "id": 3,
                                                     "name": "Food",
                                                     "iconRef": "0xe533",
                                                     "colorCode": "0xff29d697"
                                                 },
                                                 {
                                                     "id": 2,
                                                     "name": "Music",
                                                     "iconRef": "0xe415",
                                                     "colorCode": "0xfff59762"
                                                 }
                                             ],
                                             "urlPhotos": [
                                                 "nophotoevent.jpg"
                                             ]
                                         },
                                         {
                                             "purchaseId": "d23e4567-e89b-12d3-a456-426614174012",
                                             "eventId": "ae56ec32-98bf-4eb6-821d-741a0816b3bf",
                                             "name": "Concierto de la niña pastori",
                                             "latitude": 37.386207,
                                             "longitude": -5.99255572619863,
                                             "cityId": "Köln",
                                             "dateTime": "2024-06-26T08:00:00",
                                             "eventType": [
                                                 {
                                                     "id": 4,
                                                     "name": "Gaming",
                                                     "iconRef": "0xe5e8",
                                                     "colorCode": "0xff46cdfb"
                                                 }
                                             ],
                                             "urlPhotos": [
                                                 "nophotoevent.jpg"
                                             ]
                                         }
                                     ]
                                                                        """)})}),
    })
    @GetMapping("/all-by-student")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<List<PurchaseOverviewResponse>> getAllPurchasesByStudent(@AuthenticationPrincipal Student student){
        return ResponseEntity.ok(purchaseService.findEventsPurchasedByUser(student).stream().map(PurchaseOverviewResponse::of).toList());
    }

    @Operation(summary = "Gets the ticket of a purchase including an unique QR code")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The purchase details were provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = PurchaseTicket.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "id": "4b7f16d5-fb10-4c82-ae9c-c247cf827d2d",
                                        "eventName": "Degustación en grupo",
                                        "latitude": 37.3824023,
                                        "longitude": -5.99631554987113,
                                        "eventDate": "2024-06-19T08:00:00",
                                        "eventType": [
                                            {
                                                "id": 3,
                                                "name": "Food",
                                                "iconRef": "0xe533",
                                                "colorCode": "0xff29d697"
                                            },
                                            {
                                                "id": 2,
                                                "name": "Music",
                                                "iconRef": "0xe415",
                                                "colorCode": "0xfff59762"
                                            }
                                        ],
                                        "price": 20.5,
                                        "participant": "Student 1",
                                        "qrCode": "iVBORw0KGgoAAAANSUhEUgAAAMgAAADIAQAAAACFI5MzAAABeklEQVR4Xu2WQW6EMAxFjbrIkiPkJnAxJJC42PQmOQLLLNC4/wc6pKXdfloJS4xi3iys2P8b89/Cvr94xU1uwvgbJJnZm+fOhpitnZC1aoJnTrlfLFrXzu5POUFFzG1gNifgKwjzKdp+uoJ44Mmac20K4ryT8GjXiNacOycgnNGUMRz8OU2vgGzBi9nL2nIhQW2oKLz7asGXIeIkJu444mJoF5xRdEpNcJx9dwqINfd8KSW5Wca0O0U5vWoTkYTb+XSKHv2xnn+Xktz4GotT+AN6qWoTEQRaQ6cw48aoZ1RDWNHIQS1OwfToj4q4T8YrMsOs0DPUpFRUdIoC4RlHbTLCTVV0yqL80KmMlP6EJ36g2IG+qSaZ32/QBtZVh41VV60hJdLmD2hNCrVOJQQ7C/6AxbVSrDOtS03wFH+Y+O3iV5BtVyLHxaDO2q+VZNvbfFnrVEr2vW1fVaIhzm9Y7O2RisXy1hPjjFKnXJ1TrBQsIj/HTW7C+J/kA9uhp4LI+6yuAAAAAElFTkSuQmCC"
                                    }
                                                                        """)})}),
            @ApiResponse(responseCode = "404 Not Found", description = "The purchase provided does not exist", content = @Content),
    })
    @GetMapping("/purchase-details/{id}")
    public ResponseEntity<PurchaseTicket> getPurchaseTicket(@PathVariable("id") String purchaseId){
        return ResponseEntity.ok(purchaseService.getPurchase(purchaseId));
    }

    @Operation(summary = "Retrieves a list from purchases (Admin or Organizer)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MyPage.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "name": "Purchases",
                                        "content": [
                                            {
                                                "purchaseId": "f23e4567-e89b-12d3-a456-426614174016",
                                                "eventId": "62feb988-886b-44ad-ac0b-43acd928a7c3",
                                                "eventName": "Torneo de fifa por parejas",
                                                "city": "Sevilla",
                                                "dateTime": "2024-06-12T15:15:27.436887",
                                                "student": {
                                                    "id": "4e50fd4f-8982-4f9d-bc92-cba499a51a69",
                                                    "username": "student5",
                                                    "name": "Student 5"
                                                }
                                            },
                                            {
                                                "purchaseId": "f23e4567-e89b-12d3-a456-426614174015",
                                                "eventId": "39ff97ef-c4e2-4980-92a7-9d67b4d03749",
                                                "eventName": "Feria de artesanía",
                                                "city": "Köln",
                                                "dateTime": "2024-06-12T15:15:27.432523",
                                                "student": {
                                                    "id": "26e350e2-e2d7-40a8-bb8d-3e2d31e5a907",
                                                    "username": "student4",
                                                    "name": "Student 4"
                                                }
                                            },
                                            {
                                                "purchaseId": "f23e4567-e89b-12d3-a456-426614174014",
                                                "eventId": "2ab0b875-0b9c-4cd6-aa1c-de2dc561e2d0",
                                                "eventName": "Torneo de futbol",
                                                "city": "Köln",
                                                "dateTime": "2024-06-12T15:15:27.42925",
                                                "student": {
                                                    "id": "f3d074a8-d100-4b2f-ad93-ab0da39617c5",
                                                    "username": "student3",
                                                    "name": "Student 3"
                                                }
                                            },
                                            {
                                                "purchaseId": "e23e4567-e89b-12d3-a456-426614174013",
                                                "eventId": "d5c3c5de-89d6-4c1f-b0c4-3e1f45d8d2a2",
                                                "eventName": "Exposición de arte contemporáneo",
                                                "city": "Köln",
                                                "dateTime": "2024-06-12T15:15:27.425593",
                                                "student": {
                                                    "id": "e010f144-b376-4dbb-933d-b3ec8332ed0d",
                                                    "username": "student2",
                                                    "name": "Student 2"
                                                }
                                            },
                                            {
                                                "purchaseId": "d23e4567-e89b-12d3-a456-426614174012",
                                                "eventId": "ae56ec32-98bf-4eb6-821d-741a0816b3bf",
                                                "eventName": "Concierto de la niña pastori",
                                                "city": "Köln",
                                                "dateTime": "2024-06-12T15:15:27.421059",
                                                "student": {
                                                    "id": "04d0595e-45d5-4f63-8b53-1d79e9d84a5d",
                                                    "username": "student1",
                                                    "name": "Student 1"
                                                }
                                            },
                                            {
                                                "purchaseId": "c23e4567-e89b-12d3-a456-426614174011",
                                                "eventId": "9b3ee893-9181-47b8-91fc-63dd16c74f50",
                                                "eventName": "Conferencia sobre inteligencia artificial",
                                                "city": "Köln",
                                                "dateTime": "2024-06-12T15:15:27.417306",
                                                "student": {
                                                    "id": "934feb89-6380-4ae1-ab35-cdb38979f864",
                                                    "username": "student12",
                                                    "name": "Student 12"
                                                }
                                            }
                                        ],
                                        "size": 10,
                                        "totalElements": 21,
                                        "pageNumber": 0,
                                        "first": true,
                                        "last": false
                                    }
                                                                        """)})}),
    })
    @GetMapping("/all")
    @PreAuthorize("hasAnyRole('ORGANIZER', 'ADMIN')")
    public MyPage<PurchaseItemResponse> getAllPurchases(@AuthenticationPrincipal UserDefault user, @PageableDefault(size = 10, page = 0) Pageable pageable, @RequestParam(value = "term", required = false) String term){
        return purchaseService.findAllPurchases(pageable, user, term);
    }

    @Operation(summary = "Gets the details of a purchase")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The purchase details were provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = PurchaseDetailResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                         "purchaseId": "123e4567-e89b-12d3-a456-426614174000",
                                         "event": {
                                             "uuid": "9d782609-1b54-4cee-ad3d-5ce678be376d",
                                             "name": "Torneo de Fútbol 7",
                                             "latitude": 37.38283,
                                             "longitude": -5.97317,
                                             "cityId": "Sevilla",
                                             "dateTime": "2024-05-22T08:00:00"
                                         },
                                         "price": 20.0,
                                         "dateTime": "2024-06-12T15:15:27.387316",
                                         "student": {
                                             "id": "04d0595e-45d5-4f63-8b53-1d79e9d84a5d",
                                             "username": "student1",
                                             "name": "Student 1"
                                         }
                                     }
                                                                        """)})}),
            @ApiResponse(responseCode = "404 Not Found", description = "The purchase provided does not exist", content = @Content),
    })
    @GetMapping("/details/{id}")
    @PreAuthorize("hasAnyRole('ORGANIZER', 'ADMIN')")
    public ResponseEntity<PurchaseDetailResponse> getPurchaseDetails(@PathVariable("id") String id){
        return ResponseEntity.ok(purchaseService.getPurchaseById(id));
    }

    @Operation(summary = "Add a purchase (Only Admin)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201 Created", description = "The purchase was created successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = PurchaseDoneResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "id": "4f9e4529-09eb-4693-ad38-2b42ffe0708c",
                                        "dateTime": "2024-06-12T16:07:56.0678841",
                                        "totalPrice": 1.0,
                                        "eventId": "9d782609-1b54-4cee-ad3d-5ce678be376d",
                                        "author": "e010f144-b376-4dbb-933d-b3ec8332ed0d"
                                    }
                                                                        """)})}),
            @ApiResponse(responseCode = "400 Bad Request", description = "The creation was not successful", content = @Content),
            @ApiResponse(responseCode = "404 Not Found", description = "The entity provided does not exist", content = @Content),
    })
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

    @Operation(summary = "Edit a purchase (Only Admin)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The purchase was edited successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = PurchaseDoneResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "id": "4f9e4529-09eb-4693-ad38-2b42ffe0708c",
                                        "dateTime": "2024-06-12T16:07:56.067884",
                                        "totalPrice": 21.0,
                                        "eventId": "9d782609-1b54-4cee-ad3d-5ce678be376d",
                                        "author": "e010f144-b376-4dbb-933d-b3ec8332ed0d"
                                    }
                                                                        """)})}),
            @ApiResponse(responseCode = "400 Bad Request", description = "The edit was not successful", content = @Content),
            @ApiResponse(responseCode = "404 Not Found", description = "The entity provided does not exist", content = @Content),
    })
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public PurchaseDoneResponse editPurchase(@PathVariable("id") String purchaseId, @RequestBody @Valid PurchaseRequest purchaseRequest){
        return PurchaseDoneResponse.of(purchaseService.editPurchase(purchaseId, purchaseRequest));
    }

}
