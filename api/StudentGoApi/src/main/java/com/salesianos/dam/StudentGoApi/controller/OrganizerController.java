package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.MyPage;
import com.salesianos.dam.StudentGoApi.dto.eventType.EventTypeResponse;
import com.salesianos.dam.StudentGoApi.dto.user.organizer.OrganizerDetailsResponse;
import com.salesianos.dam.StudentGoApi.dto.user.organizer.OrganizerItemResponse;
import com.salesianos.dam.StudentGoApi.dto.user.organizer.OrganizerRequest;
import com.salesianos.dam.StudentGoApi.dto.user.organizer.OrganizerShortResponse;
import com.salesianos.dam.StudentGoApi.dto.user.student.StudentShortResponse;
import com.salesianos.dam.StudentGoApi.service.user.OrganizerService;
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
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@Tag(name = "Organizer", description = "The organizer controller has different methods to obtain various information " +
        "about the organizer, such as methods for create, edit....")
@RequestMapping("/organizer")
public class OrganizerController {

    private final OrganizerService organizerService;

    @Operation(summary = "Get all organizers (Only Admin)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MyPage.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "name": "Organizers",
                                        "content": [
                                            {
                                                "id": "5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2",
                                                "username": "organizer1",
                                                "email": "organizer1@organizer.com",
                                                "name": "Organizer 1",
                                                "userPhoto": "nophoto.png",
                                                "created": "2024-06-12T15:04:18.737207",
                                                "business": "Nike"
                                            }
                                        ],
                                        "size": 10,
                                        "totalElements": 1,
                                        "pageNumber": 0,
                                        "first": true,
                                        "last": true
                                    }
                                                                      """) }) }),
    })
    @GetMapping("/all")
    @PreAuthorize("hasRole('ADMIN')")
    public MyPage<OrganizerItemResponse> getAllOrganizers(@PageableDefault(size = 10, page = 0) Pageable pageable, @RequestParam(value = "term", required = false) String term){
        return organizerService.getAll(pageable, term);
    }

    @Operation(summary = "Retrieves an organizer")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The organizer was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = OrganizerDetailsResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "id": "5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2",
                                        "username": "organizer1",
                                        "email": "organizer1@organizer.com",
                                        "name": "Organizer 1",
                                        "userPhoto": "nophoto.png",
                                        "created": "2024-06-12T15:04:18.737207",
                                        "business": "Nike",
                                        "description": "Soy un empresario exitoso"
                                    }
                                                                        """) }) }),
            @ApiResponse(responseCode = "404 Not Found", description = "The organizer provided does not exist", content = @Content),
    })
    @GetMapping("/{id}")
    public ResponseEntity<OrganizerDetailsResponse> getOrganizerById(@PathVariable("id") String id){
        return ResponseEntity.ok(OrganizerDetailsResponse.of(organizerService.getOrganizer(id)));
    }

    @Operation(summary = "Edits an organizer (Only Admin)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The organizer was edited successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = OrganizerDetailsResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "id": "5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2",
                                        "username": "alex.luque",
                                        "email": "pepe@gmail.com",
                                        "name": "Alex Luque",
                                        "userPhoto": "nophoto.png",
                                        "created": "2024-06-12T15:04:18.737207",
                                        "business": "Nike",
                                        "description": "Es el mejor estudiante del mundo"
                                    }
                                                                        """) }) }),
            @ApiResponse(responseCode = "400 Bad Request", description = "The payload provided is not correct", content = @Content),
            @ApiResponse(responseCode = "404 Not Found", description = "The organizer provided was not found", content = @Content),
    })
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public OrganizerDetailsResponse editOrganizer(@PathVariable("id") String id, @RequestBody @Valid OrganizerRequest organizerRequest){
        return OrganizerDetailsResponse.of(organizerService.editOrganizer(id, organizerRequest));
    }

    @Operation(summary = "Search organizer by username")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MyPage.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "name": "Organizers",
                                        "content": [
                                            {
                                                "id": "5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2",
                                                "name": "Alex Luque",
                                                "username": "alex.luque"
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
    public MyPage<OrganizerShortResponse> searchByUsername(@RequestParam(value = "term", required = false) String term, @PageableDefault(size = 5, page = 0) Pageable pageable){
        return organizerService.findByUsername(term, pageable);
    }
}
