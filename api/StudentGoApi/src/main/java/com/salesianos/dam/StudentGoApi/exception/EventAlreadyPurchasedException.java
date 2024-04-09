package com.salesianos.dam.StudentGoApi.exception;

public class EventAlreadyPurchasedException  extends RuntimeException{
    public EventAlreadyPurchasedException(String message) {
        super(message);
    }
}
