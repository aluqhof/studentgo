package com.salesianos.dam.StudentGoApi;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
public class StudentGoApiApplication {

	public static void main(String[] args) {
		SpringApplication.run(StudentGoApiApplication.class, args);
	}

}
