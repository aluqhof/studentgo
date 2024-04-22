package com.salesianos.dam.StudentGoApi.service.user;

import com.salesianos.dam.StudentGoApi.dto.user.ChangeUsernameRequest;
import com.salesianos.dam.StudentGoApi.dto.user.UpdateProfileRequest;
import com.salesianos.dam.StudentGoApi.dto.user.student.StudentInfoResponse;
import com.salesianos.dam.StudentGoApi.exception.NotFoundException;
import com.salesianos.dam.StudentGoApi.exception.UsernameAlreadyExistsException;
import com.salesianos.dam.StudentGoApi.exception.TextLengthException;
import com.salesianos.dam.StudentGoApi.model.EventType;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.model.UserDefault;
import com.salesianos.dam.StudentGoApi.repository.EventTypeRepository;
import com.salesianos.dam.StudentGoApi.repository.user.StudentRepository;
import com.salesianos.dam.StudentGoApi.repository.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final StudentRepository studentRepository;
    private final EventTypeRepository eventTypeRepository;

    public Optional<UserDefault> findById(UUID id){
        return userRepository.findById(id);
    }

    public boolean userExistsByUsername(String username) {
        return userRepository.existsByUsernameIgnoreCase(username);
    }

    public boolean userExistsByEmail(String email) {
        return userRepository.existsByEmailIgnoreCase(email);
    }

    public UserDefault changeUsername(UserDefault user, ChangeUsernameRequest changeUsernameRequest){

        String username = changeUsernameRequest.username();

        findById(user.getId()).orElseThrow(() -> new NotFoundException("User"));

        if(userExistsByUsername(username)){
            throw new UsernameAlreadyExistsException();
        }else {
            user.setUsername(username);
            return userRepository.save(user);
        }
    }

    public Student updateProfile(Student user, UpdateProfileRequest updateProfileRequest){
        String name = updateProfileRequest.name();
        String description = updateProfileRequest.description();
        List<Long> interestIds = updateProfileRequest.interests();

        findById(user.getId()).orElseThrow(() -> new NotFoundException("User"));

        List<EventType> interests = interestIds.stream()
                .map(i-> eventTypeRepository.findById(i).orElseThrow(() ->  new NotFoundException("Event Type")))
                .toList();

        user.setName(name);
        user.setDescription(description);
        user.setInterests(interests);
        return studentRepository.save(user);
    }


}