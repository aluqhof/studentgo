# StudentGo

StudentGo is an application designed to foster social activities among students, helping them connect through events that match their interests. The project is divided into a mobile app for students and a web dashboard for administrators and organizers.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Project Structure](#project-structure)
3. [Login Credentials](#login-credentials)
4. [Usage](#usage)
5. [Testing Endpoints](#testing-endpoints)

## Getting Started

Follow these steps to set up and run the StudentGo project.

### Clone the Repository

First, clone the repository:

```bash
git clone <repository-url>
cd studentgo
```

### Set Up the API

Navigate to the API directory and start the database using Docker:

```bash
cd api
docker-compose up
```

Next, go to the StudentGoApi directory and run the Spring Boot application:

```bash
cd StudentGoApi
mvn clean install
mvn spring-boot:run
```

Make sure you have Java 17 installed as the project requires it.

### Set Up the Flutter App

Navigate to the mobile directory, install the dependencies, and run the Flutter application:

```bash
cd ../mobile/student_go
flutter pub get
flutter run
```

Open your simulator to ensure the app can make requests to the API correctly.

### Set Up the Web Dashboard

Navigate to the web dashboard directory, install the dependencies, and start the Angular application:

```bash
cd ../../student-go-web
npm install
npm start
```

## Project Structure
- **`api`**: Contains the Docker setup for the database and the Postman Collection.
- **`StudentGoApi`**: Contains the backend API built with Spring Boot.
- **`mobile/student_go`**: Contains the Flutter mobile application.
- **`student-go-web`**: Contains the Angular web platform and dashboard.

## Login Credentials

To log in to platform, use the following credentials:

**Admin:**
- Username: admin
- Password: admin1

**Organizer:**
- Username: organizer1
- Password: user1234

**Student:**
- Username: student1
- Password: user1234

## Usage

### Mobile App

The mobile app is designed exclusively for students. It allows students to:

- Interact with upcoming events
- View events that match their interests
- Use an interactive map to see all events in their city
- Use a calendar to keep track of events
- Participate in events by purchasing a ticket with a unique QR code
- Save events for future reference

> Note: Only the credentials for student users are valid in the mobile app at the moment.

### Web Dashboard Functionalities

The web dashboard allows:

- Administrators to manage all entities within the app
- Organizers to create and edit events, and view user purchases

### Testing Endpoints

You can test the API endpoints using the Postman collection provided in the `api` directory. Import the collection into Postman to start testing the endpoints.

## Conclusion

StudentGo helps students stay entertained and connected through events tailored to their interests, organized by city. While the mobile app is currently focused on students, the web dashboard provides extensive functionalities for administrators and organizers.

Feel free to contribute to the project by submitting issues or pull requests. Enjoy using StudentGo!
