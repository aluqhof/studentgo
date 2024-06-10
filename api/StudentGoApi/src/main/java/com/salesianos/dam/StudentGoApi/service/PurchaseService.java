package com.salesianos.dam.StudentGoApi.service;

import com.salesianos.dam.StudentGoApi.MyPage;
import com.salesianos.dam.StudentGoApi.dto.purchase.PurchaseDetailResponse;
import com.salesianos.dam.StudentGoApi.dto.purchase.PurchaseItemResponse;
import com.salesianos.dam.StudentGoApi.dto.purchase.PurchaseRequest;
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
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
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
    private final QRService qrService;

    public Purchase buyEventTicket(Student student, String idEvent){
        Event eventSelected = eventRepository.findById(UUID.fromString(idEvent)).orElseThrow(() -> new NotFoundException("Event"));
        List<Student> students = eventRepository.findStudentsByEventIdNoPageable(UUID.fromString(idEvent));
        if(eventSelected.getMaxCapacity() <= students.size()){
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

    public MyPage<PurchaseItemResponse> findAllPurchases(Pageable pageable){
        Page<Purchase> purchases = purchaseRepository.findAllPurchases(pageable);
        return MyPage.of(purchases.map(p -> PurchaseItemResponse.of(p, studentRepository.findById(UUID.fromString(p.getAuthor())).orElseThrow(() -> new NotFoundException("Student")))), "Purchases");
    }

    public PurchaseDetailResponse getPurchaseById(String id){
        Purchase p = purchaseRepository.findById(UUID.fromString(id)).orElseThrow(() -> new NotFoundException("Purchase"));
        Student s = studentRepository.findById(UUID.fromString(p.getAuthor())).orElseThrow(() -> new NotFoundException("Student"));
        return PurchaseDetailResponse.of(p, s);
    }

    public Purchase makePurchase(PurchaseRequest purchaseRequest){
        List<Event> eventsPurchasedByStudent = purchaseRepository.findEventsPurchasedByStudentId(purchaseRequest.studentId());

        for (Event event : eventsPurchasedByStudent){
            if(event.getId() == UUID.fromString(purchaseRequest.eventId())){
                throw new EventAlreadyPurchasedException("This user has already a ticket for this event");
            }
        }

        Purchase p = Purchase.builder()
                .event(eventRepository.findById(UUID.fromString(purchaseRequest.eventId())).orElseThrow(() -> new NotFoundException("Event")))
                .author(studentRepository.findById(UUID.fromString(purchaseRequest.studentId())).orElseThrow(() -> new NotFoundException("Student")).getId().toString())
                .dateTime(LocalDateTime.now())
                .totalPrice(purchaseRequest.price())
                .build();

        p = purchaseRepository.save(p);

        String qrCode = qrService.generateQRCode(p.getUuid().toString());

        System.out.println("Qr Code: "+qrCode);
        p.setQrCode(qrCode);
        return purchaseRepository.save(p);
    }

    public Purchase editPurchase(String purchaseId, PurchaseRequest purchaseRequest){
        Purchase p = purchaseRepository.findById(UUID.fromString(purchaseId)).orElseThrow(() -> new NotFoundException("Purchase"));
        p.setTotalPrice(purchaseRequest.price());
        p.setEvent(eventRepository.findById(UUID.fromString(purchaseRequest.eventId())).orElseThrow(() -> new NotFoundException("Event")));
        p.setAuthor(studentRepository.findById(UUID.fromString(purchaseRequest.studentId())).orElseThrow(() -> new NotFoundException("Student")).getId().toString());
        return purchaseRepository.save(p);
    }
}
