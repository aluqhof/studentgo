package com.salesianos.dam.StudentGoApi.exception;

public class InvalidEventTypeIdException extends RuntimeException{

    public InvalidEventTypeIdException(Long id) {
        super("The id provided is invalid: "+id);
    }
}
