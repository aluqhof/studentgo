INSERT INTO user_default (id, username, password, email, name, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at) VALUES ('c62db400-22e3-4e92-94db-1447f5688f2c', 'admin', '{bcrypt}$2a$10$4zcpWiElBDO8KELG3JE37ukgcCVfrdYeDd2i.F3MEioTkHFIfcqfK', 'admin@admin.com', 'admin',  true, true, true, true, current_timestamp, current_timestamp);--admin
INSERT INTO user_default (id, username, password, email, name, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at) VALUES ('04d0595e-45d5-4f63-8b53-1d79e9d84a5d', 'student1', '{bcrypt}$2a$10$pWJK9KslilCl0HcW5eVKOOdRd8AHuwymd0kze.WvLXM/kQVdKNRi.', 'student1@student.com', 'Student 1', true, true, true, true, current_timestamp, current_timestamp);--user1234
INSERT INTO user_default (id, username, password, email, name, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at) VALUES ('e010f144-b376-4dbb-933d-b3ec8332ed0d', 'student2', '{bcrypt}$2a$10$pWJK9KslilCl0HcW5eVKOOdRd8AHuwymd0kze.WvLXM/kQVdKNRi.', 'student2@student.com', 'Student 2', true, true, true, true, current_timestamp, current_timestamp);
INSERT INTO user_default (id, username, password, email, name, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at) VALUES ('5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2', 'organizer1', '{bcrypt}$2a$10$pWJK9KslilCl0HcW5eVKOOdRd8AHuwymd0kze.WvLXM/kQVdKNRi.', 'organizer1@organizer.com', 'Organizer 1', true, true, true, true, current_timestamp, current_timestamp);

INSERT INTO admin (id) VALUES ('c62db400-22e3-4e92-94db-1447f5688f2c');

INSERT INTO student (id, description) VALUES ('04d0595e-45d5-4f63-8b53-1d79e9d84a5d', 'Soy una persona extrovertida');
INSERT INTO student (id, description) VALUES ('e010f144-b376-4dbb-933d-b3ec8332ed0d', 'Soy una persona introvertida');

INSERT INTO organizer (id, description, business) VALUES ('5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2', 'Soy un empresario exitoso', 'Nike');

INSERT INTO event_type (id, name, icon_ref, color_code) VALUES (1, 'Sports', '0xe5e6', '0xfff0635a');
INSERT INTO event_type (id, name, icon_ref, color_code) VALUES (2, 'Music', '0xe415', '0xfff59762');
INSERT INTO event_type (id, name, icon_ref, color_code) VALUES (3, 'Food', '0xe533', '0xff29d697');
INSERT INTO event_type (id, name, icon_ref, color_code) VALUES (4, 'Gaming', '0xe5e8', '0xff46cdfb');

INSERT INTO student_event_type (student_id, event_type_id) VALUES ('04d0595e-45d5-4f63-8b53-1d79e9d84a5d', 1);
INSERT INTO student_event_type (student_id, event_type_id) VALUES ('04d0595e-45d5-4f63-8b53-1d79e9d84a5d', 2);
INSERT INTO student_event_type (student_id, event_type_id) VALUES ('04d0595e-45d5-4f63-8b53-1d79e9d84a5d', 3);
INSERT INTO student_event_type (student_id, event_type_id) VALUES ('e010f144-b376-4dbb-933d-b3ec8332ed0d', 1);
INSERT INTO student_event_type (student_id, event_type_id) VALUES ('e010f144-b376-4dbb-933d-b3ec8332ed0d', 4);

INSERT INTO city (id, name) VALUES (1, 'Sevilla');
INSERT INTO city (id, name) VALUES (2, 'Köln');
INSERT INTO city (id, name) VALUES (3, 'Madrid');

INSERT INTO event (id, name, latitude, longitude, city_id, description, date_time, author) VALUES ('9d782609-1b54-4cee-ad3d-5ce678be376d', 'Torneo de Fútbol 7', 37.38283, -5.97317, 1, 'Algo guapo', current_timestamp, '5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2');
INSERT INTO event (id, name, latitude, longitude, city_id, description, date_time, author) VALUES ('f13a8a04-afe2-4b12-a279-91b3e365073b', 'Degustación en grupo', 37.3824023, -5.99631554987113, 1, 'Algo guapo', current_timestamp, '5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2');
INSERT INTO event (id, name, latitude, longitude, city_id, description, date_time, author) VALUES ('62feb988-886b-44ad-ac0b-43acd928a7c3', 'Torneo de fifa por parejas', 37.386207, -5.99255572619863, 1, 'Algo guapo', current_timestamp, '5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2');
INSERT INTO event (id, name, latitude, longitude, city_id, description, date_time, author) VALUES ('ae56ec32-98bf-4eb6-821d-741a0816b3bf', 'Concierto de la niña pastori', 37.386207, -5.99255572619863, 2, 'Algo guapo', '2024-02-26 08:00:00', '5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2');
INSERT INTO event (id, name, latitude, longitude, city_id, description, date_time, author) VALUES ('39ff97ef-c4e2-4980-92a7-9d67b4d03749', 'Feria de artesanía', 37.3824023, -5.99631554987113, 2, 'Algo guapo', '2024-02-27 10:00:00', '5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2');
INSERT INTO event (id, name, latitude, longitude, city_id, description, date_time, author) VALUES ('2ab0b875-0b9c-4cd6-aa1c-de2dc561e2d0', 'Torneo de futbol', 37.386207, -5.99255572619863, 2, 'Algo guapo', '2024-02-28 15:00:00', '5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2');
INSERT INTO event (id, name, latitude, longitude, city_id, description, date_time, author) VALUES ('d5c3c5de-89d6-4c1f-b0c4-3e1f45d8d2a2', 'Exposición de arte contemporáneo', 37.38283, -5.97317, 2, 'Algo guapo', '2024-03-01 12:00:00', '5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2');
INSERT INTO event (id, name, latitude, longitude, city_id, description, date_time, author) VALUES ('a2f6b827-1042-4a7c-a9c3-84f1356d10c4', 'Festival de música indie', 37.386207, -5.99255572619863, 2, 'Algo guapo', '2024-03-02 18:00:00', '5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2');
INSERT INTO event (id, name, latitude, longitude, city_id, description, date_time, author) VALUES ('9b3ee893-9181-47b8-91fc-63dd16c74f50', 'Conferencia sobre inteligencia artificial', 37.3824023, -5.99631554987113, 2, 'Algo guapo', '2024-03-03 09:00:00', '5cf8b808-3b6e-4d9d-90d5-65c83b0e75b2');

INSERT INTO event_event_type (event_id, event_type_id) VALUES ('9d782609-1b54-4cee-ad3d-5ce678be376d', 1);
INSERT INTO event_event_type (event_id, event_type_id) VALUES ('f13a8a04-afe2-4b12-a279-91b3e365073b', 3);
INSERT INTO event_event_type (event_id, event_type_id) VALUES ('f13a8a04-afe2-4b12-a279-91b3e365073b', 2);
INSERT INTO event_event_type (event_id, event_type_id) VALUES ('62feb988-886b-44ad-ac0b-43acd928a7c3', 4);
INSERT INTO event_event_type (event_id, event_type_id) VALUES ('ae56ec32-98bf-4eb6-821d-741a0816b3bf', 4);
INSERT INTO event_event_type (event_id, event_type_id) VALUES ('39ff97ef-c4e2-4980-92a7-9d67b4d03749', 4);
INSERT INTO event_event_type (event_id, event_type_id) VALUES ('2ab0b875-0b9c-4cd6-aa1c-de2dc561e2d0', 4);
INSERT INTO event_event_type (event_id, event_type_id) VALUES ('d5c3c5de-89d6-4c1f-b0c4-3e1f45d8d2a2', 4);
INSERT INTO event_event_type (event_id, event_type_id) VALUES ('a2f6b827-1042-4a7c-a9c3-84f1356d10c4', 4);
INSERT INTO event_event_type (event_id, event_type_id) VALUES ('9b3ee893-9181-47b8-91fc-63dd16c74f50', 4);