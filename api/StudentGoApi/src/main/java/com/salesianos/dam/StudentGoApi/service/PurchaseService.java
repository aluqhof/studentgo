package com.salesianos.dam.StudentGoApi.service;

import com.salesianos.dam.StudentGoApi.exception.EventAlreadyPurchasedException;
import com.salesianos.dam.StudentGoApi.exception.NotFoundException;
import com.salesianos.dam.StudentGoApi.exception.NumberOfTicketsLowerThan0Exception;
import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.Purchase;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.repository.EventRepository;
import com.salesianos.dam.StudentGoApi.repository.PurchaseRepository;
import com.salesianos.dam.StudentGoApi.repository.user.StudentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PurchaseService {

    private final StudentRepository studentRepository;
    private final EventRepository eventRepository;
    private final PurchaseRepository purchaseRepository;

    public Purchase buyEventTicket(Student student, String idEvent, int numberOfTickets){
        Event eventSelected = eventRepository.findById(UUID.fromString(idEvent)).orElseThrow(() -> new NotFoundException("Event"));

        if(numberOfTickets <= 0) {
             throw new NumberOfTicketsLowerThan0Exception("The number of tickets selected must be higher than 0");
        }

        List<Event> eventsPurchasedByStudent = purchaseRepository.findEventsPurchasedByStudentId(student.getId().toString());

        for (Event event : eventsPurchasedByStudent){
            if(event.getId() == eventSelected.getId()){
                throw new EventAlreadyPurchasedException("You can't buy a ticket because you've already bought a ticket for this event");
            }
        }
        Purchase purchase = Purchase.builder()
                .numberOfTickets(numberOfTickets)
                .event(eventSelected)
                .author(student.getId().toString())
                .dateTime(LocalDateTime.now())
                .totalPrice(eventSelected.getPrice() * numberOfTickets)
                .build();

        return purchaseRepository.save(purchase);
    }

    public  List<Event> findEventsPurchasedByUser(Student student){
        return purchaseRepository.findEventsPurchasedByStudentId(student.getId().toString());
    }

}
