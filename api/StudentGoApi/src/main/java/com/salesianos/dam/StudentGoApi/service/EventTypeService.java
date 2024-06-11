package com.salesianos.dam.StudentGoApi.service;

import com.salesianos.dam.StudentGoApi.dto.eventType.EventTypeRequest;
import com.salesianos.dam.StudentGoApi.exception.InvalidEventTypeName;
import com.salesianos.dam.StudentGoApi.exception.NotFoundException;
import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.EventType;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.repository.EventRepository;
import com.salesianos.dam.StudentGoApi.repository.EventTypeRepository;
import com.salesianos.dam.StudentGoApi.repository.user.StudentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class EventTypeService {

    private final EventTypeRepository eventTypeRepository;
    private final EventRepository eventRepository;
    private final StudentRepository studentRepository;

    public List<EventType> getAllEventTypes(){
        return eventTypeRepository.findAll();
    }

    public EventType getEventTypeById(Long id){
        return eventTypeRepository.findById(id).orElseThrow(() -> new NotFoundException("Event Type"));
    }

    public EventType createEventType(EventTypeRequest eventTypeRequest){
        List<EventType> ets = eventTypeRepository.findAll();
        for(EventType et: ets){
            if(et.getName().equalsIgnoreCase(eventTypeRequest.name())){
                throw new InvalidEventTypeName(eventTypeRequest.name());
            }
        }
        EventType et = EventType.builder()
                .name(eventTypeRequest.name())
                .colorCode(eventTypeRequest.colorCode())
                .iconRef(eventTypeRequest.iconRef())
                .build();

        return eventTypeRepository.save(et);
    }

    public EventType editEventType(Long id, EventTypeRequest eventTypeRequest){
        EventType et = eventTypeRepository.findById(id).orElseThrow(() -> new NotFoundException("Event Type"));
        List<EventType> ets = eventTypeRepository.findAll();
        for(EventType type: ets){
            if(type.getName().equalsIgnoreCase(eventTypeRequest.name()) && !Objects.equals(type.getId(), et.getId())){
                throw new InvalidEventTypeName(eventTypeRequest.name());
            }
        }

        et.setName(eventTypeRequest.name());
        et.setIconRef(eventTypeRequest.iconRef());
        et.setColorCode(eventTypeRequest.colorCode());

        return eventTypeRepository.save(et);
    }

    @Transactional
    public void deleteEventType(Long id){
        EventType eventType = eventTypeRepository.findById(id).orElseThrow(() -> new NotFoundException("Event Type"));
        List <Event> events = eventRepository.findByEventTypeId(id);
        events.forEach(e -> {
            e.removeEventType(eventType);
            eventRepository.save(e);
        });
        List <Student> students = studentRepository.findByEventTypeId(id);
        students.forEach(s -> {
            s.removeEventType(eventType);
            studentRepository.save(s);
        });
        eventTypeRepository.delete(eventType);
    }

}
