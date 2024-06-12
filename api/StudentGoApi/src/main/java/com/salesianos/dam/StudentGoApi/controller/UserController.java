package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.dto.file.response.FileResponse;
import com.salesianos.dam.StudentGoApi.dto.user.ChangeUsernameRequest;
import com.salesianos.dam.StudentGoApi.dto.user.ChangeUsernameResponse;
import com.salesianos.dam.StudentGoApi.dto.user.LoginUser;
import com.salesianos.dam.StudentGoApi.dto.user.UpdateProfileRequest;
import com.salesianos.dam.StudentGoApi.dto.user.organizer.OrganizerDetailsResponse;
import com.salesianos.dam.StudentGoApi.dto.user.organizer.OrganizerRequest;
import com.salesianos.dam.StudentGoApi.dto.user.student.AddStudentRequest;
import com.salesianos.dam.StudentGoApi.dto.user.student.StudentInfoResponse;
import com.salesianos.dam.StudentGoApi.exception.NotFoundException;
import com.salesianos.dam.StudentGoApi.model.Organizer;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.model.UserDefault;
import com.salesianos.dam.StudentGoApi.repository.user.UserRepository;
import com.salesianos.dam.StudentGoApi.security.jwt.JwtProvider;
import com.salesianos.dam.StudentGoApi.security.jwt.JwtUserResponse;
import com.salesianos.dam.StudentGoApi.service.StorageService;
import com.salesianos.dam.StudentGoApi.service.user.OrganizerService;
import com.salesianos.dam.StudentGoApi.service.user.StudentService;
import com.salesianos.dam.StudentGoApi.service.user.UserService;
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
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
@Tag(name = "User", description = "The user controller has different methods to obtain various information " +
        "about the users, such as methods for registration and login.")
public class UserController {

    private final StudentService studentService;
    private final AuthenticationManager authManager;
    private final JwtProvider jwtProvider;
    private final OrganizerService organizerService;
    private final UserService userService;
    private final StorageService storageService;
    private final UserRepository userRepository;

    @Operation(summary = "Register student")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201 Created", description = "Register was successful", content = {
                    @Content(mediaType = "application/json", schema = @Schema(implementation = JwtUserResponse.class), examples = {
                            @ExampleObject(value = """
                                    {
                                        "id": "c5a551c9-a514-433d-b7ef-a469724fe492",
                                        "username": "estudiante1",
                                        "name": "alex",
                                        "role": "ROLE_USER",
                                        "createdAt": "20/02/2024 10:41:54",
                                        "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJjNWE1NTFjOS1hNTE0LTQzM2QtYjdlZi1hNDY5NzI0ZmU0OTIiLCJpYXQiOjE3MDg0MjIxMTQsImV4cCI6MTcwODUwODUxNH0.w58Bj9NPZjOMnJy_JKE3fK-y3J5BC9Uzq1n4dzmqbgIT1_GrT0GxR_TMMCUwRetrLyK5yC1DQyUqBtJsGoPcsA"
                                    }
                                                                        """) }) }),
            @ApiResponse(responseCode = "400 Bad Request", content = @Content),
            @ApiResponse(responseCode = "401 Unauthorized", content = @Content),
            @ApiResponse(responseCode = "403 Forbidden", content = @Content)
    })
    @PostMapping("/auth/register-student")
    public ResponseEntity<JwtUserResponse> registerStudent(@Valid @RequestBody AddStudentRequest addStudentRequest) {
        Student student = studentService.createStudent(addStudentRequest);
        Authentication authentication = authManager.authenticate(new UsernamePasswordAuthenticationToken(addStudentRequest.username(),addStudentRequest.password()));
        SecurityContextHolder.getContext().setAuthentication(authentication);
        String token = jwtProvider.generateToken(authentication);
        return ResponseEntity.status(HttpStatus.CREATED).body(JwtUserResponse.of(student, token));
    }

    @Operation(summary = "Registers an organizer and sends an email with login credentials (Only Admin)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201 Created", description = "Register was successful", content = {
                    @Content(mediaType = "application/json", schema = @Schema(implementation = OrganizerDetailsResponse.class), examples = {
                            @ExampleObject(value = """
                                    {
                                        "id": "481a235b-f7ef-4a8a-a117-34c7f0a7c293",
                                        "username": "estudiante1",
                                        "name": "alex",
                                        "role": "ROLE_ORGANIZER",
                                        "createdAt": "20/02/2024 10:54:32",
                                        "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI0ODFhMjM1Yi1mN2VmLTRhOGEtYTExNy0zNGM3ZjBhN2MyOTMiLCJpYXQiOjE3MDg0MjI4NzIsImV4cCI6MTcwODUwOTI3Mn0.fApEWi0H4fyCHLJEOob2H9ClCdMv--4i1gGtdWMfxmp3MBzPnPm1035ksvAU6hRmTIeqBdOCuZ1ZxMrKyBFIjw"
                                    }
                                                                        """) }) }),
            @ApiResponse(responseCode = "400 Bad Request", content = @Content),
            @ApiResponse(responseCode = "401 Unauthorized", content = @Content),
            @ApiResponse(responseCode = "403 Forbidden", content = @Content)
    })
    @PostMapping("/auth/register-organizer")
    public ResponseEntity<OrganizerDetailsResponse> registerOrganizer(@Valid @RequestBody OrganizerRequest addOrganizerRequest) {
        Organizer organizer = organizerService.createOrganizer(addOrganizerRequest);
        return ResponseEntity.status(HttpStatus.CREATED).body(OrganizerDetailsResponse.of(organizer));
    }


    @Operation(summary = "Login user")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201 Created", description = "Login was succesful", content = {
                    @Content(mediaType = "application/json", schema = @Schema(implementation = JwtUserResponse.class), examples = {
                            @ExampleObject(value = """
                                                                        {
                                                                            "id": "ba00362c-f808-4dfd-8d0c-386d6c1757a9",
                                                                            "username": "alexluque",
                                                                            "email": "user@gmail.com",
                                                                            "nombre": "Alexander Luque",
                                                                            "createdAt": "22/11/2023 10:27:44",
                                                                            "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJiYTAwMzYyYy1mODA4LTRkZmQtOGQwYy0zODZkNmMxNzU3YTkiLCJpYXQiOjE3MDA2NDUyNjQsImV4cCI6MTcwMDczMTY2NH0.2a62n6XejYfeInr-00ywKVfm5me6armBPHA7ehLMwyelHvnLUWRLGmLv6CUN6nZd8QvKMlueIRQEezAqmftcPw"
                                                                        }
                                                                        """) }) }),
            @ApiResponse(responseCode = "400 Bad Request", content = @Content),
            @ApiResponse(responseCode = "401 Unauthorized", content = @Content),
            @ApiResponse(responseCode = "403 Forbidden", content = @Content)
    })
    @PostMapping("/auth/login")
    public ResponseEntity<JwtUserResponse> login(@RequestBody LoginUser loginUser) {

        Authentication authentication = authManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        loginUser.username(),
                        loginUser.password()));
        SecurityContextHolder.getContext().setAuthentication(authentication);
        String token = jwtProvider.generateToken(authentication);

        UserDefault user = (UserDefault) authentication.getPrincipal();

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(JwtUserResponse.of(user, token));

    }

    @Operation(summary = "Change username")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The username was changed successfully", content = {
                    @Content(mediaType = "application/json", schema = @Schema(implementation = ChangeUsernameResponse.class), examples = {
                            @ExampleObject(value = """
                                    {
                                         "id": "04d0595e-45d5-4f63-8b53-1d79e9d84a5d",
                                         "username": "alexluque1"
                                     }
                                                                        """) }) }),
            @ApiResponse(responseCode = "400 Bad Request", content = @Content),
            @ApiResponse(responseCode = "401 Unauthorized", content = @Content),
            @ApiResponse(responseCode = "403 Forbidden", content = @Content)
    })
    @PutMapping("/user/change-username")
    public ChangeUsernameResponse changeUsername(@AuthenticationPrincipal UserDefault user, @RequestBody @Valid  ChangeUsernameRequest changeUsernameRequest){
        return ChangeUsernameResponse.of(userService.changeUsername(user, changeUsernameRequest));
    }

    @Operation(summary = "Updates a student profile")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The profile was updated successfully", content = {
                    @Content(mediaType = "application/json", schema = @Schema(implementation = StudentInfoResponse.class), examples = {
                            @ExampleObject(value = """
                                    {
                                        "id": "04d0595e-45d5-4f63-8b53-1d79e9d84a5d",
                                        "username": "student1",
                                        "name": "dfd",
                                        "description": "Soy una persona a la que le encanta hacer deporte y salir con sus amigos",
                                        "userPhoto": "nophoto.png",
                                        "interests": [
                                            {
                                                "id": 1,
                                                "name": "Sports",
                                                "iconRef": "0xe5e6",
                                                "colorCode": "0xfff0635a"
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
                                                                        """) }) }),
            @ApiResponse(responseCode = "400 Bad Request", content = @Content),
            @ApiResponse(responseCode = "401 Unauthorized", content = @Content),
            @ApiResponse(responseCode = "403 Forbidden", content = @Content)
    })
    @PreAuthorize("hasRole('USER')")
    @PutMapping("/user/student/update")
    public StudentInfoResponse updateStudentProfile(@AuthenticationPrincipal Student user,
                                                    @RequestBody @Valid UpdateProfileRequest updateProfileRequest){
        return StudentInfoResponse.of(userService.updateProfile(user, updateProfileRequest));
    }

    @Operation(summary = "Add profile photo for the user in session ")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201 Created", description = "The image was uploaded successfully", content = {
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
    @PostMapping("/upload-profile-image")
    public ResponseEntity<?> upload(@RequestPart("file") MultipartFile file, @AuthenticationPrincipal UserDefault user) {

        FileResponse response = uploadFile(file);
        user.setUrlPhoto(file.getOriginalFilename());
        userRepository.save(user);
        //if (!Objects.requireNonNull(file.getContentType()).startsWith("image/")) {
          //  throw new FileTypeException("The file must be of type image");
        //}

        return ResponseEntity.created(URI.create(response.getUri())).body(response);
    }

    @Operation(summary = "Add profile photo for an user (Only Admin)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201 Created", description = "The image was uploaded successfully", content = {
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
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/upload-profile-image/{id}")
    public ResponseEntity<?> uploadPhotoByUserId(@RequestPart("file") MultipartFile file, @PathVariable("id") String id) {

        FileResponse response = uploadFile(file);
        UserDefault user = userRepository.findById(UUID.fromString(id)).orElseThrow(() -> new NotFoundException("User"));
        user.setUrlPhoto(file.getOriginalFilename());
        userRepository.save(user);
        //if (!Objects.requireNonNull(file.getContentType()).startsWith("image/")) {
        //  throw new FileTypeException("The file must be of type image");
        //}

        return ResponseEntity.created(URI.create(response.getUri())).body(response);
    }

    @Operation(summary = "Deletes the current profile photo")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204 No Content", description = "The image was deleted successful"),
    })
    @GetMapping("/delete-photo")
    public ResponseEntity<?> deletePhoto(@AuthenticationPrincipal UserDefault user) {

        user.setUrlPhoto("nophoto.png");
        userRepository.save(user);

        return ResponseEntity.noContent().build();
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

    @Operation(summary = "Download the profile photo from the user in session")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The image was downloaded successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MediaTypeUrlResource.class)))}),
    })
    @GetMapping("/download-profile-photo")
    public ResponseEntity<Resource> getFile(@AuthenticationPrincipal UserDefault user){

        MediaTypeUrlResource resource =
                (MediaTypeUrlResource) storageService.loadAsResource(user.getUrlPhoto());

        return ResponseEntity.status(HttpStatus.OK)
                .header("Content-Type", resource.getType())
                .body(resource);
    }

    @Operation(summary = "Download a photo from a specific user")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The image was downloaded successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MediaTypeUrlResource.class)))}),
            @ApiResponse(responseCode = "404 Not Found", description = "The image was not found", content = @Content),
    })
    @GetMapping("/download-profile-photo/{id}")
    public ResponseEntity<Resource> getFileByUserId(@PathVariable("id") String uuid){

        UserDefault user = userRepository.findById(UUID.fromString(uuid)).orElseThrow(() -> new NotFoundException("User"));
        MediaTypeUrlResource resource =
                (MediaTypeUrlResource) storageService.loadAsResource(user.getUrlPhoto());

        return ResponseEntity.status(HttpStatus.OK)
                .header("Content-Type", resource.getType())
                .body(resource);
    }

}