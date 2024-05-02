package com.salesianos.dam.StudentGoApi.exception;

import jakarta.persistence.EntityNotFoundException;

public class ImageNotFoundException extends RuntimeException {
    public ImageNotFoundException(String message) {
        super(message);
    }
}
