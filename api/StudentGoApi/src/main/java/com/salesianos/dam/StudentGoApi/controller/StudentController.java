package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.MyPage;
import com.salesianos.dam.StudentGoApi.dto.event.EventViewResponse;
import com.salesianos.dam.StudentGoApi.dto.event.EventsSavedResponse;
import com.salesianos.dam.StudentGoApi.dto.user.student.StudentInfoResponse;
import com.salesianos.dam.StudentGoApi.dto.user.student.StudentShortResponse;
import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.service.user.StudentService;
import io.swagger.v3.oas.annotations.tags.Tag;
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

    @GetMapping("/")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<StudentInfoResponse> getStudentInfo(@AuthenticationPrincipal Student student){
        return ResponseEntity.ok(StudentInfoResponse.of(studentService.getStudentInfo(student)));
    }

    @PutMapping("/save-unsave-event/{eventId}")
    @PreAuthorize("hasRole('USER')")
    public StudentInfoResponse saveOrUnsaveEvent(@AuthenticationPrincipal Student student, @PathVariable UUID eventId){
        return StudentInfoResponse.of(studentService.saveEvent(eventId, student));
    }

    @GetMapping("/saved-events")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<List<EventViewResponse>> getAllSavedEvents(@AuthenticationPrincipal Student student){
        return ResponseEntity.ok(studentService.getAllSavedEventsByStudent(student));
    }

    @GetMapping("/search")
    public MyPage<StudentShortResponse> searchByUsername(@RequestParam(value = "term", required = false) String term, @PageableDefault(size = 5, page = 0) Pageable pageable){
        return studentService.findByUsername(term, pageable);
    }

}
