package com.salesianos.dam.StudentGoApi.repository;

import com.salesianos.dam.StudentGoApi.model.City;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CityRepository extends JpaRepository<City, Long> {
    Optional<City> findFirstByNameIgnoreCase(String name);
}
