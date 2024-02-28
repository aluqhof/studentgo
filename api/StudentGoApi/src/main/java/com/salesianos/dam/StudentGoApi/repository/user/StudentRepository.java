package com.salesianos.dam.StudentGoApi.repository.user;

import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.UUID;

public interface StudentRepository extends JpaRepository<Student, UUID> {

    @Query("SELECT s.saved FROM Student s WHERE s.id = :studentId")
    List<Event> findSavedEventsByStudentId(UUID studentId);

}
