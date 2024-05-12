package com.salesianos.dam.StudentGoApi.service;

import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.salesianos.dam.StudentGoApi.dto.purchase.PurchaseTicket;
import com.salesianos.dam.StudentGoApi.exception.EventAlreadyPurchasedException;
import com.salesianos.dam.StudentGoApi.exception.NotFoundException;
import com.salesianos.dam.StudentGoApi.exception.SoldOutException;
import com.salesianos.dam.StudentGoApi.model.Event;
import com.salesianos.dam.StudentGoApi.model.Purchase;
import com.salesianos.dam.StudentGoApi.model.Student;
import com.salesianos.dam.StudentGoApi.repository.EventRepository;
import com.salesianos.dam.StudentGoApi.repository.PurchaseRepository;
import com.salesianos.dam.StudentGoApi.repository.user.StudentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PurchaseService {

    private final StudentRepository studentRepository;
    private final EventRepository eventRepository;
    private final PurchaseRepository purchaseRepository;
    private final QRService qrService;

    public Purchase buyEventTicket(Student student, String idEvent){
        Event eventSelected = eventRepository.findById(UUID.fromString(idEvent)).orElseThrow(() -> new NotFoundException("Event"));
        List<Student> students = eventRepository.findStudentsByEventIdNoPageable(UUID.fromString(idEvent));
        if(eventSelected.getMaxCapacity() >= students.size()){
            throw new SoldOutException("The event has reached its maximum capacity.");
        }

        List<Event> eventsPurchasedByStudent = purchaseRepository.findEventsPurchasedByStudentId(student.getId().toString());

        for (Event event : eventsPurchasedByStudent){
            if(event.getId() == eventSelected.getId()){
                throw new EventAlreadyPurchasedException("You can't buy a ticket because you've already bought a ticket for this event");
            }
        }
        Purchase purchase = Purchase.builder()
                .event(eventSelected)
                .author(student.getId().toString())
                .dateTime(LocalDateTime.now())
                .totalPrice(eventSelected.getPrice())
                .build();

        purchase = purchaseRepository.save(purchase);

        String qrCode = qrService.generateQRCode(purchase.getUuid().toString());

        System.out.println("Qr Code: "+qrCode);
        purchase.setQrCode(qrCode);

        return purchaseRepository.save(purchase);
    }

    public  List<Purchase> findEventsPurchasedByUser(Student student){
        return purchaseRepository.findPurchasesByStudentId(student.getId().toString());
    }

    public PurchaseTicket getPurchase(String id){
        Purchase purchase = purchaseRepository.findById(UUID.fromString(id)).orElseThrow(() -> new NotFoundException("Purchase"));
        Student student = studentRepository.findById(UUID.fromString(purchase.getAuthor())).orElseThrow(() -> new NotFoundException("Student"));
        return PurchaseTicket.of(purchase, student);
    }

}
