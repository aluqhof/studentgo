package com.salesianos.dam.StudentGoApi.exception;

public class EmailAlreadyExistException extends RuntimeException{

    public EmailAlreadyExistException(){
        super("The email selected already exists");
    }

}
