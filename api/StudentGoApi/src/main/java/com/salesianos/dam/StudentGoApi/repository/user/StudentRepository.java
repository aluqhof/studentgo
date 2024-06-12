package com.salesianos.dam.StudentGoApi.repository.user;

import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.Student;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface StudentRepository extends JpaRepository<Student, UUID> {

    @Query("SELECT s.saved FROM Student s WHERE s.id = :studentId")
    List<Event> findSavedEventsByStudentId(UUID studentId);

    Page<Student> findByUsernameIgnoreCaseContaining(String username, Pageable pageable);

    @Query("SELECT s FROM Student s JOIN s.interests i WHERE i.id = :eventTypeId")
    List<Student> findByEventTypeId(@Param("eventTypeId") Long eventTypeId);

    @Query("SELECT s FROM Student s WHERE " +
            "(:term IS NULL OR LOWER(CAST(s.id AS string)) LIKE LOWER(CONCAT('%', :term, '%')) OR " +
            "LOWER(s.name) LIKE LOWER(CONCAT('%', :term, '%')) OR " +
            "LOWER(s.email) LIKE LOWER(CONCAT('%', :term, '%'))) ")
    Page<Student> findAll(@Param("term") String term, Pageable pageable);
}
