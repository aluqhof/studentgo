package com.salesianos.dam.StudentGoApi.controller;

import com.salesianos.dam.StudentGoApi.dto.file.response.FileResponse;
import com.salesianos.dam.StudentGoApi.exception.FileTypeException;
import com.salesianos.dam.StudentGoApi.service.StorageService;
import com.salesianos.dam.StudentGoApi.utils.MediaTypeUrlResource;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

@RestController
@RequiredArgsConstructor
public class FileController {

    private final StorageService storageService;



    @PostMapping("/upload/files")
    public ResponseEntity<?> upload(@RequestPart("files") MultipartFile[] files) {

        List<FileResponse> result = Arrays.stream(files)
                .map(this::uploadFile)
                .toList();

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(result);
    }


    @PostMapping("/upload")
    public ResponseEntity<?> upload(@RequestPart("file") MultipartFile file) {

        FileResponse response = uploadFile(file);

        if (!Objects.requireNonNull(file.getContentType()).startsWith("image/")) {
            throw new FileTypeException("The file must be of type image");
        }

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


    @GetMapping("/download/{filename:.+}")
    public ResponseEntity<Resource> getFile(@PathVariable String filename){
        MediaTypeUrlResource resource =
                (MediaTypeUrlResource) storageService.loadAsResource(filename);

        return ResponseEntity.status(HttpStatus.OK)
                .header("Content-Type", resource.getType())
                .body(resource);
    }

}
