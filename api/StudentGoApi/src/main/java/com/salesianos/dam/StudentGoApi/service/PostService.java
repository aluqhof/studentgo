package com.salesianos.dam.StudentGoApi.service;

import com.salesianos.dam.StudentGoApi.dto.file.post.CreatePostDto;
import com.salesianos.dam.StudentGoApi.model.Post;
import com.salesianos.dam.StudentGoApi.repository.PostRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PostService {

    private final PostRepository repository;
    private final StorageService storageService;

    @Transactional
    public Post save(CreatePostDto createPostDto, MultipartFile file) {
        String filename = storageService.store(file);

        return repository.save(
                Post.builder()
                        .title(createPostDto.getTitle())
                        .image(filename)
                        .build()
        );
    }

    public List<Post> findAll() { return repository.findAll(); }




}
