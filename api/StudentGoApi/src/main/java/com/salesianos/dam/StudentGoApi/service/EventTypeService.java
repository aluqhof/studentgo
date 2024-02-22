package com.salesianos.dam.StudentGoApi.service;

import com.salesianos.dam.StudentGoApi.model.EventType;
import com.salesianos.dam.StudentGoApi.repository.EventTypeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class EventTypeService {

    private final EventTypeRepository eventTypeRepository;

    public List<EventType> getAllEventTypes(){
        return eventTypeRepository.findAll();
    }
}
