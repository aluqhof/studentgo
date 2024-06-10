package com.salesianos.dam.StudentGoApi.error;


import com.salesianos.dam.StudentGoApi.error.impl.ApiValidationSubError;
import com.salesianos.dam.StudentGoApi.exception.*;
import com.salesianos.dam.StudentGoApi.security.errorhandling.JwtTokenException;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.ErrorResponse;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import java.net.URI;
import java.time.Instant;
import java.util.List;

@RestControllerAdvice
public class GlobalRestControllerAdvice extends ResponseEntityExceptionHandler {

    @Override
    public ResponseEntity<Object> handleMethodArgumentNotValid(MethodArgumentNotValidException exception,
                                                               HttpHeaders headers, HttpStatusCode status, WebRequest request) {
        List<ApiValidationSubError> validationErrors = exception.getBindingResult().getAllErrors().stream()
                .map(ApiValidationSubError::fromObjectError)
                .toList();
        ErrorResponse er = ErrorResponse.builder(exception, HttpStatus.BAD_REQUEST, exception.getMessage())
                .title("Invalid data error")
                .type(URI.create("https://api.studentgo.com/errors/not-valid"))
                .property("Fields errors", validationErrors)
                .build();
        return ResponseEntity.status(status)
                .body(er.getBody()  );
    }

    @ExceptionHandler({ EntityNotFoundException.class })
    public ErrorResponse handleNotFoundException(EntityNotFoundException exception) {
        return ErrorResponse.builder(exception, HttpStatus.NOT_FOUND, exception.getMessage())
                .title("Entity not found")
                .type(URI.create("https://api.studentgo.com/errors/not-found"))
                .property("timestamp", Instant.now())
                .build();
    }

    @ExceptionHandler({ StorageException.class })
    public ErrorResponse handleStorageException(StorageException exception) {
        return ErrorResponse.builder(exception, HttpStatus.BAD_REQUEST, exception.getMessage())
                .title("Storage Exception")
                .type(URI.create("https://api.studentgo.com/errors/storage-exception"))
                .property("timestamp", Instant.now())
                .build();
    }

    @ExceptionHandler(InvalidCredentialsException.class)
    public ErrorResponse handleInvalidCredentialsException(
            InvalidCredentialsException exception) {
        return ErrorResponse.builder(exception, HttpStatus.UNAUTHORIZED, exception.getMessage())
                .title("Username or password incorrect")
                .type(URI.create("https://api.studentgo.com/errors/invalid-credentials"))
                .property("timestamp", Instant.now())
                .build();
    }

    @ExceptionHandler(FileTypeException.class)
    public ErrorResponse handleFileTypeException(
            FileTypeException exception) {
        return ErrorResponse.builder(exception, HttpStatus.BAD_REQUEST, exception.getMessage())
                .title("File Type Exception")
                .type(URI.create("https://api.studentgo.com/errors/invalid-file-type"))
                .property("timestamp", Instant.now())
                .build();
    }

    @ExceptionHandler(ImageNotFoundException.class)
    public ErrorResponse handleImageNotFoundException(
            ImageNotFoundException exception) {
        return ErrorResponse.builder(exception, HttpStatus.NOT_FOUND, exception.getMessage())
                .title("Image not found")
                .type(URI.create("https://api.studentgo.com/errors/image-not-found"))
                .property("timestamp", Instant.now())
                .build();
    }

    @ExceptionHandler({ AuthenticationException.class })
    public ErrorResponse handleAuthenticationException(AuthenticationException exception) {
        return ErrorResponse.builder(exception, HttpStatus.UNAUTHORIZED, exception.getMessage())
                .title("AUTHENTICATION")
                .type(URI.create("https://api.studentgo.com/errors/unauthorized-user"))
                .property("timestamp", Instant.now())
                .build();

    }

    @ExceptionHandler({ AccessDeniedException.class })
    public ErrorResponse handleAccessDeniedException(AccessDeniedException exception) {
        return ErrorResponse.builder(exception, HttpStatus.FORBIDDEN, exception.getMessage())
                .title("ACCESS DENIED")
                .type(URI.create("https://api.studentgo.com/errors/access-denied"))
                .property("timestamp", Instant.now())
                .build();

    }

    @ExceptionHandler({ PermissionException.class })
    public ErrorResponse handlePermissionException(PermissionException exception) {
        return ErrorResponse.builder(exception, HttpStatus.FORBIDDEN, exception.getMessage())
                .title("NO PERMISSION")
                .type(URI.create("https://api.studentgo.com/errors/no-permission"))
                .property("timestamp", Instant.now())
                .build();

    }


    @ExceptionHandler({JwtTokenException.class})
    public ErrorResponse handleTokenException(JwtTokenException exception) {
        return ErrorResponse.builder(exception, HttpStatus.FORBIDDEN, exception.getMessage())
                .title("TOKEN INVALID")
                .type(URI.create("https://api.studentgo.com/errors/invalid-token"))
                .property("timestamp", Instant.now())
                .build();
    }

    @ExceptionHandler({UsernameNotFoundException.class})
    public ErrorResponse handleUserNotExistsException(UsernameNotFoundException exception) {
        return ErrorResponse.builder(exception, HttpStatus.FORBIDDEN, exception.getMessage())
                .title("FORBIDDEN")
                .type(URI.create("https://api.studentgo.com/errors/forbidden"))
                .property("timestamp", Instant.now())
                .build();
    }

    @ExceptionHandler(NumberOfTicketsLowerThan0Exception.class)
    public ErrorResponse handleNumberOfTicketsException(
            NumberOfTicketsLowerThan0Exception exception) {
        return ErrorResponse.builder(exception, HttpStatus.BAD_REQUEST, exception.getMessage())
                .title("Number of tickets error")
                .type(URI.create("https://api.studentgo.com/errors/number-of-tickets-error"))
                .property("timestamp", Instant.now())
                .build();
    }

    @ExceptionHandler(SoldOutException.class)
    public ErrorResponse handleSoldOutException(
            SoldOutException exception) {
        return ErrorResponse.builder(exception, HttpStatus.BAD_REQUEST, exception.getMessage())
                .title("Event Sold Out")
                .type(URI.create("https://api.studentgo.com/errors/sold-out"))
                .property("timestamp", Instant.now())
                .build();
    }

    @ExceptionHandler(EventAlreadyPurchasedException.class)
    public ErrorResponse handleEventAlreadyPurchased(
            EventAlreadyPurchasedException exception) {
        return ErrorResponse.builder(exception, HttpStatus.BAD_REQUEST, exception.getMessage())
                .title("Event already purchased error")
                .type(URI.create("https://api.studentgo.com/errors/event-already-purchased-error"))
                .property("timestamp", Instant.now())
                .build();
    }

    @ExceptionHandler(PriceRangeFilterException.class)
    public ErrorResponse handlePriceRangeFilterException(
            PriceRangeFilterException exception) {
        return ErrorResponse.builder(exception, HttpStatus.BAD_REQUEST, exception.getMessage())
                .title("Price range filter error")
                .type(URI.create("https://api.studentgo.com/errors/price-range-filter-error"))
                .property("timestamp", Instant.now())
                .build();
    }

    @ExceptionHandler(DateRangeFilterException.class)
    public ErrorResponse handleDateRangeFilterException(
            DateRangeFilterException exception) {
        return ErrorResponse.builder(exception, HttpStatus.BAD_REQUEST, exception.getMessage())
                .title("Date range filter error")
                .type(URI.create("https://api.studentgo.com/errors/date-range-filter-error"))
                .property("timestamp", Instant.now())
                .build();
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ErrorResponse handleDateTimeParseException(IllegalArgumentException exception) {
        return ErrorResponse.builder(exception, HttpStatus.BAD_REQUEST, exception.getMessage())
                .title("Illegal argument exception")
                .type(URI.create("https://api.studentgo.com/errors/illegal-argument-exception"))
                .property("timestamp", Instant.now())
                .build();
    }

    @ExceptionHandler(TextLengthException.class)
    public ErrorResponse handleUsernameLengthException(TextLengthException exception) {
        return ErrorResponse.builder(exception, HttpStatus.BAD_REQUEST, exception.getMessage())
                .title("Text length error")
                .type(URI.create("https://api.studentgo.com/errors/text-length-error"))
                .property("timestamp", Instant.now())
                .build();
    }


    @ExceptionHandler(NotLoggedInException.class)
    public ErrorResponse handleUserNotLoggedIn(NotLoggedInException exception) {
        return ErrorResponse.builder(exception, HttpStatus.UNAUTHORIZED, exception.getMessage())
                .title("User not logged in")
                .type(URI.create("https://api.studentgo.com/errors/not-logged-in"))
                .property("timestamp", Instant.now())
                .build();
    }


    @ExceptionHandler(UsernameAlreadyExistsException.class)
    public ErrorResponse handleUsernameExistsException(UsernameAlreadyExistsException exception) {
        return ErrorResponse.builder(exception, HttpStatus.BAD_REQUEST, exception.getMessage())
                .title("Username exist error")
                .type(URI.create("https://api.studentgo.com/errors/username-exists-error"))
                .property("timestamp", Instant.now())
                .build();
    }

    @ExceptionHandler(EmailAlreadyExistException.class)
    public ErrorResponse handleEmailExistsException(EmailAlreadyExistException exception) {
        return ErrorResponse.builder(exception, HttpStatus.BAD_REQUEST, exception.getMessage())
                .title("Email exist error")
                .type(URI.create("https://api.studentgo.com/errors/username-exists-error"))
                .property("timestamp", Instant.now())
                .build();
    }

}