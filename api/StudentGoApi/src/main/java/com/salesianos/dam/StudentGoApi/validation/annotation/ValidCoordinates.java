package com.salesianos.dam.StudentGoApi.validation.annotation;

import com.salesianos.dam.StudentGoApi.validation.validator.ValidCoordinatesValidator;
import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.*;

@Target({ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = ValidCoordinatesValidator.class)
@Documented
public @interface ValidCoordinates {

    String message() default "The coordinates format is invalid";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

}
