package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.MyPage;
import com.salesianos.dam.StudentGoApi.dto.event.*;
import com.salesianos.dam.StudentGoApi.dto.file.response.FileResponse;
import com.salesianos.dam.StudentGoApi.dto.user.student.StudentListResponse;
import com.salesianos.dam.StudentGoApi.exception.ImageNotFoundException;
import com.salesianos.dam.StudentGoApi.exception.NotFoundException;
import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.Organizer;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.model.UserDefault;
import com.salesianos.dam.StudentGoApi.repository.EventRepository;
import com.salesianos.dam.StudentGoApi.service.EventService;
import com.salesianos.dam.StudentGoApi.service.StorageService;
import com.salesianos.dam.StudentGoApi.utils.MediaTypeUrlResource;
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
import org.springframework.core.io.Resource;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.*;

@RestController
@RequiredArgsConstructor
@Tag(name = "Event", description = "The event handler has different methods" +
        "to get information about them or even to create, edit or delete them.")
@RequestMapping("/event")
public class EventController {

    private final EventService eventService;
    private final EventRepository eventRepository;
    private final StorageService storageService;

    @Operation(summary = "Add an event (Only Organizer)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201 Created", description = "The event was created successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = EventViewResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "uuid": "66fa27d2-e956-4428-b533-07938267c551",
                                        "name": "Fiesta casera",
                                        "latitude": 80.0,
                                        "longitude": -5.0,
                                        "cityId": "Sevilla",
                                        "dateTime": "2024-06-28T12:30:00",
                                        "maxCapacity": 100,
                                        "eventType": [
                                            {
                                                "id": 4,
                                                "name": "Gaming",
                                                "iconRef": "0xe5e8",
                                                "colorCode": "0xff46cdfb"
                                            }
                                        ],
                                        "students": []
                                    }
                                                                        """)})}),
            @ApiResponse(responseCode = "400 Bad Request", description = "The creation was not successful", content = @Content),
            @ApiResponse(responseCode = "404 Not Found", description = "The entity provided does not exist", content = @Content),
    })
    @PostMapping("/")
    @PreAuthorize("hasRole('ORGANIZER')")
    public ResponseEntity<EventViewResponse> createEvent(
            @RequestPart("addEventRequest") String addEventRequest,
            @RequestPart("files") MultipartFile[] files,
            @AuthenticationPrincipal UserDefault user) {

        Event newEvent = eventService.createEvent(addEventRequest, files, user);

        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(newEvent.getId()).toUri();

        return ResponseEntity
                .created(createdURI)
                .body(EventViewResponse.of(newEvent, eventRepository.findStudentsByEventIdNoPageable(newEvent.getId())));
    }

    @Operation(summary = "Add an event (Only Admin)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201 Created", description = "The event was created successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = EventViewResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "uuid": "66fa27d2-e956-4428-b533-07938267c551",
                                        "name": "Fiesta casera",
                                        "latitude": 80.0,
                                        "longitude": -5.0,
                                        "cityId": "Sevilla",
                                        "dateTime": "2024-06-28T12:30:00",
                                        "maxCapacity": 100,
                                        "eventType": [
                                            {
                                                "id": 4,
                                                "name": "Gaming",
                                                "iconRef": "0xe5e8",
                                                "colorCode": "0xff46cdfb"
                                            }
                                        ],
                                        "students": []
                                    }
                                                                        """)})}),
            @ApiResponse(responseCode = "400 Bad Request", description = "The creation was not successful", content = @Content),
            @ApiResponse(responseCode = "404 Not Found", description = "The entity provided does not exist", content = @Content),
    })
    @PostMapping("/admin")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<EventViewResponse> createEventAdmin(
            @RequestPart("addEventRequest") String addEventRequest,
            @RequestPart("files") MultipartFile[] files) {

        Event newEvent = eventService.createEventAdmin(addEventRequest, files);

        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(newEvent.getId()).toUri();

        return ResponseEntity
                .created(createdURI)
                .body(EventViewResponse.of(newEvent, eventRepository.findStudentsByEventIdNoPageable(newEvent.getId())));
    }

    @Operation(summary = "Get all events in a city")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = EventViewResponse[].class)), examples = {
                            @ExampleObject(value = """
                                    [
                                         {
                                             "uuid": "f13a8a04-afe2-4b12-a279-91b3e365073b",
                                             "name": "Degustación en grupo",
                                             "latitude": 37.3824023,
                                             "longitude": -5.99631554987113,
                                             "cityId": "Köln",
                                             "dateTime": "2024-06-19T08:00:00",
                                             "maxCapacity": 200,
                                             "eventType": [
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
                                                 }
                                             ],
                                             "students": [
                                                 {
                                                     "id": "26e350e2-e2d7-40a8-bb8d-3e2d31e5a907",
                                                     "username": "student4",
                                                     "name": "Student 4",
                                                     "userPhoto": "nophoto.png"
                                                 },
                                                 {
                                                     "id": "dc98d909-98fd-44da-8944-f2e84ecb1695",
                                                     "username": "student7",
                                                     "name": "Student 7",
                                                     "userPhoto": "nophoto.png"
                                                 },
                                                 {
                                                     "id": "f3d074a8-d100-4b2f-ad93-ab0da39617c5",
                                                     "username": "student3",
                                                     "name": "Student 3",
                                                     "userPhoto": "nophoto.png"
                                                 }
                                             ]
                                         },
                                         {
                                             "uuid": "a2f6b827-1042-4a7c-a9c3-84f1356d10c4",
                                             "name": "Festival de música indie",
                                             "latitude": 50.976048,
                                             "longitude": 7.015457,
                                             "cityId": "Köln",
                                             "dateTime": "2024-06-20T18:00:00",
                                             "maxCapacity": 250,
                                             "eventType": [
                                                 {
                                                     "id": 3,
                                                     "name": "Food",
                                                     "iconRef": "0xe533",
                                                     "colorCode": "0xff29d697"
                                                 }
                                             ],
                                             "students": [
                                                 {
                                                     "id": "4847d54e-f0aa-49b8-bc3e-428bc4d990b8",
                                                     "username": "student11",
                                                     "name": "Student 11",
                                                     "userPhoto": "nophoto.png"
                                                 }
                                             ]
                                         }
                                    ]
                                                                        """)})}),
            @ApiResponse(responseCode = "400 Bad Request", description = "The search params are not corrects", content = @Content),
            @ApiResponse(responseCode = "404 Not Found", description = "The city provided does not exist", content = @Content),
    })
    @GetMapping("/upcoming/{cityName}")
    public ResponseEntity<List<EventViewResponse>> getEventsByCity(@PathVariable String cityName, @RequestParam(value = "eventName", required = false) String eventName,
                                                                   @RequestParam(value = "eventTypes", required = false) List<Long> eventTypeIds,
                                                                   @RequestParam(value = "start", required = false) String startDate,
                                                                   @RequestParam(value = "end", required = false) String endDate,
                                                                   @RequestParam(value = "min", required = false) Double minPrice,
                                                                   @RequestParam(value = "max", required = false) Double maxPrice
    ) {
        return ResponseEntity.ok(eventService.getAllUpcomingEventsInCity(cityName, eventName, eventTypeIds, startDate, endDate, minPrice, maxPrice).stream().map(event -> EventViewResponse.of(event, eventRepository.findStudentsByEventIdNoPageable(event.getId()))).toList());
    }

    @Operation(summary = "Get future events by organizer searchable")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MyPage.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                         "name": "Future Organizer Events",
                                         "content": [
                                             {
                                                 "uuid": "62feb988-886b-44ad-ac0b-43acd928a7c3",
                                                 "name": "Torneo de fifa por parejas",
                                                 "latitude": 37.386207,
                                                 "longitude": -5.99255572619863,
                                                 "cityId": "Sevilla",
                                                 "dateTime": "2024-06-22T08:00:00",
                                                 "maxCapacity": 150,
                                                 "eventType": [
                                                     {
                                                         "id": 4,
                                                         "name": "Gaming",
                                                         "iconRef": "0xe5e8",
                                                         "colorCode": "0xff46cdfb"
                                                     }
                                                 ],
                                                 "students": [
                                                     {
                                                         "id": "4e50fd4f-8982-4f9d-bc92-cba499a51a69",
                                                         "username": "student5",
                                                         "name": "Student 5",
                                                         "userPhoto": "nophoto.png"
                                                     },
                                                     {
                                                         "id": "ad7242d7-11db-4e72-ac96-f668eb1147bb",
                                                         "username": "student6",
                                                         "name": "Student 6",
                                                         "userPhoto": "nophoto.png"
                                                     }
                                                 ]
                                             },
                                             {
                                                 "uuid": "ae56ec32-98bf-4eb6-821d-741a0816b3bf",
                                                 "name": "Concierto de la niña pastori",
                                                 "latitude": 37.386207,
                                                 "longitude": -5.99255572619863,
                                                 "cityId": "Köln",
                                                 "dateTime": "2024-06-26T08:00:00",
                                                 "maxCapacity": 200,
                                                 "eventType": [
                                                     {
                                                         "id": 4,
                                                         "name": "Gaming",
                                                         "iconRef": "0xe5e8",
                                                         "colorCode": "0xff46cdfb"
                                                     }
                                                 ],
                                                 "students": [
                                                     {
                                                         "id": "04d0595e-45d5-4f63-8b53-1d79e9d84a5d",
                                                         "username": "student1",
                                                         "name": "Student 1",
                                                         "userPhoto": "nophoto.png"
                                                     },
                                                     {
                                                         "id": "23b9773b-b123-4f48-8a6d-ef732806d1f5",
                                                         "username": "student8",
                                                         "name": "Student 8",
                                                         "userPhoto": "nophoto.png"
                                                     },
                                                     {
                                                         "id": "dc98d909-98fd-44da-8944-f2e84ecb1695",
                                                         "username": "student7",
                                                         "name": "Student 7",
                                                         "userPhoto": "nophoto.png"
                                                     }
                                                 ]
                                             },
                                             {
                                                 "uuid": "2ab0b875-0b9c-4cd6-aa1c-de2dc561e2d0",
                                                 "name": "Torneo de futbol",
                                                 "latitude": 50.936688,
                                                 "longitude": 6.960099,
                                                 "cityId": "Köln",
                                                 "dateTime": "2024-06-28T15:00:00",
                                                 "maxCapacity": 500,
                                                 "eventType": [
                                                     {
                                                         "id": 4,
                                                         "name": "Gaming",
                                                         "iconRef": "0xe5e8",
                                                         "colorCode": "0xff46cdfb"
                                                     }
                                                 ],
                                                 "students": [
                                                     {
                                                         "id": "5ab9f5d1-6295-43bc-838c-16dd4dd6dfe7",
                                                         "username": "student9",
                                                         "name": "Student 9",
                                                         "userPhoto": "nophoto.png"
                                                     },
                                                     {
                                                         "id": "f3d074a8-d100-4b2f-ad93-ab0da39617c5",
                                                         "username": "student3",
                                                         "name": "Student 3",
                                                         "userPhoto": "nophoto.png"
                                                     }
                                                 ]
                                             }
                                         ],
                                         "size": 10,
                                         "totalElements": 3,
                                         "pageNumber": 0,
                                         "first": true,
                                         "last": true
                                     }
                                                                        """)})}),
    })
    @GetMapping("/organizer")
    @PreAuthorize("hasRole('ORGANIZER')")
    public MyPage<EventViewResponse> getEventsByOrganizer(@AuthenticationPrincipal Organizer organizer, @PageableDefault(size = 10, page = 0) Pageable pageable, @RequestParam(value = "term", required = false) String term
    ) {
        return eventService.getEventsByOrganizer(organizer, pageable, term);
    }

    @Operation(summary = "Get past events by organizer")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MyPage.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                         "name": "Past Organizer Events",
                                         "content": [
                                             {
                                                 "uuid": "9d782609-1b54-4cee-ad3d-5ce678be376d",
                                                 "name": "Torneo de Fútbol 7",
                                                 "latitude": 37.38283,
                                                 "longitude": -5.97317,
                                                 "cityId": "Sevilla",
                                                 "dateTime": "2024-05-22T08:00:00",
                                                 "maxCapacity": 0,
                                                 "eventType": [
                                                     {
                                                         "id": 1,
                                                         "name": "Sports",
                                                         "iconRef": "0xe5e6",
                                                         "colorCode": "0xfff0635a"
                                                     }
                                                 ],
                                                 "students": [
                                                     {
                                                         "id": "04d0595e-45d5-4f63-8b53-1d79e9d84a5d",
                                                         "username": "student1",
                                                         "name": "Student 1",
                                                         "userPhoto": "nophoto.png"
                                                     },
                                                     {
                                                         "id": "ad7242d7-11db-4e72-ac96-f668eb1147bb",
                                                         "username": "student6",
                                                         "name": "Student 6",
                                                         "userPhoto": "nophoto.png"
                                                     },
                                                     {
                                                         "id": "e010f144-b376-4dbb-933d-b3ec8332ed0d",
                                                         "username": "student2",
                                                         "name": "Student 2",
                                                         "userPhoto": "nophoto.png"
                                                     }
                                                 ]
                                             }
                                         ],
                                         "size": 10,
                                         "totalElements": 1,
                                         "pageNumber": 0,
                                         "first": true,
                                         "last": true
                                     }
                                                                        """)})}),
    })
    @PreAuthorize("hasRole('ORGANIZER')")
    @GetMapping("/past/organizer")
    public MyPage<EventViewResponse> getEventsByOrganizerPast(@AuthenticationPrincipal Organizer organizer, @PageableDefault(size = 10, page = 0) Pageable pageable, @RequestParam(value = "term", required = false) String term
    ) {
        return eventService.getPastEventsByOrganizer(organizer, pageable, term);
    }

    @Operation(summary = "Get all events past (Only Admin)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MyPage.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                         "name": "Past Events",
                                         "content": [
                                             {
                                                 "uuid": "9d782609-1b54-4cee-ad3d-5ce678be376d",
                                                 "name": "Torneo de Fútbol 7",
                                                 "latitude": 37.38283,
                                                 "longitude": -5.97317,
                                                 "cityId": "Sevilla",
                                                 "dateTime": "2024-05-22T08:00:00",
                                                 "maxCapacity": 0,
                                                 "eventType": [
                                                     {
                                                         "id": 1,
                                                         "name": "Sports",
                                                         "iconRef": "0xe5e6",
                                                         "colorCode": "0xfff0635a"
                                                     }
                                                 ],
                                                 "students": [
                                                     {
                                                         "id": "04d0595e-45d5-4f63-8b53-1d79e9d84a5d",
                                                         "username": "student1",
                                                         "name": "Student 1",
                                                         "userPhoto": "nophoto.png"
                                                     },
                                                     {
                                                         "id": "ad7242d7-11db-4e72-ac96-f668eb1147bb",
                                                         "username": "student6",
                                                         "name": "Student 6",
                                                         "userPhoto": "nophoto.png"
                                                     },
                                                     {
                                                         "id": "e010f144-b376-4dbb-933d-b3ec8332ed0d",
                                                         "username": "student2",
                                                         "name": "Student 2",
                                                         "userPhoto": "nophoto.png"
                                                     }
                                                 ]
                                             }
                                         ],
                                         "size": 10,
                                         "totalElements": 1,
                                         "pageNumber": 0,
                                         "first": true,
                                         "last": true
                                     }
                                                                        """)})}),
    })
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/past")
    public MyPage<EventViewResponse> getEventsPast(@PageableDefault(size = 10, page = 0) Pageable pageable, @RequestParam(value = "term", required = false) String term
    ) {
        return eventService.getPastEvents(pageable, term);
    }

    @Operation(summary = "Get Pageable results from upcoming events in a city limited to 5")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MyPage.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "name": "Upcoming Events",
                                        "content": [
                                            {
                                                "uuid": "d5c3c5de-89d6-4c1f-b0c4-3e1f45d8d2a2",
                                                "name": "Exposición de arte contemporáneo",
                                                "latitude": 50.934741,
                                                "longitude": 6.97958,
                                                "cityId": "Köln",
                                                "dateTime": "2024-04-14T12:00:00",
                                                "eventType": [
                                                    {
                                                        "id": 3,
                                                        "name": "Food",
                                                        "iconRef": "0xe533",
                                                        "colorCode": "0xff29d697"
                                                    }
                                                ],
                                                "students": [
                                                    {
                                                        "id": "7f40a32b-344f-4928-9995-8f6d12c34694",
                                                        "username": "student10",
                                                        "name": "Student 10"
                                                    },
                                                    {
                                                        "id": "e010f144-b376-4dbb-933d-b3ec8332ed0d",
                                                        "username": "student2",
                                                        "name": "Student 2"
                                                    }
                                                ]
                                            },
                                            {
                                                "uuid": "ae56ec32-98bf-4eb6-821d-741a0816b3bf",
                                                "name": "Concierto de la niña pastori",
                                                "latitude": 37.386207,
                                                "longitude": -5.99255572619863,
                                                "cityId": "Köln",
                                                "dateTime": "2024-04-26T08:00:00",
                                                "eventType": [
                                                    {
                                                        "id": 4,
                                                        "name": "Gaming",
                                                        "iconRef": "0xe5e8",
                                                        "colorCode": "0xff46cdfb"
                                                    }
                                                ],
                                                "students": [
                                                    {
                                                        "id": "04d0595e-45d5-4f63-8b53-1d79e9d84a5d",
                                                        "username": "student1",
                                                        "name": "Student 1"
                                                    },
                                                    {
                                                        "id": "23b9773b-b123-4f48-8a6d-ef732806d1f5",
                                                        "username": "student8",
                                                        "name": "Student 8"
                                                    },
                                                    {
                                                        "id": "dc98d909-98fd-44da-8944-f2e84ecb1695",
                                                        "username": "student7",
                                                        "name": "Student 7"
                                                    }
                                                ]
                                            }
                                        ],
                                        "size": 5,
                                        "totalElements": 2,
                                        "pageNumber": 0,
                                        "first": true,
                                        "last": true
                                    }
                                                                        """)})}),
            @ApiResponse(responseCode = "404 Not Found", description = "The city provided does not exist", content = @Content),
    })
    @GetMapping("/upcoming-limit/{cityName}")
    public MyPage<EventViewResponse> getUpcomingEventsByCity(@PathVariable String cityName, @PageableDefault(size = 5, page = 0) Pageable pageable) {
        return eventService.getAllUpcomingEventsInCityPaged(cityName, pageable);
    }

    @Operation(summary = "Get Pageable results for all upcoming events")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MyPage.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "name": "Upcoming Events",
                                        "content": [
                                            {
                                                "uuid": "ae56ec32-98bf-4eb6-821d-741a0816b3bf",
                                                "name": "Concierto de la niña pastori",
                                                "latitude": 37.386207,
                                                "longitude": -5.99255572619863,
                                                "cityId": "Köln",
                                                "dateTime": "2024-06-26T08:00:00",
                                                "maxCapacity": 200,
                                                "eventType": [
                                                    {
                                                        "id": 4,
                                                        "name": "Gaming",
                                                        "iconRef": "0xe5e8",
                                                        "colorCode": "0xff46cdfb"
                                                    }
                                                ],
                                                "students": [
                                                    {
                                                        "id": "04d0595e-45d5-4f63-8b53-1d79e9d84a5d",
                                                        "username": "student1",
                                                        "name": "Student 1",
                                                        "userPhoto": "nophoto.png"
                                                    },
                                                    {
                                                        "id": "23b9773b-b123-4f48-8a6d-ef732806d1f5",
                                                        "username": "student8",
                                                        "name": "Student 8",
                                                        "userPhoto": "nophoto.png"
                                                    },
                                                    {
                                                        "id": "dc98d909-98fd-44da-8944-f2e84ecb1695",
                                                        "username": "student7",
                                                        "name": "Student 7",
                                                        "userPhoto": "nophoto.png"
                                                    }
                                                ]
                                            }
                                        ],
                                        "size": 10,
                                        "totalElements": 1,
                                        "pageNumber": 0,
                                        "first": true,
                                        "last": true
                                    }
                                                                        """)})})
    })
    @GetMapping("/upcoming")
    @PreAuthorize("hasRole('ADMIN')")
    public MyPage<EventViewResponse> getUpcomingEvents(@PageableDefault(size = 10, page = 0) Pageable pageable, @RequestParam(value = "term", required = false) String term) {
        return eventService.getAllUpcomingEventsPaged(pageable, term);
    }

    @Operation(summary = "Get Pageable results from recommended events in a city limited based on user interests")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MyPage.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                         "name": "According to you",
                                         "result": [
                                             {
                                                 "uuid": "a2f6b827-1042-4a7c-a9c3-84f1356d10c4",
                                                 "name": "Festival de música indie",
                                                 "latitude": 37.386207,
                                                 "longitude": -5.99255572619863,
                                                 "cityId": "Köln",
                                                 "description": "Algo guapo",
                                                 "dateTime": "2024-03-02T18:00:00",
                                                 "organizer": "5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2",
                                                 "eventTypes": [
                                                     "Food"
                                                 ]
                                             },
                                             {
                                                 "uuid": "d5c3c5de-89d6-4c1f-b0c4-3e1f45d8d2a2",
                                                 "name": "Exposición de arte contemporáneo",
                                                 "latitude": 37.38283,
                                                 "longitude": -5.97317,
                                                 "cityId": "Köln",
                                                 "description": "Algo guapo",
                                                 "dateTime": "2024-03-01T12:00:00",
                                                 "organizer": "5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2",
                                                 "eventTypes": [
                                                     "Food"
                                                 ]
                                             }
                                         ]
                                     }
                                                                        """)})}),
            @ApiResponse(responseCode = "404 Not Found", description = "The city provided does not exist", content = @Content),
    })
    @GetMapping("/according-limit/{cityName}")
    public MyPage<EventViewResponse> getUpcomingEventsByCityAccordingToUser(
            @PathVariable String cityName,
            @PageableDefault(size = 5, page = 0) Pageable pageable,
            @AuthenticationPrincipal Student student) {
        return eventService.getFutureEventsInCityAccordingToUser(cityName, student, pageable);
    }

    @Operation(summary = "Get Pageable results from events in a city filtered by event types")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MyPage.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "name": "Food",
                                        "content": [
                                            {
                                                "uuid": "d5c3c5de-89d6-4c1f-b0c4-3e1f45d8d2a2",
                                                "name": "Exposición de arte contemporáneo",
                                                "latitude": 50.934741,
                                                "longitude": 6.97958,
                                                "cityId": "Köln",
                                                "dateTime": "2024-06-14T12:00:00",
                                                "maxCapacity": 100,
                                                "eventType": [
                                                    {
                                                        "id": 3,
                                                        "name": "Food",
                                                        "iconRef": "0xe533",
                                                        "colorCode": "0xff29d697"
                                                    }
                                                ],
                                                "students": [
                                                    {
                                                        "id": "7f40a32b-344f-4928-9995-8f6d12c34694",
                                                        "username": "student10",
                                                        "name": "Student 10",
                                                        "userPhoto": "nophoto.png"
                                                    },
                                                    {
                                                        "id": "e010f144-b376-4dbb-933d-b3ec8332ed0d",
                                                        "username": "student2",
                                                        "name": "Student 2",
                                                        "userPhoto": "nophoto.png"
                                                    }
                                                ]
                                            },
                                            {
                                                "uuid": "a2f6b827-1042-4a7c-a9c3-84f1356d10c4",
                                                "name": "Festival de música indie",
                                                "latitude": 50.976048,
                                                "longitude": 7.015457,
                                                "cityId": "Köln",
                                                "dateTime": "2024-06-20T18:00:00",
                                                "maxCapacity": 250,
                                                "eventType": [
                                                    {
                                                        "id": 3,
                                                        "name": "Food",
                                                        "iconRef": "0xe533",
                                                        "colorCode": "0xff29d697"
                                                    }
                                                ],
                                                "students": [
                                                    {
                                                        "id": "4847d54e-f0aa-49b8-bc3e-428bc4d990b8",
                                                        "username": "student11",
                                                        "name": "Student 11",
                                                        "userPhoto": "nophoto.png"
                                                    }
                                                ]
                                            }
                                        ],
                                        "size": 10,
                                        "totalElements": 2,
                                        "pageNumber": 0,
                                        "first": true,
                                        "last": true
                                    }
                                                                        """)})}),
            @ApiResponse(responseCode = "404 Not Found", description = "The entity provided does not exist", content = @Content),
    })
    @GetMapping("/by-event-type/{cityName}/{eventTypeId}")
    public MyPage<EventViewResponse> getEventsByEventType(
            @PathVariable String cityName,
            @PathVariable Long eventTypeId,
            @PageableDefault(size = 10, page = 0) Pageable pageable) {
        return eventService.getFutureEventsByEventType(cityName, pageable, eventTypeId);
    }

    @Operation(summary = "Get Pageable results from students who participate at the event")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MyPage.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "name": "Students in Exposición de arte contemporáneo",
                                        "content": [
                                            {
                                                "id": "7f40a32b-344f-4928-9995-8f6d12c34694",
                                                "username": "student10",
                                                "name": "student10"
                                            },
                                            {
                                                "id": "e010f144-b376-4dbb-933d-b3ec8332ed0d",
                                                "username": "student2",
                                                "name": "student2"
                                            }
                                        ],
                                        "size": 10,
                                        "totalElements": 2,
                                        "pageNumber": 0,
                                        "first": true,
                                        "last": true
                                    }
                                                                        """)})}),
            @ApiResponse(responseCode = "404 Not Found", description = "The event provided does not exist", content = @Content),
    })
    @GetMapping("/{eventId}/students")
    public MyPage<StudentListResponse> getStudentsByEvent(
            @PathVariable UUID eventId,
            @PageableDefault(size = 10, page = 0) Pageable pageable) {
        return eventService.getStudentsByEvent(eventId, pageable);
    }


    @Operation(summary = "Get the details of event")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The event details were provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = EventDetailsResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                         "uuid": "d5c3c5de-89d6-4c1f-b0c4-3e1f45d8d2a2",
                                         "name": "Exposición de arte contemporáneo",
                                         "latitude": 50.934741,
                                         "longitude": 6.97958,
                                         "description": "Algo guapo",
                                         "cityId": "Köln",
                                         "price": 20.5,
                                         "place": "Estadio guapo",
                                         "dateTime": "2024-06-14T12:00:00",
                                         "organizer": {
                                             "id": "5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2",
                                             "name": "Organizer 1",
                                             "username": "organizer1"
                                         },
                                         "eventType": [
                                             "Food"
                                         ],
                                         "students": [
                                             {
                                                 "id": "7f40a32b-344f-4928-9995-8f6d12c34694",
                                                 "username": "student10",
                                                 "name": "Student 10",
                                                 "userPhoto": "nophoto.png"
                                             },
                                             {
                                                 "id": "e010f144-b376-4dbb-933d-b3ec8332ed0d",
                                                 "username": "student2",
                                                 "name": "Student 2",
                                                 "userPhoto": "nophoto.png"
                                             }
                                         ],
                                         "urlPhotos": [
                                             "nophotoevent.jpg"
                                         ],
                                         "maxCapacity": 100
                                     }
                                                                        """)})}),
            @ApiResponse(responseCode = "404 Not Found", description = "The event provided does not exist", content = @Content),
    })
    @GetMapping("/details/{eventId}")
    public ResponseEntity<EventDetailsResponse> getEventDetails(
            @PathVariable UUID eventId) {
        return ResponseEntity.ok(eventService.getEventById(eventId));
    }

    @Operation(summary = "Deletes an event photo")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204 No Content", description = "The image was deleted successful"),
            @ApiResponse(responseCode = "404 Not Found", description = "The image provided does not exist", content = @Content),
    })
    @GetMapping("/delete-photo/{id}/number/{index}")
    @PreAuthorize("hasAnyRole('ORGANIZER', 'ADMIN')")
    public ResponseEntity<?> deletePhoto(@PathVariable("id") String eventId, @PathVariable("index") int index) {

        Event event = eventRepository.findById(UUID.fromString(eventId))
                .orElseThrow(() -> new NotFoundException("Event"));

        List<String> eventPhotos = new ArrayList<>(event.getUrlPhotos());

        if (index >= 0 && index < eventPhotos.size()) {
            eventPhotos.remove(index);

            if (eventPhotos.isEmpty()) {
                event.setUrlPhotos(new ArrayList<>(Collections.singletonList("nophotoevent.jpg")));
            } else {
                event.setUrlPhotos(new ArrayList<>(eventPhotos));
            }

            eventRepository.save(event);

            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @Operation(summary = "Add photos for a event (Admin or Organizer)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201 Created", description = "The images were uploaded successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = FileResponse.class)), examples = {
                            @ExampleObject(value = """
                                    [{
                                        "name": "logo-navbar-blue_596356.png",
                                        "uri": "http://localhost:8080/download/logo-navbar-blue_596356.png",
                                        "type": "image/png",
                                        "size": 9306
                                    }]
                                                                        """)})}),
            @ApiResponse(responseCode = "400 Bad Request", description = "The upload was not successfully", content = @Content),
    })
    @PostMapping("/upload/event-photos/{idEvent}")
    @PreAuthorize("hasAnyRole('ORGANIZER', 'ADMIN')")
    public ResponseEntity<?> upload(@RequestPart("files") MultipartFile[] files, @PathVariable("idEvent") String idEvent) {

        List<FileResponse> result = Arrays.stream(files)
                .map(this::uploadFile)
                .toList();
        Event event = eventRepository.findById(UUID.fromString(idEvent)).orElseThrow(() -> new NotFoundException("Event"));

        List<String> eventPhotos = event.getUrlPhotos();
        if (eventPhotos == null) {
            eventPhotos = new ArrayList<>(); // Use ArrayList for modifiability
        }

        for (MultipartFile file : files) {
            String filename = file.getOriginalFilename();
            if (filename != null && !filename.isBlank()) {
                eventPhotos.add(filename);
            }
        }

        event.setUrlPhotos(eventPhotos);

        eventRepository.save(event);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(result);
    }

    private FileResponse uploadFile(MultipartFile file) {
        String name = storageService.store(file);
        String uri = ServletUriComponentsBuilder.fromCurrentContextPath()
                .path("/download/")
                .path(name)
                .toUriString();

        return FileResponse.builder()
                .name(name)
                .size(file.getSize())
                .type(file.getContentType())
                .uri(uri)
                .build();
    }

    @Operation(summary = "Download a photo from a specific event")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The image was downloaded successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MediaTypeUrlResource.class)))}),
            @ApiResponse(responseCode = "404 Not Found", description = "The image was not found", content = @Content),
    })
    @GetMapping("/download-event-photo/{idEvent}/number/{index}")
    public ResponseEntity<Resource> getFile(@PathVariable("idEvent") String eventId, @PathVariable("index") int number) {

        Event event = eventRepository.findById(UUID.fromString(eventId)).orElseThrow(() -> new NotFoundException("Event"));

        String imageUrl;
        List<String> urlPhotos = event.getUrlPhotos() == null ? new ArrayList<>() : event.getUrlPhotos();

        if (number < 0 || number >= urlPhotos.size()) {
            throw new ImageNotFoundException("Image not found for index: " + number);
        }

        if (urlPhotos.get(number).isBlank()) {
            throw new ImageNotFoundException("Image URL is blank at index: " + number);
        }

        imageUrl = urlPhotos.get(number);

        MediaTypeUrlResource resource =
                (MediaTypeUrlResource) storageService.loadAsResource(imageUrl);

        return ResponseEntity.status(HttpStatus.OK)
                .header("Content-Type", resource.getType())
                .body(resource);
    }

    @Operation(summary = "Edit an event (Only Organizer)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The event was edited successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = EventDetailsResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "uuid": "f13a8a04-afe2-4b12-a279-91b3e365073b",
                                        "name": "Fiesta casera",
                                        "latitude": 80.0,
                                        "longitude": -5.0,
                                        "description": "Va a ser una pasaada autentica",
                                        "cityId": "Sevilla",
                                        "price": 10.0,
                                        "place": "Estadio guapo",
                                        "dateTime": "2024-06-28T12:30:00",
                                        "organizer": {
                                            "id": "5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2",
                                            "name": "Organizer 1",
                                            "username": "organizer1"
                                        },
                                        "eventType": [
                                            "Gaming"
                                        ],
                                        "students": [
                                            {
                                                "id": "26e350e2-e2d7-40a8-bb8d-3e2d31e5a907",
                                                "username": "student4",
                                                "name": "Student 4",
                                                "userPhoto": "nophoto.png"
                                            },
                                            {
                                                "id": "dc98d909-98fd-44da-8944-f2e84ecb1695",
                                                "username": "student7",
                                                "name": "Student 7",
                                                "userPhoto": "nophoto.png"
                                            },
                                            {
                                                "id": "f3d074a8-d100-4b2f-ad93-ab0da39617c5",
                                                "username": "student3",
                                                "name": "Student 3",
                                                "userPhoto": "nophoto.png"
                                            }
                                        ],
                                        "urlPhotos": [
                                            "nophotoevent.jpg"
                                        ],
                                        "maxCapacity": 200
                                    }
                                                                        """)})}),
            @ApiResponse(responseCode = "400 Bad Request", description = "The edition was not successful", content = @Content),
            @ApiResponse(responseCode = "404 Not Found", description = "The entity provided does not exist", content = @Content),
    })
    @PutMapping("/edit-organizer/{id}")
    @PreAuthorize("hasRole('ORGANIZER')")
    public EventDetailsResponse editEvent(@PathVariable("id") String id, @RequestBody @Valid EditEventOrganizerRequest edit) {
        return eventService.editEventOrganizer(id, edit);
    }

    @Operation(summary = "Edit an event (Only Admin)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The event was edited successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = EventDetailsResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "uuid": "f13a8a04-afe2-4b12-a279-91b3e365073b",
                                        "name": "Fiesta casera",
                                        "latitude": 80.0,
                                        "longitude": -5.0,
                                        "description": "Va a ser una pasaada autentica",
                                        "cityId": "Sevilla",
                                        "price": 10.0,
                                        "place": "Estadio guapo",
                                        "dateTime": "2024-06-28T12:30:00",
                                        "organizer": {
                                            "id": "5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2",
                                            "name": "Organizer 1",
                                            "username": "organizer1"
                                        },
                                        "eventType": [
                                            "Gaming"
                                        ],
                                        "students": [
                                            {
                                                "id": "26e350e2-e2d7-40a8-bb8d-3e2d31e5a907",
                                                "username": "student4",
                                                "name": "Student 4",
                                                "userPhoto": "nophoto.png"
                                            },
                                            {
                                                "id": "dc98d909-98fd-44da-8944-f2e84ecb1695",
                                                "username": "student7",
                                                "name": "Student 7",
                                                "userPhoto": "nophoto.png"
                                            },
                                            {
                                                "id": "f3d074a8-d100-4b2f-ad93-ab0da39617c5",
                                                "username": "student3",
                                                "name": "Student 3",
                                                "userPhoto": "nophoto.png"
                                            }
                                        ],
                                        "urlPhotos": [
                                            "nophotoevent.jpg"
                                        ],
                                        "maxCapacity": 200
                                    }
                                                                        """)})}),
            @ApiResponse(responseCode = "400 Bad Request", description = "The edition was not successful", content = @Content),
            @ApiResponse(responseCode = "404 Not Found", description = "The entity provided does not exist", content = @Content),
    })
    @PutMapping("/edit-admin/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public EventDetailsResponse editEventAdmin(@PathVariable("id") String id, @RequestBody @Valid EditEventRequestAdmin edit) {
        return eventService.editEventAdmin(id, edit);
    }

    @Operation(summary = "Search event by id or name")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MyPage.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "name": "Events",
                                        "content": [
                                            {
                                                "uuid": "9d782609-1b54-4cee-ad3d-5ce678be376d",
                                                "name": "Torneo de Fútbol 7",
                                                "latitude": 37.38283,
                                                "longitude": -5.97317,
                                                "cityId": "Sevilla",
                                                "dateTime": "2024-05-22T08:00:00"
                                            }
                                        ],
                                        "size": 5,
                                        "totalElements": 1,
                                        "pageNumber": 0,
                                        "first": true,
                                        "last": true
                                    }
                                                                        """)})}),
    })
    @GetMapping("/search")
    public MyPage<EventShortResponse> searchByIdOrName(@RequestParam(value = "term", required = false) String term, @PageableDefault(size = 5, page = 0) Pageable pageable) {
        return eventService.getEventByIdOrName(term, pageable);
    }
}
