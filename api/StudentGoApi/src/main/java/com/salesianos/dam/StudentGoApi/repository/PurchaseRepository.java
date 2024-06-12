package com.salesianos.dam.StudentGoApi.repository;

import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.Purchase;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
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

    @Query(value = "SELECT p.* FROM purchase p " +
            "JOIN event e ON p.event_id = e.id " +
            "LEFT JOIN student s ON p.author = CAST(s.id AS varchar) " +
            "LEFT JOIN user_default u ON s.id = u.id " +
            "WHERE (:term IS NULL OR " +
            "LOWER(CAST(p.uuid AS varchar)) LIKE LOWER(CONCAT('%', :term, '%')) OR " +
            "LOWER(CAST(e.id AS varchar)) LIKE LOWER(CONCAT('%', :term, '%')) OR " +
            "LOWER(e.name) LIKE LOWER(CONCAT('%', :term, '%')) OR " +
            "LOWER(p.author) LIKE LOWER(CONCAT('%', :term, '%')) OR " +
            "LOWER(u.username) LIKE LOWER(CONCAT('%', :term, '%'))) " +
            "ORDER BY p.date_time DESC",
            nativeQuery = true)
    Page<Purchase> findAllPurchases(Pageable pageable, @Param("term") String term);


    @Query(value = "SELECT p.* FROM purchase p " +
            "JOIN event e ON p.event_id = e.id " +
            "LEFT JOIN student s ON p.author = CAST(s.id AS varchar) " +
            "LEFT JOIN user_default u ON s.id = u.id " +
            "WHERE e.author = :author " +
            "AND (:term IS NULL OR " +
            "LOWER(CAST(p.uuid AS varchar)) LIKE LOWER(CONCAT('%', :term, '%')) OR " +
            "LOWER(CAST(e.id AS varchar)) LIKE LOWER(CONCAT('%', :term, '%')) OR " +
            "LOWER(e.name) LIKE LOWER(CONCAT('%', :term, '%')) OR " +
            "LOWER(p.author) LIKE LOWER(CONCAT('%', :term, '%')) OR " +
            "LOWER(u.username) LIKE LOWER(CONCAT('%', :term, '%'))) " +
            "ORDER BY p.date_time DESC",
            nativeQuery = true)
    Page<Purchase> findPurchasesFromEventByOrganizerId(@Param("author") String author, Pageable pageable, @Param("term") String term);
}

