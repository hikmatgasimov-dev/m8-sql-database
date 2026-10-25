-- Note: (SELECT MIN(course_id) FROM courses) picks a course that exists,
-- so each example fails only because of the error it is testing.

-- ERROR 1:
-- Duplicate primary key.
-- Uses the id of a student that already exists.
INSERT INTO students (id, name, email, age, course_id)
VALUES ((SELECT MIN(id) FROM students), 'Duplicate ID Student', 'duplicateid@example.com', 20, (SELECT MIN(course_id) FROM courses));

-- ERROR 2:
-- Duplicate email.
-- Uses the email of a student that already exists.
INSERT INTO students (id, name, email, age, course_id)
VALUES (10, 'Duplicate Email Student', (SELECT email FROM students LIMIT 1), 20, (SELECT MIN(course_id) FROM courses));

-- ERROR 3:
-- NOT NULL constraint.
-- name cannot be NULL.
INSERT INTO students (id, name, email, age, course_id)
VALUES (11, NULL, 'noname@example.com', 20, (SELECT MIN(course_id) FROM courses));

-- ERROR 4:
-- CHECK constraint.
-- age must be 18 or older.
INSERT INTO students (id, name, email, age, course_id)
VALUES (12, 'Too Young Student', 'young@example.com', 12, (SELECT MIN(course_id) FROM courses));

-- ERROR 5:
-- Table does not exist.
SELECT * FROM teachers;

-- ERROR 6:
-- Column does not exist.
SELECT phone_number FROM students;
