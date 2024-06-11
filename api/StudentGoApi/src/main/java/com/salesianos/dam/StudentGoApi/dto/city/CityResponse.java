package com.salesianos.dam.StudentGoApi.dto.city;

import com.salesianos.dam.StudentGoApi.model.City;
import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

public record CityResponse(

        Long id,

        String name,

        String photoUrl
) {

    public static CityResponse of(City city){
        return new CityResponse(
                city.getId(),
                city.getName(),
                city.getPhotoUrl()
        );
    }

}
