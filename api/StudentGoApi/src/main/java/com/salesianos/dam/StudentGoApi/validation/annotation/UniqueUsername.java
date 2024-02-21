package com.salesianos.dam.StudentGoApi.validation.annotation;

import com.salesianos.dam.StudentGoApi.validation.validator.UniqueUsernameValidator;
import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.*;

@Target({ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = UniqueUsernameValidator.class)
@Documented
public @interface UniqueUsername {

    String message() default "The username already exists";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

}