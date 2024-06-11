package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.dto.file.response.FileResponse;
import com.salesianos.dam.StudentGoApi.exception.FileTypeException;
import com.salesianos.dam.StudentGoApi.exception.NotFoundException;
import com.salesianos.dam.StudentGoApi.model.City;
import com.salesianos.dam.StudentGoApi.repository.CityRepository;
import com.salesianos.dam.StudentGoApi.service.StorageService;
import com.salesianos.dam.StudentGoApi.utils.MediaTypeUrlResource;
import lombok.RequiredArgsConstructor;
import org.apache.coyote.BadRequestException;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping("/city")
public class CityController {

    private final CityRepository cityRepository;
    private final StorageService storageService;

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/{name}")
    public ResponseEntity<City> addCity(@PathVariable("name") String name, @RequestPart("file") MultipartFile file) {

        FileResponse response = uploadFile(file);
        City city = new City();
        city.setName(name);
        city.setPhotoUrl(file.getOriginalFilename());
        City saved = cityRepository.save(city);

        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(saved.getId()).toUri();

        return ResponseEntity.created(createdURI).body(city);
    }

    @PostMapping("/upload/{id}")
    public ResponseEntity<?> upload(@RequestPart("file") MultipartFile file, @PathVariable("id") Long cityId) {

        FileResponse response = uploadFile(file);
        City city = cityRepository.findById(cityId).orElseThrow(() -> new NotFoundException("City"));
        city.setPhotoUrl(file.getOriginalFilename());
        cityRepository.save(city);

        return ResponseEntity.created(URI.create(response.getUri())).body(response);
    }

    private FileResponse uploadFile(MultipartFile file) {
        String name = storageService.store(file);
        System.out.println(file.getContentType());
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

    @GetMapping("/download-photo/{id}")
    public ResponseEntity<Resource> getFile(@PathVariable("id") Long id){

        City city = cityRepository.findById(id).orElseThrow(() -> new NotFoundException("City"));

        MediaTypeUrlResource resource =
                (MediaTypeUrlResource) storageService.loadAsResource(city.getPhotoUrl());

        return ResponseEntity.status(HttpStatus.OK)
                .header("Content-Type", resource.getType())
                .body(resource);
    }

    @GetMapping("/all")
    public ResponseEntity<List<City>> getAllCities(){
        List<City> all = cityRepository.findAll();
        return ResponseEntity.ok(all);
    }

    @GetMapping("/{id}")
    public ResponseEntity<City> getCity(@PathVariable("id") Long id){
        return ResponseEntity.ok(cityRepository.findById(id).orElseThrow(() -> new NotFoundException("City")));
    }

    @PutMapping("/{id}/name/{name}")
    public City editCity(@PathVariable("id") Long id, @PathVariable("name") String name, @RequestPart(value = "file", required = false) MultipartFile file) throws BadRequestException {
        FileResponse response;
        City city = cityRepository.findById(id).orElseThrow(() -> new NotFoundException("City"));
        city.setName(name);
        if(file != null){
            response = uploadFile(file);
            city.setPhotoUrl(file.getOriginalFilename());
        } else{
            if(city.getPhotoUrl() == null){
                throw new BadRequestException("'file' is not present");
            }
        }


        return cityRepository.save(city);
    }
}
