package com.salesianos.dam.StudentGoApi.validation.validator;

import com.salesianos.dam.StudentGoApi.service.user.UserService;
import com.salesianos.dam.StudentGoApi.validation.annotation.UniqueEmail;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

public class UniqueEmailValidator implements ConstraintValidator<UniqueEmail, String> {

    @Autowired
    private UserService userService;

    @Override
    public boolean isValid(String s, ConstraintValidatorContext constraintValidatorContext) {
        return StringUtils.hasText(s) && !userService.userExistsByEmail(s);
    }
}