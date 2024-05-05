package com.salesianos.dam.StudentGoApi.repository;

import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.Purchase;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface PurchaseRepository extends JpaRepository<Purchase, UUID> {

    @Query("SELECT p.event FROM Purchase p WHERE p.author = :studentId")
    List<Event> findEventsPurchasedByStudentId(@Param("studentId") String studentId);

    @Query("SELECT p FROM Purchase p JOIN p.event e WHERE p.author = :studentId AND e.dateTime >= current_timestamp ORDER BY e.dateTime ASC")
    List<Purchase> findPurchasesByStudentId(@Param("studentId") String studentId);
}

