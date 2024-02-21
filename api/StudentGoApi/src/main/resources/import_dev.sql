INSERT INTO user_default (id, username, password, email, name, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at) VALUES ('c62db400-22e3-4e92-94db-1447f5688f2c', 'admin', '{bcrypt}$2a$10$4zcpWiElBDO8KELG3JE37ukgcCVfrdYeDd2i.F3MEioTkHFIfcqfK', 'admin@admin.com', 'admin',  true, true, true, true, current_timestamp, current_timestamp);--admin
INSERT INTO user_default (id, username, password, email, name, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at) VALUES ('04d0595e-45d5-4f63-8b53-1d79e9d84a5d', 'student1', '{bcrypt}$2a$10$pWJK9KslilCl0HcW5eVKOOdRd8AHuwymd0kze.WvLXM/kQVdKNRi.', 'student1@student.com', 'Student 1', true, true, true, true, current_timestamp, current_timestamp);--user1234
INSERT INTO user_default (id, username, password, email, name, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at) VALUES ('e010f144-b376-4dbb-933d-b3ec8332ed0d', 'student2', '{bcrypt}$2a$10$pWJK9KslilCl0HcW5eVKOOdRd8AHuwymd0kze.WvLXM/kQVdKNRi.', 'student2@student.com', 'Student 2', true, true, true, true, current_timestamp, current_timestamp);
INSERT INTO user_default (id, username, password, email, name, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at) VALUES ('5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2', 'organizer1', '{bcrypt}$2a$10$pWJK9KslilCl0HcW5eVKOOdRd8AHuwymd0kze.WvLXM/kQVdKNRi.', 'organizer1@organizer.com', 'Organizer 1', true, true, true, true, current_timestamp, current_timestamp);

INSERT INTO admin (id) VALUES ('c62db400-22e3-4e92-94db-1447f5688f2c');

INSERT INTO student (id, description) VALUES ('04d0595e-45d5-4f63-8b53-1d79e9d84a5d', 'Soy una persona extrovertida');
INSERT INTO student (id, description) VALUES ('e010f144-b376-4dbb-933d-b3ec8332ed0d', 'Soy una persona introvertida');

INSERT INTO organizer (id, description, business) VALUES ('5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2', 'Soy un empresario exitoso', 'Nike');

INSERT INTO event_type (id, name) VALUES (1, 'Sports');
INSERT INTO event_type (id, name) VALUES (2, 'Music');
INSERT INTO event_type (id, name) VALUES (3, 'Food');
INSERT INTO event_type (id, name) VALUES (4, 'Gaming');

INSERT INTO student_event_type (student_id, event_type_id) VALUES ('04d0595e-45d5-4f63-8b53-1d79e9d84a5d', 1);
INSERT INTO student_event_type (student_id, event_type_id) VALUES ('04d0595e-45d5-4f63-8b53-1d79e9d84a5d', 2);
INSERT INTO student_event_type (student_id, event_type_id) VALUES ('04d0595e-45d5-4f63-8b53-1d79e9d84a5d', 3);
INSERT INTO student_event_type (student_id, event_type_id) VALUES ('e010f144-b376-4dbb-933d-b3ec8332ed0d', 1);
INSERT INTO student_event_type (student_id, event_type_id) VALUES ('e010f144-b376-4dbb-933d-b3ec8332ed0d', 4);

INSERT INTO event (id, name, latitude, longitude, description, date_time, author) VALUES ('9d782609-1b54-4cee-ad3d-5ce678be376d', 'Torneo de Fútbol 7', 37.38283, -5.97317, 'Algo guapo', current_timestamp, '5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2');
INSERT INTO event (id, name, latitude, longitude, description, date_time, author) VALUES ('f13a8a04-afe2-4b12-a279-91b3e365073b', 'Degustación en grupo', 37.3824023, -5.99631554987113, 'Algo guapo', current_timestamp, '5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2');
INSERT INTO event (id, name, latitude, longitude, description, date_time, author) VALUES ('62feb988-886b-44ad-ac0b-43acd928a7c3', 'Torneo de fifa por parejas', 37.386207, -5.99255572619863, 'Algo guapo', current_timestamp, '5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2');

INSERT INTO event_event_type (event_id, event_type_id) VALUES ('9d782609-1b54-4cee-ad3d-5ce678be376d', 1);
INSERT INTO event_event_type (event_id, event_type_id) VALUES ('f13a8a04-afe2-4b12-a279-91b3e365073b', 3);
INSERT INTO event_event_type (event_id, event_type_id) VALUES ('f13a8a04-afe2-4b12-a279-91b3e365073b', 2);
INSERT INTO event_event_type (event_id, event_type_id) VALUES ('62feb988-886b-44ad-ac0b-43acd928a7c3', 4);