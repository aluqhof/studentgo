package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.dto.eventType.EventTypeRequest;
import com.salesianos.dam.StudentGoApi.dto.eventType.EventTypeResponse;
import com.salesianos.dam.StudentGoApi.exception.NotFoundException;
import com.salesianos.dam.StudentGoApi.model.EventType;
import com.salesianos.dam.StudentGoApi.repository.EventTypeRepository;
import com.salesianos.dam.StudentGoApi.service.EventTypeService;
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
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.List;

@RestController
@RequiredArgsConstructor
@Tag(name = "Event type", description = "The event type handler has different methods" +
        "to get information about them or even to create, edit or delete them.")
@RequestMapping("/event-type")
public class EventTypeController {

    private final EventTypeService eventTypeService;
    private final EventTypeRepository eventTypeRepository;


    @Operation(summary = "Get all event types")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided succesful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = EventTypeResponse.class)), examples = {
                            @ExampleObject(value = """
                                    [
                                        {
                                            "id": 1,
                                            "name": "Sports",
                                            "iconRef": "0xe5e6",
                                            "colorCode": "0xfff0635a"
                                        },
                                        {
                                            "id": 2,
                                            "name": "Music",
                                            "iconRef": "0xe415",
                                            "colorCode": "0xfff59762"
                                        },
                                        {
                                            "id": 3,
                                            "name": "Food",
                                            "iconRef": "0xe533",
                                            "colorCode": "0xff29d697"
                                        },
                                        {
                                            "id": 4,
                                            "name": "Gaming",
                                            "iconRef": "0xe5e8",
                                            "colorCode": "0xff46cdfb"
                                        }
                                    ]
                                                                        """) }) }),
    })
    @GetMapping("/")
    public ResponseEntity<List<EventTypeResponse>> getAllEventTypes(){
        return ResponseEntity.ok(eventTypeService.getAllEventTypes().stream().map(EventTypeResponse::of).toList());
    }

    @GetMapping("/{id}")
    public ResponseEntity<EventTypeResponse> getEventType(@PathVariable("id") Long id){
        return ResponseEntity.ok(EventTypeResponse.of(eventTypeService.getEventTypeById(id)));
    }

    @PostMapping("/")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<EventTypeResponse> createEventType(@RequestBody @Valid EventTypeRequest add){

        EventType eventType = eventTypeService.createEventType(add);

        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(eventType.getId()).toUri();

        return ResponseEntity.created(createdURI).body(EventTypeResponse.of(eventType));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public EventTypeResponse editEventType(@PathVariable("id") Long id, @RequestBody @Valid EventTypeRequest eventTypeRequest){
        return EventTypeResponse.of(eventTypeService.editEventType(id, eventTypeRequest));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteEventType(@PathVariable("id") Long id){
        eventTypeService.deleteEventType(id);
        return ResponseEntity.noContent().build();
    }
}
