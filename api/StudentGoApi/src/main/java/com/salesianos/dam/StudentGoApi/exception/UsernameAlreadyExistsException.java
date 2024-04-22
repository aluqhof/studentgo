package com.salesianos.dam.StudentGoApi.exception;

public class UsernameAlreadyExistsException extends RuntimeException{

    public UsernameAlreadyExistsException(){
        super("The username selected already exists");
    }

}
