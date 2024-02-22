package com.salesianos.dam.StudentGoApi.exception;

import jakarta.persistence.EntityNotFoundException;

public class NotFoundException extends EntityNotFoundException {
    public NotFoundException(String entity) {
        super("No matching " + entity + " or list was found.");
    }
}
    

