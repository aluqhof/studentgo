package com.salesianos.dam.StudentGoApi.repository;

import com.salesianos.dam.StudentGoApi.model.Post;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PostRepository extends JpaRepository<Post, Long> {
}
