package com.salesianos.dam.StudentGoApi.validation.validator;

import com.salesianos.dam.StudentGoApi.validation.annotation.ValidCoordinates;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

public class ValidCoordinatesValidator implements ConstraintValidator<ValidCoordinates, Double> {
    @Override
    public boolean isValid(Double value, ConstraintValidatorContext context) {
        return value != null && value >= -90 && value <= 90;
    }
}
