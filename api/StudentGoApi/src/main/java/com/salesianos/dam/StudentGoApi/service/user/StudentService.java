package com.salesianos.dam.StudentGoApi.service.user;

import com.salesianos.dam.StudentGoApi.dto.user.student.AddStudentRequest;
import com.salesianos.dam.StudentGoApi.exception.NotFoundException;
import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.repository.EventRepository;
import com.salesianos.dam.StudentGoApi.repository.user.StudentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class StudentService {

    private final PasswordEncoder passwordEncoder;
    private final StudentRepository studentRepository;
    private final EventRepository eventRepository;

    public Student createStudent(AddStudentRequest addStudentRequest) {

        Student user = new Student();
        user.setUsername(addStudentRequest.username());
        user.setPassword(passwordEncoder.encode(addStudentRequest.password()));
        user.setEmail(addStudentRequest.email());
        user.setName(addStudentRequest.name());

        return studentRepository.save(user);
    }

    public Student getStudentInfo(Student student){
        return studentRepository.findById(student.getId()).orElseThrow(() -> new NotFoundException("Student"));
    }

    public Student saveEvent(UUID eventId, Student student){
        //studentRepository.findById(student.getId()).orElseThrow(() -> new NotFoundException("Student"));
        Event event = eventRepository.findById(eventId).orElseThrow(() -> new NotFoundException("Event"));
        List<Event> eventsSaved = studentRepository.findSavedEventsByStudentId(student.getId());
        for (Event eventInList: eventsSaved) {
            if(eventInList.getId() == eventId){
                eventsSaved.remove(eventInList);
                student.setSaved(eventsSaved);
                return studentRepository.save(student);
            }
        }
        eventsSaved.add(event);
        student.setSaved(eventsSaved);
        return studentRepository.save(student);
    }
    
}
