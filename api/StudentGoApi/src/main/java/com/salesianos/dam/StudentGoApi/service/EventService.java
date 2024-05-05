package com.salesianos.dam.StudentGoApi.service;

import com.salesianos.dam.StudentGoApi.MyPage;
import com.salesianos.dam.StudentGoApi.dto.event.AddEventRequest;
import com.salesianos.dam.StudentGoApi.dto.event.EventDetailsResponse;
import com.salesianos.dam.StudentGoApi.dto.event.EventViewResponse;
import com.salesianos.dam.StudentGoApi.dto.user.student.StudentListResponse;
import com.salesianos.dam.StudentGoApi.exception.DateRangeFilterException;
import com.salesianos.dam.StudentGoApi.exception.NotFoundException;
import com.salesianos.dam.StudentGoApi.exception.PriceRangeFilterException;
import com.salesianos.dam.StudentGoApi.model.*;
import com.salesianos.dam.StudentGoApi.repository.CityRepository;
import com.salesianos.dam.StudentGoApi.repository.EventRepository;
import com.salesianos.dam.StudentGoApi.repository.EventTypeRepository;
import com.salesianos.dam.StudentGoApi.repository.user.OrganizerRepository;
import com.salesianos.dam.StudentGoApi.repository.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
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
                .maxCapacity(addEventRequest.maxCapacity())
                .build();

        return eventRepository.save(event);
    }

    public List<Event> getAllUpcomingEventsInCity(String cityName, String searchQuery,
                                                  List<Long> eventTypes, String start, String end,
                                                  Double min, Double max) {
        List<EventType> eventTypeObjects;
        String eventName;
        LocalDateTime startDate;
        LocalDateTime endDate;
        double minPrice;
        double maxPrice;

        City city = cityRepository.findFirstByNameIgnoreCase(cityName)
                .orElseThrow(() -> new NotFoundException("City not found"));

        if (searchQuery == null || searchQuery.isEmpty()) {
            eventName = "";
        } else {
            eventName = searchQuery;
        }

        if (eventTypes != null && !eventTypes.isEmpty()) {
            eventTypeObjects = eventTypes.stream()
                    .map(eventTypeId -> eventTypeRepository.findById(eventTypeId)
                            .orElseThrow(() -> new NotFoundException("Event Type not found")))
                    .toList();
        } else {
            eventTypeObjects = eventTypeRepository.findAll();
        }

        try {
            startDate = start != null && !start.isEmpty() ? LocalDateTime.parse(start) : LocalDateTime.now();
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("Invalid start date format. Please provide the date in the format yyyy-MM-dd'T'HH:mm:ss");
        }

        try {
            endDate = end != null && !end.isEmpty() ? LocalDateTime.parse(end) : LocalDateTime.now().plusYears(1);
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("Invalid end date format. Please provide the date in the format yyyy-MM-dd'T'HH:mm:ss");
        }

        if (min == null || min < 0) {
            minPrice = 0;
        } else {
            minPrice = min;
        }

        if (max == null || max < 0) {
            Optional<Double> maxPriceOptional = eventRepository.findAll()
                    .stream()
                    .map(Event::getPrice)
                    .max(Comparator.naturalOrder());

            maxPrice = maxPriceOptional.orElse(0.0);
        } else {
            maxPrice = max;
        }

        if (minPrice >= maxPrice) {
            throw new PriceRangeFilterException("The min price cannot be higher or equal than the max price");
        }

        if (startDate.isAfter(endDate) || startDate.isEqual(endDate)) {
            throw new DateRangeFilterException("The start date cannot be higher or equal than the end date");
        }

        if(startDate.isBefore(LocalDateTime.now()) || endDate.isAfter(LocalDateTime.now().plusYears(1))){
            throw new DateRangeFilterException("The date selected is out of range");
        }

        return eventRepository.findFutureEventsByCityFiltered(city.getId(), eventName,
                eventTypeObjects.stream().map(EventType::getId).toList(), startDate,
                endDate, minPrice, maxPrice);
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
