package com.salesianos.dam.StudentGoApi.service;

import com.salesianos.dam.StudentGoApi.dto.event.AddEventRequest;
import com.salesianos.dam.StudentGoApi.exception.InvalidEventTypeIdException;
import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.Organizer;
import com.salesianos.dam.StudentGoApi.repository.EventRepository;
import com.salesianos.dam.StudentGoApi.repository.EventTypeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class EventService {

    private final EventRepository eventRepository;
    private final EventTypeRepository eventTypeRepository;

    public Event createEvent(AddEventRequest addEventRequest, Organizer organizer){
        Event event = Event.builder()
                .name(addEventRequest.name())
                .description(addEventRequest.description())
                .latitude(addEventRequest.latitude())
                .longitude(addEventRequest.longitude())
                .author(organizer.getId().toString())
                .dateTime(addEventRequest.dateTime())
                .eventTypes(addEventRequest.eventTypesIds()
                        .stream()
                        .map(e -> eventTypeRepository.findById(e)
                                .orElseThrow(() -> new InvalidEventTypeIdException(e)))
                        .toList())
                .build();

        return eventRepository.save(event);
    }
}
