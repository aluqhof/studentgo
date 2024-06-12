package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.MyPage;
import com.salesianos.dam.StudentGoApi.dto.event.EventDetailsResponse;
import com.salesianos.dam.StudentGoApi.dto.event.EventViewResponse;
import com.salesianos.dam.StudentGoApi.dto.event.EventsSavedResponse;
import com.salesianos.dam.StudentGoApi.dto.file.response.FileResponse;
import com.salesianos.dam.StudentGoApi.dto.user.student.StudentInfoResponse;
import com.salesianos.dam.StudentGoApi.dto.user.student.StudentItemResponse;
import com.salesianos.dam.StudentGoApi.dto.user.student.StudentShortResponse;
import com.salesianos.dam.StudentGoApi.dto.user.student.UpdateStudentRequest;
import com.salesianos.dam.StudentGoApi.model.City;
import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.service.user.StudentService;
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
import org.apache.catalina.connector.Response;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
@Tag(name = "Student", description = "The student controller has different methods to obtain various information " +
        "about the students, such as methods for create, edit....")
@RequestMapping("/student")
public class StudentController {

    private final StudentService studentService;

    @Operation(summary = "Get Student Info (student in session)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The information was provided successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = StudentInfoResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "id": "04d0595e-45d5-4f63-8b53-1d79e9d84a5d",
                                        "username": "student1",
                                        "name": "Student 1",
                                        "description": "Soy una persona extrovertida",
                                        "userPhoto": "nophoto.png",
                                        "interests": [
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
                                            }
                                        ],
                                        "events": [
                                            {
                                                "uuid": "d5c3c5de-89d6-4c1f-b0c4-3e1f45d8d2a2",
                                                "name": "Exposición de arte contemporáneo",
                                                "latitude": 50.934741,
                                                "longitude": 6.97958,
                                                "cityId": "Köln",
                                                "dateTime": "2024-06-14T12:00:00"
                                            },
                                            {
                                                "uuid": "a2f6b827-1042-4a7c-a9c3-84f1356d10c4",
                                                "name": "Festival de música indie",
                                                "latitude": 50.976048,
                                                "longitude": 7.015457,
                                                "cityId": "Köln",
                                                "dateTime": "2024-06-20T18:00:00"
                                            },
                                            {
                                                "uuid": "9b3ee893-9181-47b8-91fc-63dd16c74f50",
                                                "name": "Conferencia sobre inteligencia artificial",
                                                "latitude": 50.963941,
                                                "longitude": 6.955118,
                                                "cityId": "Köln",
                                                "dateTime": "2024-06-21T09:00:00"
                                            }
                                        ]
                                    }
                                                                        """)})}),
    })
    @GetMapping("/")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<StudentInfoResponse> getStudentInfo(@AuthenticationPrincipal Student student){
        return ResponseEntity.ok(StudentInfoResponse.of(studentService.getStudentInfo(student)));
    }

    @Operation(summary = "Save an event if it is not saved and vice versa (Only Student)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The Event was saved/unsaved successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = FileResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "name": "logo-navbar-blue_596356.png",
                                        "uri": "http://localhost:8080/download/logo-navbar-blue_596356.png",
                                        "type": "image/png",
                                        "size": 9306
                                    }
                                                                        """)})}),
            @ApiResponse(responseCode = "404 Not Found", description = "The event provided was not found", content = @Content),
    })
    @PutMapping("/save-unsave-event/{eventId}")
    @PreAuthorize("hasRole('USER')")
    public StudentInfoResponse saveOrUnsaveEvent(@AuthenticationPrincipal Student student, @PathVariable UUID eventId){
        return StudentInfoResponse.of(studentService.saveEvent(eventId, student));
    }

    @Operation(summary = "Retrieves a list of all saved events (Only Student)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The list was provided successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = EventViewResponse[].class)), examples = {
                            @ExampleObject(value = """
                                    [
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
                                             "students": []
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
                                             "students": []
                                         }
                                     ]
                                                                        """)})}),
    })
    @GetMapping("/saved-events")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<List<EventViewResponse>> getAllSavedEvents(@AuthenticationPrincipal Student student){
        return ResponseEntity.ok(studentService.getAllSavedEventsByStudent(student));
    }

    @Operation(summary = "Search students by username")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MyPage.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "name": "Students",
                                        "content": [
                                            {
                                                "id": "04d0595e-45d5-4f63-8b53-1d79e9d84a5d",
                                                "username": "student1",
                                                "name": "Student 1"
                                            },
                                            {
                                                "id": "7f40a32b-344f-4928-9995-8f6d12c34694",
                                                "username": "student10",
                                                "name": "Student 10"
                                            },
                                            {
                                                "id": "4847d54e-f0aa-49b8-bc3e-428bc4d990b8",
                                                "username": "student11",
                                                "name": "Student 11"
                                            },
                                            {
                                                "id": "934feb89-6380-4ae1-ab35-cdb38979f864",
                                                "username": "student12",
                                                "name": "Student 12"
                                            }
                                        ],
                                        "size": 5,
                                        "totalElements": 4,
                                        "pageNumber": 0,
                                        "first": true,
                                        "last": true
                                    }
                                                                        """)})}),
    })
    @GetMapping("/search")
    public MyPage<StudentShortResponse> searchByUsername(@RequestParam(value = "term", required = false) String term, @PageableDefault(size = 5, page = 0) Pageable pageable){
        return studentService.findByUsername(term, pageable);
    }

    @Operation(summary = "Get all students (Only Admin)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 Ok", description = "The list was provided successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MyPage.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                         "name": "Student",
                                         "content": [
                                             {
                                                 "id": "04d0595e-45d5-4f63-8b53-1d79e9d84a5d",
                                                 "username": "student1",
                                                 "email": "student1@student.com",
                                                 "name": "Student 1",
                                                 "description": "Soy una persona extrovertida",
                                                 "userPhoto": "nophoto.png",
                                                 "created": "2024-06-12T16:12:33.627842",
                                                 "interests": [
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
                                                     }
                                                 ]
                                             },
                                             {
                                                 "id": "7f40a32b-344f-4928-9995-8f6d12c34694",
                                                 "username": "student10",
                                                 "email": "student10@student.com",
                                                 "name": "Student 10",
                                                 "description": "Soy una persona introvertida",
                                                 "userPhoto": "nophoto.png",
                                                 "created": "2024-06-12T16:12:33.656127",
                                                 "interests": []
                                             },
                                             {
                                                 "id": "4847d54e-f0aa-49b8-bc3e-428bc4d990b8",
                                                 "username": "student11",
                                                 "email": "student11@student.com",
                                                 "name": "Student 11",
                                                 "description": "Soy una persona introvertida",
                                                 "userPhoto": "nophoto.png",
                                                 "created": "2024-06-12T16:12:33.658791",
                                                 "interests": []
                                             },
                                             {
                                                 "id": "934feb89-6380-4ae1-ab35-cdb38979f864",
                                                 "username": "student12",
                                                 "email": "student12@student.com",
                                                 "name": "Student 12",
                                                 "description": "Soy una persona introvertida",
                                                 "userPhoto": "nophoto.png",
                                                 "created": "2024-06-12T16:12:33.661014",
                                                 "interests": []
                                             }
                                         ],
                                         "size": 10,
                                         "totalElements": 4,
                                         "pageNumber": 0,
                                         "first": true,
                                         "last": true
                                     }
                                                                        """)})}),
    })
    @GetMapping("/all")
    @PreAuthorize("hasRole('ADMIN')")
    public MyPage<StudentItemResponse> getAllStudents(@PageableDefault(size = 10, page = 0) Pageable pageable, @RequestParam(value = "term", required = false) String term){
        return studentService.findAllStudents(pageable, term);
    }

    @Operation(summary = "Retrieves a student (Only Admin)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The student was provided successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = StudentItemResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "id": "04d0595e-45d5-4f63-8b53-1d79e9d84a5d",
                                        "username": "student1",
                                        "email": "student1@student.com",
                                        "name": "Student 1",
                                        "description": "Soy una persona extrovertida",
                                        "userPhoto": "nophoto.png",
                                        "created": "2024-06-12T16:12:33.627842",
                                        "interests": [
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
                                            }
                                        ]
                                    }
                                                                        """)})}),
            @ApiResponse(responseCode = "404 Not Found", description = "The student provided does not exist", content = @Content),
    })
    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<StudentItemResponse> getStudent(@PathVariable("id") String id){
        return ResponseEntity.ok(StudentItemResponse.of(studentService.findStudent(id)));
    }

    @Operation(summary = "Edit a student (Only Admin)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The student was edited successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = StudentItemResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "id": "04d0595e-45d5-4f63-8b53-1d79e9d84a5d",
                                        "username": "pepe.perez",
                                        "email": "pepe@gmail.com",
                                        "name": "Pepe Pérez",
                                        "description": "Es el mejor estudiante del mundo",
                                        "userPhoto": "nophoto.png",
                                        "created": "2024-06-12T16:12:33.627842",
                                        "interests": [
                                            {
                                                "id": 4,
                                                "name": "Gaming",
                                                "iconRef": "0xe5e8",
                                                "colorCode": "0xff46cdfb"
                                            }
                                        ]
                                    }
                                                                        """)})}),
            @ApiResponse(responseCode = "400 Bad Request", description = "The edition was not successful", content = @Content),
            @ApiResponse(responseCode = "404 Not Found", description = "The student provided does not exist", content = @Content),
    })
    @PutMapping("{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public StudentItemResponse editStudent(@PathVariable("id") String id, @RequestBody @Valid UpdateStudentRequest updateStudentRequest){
        return StudentItemResponse.of(studentService.editStudent(id, updateStudentRequest));
    }

}
