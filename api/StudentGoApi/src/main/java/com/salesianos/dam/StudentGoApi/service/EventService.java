package com.salesianos.dam.StudentGoApi.service;

import com.salesianos.dam.StudentGoApi.MyPage;
import com.salesianos.dam.StudentGoApi.dto.event.AddEventRequest;
import com.salesianos.dam.StudentGoApi.dto.event.EventDetailsResponse;
import com.salesianos.dam.StudentGoApi.dto.event.EventViewResponse;
import com.salesianos.dam.StudentGoApi.dto.user.student.StudentListResponse;
import com.salesianos.dam.StudentGoApi.exception.NotFoundException;
import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.EventType;
import com.salesianos.dam.StudentGoApi.model.Organizer;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.repository.CityRepository;
import com.salesianos.dam.StudentGoApi.repository.EventRepository;
import com.salesianos.dam.StudentGoApi.repository.EventTypeRepository;
import com.salesianos.dam.StudentGoApi.repository.user.OrganizerRepository;
import com.salesianos.dam.StudentGoApi.repository.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class EventService {

    private final EventRepository eventRepository;
    private final EventTypeRepository eventTypeRepository;
    private final CityRepository cityRepository;
    private final UserRepository userRepository;
    private final OrganizerRepository organizerRepository;

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

    public List<Event> getAllUpcomingEventsInCity(String cityName, String query){
        if(query == null){
            return eventRepository.findFutureEventsByCity(cityRepository.findFirstByNameIgnoreCase(cityName)
                    .orElseThrow(() -> new NotFoundException("city")).getId());
        }else {
            return eventRepository.findFutureEventsByCityIdAndName(cityRepository.findFirstByNameIgnoreCase(cityName)
                    .orElseThrow(() -> new NotFoundException("city")).getId(), query);
        }
    }

    public MyPage<EventViewResponse> getAllUpcomingEventsInCityPaged(String cityName, Pageable pageable){
        Page<Event> events =  eventRepository.findFutureEventsByCityPaged(cityRepository.findFirstByNameIgnoreCase(cityName)
                    .orElseThrow(() -> new NotFoundException("city")).getId(), pageable);
        return MyPage.of(events
                .map(event ->EventViewResponse.of(event, eventRepository.findStudentsByEventIdNoPageable(event.getId()))), "Upcoming Events");
    }

    public MyPage<EventViewResponse> getFutureEventsInCityAccordingToUser(String cityName, Student student, Pageable pageable) {
        Page<Event> events =  eventRepository.findAllFutureEventsByCityIdWithAccordingToUser(cityRepository.findFirstByNameIgnoreCase(cityName)
                .orElseThrow(() -> new NotFoundException("city")).getId(), userRepository.findById(student.getId()).orElseThrow(() -> new NotFoundException("User")).getId(), pageable);
        return MyPage.of(events
                .map(event ->EventViewResponse.of(event, eventRepository.findStudentsByEventIdNoPageable(event.getId()))), "According to you");
    }

    public MyPage<EventViewResponse> getFutureEventsByEventType(String cityName, Pageable pageable, Long eventTypeId){
        EventType eventType = eventTypeRepository.findById(eventTypeId).orElseThrow(() -> new NotFoundException("event type"));
        Page<Event> events =  eventRepository.findAllByEventType(cityRepository.findFirstByNameIgnoreCase(cityName)
                .orElseThrow(() -> new NotFoundException("city")).getId(), eventType.getId(), pageable);
        return MyPage.of(events
                .map(event ->EventViewResponse.of(event, eventRepository.findStudentsByEventIdNoPageable(event.getId()))), eventType.getName());
    }

    public MyPage<StudentListResponse> getStudentsByEvent(UUID eventId, Pageable pageable){
        Event event = eventRepository.findById(eventId).orElseThrow( () -> new NotFoundException("event"));
        Page<Student> students =  eventRepository.findStudentsByEventId(event.getId(), pageable);
        return MyPage.of(students
                .map(StudentListResponse::of), "Students in "+ event.getName());
    }

    public EventDetailsResponse getEventById(UUID eventId){
        Event event = eventRepository.findById(eventId).orElseThrow(() -> new NotFoundException("event"));
        List<Student> students = eventRepository.findStudentsByEventIdNoPageable(event.getId());
        Organizer organizer= organizerRepository.findById(UUID.fromString(event.getAuthor())).orElseThrow(() -> new NotFoundException("organizer"));
        return EventDetailsResponse.of(event, students, organizer);
    }
}
