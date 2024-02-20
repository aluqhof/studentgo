package com.salesianos.dam.StudentGoApi.service;

import com.salesianos.dam.StudentGoApi.dto.user.organizer.AddOrganizerRequest;
import com.salesianos.dam.StudentGoApi.model.Organizer;
import com.salesianos.dam.StudentGoApi.repository.OrganizerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OrganizerService {

    private final PasswordEncoder passwordEncoder;
    private final OrganizerRepository organizerRepository;

    public Organizer createOrganizer(AddOrganizerRequest addOrganizerRequest) {

        Organizer or = new Organizer();
        or.setUsername(addOrganizerRequest.username());
        or.setPassword(passwordEncoder.encode(addOrganizerRequest.password()));
        or.setEmail(addOrganizerRequest.email());
        or.setName(addOrganizerRequest.name());

        return organizerRepository.save(or);
    }

}
