PRAGMA foreign_keys = ON;

-- Delete students first because students depends on courses.
DELETE FROM students;
DELETE FROM courses;

-- TODO 1:
-- Insert 3 courses.
-- Remember:
-- course_id is a number.
-- course_name must be present.
-- credits must be greater than 0.
-- Hint: INSERT INTO table (columns) VALUES (row 1), (row 2), ...


INSERT INTO courses (course_id, course_name, credits) VALUES
                                                          (1, 'Java Fundamentals', 4),
                                                          (2, 'Databases', 3),
                                                          (3, 'Web Development', 5);

-- TODO 2:
-- Insert 5 students.
-- Remember:
-- id is a number.
-- name must be present.
-- email must be unique.
-- age must be 18 or older.
-- course_id must exist in the courses table.


INSERT INTO students (id, name, email, age, course_id) VALUES
                                                           (1, 'Anna Berzina', 'anna.berzina@example.com', 19, 1),
                                                           (2, 'Janis Ozols', 'janis.ozols@example.com', 22, 1),
                                                           (3, 'Liga Kalnina', 'liga.kalnina@example.com', 21, 2),
                                                           (4, 'Peteris Liepa', 'peteris.liepa@example.com', 18, 2),
                                                           (5, 'Marta Egle', 'marta.egle@example.com', 25, 2);



-- TODO 3:
-- Uncomment this to test a foreign key error.
-- This should fail because course_id 999 does not exist.
-- INSERT INTO students (id, name, email, age, course_id)
-- VALUES (6, 'Invalid Course Student', 'invalid@example.com', 20, 999);
