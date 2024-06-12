package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.dto.event.EventViewResponse;
import com.salesianos.dam.StudentGoApi.dto.file.response.FileResponse;
import com.salesianos.dam.StudentGoApi.exception.FileTypeException;
import com.salesianos.dam.StudentGoApi.exception.NotFoundException;
import com.salesianos.dam.StudentGoApi.model.City;
import com.salesianos.dam.StudentGoApi.repository.CityRepository;
import com.salesianos.dam.StudentGoApi.service.StorageService;
import com.salesianos.dam.StudentGoApi.utils.MediaTypeUrlResource;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
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
@Tag(name = "City", description = "The city controller has different methods to obtain various information " +
        "about the cities, such as methods for create, edit....")
public class CityController {

    private final CityRepository cityRepository;
    private final StorageService storageService;

    @Operation(summary = "Add a city (Only Admin)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201 Created", description = "The city was created successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = City.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                         "id": 4,
                                         "name": "Málaga",
                                         "photoUrl": "malaga.png"
                                     }
                                                                        """)})}),
            @ApiResponse(responseCode = "400 Bad Request", description = "The creation was not successful", content = @Content),
    })
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

    @Operation(summary = "Add a photo for a city (Only Admin)")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201 Created", description = "The image was uploaded successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = FileResponse.class)), examples = {
                            @ExampleObject(value = """
                                    {
                                        "name": "logo-navbar-blue_596356.png",
                                        "uri": "http://localhost:8080/download/logo-navbar-blue_596356.png",
                                        "type": "image/png",
                                        "size": 9306
                                    }
                                                                        """)})}),
            @ApiResponse(responseCode = "400 Bad Request", description = "The upload was not successfully", content = @Content),
    })
    @PreAuthorize("hasRole('ADMIN')")
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

    @Operation(summary = "Download a photo from a specific city")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The image was downloaded successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = MediaTypeUrlResource.class)))}),
            @ApiResponse(responseCode = "404 Not Found", description = "The image was not found", content = @Content),
    })
    @GetMapping("/download-photo/{id}")
    public ResponseEntity<Resource> getFile(@PathVariable("id") Long id){

        City city = cityRepository.findById(id).orElseThrow(() -> new NotFoundException("City"));

        MediaTypeUrlResource resource =
                (MediaTypeUrlResource) storageService.loadAsResource(city.getPhotoUrl());

        return ResponseEntity.status(HttpStatus.OK)
                .header("Content-Type", resource.getType())
                .body(resource);
    }

    @Operation(summary = "Retrieves a list from all cities")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The list was provided successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = City[].class)), examples = {
                            @ExampleObject(value = """
                                    [
                                         {
                                             "id": 1,
                                             "name": "Sevilla",
                                             "photoUrl": "sevilla.jpg"
                                         },
                                         {
                                             "id": 2,
                                             "name": "Köln",
                                             "photoUrl": "koeln.jpg"
                                         },
                                         {
                                             "id": 3,
                                             "name": "Madrid",
                                             "photoUrl": "madrid.jpg"
                                         },
                                     ]
                                                                        """)})}),
    })
    @GetMapping("/all")
    public ResponseEntity<List<City>> getAllCities(){
        List<City> all = cityRepository.findAll();
        return ResponseEntity.ok(all);
    }

    @Operation(summary = "Retrieves a city")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The city was provided successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = City.class)), examples = {
                            @ExampleObject(value = """
                                         {
                                             "id": 1,
                                             "name": "Sevilla",
                                             "photoUrl": "sevilla.jpg"
                                         }
                                                                        """)})}),
    })
    @GetMapping("/{id}")
    public ResponseEntity<City> getCity(@PathVariable("id") Long id){
        return ResponseEntity.ok(cityRepository.findById(id).orElseThrow(() -> new NotFoundException("City")));
    }

    @Operation(summary = "Edits a city")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200 OK", description = "The city was edited successfully", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = City.class)), examples = {
                            @ExampleObject(value = """
                                         {
                                             "id": 1,
                                             "name": "Seville",
                                             "photoUrl": "sevilla.jpg"
                                         }
                                                                        """)})}),
            @ApiResponse(responseCode = "404 Not Found", description = "The city was not found", content = @Content),
    })
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
