package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.dto.event.AddEventRequest;
import com.salesianos.dam.StudentGoApi.dto.event.EventResponse;
import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.Organizer;
import com.salesianos.dam.StudentGoApi.security.jwt.JwtUserResponse;
import com.salesianos.dam.StudentGoApi.service.EventService;
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
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.List;

@RestController
@RequiredArgsConstructor
@Tag(name = "Event", description = "The event handler has different methods" +
        "to get information about them or even to create, edit or delete them.")
@RequestMapping("/event")
public class EventController {

    private final EventService eventService;

    @Operation(summary = "Add an event (Only Organizer)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201 Created", description = "The event was created succesful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = EventResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "uuid": "23e6942b-62d2-4a37-abf2-6b6d19d4532c",
                                        "name": "Fiesta casera",
                                        "latitude": -5.0,
                                        "longitude": 80.0,
                                        "description": "Va a ser una pasaada autentica",
                                        "dateTime": "2024-02-28T12:30:00",
                                        "organizer": "fd779f91-e193-4baa-92d8-4395af8d3b99",
                                        "eventTypes": [
                                            "Sports"
                                        ]
                                    }
                                                                        """) }) }),
            @ApiResponse(responseCode = "400 Bad Request", description = "The creation was not succesful", content = @Content),
    })
    @PostMapping("/")
    @PreAuthorize("hasRole('ORGANIZER')")
    public ResponseEntity<EventResponse> createEvent(@RequestBody @Valid AddEventRequest addEventRequest,@AuthenticationPrincipal Organizer organizer){
        Event newEvent = eventService.createEvent(addEventRequest, organizer);

        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(newEvent.getId()).toUri();

        return ResponseEntity
                .created(createdURI)
                .body(EventResponse.of(newEvent));
    }

    @GetMapping("/{city}")
    public ResponseEntity<List<EventResponse>> getEventsByCity(@PathVariable String city){

    }
}
