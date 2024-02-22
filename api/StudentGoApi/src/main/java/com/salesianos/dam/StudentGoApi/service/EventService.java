package com.salesianos.dam.StudentGoApi.service;

import com.salesianos.dam.StudentGoApi.dto.event.AddEventRequest;
import com.salesianos.dam.StudentGoApi.exception.NotFoundException;
import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.Organizer;
import com.salesianos.dam.StudentGoApi.repository.CityRepository;
import com.salesianos.dam.StudentGoApi.repository.EventRepository;
import com.salesianos.dam.StudentGoApi.repository.EventTypeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class EventService {

    private final EventRepository eventRepository;
    private final EventTypeRepository eventTypeRepository;
    private final CityRepository cityRepository;

    public Event createEvent(AddEventRequest addEventRequest, Organizer organizer){
        Event event = Event.builder()
                .name(addEventRequest.name())
                .description(addEventRequest.description())
                .latitude(addEventRequest.latitude())
                .longitude(addEventRequest.longitude())
                .author(organizer.getId().toString())
                .city(cityRepository.findById(addEventRequest.cityId()).orElseThrow(()-> new NotFoundException("city")))
                .dateTime(addEventRequest.dateTime())
                .eventTypes(addEventRequest.eventTypesIds()
                        .stream()
                        .map(e -> eventTypeRepository.findById(e)
                                .orElseThrow(() -> new NotFoundException("event type")))
                        .toList())
                .build();

        return eventRepository.save(event);
    }

    public List<Event> getAllEventsInCity(Long cityId){
        if (cityRepository.findById(cityId).isEmpty()){
            throw new NotFoundException("city");
        }
        return eventRepository.findEventsByCityId(cityId);
    }

    public List<Event> getFutureEventsInCity(String cityName){
        return eventRepository.findFutureEventsByCityId(cityRepository.findFirstByNameIgnoreCase(cityName)
                .orElseThrow(() -> new NotFoundException("city")).getId());
    }

    public List<Event> getFutureEventsInCityLimit5(String cityName, int limit){
        Pageable pageable = PageRequest.of(0, limit);
        return eventRepository.findFutureEventsByCityIdWithLimit(cityRepository.findFirstByNameIgnoreCase(cityName)
                .orElseThrow(() -> new NotFoundException("city")).getId(), pageable);
    }
}
