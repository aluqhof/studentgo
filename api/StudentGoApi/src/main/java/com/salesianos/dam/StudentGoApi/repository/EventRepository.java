package com.salesianos.dam.StudentGoApi.repository;

import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.Student;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface EventRepository extends JpaRepository<Event, UUID> {

    @Query("SELECT e FROM Event e WHERE e.city.id = :id AND e.dateTime > CURRENT_TIMESTAMP")
    List<Event> findEventsByCityId(@Param("id") Long cityId);


    @Query("SELECT e FROM Event e WHERE e.city.id = :cityId AND e.dateTime > CURRENT_TIMESTAMP ORDER BY e.dateTime ASC")
    Page<Event> findAllFutureEventsByCityId(@Param("cityId") Long cityId, Pageable pageable);
    //Esto deberia ir en orden de popularidad del organizador (reviews, eventos realizados...)

    @Query("SELECT e FROM Event e " +
            "JOIN e.eventTypes et " +
            "JOIN Student s ON et MEMBER OF s.interests " +
            "WHERE e.city.id = :cityId AND s.id = :userId " +
            "AND e.dateTime > CURRENT_TIMESTAMP")
    Page<Event> findAllFutureEventsByCityIdWithAccordingToUser(@Param("cityId") Long cityId,
                                                               @Param("userId") UUID userId, Pageable pageable);
    //Esto deberia ir en orden de popularidad del organizador (reviews, eventos realizados...)

    @Query("SELECT e FROM Event e JOIN e.eventTypes et WHERE et.id = :eventTypeId AND e.dateTime > CURRENT_TIMESTAMP " +
            "AND e.city.id = :cityId")
    Page<Event> findAllByEventType(@Param("cityId") Long cityId, @Param("eventTypeId") Long eventTypeId, Pageable pageable);

    @Query("SELECT DISTINCT s FROM Student s JOIN Purchase p ON s.id = CAST(p.author AS java.util.UUID) JOIN p.event e WHERE e.id = :eventId")
    Page<Student> findStudentsByEventId(@Param("eventId") UUID eventId, Pageable pageable);

    @Query("SELECT DISTINCT s FROM Student s JOIN Purchase p ON s.id = CAST(p.author AS java.util.UUID) JOIN p.event e WHERE e.id = :eventId")
    List<Student> findStudentsByEventIdNoPageable(@Param("eventId") UUID eventId);
}
