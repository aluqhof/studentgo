package com.salesianos.dam.StudentGoApi.dto.user;

import com.salesianos.dam.StudentGoApi.model.UserDefault;

public record ChangeUsernameResponse(
        String id,
        String username
) {
    public static ChangeUsernameResponse of(UserDefault user){
        return new ChangeUsernameResponse(
                user.getId().toString(),
                user.getUsername()
        );
    }
}
