package com.salesianos.dam.StudentGoApi.service.user;

import com.salesianos.dam.StudentGoApi.MyPage;
import com.salesianos.dam.StudentGoApi.dto.user.organizer.OrganizerItemResponse;
import com.salesianos.dam.StudentGoApi.dto.user.organizer.OrganizerRequest;
import com.salesianos.dam.StudentGoApi.dto.user.organizer.OrganizerShortResponse;
import com.salesianos.dam.StudentGoApi.exception.EmailAlreadyExistException;
import com.salesianos.dam.StudentGoApi.exception.NotFoundException;
import com.salesianos.dam.StudentGoApi.exception.UsernameAlreadyExistsException;
import com.salesianos.dam.StudentGoApi.model.Organizer;
import com.salesianos.dam.StudentGoApi.repository.user.OrganizerRepository;
import com.salesianos.dam.StudentGoApi.repository.user.UserRepository;
import com.salesianos.dam.StudentGoApi.service.EmailSenderService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class OrganizerService {

    private final PasswordEncoder passwordEncoder;
    private final OrganizerRepository organizerRepository;
    private final UserRepository userRepository;
    private final EmailSenderService emailService;

    public Organizer createOrganizer(OrganizerRequest addOrganizerRequest) {

        Organizer or = new Organizer();
        if(userRepository.existsByUsernameIgnoreCase(addOrganizerRequest.username())){
            throw new UsernameAlreadyExistsException();
        } else {
            or.setUsername(addOrganizerRequest.username());
        }
        String permittedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        int longitud = 8;
        Random random = new Random();
        StringBuilder password = new StringBuilder();
        for (int i = 0; i < longitud; i++) {
            int index = random.nextInt(permittedCharacters.length());
            password.append(permittedCharacters.charAt(index));
        }
        or.setPassword(passwordEncoder.encode(password));
        if(!Objects.equals(or.getEmail(), addOrganizerRequest.email())){
            if(userRepository.existsByEmailIgnoreCase(addOrganizerRequest.email())){
                throw new EmailAlreadyExistException();
            } else {
                or.setEmail(addOrganizerRequest.email());
            }
        }
        or.setName(addOrganizerRequest.name());
        or.setDescription(addOrganizerRequest.description());
        emailService.sendEmail(or.getEmail(),
                "Welcome to Student Go!",
                "Dear " + or.getName() + ",\n\n" +
                        "Welcome to Student Go! We are excited to have you on board.\n\n" +
                        "Here are your new account credentials:\n" +
                        " - Username: " + or.getUsername() + "\n" +
                        " - Password: " + password + "\n\n" +
                        "Please keep this information secure and do not share it with anyone.\n\n" +
                        "If you have any questions or need assistance, feel free to reach out to our support team.\n\n" +
                        "Best regards,\n" +
                        "The Student Go Team"
        );

        return organizerRepository.save(or);
    }

    public MyPage<OrganizerItemResponse> getAll(Pageable pageable, String term){
        Page<Organizer> organizers = organizerRepository.findAll(term, pageable);
        return MyPage.of(organizers.map(OrganizerItemResponse::of), "Organizers");
    }

    public Organizer getOrganizer(String id){
        return organizerRepository.findById(UUID.fromString(id)).orElseThrow(() -> new NotFoundException("Organizer"));
    }

    public Organizer editOrganizer(String id, OrganizerRequest update) {
        Organizer organizer = organizerRepository.findById(UUID.fromString(id))
                .orElseThrow(() -> new NotFoundException("Organizer"));


        if(update.business() != null){
            organizer.setBusiness(update.business());
        }

        if(!Objects.equals(organizer.getUsername(), update.username())){
            if(userRepository.existsByUsernameIgnoreCase(update.username())){
                throw new UsernameAlreadyExistsException();
            } else {
                organizer.setUsername(update.username());
            }
        }
        organizer.setName(update.name());
        if(!Objects.equals(organizer.getEmail(), update.email())){
            if(userRepository.existsByEmailIgnoreCase(update.email())){
                throw new EmailAlreadyExistException();
            } else {
                organizer.setEmail(update.email());
            }
        }
        organizer.setDescription(update.description());

        return organizerRepository.save(organizer);
    }

    public MyPage<OrganizerShortResponse> findByUsername(String term, Pageable pageable){
        Page<Organizer> organizers = organizerRepository.findByUsernameIgnoreCaseContaining(term, pageable);
        return MyPage.of(organizers.map(OrganizerShortResponse::of), "Organizers");
    }
}
