package com.salesianos.dam.StudentGoApi.repository.user;

import com.salesianos.dam.StudentGoApi.model.Organizer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface OrganizerRepository extends JpaRepository<Organizer, UUID> {
}
