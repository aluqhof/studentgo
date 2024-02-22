package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.dto.event.AddEventRequest;
import com.salesianos.dam.StudentGoApi.dto.event.EventResponse;
import com.salesianos.dam.StudentGoApi.dto.event.ListEventsResponse;
import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.Organizer;
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
            @ApiResponse(responseCode = "404 Not Found", description = "The entity provided does not exist", content = @Content),
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

    @Operation(summary = "Get all events in a city")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = EventResponse.class)), examples = {
                            @ExampleObject(value = """
                                    [
                                        {
                                            "uuid": "9d782609-1b54-4cee-ad3d-5ce678be376d",
                                            "name": "Torneo de Fútbol 7",
                                            "latitude": -5.97317,
                                            "longitude": 37.38283,
                                            "cityId": "Sevilla",
                                            "description": "Algo guapo",
                                            "dateTime": "2024-02-22T15:18:47.830396",
                                            "organizer": "5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2",
                                            "eventTypes": [
                                                "Sports"
                                            ]
                                        },
                                        {
                                            "uuid": "f13a8a04-afe2-4b12-a279-91b3e365073b",
                                            "name": "Degustación en grupo",
                                            "latitude": -5.99631554987113,
                                            "longitude": 37.3824023,
                                            "cityId": "Sevilla",
                                            "description": "Algo guapo",
                                            "dateTime": "2024-02-22T15:18:47.832156",
                                            "organizer": "5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2",
                                            "eventTypes": [
                                                "Food",
                                                "Music"
                                            ]
                                        },
                                        {
                                            "uuid": "62feb988-886b-44ad-ac0b-43acd928a7c3",
                                            "name": "Torneo de fifa por parejas",
                                            "latitude": -5.99255572619863,
                                            "longitude": 37.386207,
                                            "cityId": "Sevilla",
                                            "description": "Algo guapo",
                                            "dateTime": "2024-02-22T15:18:47.833622",
                                            "organizer": "5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2",
                                            "eventTypes": [
                                                "Gaming"
                                            ]
                                        }
                                    ]
                                                                        """) }) }),
            @ApiResponse(responseCode = "404 Not Found", description = "The entity provided does not exist", content = @Content),
    })
    @GetMapping("/{cityId}")
    //Preautorize
    public ResponseEntity<List<EventResponse>> getEventsByCity(@PathVariable Long cityId){
        return ResponseEntity.ok(eventService.getAllEventsInCity(cityId).stream().map(EventResponse::of).toList());
    }

    @Operation(summary = "Get all upcoming events in a city")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = ListEventsResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "name": "Upcoming Events",
                                        "result": [
                                            {
                                                "uuid": "ae56ec32-98bf-4eb6-821d-741a0816b3bf",
                                                "name": "Concierto de la niña pastori",
                                                "latitude": -5.99255572619863,
                                                "longitude": 37.386207,
                                                "cityId": "Köln",
                                                "description": "Algo guapo",
                                                "dateTime": "2024-02-26T08:00:00",
                                                "organizer": "5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2",
                                                "eventTypes": []
                                            }
                                        ]
                                    }
                                                                        """) }) }),
            @ApiResponse(responseCode = "404 Not Found", description = "The entity provided does not exist", content = @Content),
    })
    @GetMapping("/upcoming/{cityName}")
    public ResponseEntity<ListEventsResponse> getUpcomingEventsByCity(@PathVariable String cityName){
        return ResponseEntity.ok(ListEventsResponse.of(eventService.getFutureEventsInCity(cityName), "Upcoming Events"));
    }

    @Operation(summary = "Get all upcoming events in a city limited")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = ListEventsResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "name": "Upcoming Events",
                                        "result": [
                                            {
                                                "uuid": "ae56ec32-98bf-4eb6-821d-741a0816b3bf",
                                                "name": "Concierto de la niña pastori",
                                                "latitude": -5.99255572619863,
                                                "longitude": 37.386207,
                                                "cityId": "Köln",
                                                "description": "Algo guapo",
                                                "dateTime": "2024-02-26T08:00:00",
                                                "organizer": "5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2",
                                                "eventTypes": [
                                                    "Gaming"
                                                ]
                                            },
                                            {
                                                "uuid": "39ff97ef-c4e2-4980-92a7-9d67b4d03749",
                                                "name": "Feria de artesanía",
                                                "latitude": -5.99631554987113,
                                                "longitude": 37.3824023,
                                                "cityId": "Köln",
                                                "description": "Algo guapo",
                                                "dateTime": "2024-02-27T10:00:00",
                                                "organizer": "5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2",
                                                "eventTypes": [
                                                    "Gaming"
                                                ]
                                            }
                                        ]
                                    }
                                                                        """) }) }),
            @ApiResponse(responseCode = "404 Not Found", description = "The entity provided does not exist", content = @Content),
    })
    @GetMapping("/upcoming-limit/{cityName}")
    public ResponseEntity<ListEventsResponse> getUpcomingEventsByCityLimit5(@PathVariable String cityName, @RequestParam(defaultValue = "5") int limit){
        return ResponseEntity.ok(ListEventsResponse.of(eventService.getFutureEventsInCityLimit5(cityName, limit), "Upcoming Events"));
    }
}
