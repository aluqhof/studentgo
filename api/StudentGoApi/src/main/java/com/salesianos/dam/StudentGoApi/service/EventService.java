package com.salesianos.dam.StudentGoApi.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.salesianos.dam.StudentGoApi.MyPage;
import com.salesianos.dam.StudentGoApi.dto.event.*;
import com.salesianos.dam.StudentGoApi.dto.file.response.FileResponse;
import com.salesianos.dam.StudentGoApi.dto.user.student.StudentListResponse;
import com.salesianos.dam.StudentGoApi.exception.DateRangeFilterException;
import com.salesianos.dam.StudentGoApi.exception.NotFoundException;
import com.salesianos.dam.StudentGoApi.exception.PermissionException;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;
import java.util.stream.Collectors;

import static java.util.stream.Collectors.toList;

@Service
@RequiredArgsConstructor
public class EventService {

    private final EventRepository eventRepository;
    private final EventTypeRepository eventTypeRepository;
    private final CityRepository cityRepository;
    private final UserRepository userRepository;
    private final OrganizerRepository organizerRepository;
    private final StorageService storageService;
    private final ObjectMapper objectMapper;

    public Event createEvent(EditEventAdminRequest addEventRequest, MultipartFile[] files,UserDefault user){
        List<FileResponse> result = Arrays.stream(files)
                .map(this::uploadFile)
                .toList();

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        List<String> eventPhotos = new ArrayList<>();

        for (MultipartFile file : files) {
            String filename = file.getOriginalFilename();
            if (filename != null && !filename.isBlank()) {
                eventPhotos.add(filename);
            }
        }

        Event event = Event.builder()
                .name(addEventRequest.name())
                .description(addEventRequest.description())
                .latitude(addEventRequest.latitude())
                .longitude(addEventRequest.longitude())
                .author(user.getId().toString())
                .city(cityRepository.findFirstByNameIgnoreCase(addEventRequest.cityId()).orElseThrow(()-> new NotFoundException("city")))
                .dateTime(LocalDateTime.parse(addEventRequest.dateTime(), formatter))
                .eventTypes(addEventRequest.eventTypes()
                        .stream()
                        .map(e -> eventTypeRepository.findFirstByNameIgnoreCase(e)
                                .orElseThrow(() -> new NotFoundException("event type")))
                        .toList())
                .maxCapacity(addEventRequest.maxCapacity())
                .urlPhotos(eventPhotos)
                .build();

        return eventRepository.save(event);
    }

    public Event createEvent(String addEventRequest, MultipartFile[] files, UserDefault user){
        EditEventAdminRequest addEventDto = null;
        try {
            addEventDto = objectMapper.readValue(addEventRequest, EditEventAdminRequest.class);
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
        return createEvent(addEventDto, files, user);
    }

    public MyPage<EventViewResponse> getEventsByOrganizer(Organizer organizer, Pageable pageable) {
        if(organizer == null){
            throw new PermissionException("You don't have permission to access to this resource");
        }
        Page<Event> events = eventRepository.getAllByOrganizer(organizer.getId().toString(), pageable);
        return MyPage.of(events
                .map(event ->EventViewResponse.of(event, eventRepository.findStudentsByEventIdNoPageable(event.getId()))), "Past Organizer Events");
    }

    private FileResponse uploadFile(MultipartFile file) {
        String name = storageService.store(file);
        String uri = ServletUriComponentsBuilder.fromCurrentContextPath()
                .path("/download/")
                .path(name)
                .toUriString();

        return FileResponse.builder()
                .name(name)
                .size(file.getSize())
                .type(file.getContentType())
                .uri(uri)
                .build();
    }

    public MyPage<EventViewResponse> getPastEventsByOrganizer(Organizer organizer, Pageable pageable)  {
        if(organizer == null){
            throw new PermissionException("You don't have permission to access to this resource");
        }
        Page<Event> events = eventRepository.getAllByOrganizerPast(organizer.getId().toString(), pageable);
        return MyPage.of(events
                .map(event ->EventViewResponse.of(event, eventRepository.findStudentsByEventIdNoPageable(event.getId()))), "Past Organizer Events");
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
                .orElseThrow(() -> new NotFoundException("City"));

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

        if(startDate.isBefore(LocalDateTime.now().minusHours(5)) || endDate.isAfter(LocalDateTime.now().plusYears(1).plusDays(1))){
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

    public MyPage<EventViewResponse> getAllUpcomingEventsPaged(Pageable pageable){
        return MyPage.of(eventRepository.findFutureEventsPaged(pageable)
                .map(event ->EventViewResponse.of(event, eventRepository.findStudentsByEventIdNoPageable(event.getId()))), "Upcoming Events");
    }

    public MyPage<EventViewResponse> getFutureEventsInCityAccordingToUser(String cityName, Student student, Pageable pageable) {
        if(student == null){
            throw new PermissionException("You don't have permission to access to this resource");
        }
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

    public EventDetailsResponse editEventAdmin(String id, EditEventAdminRequest edit){
        Event eventSelected = eventRepository.findById(UUID.fromString(id)).orElseThrow(() -> new NotFoundException("Event"));

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        if (edit.name() != null) {
            eventSelected.setName(edit.name());
        }
        if (edit.dateTime() != null) {
            eventSelected.setDateTime(LocalDateTime.parse(edit.dateTime(), formatter));
        }
        if (edit.description() != null) {
            eventSelected.setDescription(edit.description());
        }
        if (edit.price() != null) {
            eventSelected.setPrice(edit.price());
        }
        if (edit.maxCapacity() != null) {
            eventSelected.setMaxCapacity(edit.maxCapacity());
        }
        if (edit.cityId() != null) {
            eventSelected.setCity(cityRepository.findFirstByNameIgnoreCase(edit.cityId()).orElseThrow(() -> new NotFoundException("City")));
        }
        if (edit.latitude() != null) {
            eventSelected.setLatitude(edit.latitude());
        }
        if (edit.longitude() != null) {
            eventSelected.setLongitude(edit.longitude());
        }
        if (edit.eventTypes() != null) {
            eventSelected.setEventTypes(
                    edit.eventTypes()
                            .stream()
                            .map(et -> eventTypeRepository.findFirstByNameIgnoreCase(et)
                                    .orElseThrow(() -> new NotFoundException("Event Type")))
                            .collect(Collectors.toList())
            );
        }
        eventRepository.save(eventSelected);
        List<Student> students = eventRepository.findStudentsByEventIdNoPageable(eventSelected.getId());
        Organizer organizer= organizerRepository.findById(UUID.fromString(eventSelected.getAuthor())).orElseThrow(() -> new NotFoundException("organizer"));

        return EventDetailsResponse.of(eventSelected, students, organizer);
    }

    public MyPage<EventShortResponse> getEventByIdOrName(String term, Pageable pageable) {
        Page<Event> events = eventRepository.findByIdOrNameContainingIgnoreCase(term, pageable);
        return MyPage.of(events.map(EventShortResponse::of), "Events");
    }
}
