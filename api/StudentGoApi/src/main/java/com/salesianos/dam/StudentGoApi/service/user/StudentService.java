package com.salesianos.dam.StudentGoApi.service.user;

import com.salesianos.dam.StudentGoApi.dto.user.student.AddStudentRequest;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.repository.user.StudentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class StudentService {

    private final PasswordEncoder passwordEncoder;
    private final StudentRepository studentRepository;

    public Student createStudent(AddStudentRequest addStudentRequest) {

        Student user = new Student();
        user.setUsername(addStudentRequest.username());
        user.setPassword(passwordEncoder.encode(addStudentRequest.password()));
        user.setEmail(addStudentRequest.email());
        user.setName(addStudentRequest.name());

        return studentRepository.save(user);
    }
    
}
