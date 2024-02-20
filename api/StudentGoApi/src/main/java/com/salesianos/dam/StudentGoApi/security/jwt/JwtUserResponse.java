package com.salesianos.dam.StudentGoApi.security.jwt;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.salesianos.dam.StudentGoApi.dto.user.UserResponse;
import com.salesianos.dam.StudentGoApi.model.UserDefault;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class JwtUserResponse extends UserResponse {

    private String token;
    private String refreshToken;

    public JwtUserResponse(UserResponse userResponse) {
        id = userResponse.getId();
        username = userResponse.getUsername();
        name = userResponse.getName();
        createdAt = userResponse.getCreatedAt();
        role = userResponse.getRole();
    }

    public static JwtUserResponse of (UserDefault user, String token) {
        JwtUserResponse result = new JwtUserResponse(UserResponse.of(user));
        result.setToken(token);
        return result;

    }

}