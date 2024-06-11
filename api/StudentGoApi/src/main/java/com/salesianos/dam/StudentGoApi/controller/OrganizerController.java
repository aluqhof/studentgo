package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.MyPage;
import com.salesianos.dam.StudentGoApi.dto.user.organizer.OrganizerDetailsResponse;
import com.salesianos.dam.StudentGoApi.dto.user.organizer.OrganizerItemResponse;
import com.salesianos.dam.StudentGoApi.dto.user.organizer.OrganizerRequest;
import com.salesianos.dam.StudentGoApi.service.user.OrganizerService;
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

    @GetMapping("/all")
    @PreAuthorize("hasRole('ADMIN')")
    public MyPage<OrganizerItemResponse> getAllOrganizers(@PageableDefault(size = 10, page = 0) Pageable pageable){
        return organizerService.getAll(pageable);
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<OrganizerDetailsResponse> getOrganizerById(@PathVariable("id") String id){
        return ResponseEntity.ok(OrganizerDetailsResponse.of(organizerService.getOrganizer(id)));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public OrganizerDetailsResponse editOrganizer(@PathVariable("id") String id, @RequestBody @Valid OrganizerRequest organizerRequest){
        return OrganizerDetailsResponse.of(organizerService.editOrganizer(id, organizerRequest));
    }
}
