package com.salesianos.dam.StudentGoApi.repository;

import com.salesianos.dam.StudentGoApi.model.Event;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface EventRepository extends JpaRepository<Event, UUID> {

    @Query("SELECT e FROM Event e WHERE e.city.id = :id")
    List<Event> findEventsByCityId(@Param("id") Long cityId);

    @Query("SELECT e FROM Event e WHERE e.city.id = :cityId AND e.dateTime > CURRENT_TIMESTAMP ORDER BY e.dateTime ASC")
    List<Event> findFutureEventsByCityId(@Param("cityId") Long cityId);

    @Query("SELECT e FROM Event e WHERE e.city.id = :id AND e.dateTime > CURRENT_TIMESTAMP")
    List<Event> findFutureEventsByCityIdWithLimit(@Param("id") Long cityId, Pageable pageable);

}
