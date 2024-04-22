package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.dto.user.ChangeUsernameRequest;
import com.salesianos.dam.StudentGoApi.dto.user.ChangeUsernameResponse;
import com.salesianos.dam.StudentGoApi.dto.user.LoginUser;
import com.salesianos.dam.StudentGoApi.dto.user.UpdateProfileRequest;
import com.salesianos.dam.StudentGoApi.dto.user.organizer.AddOrganizerRequest;
import com.salesianos.dam.StudentGoApi.dto.user.student.AddStudentRequest;
import com.salesianos.dam.StudentGoApi.dto.user.student.StudentInfoResponse;
import com.salesianos.dam.StudentGoApi.model.Organizer;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.model.UserDefault;
import com.salesianos.dam.StudentGoApi.security.jwt.JwtProvider;
import com.salesianos.dam.StudentGoApi.security.jwt.JwtUserResponse;
import com.salesianos.dam.StudentGoApi.service.user.OrganizerService;
import com.salesianos.dam.StudentGoApi.service.user.StudentService;
import com.salesianos.dam.StudentGoApi.service.user.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

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

    @Operation(summary = "Register student")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201 Created", description = "Register was succesful", content = {
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

    @Operation(summary = "Register organizer")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201 Created", description = "Register was succesful", content = {
                    @Content(mediaType = "application/json", schema = @Schema(implementation = JwtUserResponse.class), examples = {
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
    public ResponseEntity<JwtUserResponse> registerOrganizer(@Valid @RequestBody AddOrganizerRequest addOrganizerRequest) {
        Organizer organizer = organizerService.createOrganizer(addOrganizerRequest);
        Authentication authentication = authManager.authenticate(new UsernamePasswordAuthenticationToken(addOrganizerRequest.username(),addOrganizerRequest.password()));
        SecurityContextHolder.getContext().setAuthentication(authentication);
        String token = jwtProvider.generateToken(authentication);
        return ResponseEntity.status(HttpStatus.CREATED).body(JwtUserResponse.of(organizer, token));
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
    @PreAuthorize("hasRole('USER')")
    @PutMapping("/user/student/update")
    public StudentInfoResponse updateStudentProfile(@AuthenticationPrincipal Student user,
                                                    @RequestBody @Valid UpdateProfileRequest updateProfileRequest){
        return StudentInfoResponse.of(userService.updateProfile(user, updateProfileRequest));
    }

}