package com.salesianos.dam.StudentGoApi.repository.user;

import com.salesianos.dam.StudentGoApi.model.Organizer;
import com.salesianos.dam.StudentGoApi.model.Student;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.UUID;

public interface OrganizerRepository extends JpaRepository<Organizer, UUID> {

    Page<Organizer> findByUsernameIgnoreCaseContaining(String username, Pageable pageable);

    @Query("SELECT o FROM Organizer o WHERE " +
            "(:term IS NULL OR LOWER(CAST(o.id AS string)) LIKE LOWER(CONCAT('%', :term, '%')) OR " +
            "LOWER(o.name) LIKE LOWER(CONCAT('%', :term, '%')) OR " +
            "LOWER(o.email) LIKE LOWER(CONCAT('%', :term, '%'))) ")
    Page<Organizer> findAll(@Param("term") String term, Pageable pageable);
}
