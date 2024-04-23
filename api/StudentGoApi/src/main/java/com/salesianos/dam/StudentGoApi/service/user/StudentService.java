package com.salesianos.dam.StudentGoApi.service.user;

import com.salesianos.dam.StudentGoApi.MyPage;
import com.salesianos.dam.StudentGoApi.dto.event.EventViewResponse;
import com.salesianos.dam.StudentGoApi.dto.user.student.AddStudentRequest;
import com.salesianos.dam.StudentGoApi.exception.NotFoundException;
import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.EventType;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.repository.EventRepository;
import com.salesianos.dam.StudentGoApi.repository.EventTypeRepository;
import com.salesianos.dam.StudentGoApi.repository.user.StudentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
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
    private final EventTypeRepository eventTypeRepository;

    public Student createStudent(AddStudentRequest addStudentRequest) {

        List<Long> interestIds = addStudentRequest.interests();


        List<EventType> interests = interestIds.stream()
                .map(i-> eventTypeRepository.findById(i).orElseThrow(() ->  new NotFoundException("Event Type")))
                .toList();

        Student user = new Student();
        user.setUsername(addStudentRequest.username());
        user.setPassword(passwordEncoder.encode(addStudentRequest.password()));
        user.setEmail(addStudentRequest.email());
        user.setName(addStudentRequest.name());
        user.setInterests(interests);

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

    public List<EventViewResponse> getAllSavedEventsByStudent(Student student){
        List<Event> events = studentRepository.findSavedEventsByStudentId(student.getId());
        return events.stream()
                .map(event -> EventViewResponse.of(event, eventRepository.findStudentsByEventIdNoPageable(student.getId())))
                .toList();
    }
    
}
