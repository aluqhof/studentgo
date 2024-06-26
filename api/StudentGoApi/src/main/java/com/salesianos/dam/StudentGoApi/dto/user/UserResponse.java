package com.salesianos.dam.StudentGoApi.dto.user;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.salesianos.dam.StudentGoApi.model.UserDefault;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.springframework.security.core.GrantedAuthority;

import java.time.LocalDateTime;
import java.util.Collection;

@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class UserResponse {

    protected String id;
    protected String username, name, role;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy HH:mm:ss")
    protected LocalDateTime createdAt;

    public static String getRole(Collection<? extends GrantedAuthority> roleList){
        return roleList.stream().map(GrantedAuthority::getAuthority).toList().get(0);
    }
    public static UserResponse of(UserDefault user){

        return UserResponse.builder()
                .id(user.getId().toString())
                .username(user.getUsername())
                .name(user.getName())
                .createdAt(user.getCreatedAt())
                .role(getRole(user.getAuthorities()))
                .build();
    }

}