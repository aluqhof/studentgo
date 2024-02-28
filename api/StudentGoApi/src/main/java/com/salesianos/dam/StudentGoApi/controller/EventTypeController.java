package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.dto.eventType.EventTypeResponse;
import com.salesianos.dam.StudentGoApi.service.EventTypeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@Tag(name = "Event type", description = "The event type handler has different methods" +
        "to get information about them or even to create, edit or delete them.")
@RequestMapping("/event-type")
public class EventTypeController {

    private final EventTypeService eventTypeService;


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

}
