package com.salesianos.dam.StudentGoApi.exception;

public class InvalidEventTypeName extends RuntimeException{

    public InvalidEventTypeName(String name) {
        super("The name provided already exist: "+name);
    }
}
