package com.salesianos.dam.StudentGoApi.exception;

public class NotLoggedInException extends RuntimeException{
    public NotLoggedInException(String message) {
        super(message);
    }
}
