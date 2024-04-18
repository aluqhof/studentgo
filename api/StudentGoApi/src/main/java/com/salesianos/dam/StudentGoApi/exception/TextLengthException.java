package com.salesianos.dam.StudentGoApi.exception;

public class UsernameLengthException extends RuntimeException{
    public UsernameLengthException(String message) {
        super(message);
    }
}
