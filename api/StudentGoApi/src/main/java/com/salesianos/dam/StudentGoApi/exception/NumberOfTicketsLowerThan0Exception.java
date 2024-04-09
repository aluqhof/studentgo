package com.salesianos.dam.StudentGoApi.exception;

public class NumberOfTicketsLowerThan0Exception extends RuntimeException{
    public NumberOfTicketsLowerThan0Exception(String message) {
        super(message);
    }
}
