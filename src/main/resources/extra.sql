PRAGMA foreign_keys = ON;


-- PART A: more queries on the exercise tables (courses, students)
-- These run after query.sql, so the data is the final result of that file.


-- EXTRA 1: oldest students first.
SELECT name, age FROM students ORDER BY age DESC;

-- EXTRA 2: students aged 18 to 21.
SELECT name, age FROM students WHERE age BETWEEN 18 AND 21;

-- EXTRA 3: names that start with A.
SELECT name FROM students WHERE name LIKE 'A%';

-- EXTRA 4: average, youngest and oldest age per course (courses without students are kept).
SELECT courses.course_name,
       COUNT(students.id)           AS students,
       ROUND(AVG(students.age), 1)  AS average_age,
       MIN(students.age)            AS youngest,
       MAX(students.age)            AS oldest
FROM courses
         LEFT JOIN students ON students.course_id = courses.course_id
GROUP BY courses.course_id, courses.course_name;

-- EXTRA 5: courses with at least 2 students (HAVING filters after grouping).
SELECT courses.course_name, COUNT(students.id) AS student_count
FROM courses
         JOIN students ON students.course_id = courses.course_id
GROUP BY courses.course_id, courses.course_name
HAVING COUNT(students.id) >= 2;

-- EXTRA 6: courses that have no students (LEFT JOIN plus IS NULL).
SELECT courses.course_name
FROM courses
         LEFT JOIN students ON students.course_id = courses.course_id
WHERE students.id IS NULL;

-- EXTRA 7: students older than the average age (subquery).
SELECT name, age FROM students WHERE age > (SELECT AVG(age) FROM students);

-- EXTRA 8: age groups with CASE.
SELECT name, age,
       CASE
           WHEN age < 20 THEN 'under 20'
           WHEN age BETWEEN 20 AND 21 THEN '20 to 21'
           ELSE '22 and over'
           END AS age_group
FROM students
ORDER BY age;

-- EXTRA 9: the students of each course in one line (GROUP_CONCAT).
SELECT courses.course_name, GROUP_CONCAT(students.name, ', ') AS student_names
FROM courses
         LEFT JOIN students ON students.course_id = courses.course_id
GROUP BY courses.course_id, courses.course_name;

-- EXTRA 10: share of students per course in percent (subquery in the calculation).
SELECT courses.course_name,
       COUNT(students.id) AS students,
       ROUND(100.0 * COUNT(students.id) / (SELECT COUNT(*) FROM students), 1) AS percent_of_all
FROM courses
         LEFT JOIN students ON students.course_id = courses.course_id
GROUP BY courses.course_id, courses.course_name;

-- EXTRA 11: rank students by age inside each course (window function).
SELECT courses.course_name, students.name, students.age,
       RANK() OVER (PARTITION BY students.course_id ORDER BY students.age DESC) AS rank_in_course
FROM students
         JOIN courses ON students.course_id = courses.course_id
ORDER BY courses.course_name, rank_in_course;

-- EXTRA 12: a transaction that is rolled back (nothing changes).
BEGIN;
UPDATE students SET age = 99 WHERE id = 1;
SELECT name, age FROM students WHERE id = 1;
ROLLBACK;
SELECT name, age FROM students WHERE id = 1;

-- ============================================================
-- PART B: a bigger design with new tables (teachers and enrollments)
-- The tables are removed at the end of this file, so the exercise can run again.
-- ============================================================

DROP VIEW IF EXISTS course_summary;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS teachers;

-- EXTRA 13: a teachers table, and every course gets an optional teacher (foreign key).
CREATE TABLE teachers (
                          teacher_id INTEGER PRIMARY KEY,
                          name       TEXT NOT NULL,
                          email      TEXT NOT NULL UNIQUE
);

ALTER TABLE courses ADD COLUMN teacher_id INTEGER REFERENCES teachers (teacher_id);

-- EXTRA 14: many-to-many. One student can take many courses and one course has many students.
CREATE TABLE enrollments (
                             student_id INTEGER NOT NULL,
                             course_id  INTEGER NOT NULL,
                             grade      INTEGER CHECK (grade BETWEEN 1 AND 10),
                             PRIMARY KEY (student_id, course_id),
                             FOREIGN KEY (student_id) REFERENCES students (id) ON DELETE CASCADE,
                             FOREIGN KEY (course_id)  REFERENCES courses (course_id) ON DELETE CASCADE
);

INSERT INTO teachers (teacher_id, name, email) VALUES
                                                   (1, 'Dr. Ozolina', 'ozolina@example.com'),
                                                   (2, 'Mr. Kalns', 'kalns@example.com');

UPDATE courses SET teacher_id = 1 WHERE course_id IN (1, 2);
UPDATE courses SET teacher_id = 2 WHERE course_id = 3;

INSERT INTO enrollments (student_id, course_id, grade) VALUES
                                                           (1, 1, 9),
                                                           (1, 3, 8),
                                                           (2, 3, 7),
                                                           (3, 2, 10),
                                                           (3, 1, 6),
                                                           (4, 2, 5),
                                                           (4, 3, NULL);

-- EXTRA 15: a join across three tables (student, course, teacher).
SELECT students.name AS student, courses.course_name, teachers.name AS teacher, enrollments.grade
FROM enrollments
         JOIN students ON students.id = enrollments.student_id
         JOIN courses  ON courses.course_id = enrollments.course_id
         LEFT JOIN teachers ON teachers.teacher_id = courses.teacher_id
ORDER BY students.name, courses.course_name;

-- EXTRA 16: average grade per student, best first. AVG ignores the missing grade.
SELECT students.name, COUNT(enrollments.course_id) AS courses_taken, ROUND(AVG(enrollments.grade), 1) AS average_grade
FROM students
         LEFT JOIN enrollments ON enrollments.student_id = students.id
GROUP BY students.id, students.name
ORDER BY average_grade DESC;

-- EXTRA 17: grade labels with CASE, and a missing grade shown as text.
SELECT students.name, courses.course_name,
       CASE
           WHEN enrollments.grade IS NULL THEN 'not graded'
           WHEN enrollments.grade >= 9 THEN 'excellent'
           WHEN enrollments.grade >= 6 THEN 'good'
           ELSE 'needs work'
           END AS result
FROM enrollments
         JOIN students ON students.id = enrollments.student_id
         JOIN courses  ON courses.course_id = enrollments.course_id
ORDER BY students.name, courses.course_name;

-- EXTRA 18: a view that hides the joins.
CREATE VIEW course_summary AS
SELECT courses.course_name, teachers.name AS teacher,
       COUNT(enrollments.student_id) AS enrolled, ROUND(AVG(enrollments.grade), 1) AS average_grade
FROM courses
         LEFT JOIN teachers ON teachers.teacher_id = courses.teacher_id
         LEFT JOIN enrollments ON enrollments.course_id = courses.course_id
GROUP BY courses.course_id, courses.course_name, teachers.name;

SELECT * FROM course_summary ORDER BY course_name;

-- EXTRA 19: an index to speed up searches by course.
CREATE INDEX IF NOT EXISTS idx_enrollments_course ON enrollments (course_id);

-- EXTRA 20: ON DELETE CASCADE. Deleting a student also removes the student's enrollments.
SELECT COUNT(*) AS enrollments_before FROM enrollments;
DELETE FROM students WHERE id = 4;
SELECT COUNT(*) AS enrollments_after FROM enrollments;

-- EXTRA 21: a transaction that is committed.
BEGIN;
UPDATE enrollments SET grade = 10 WHERE student_id = 2 AND course_id = 3;
INSERT INTO enrollments (student_id, course_id, grade) VALUES (2, 1, 8);
COMMIT;
SELECT * FROM enrollments WHERE student_id = 2;

-- EXTRA 22: clean up, so create.sql can drop and recreate its tables on the next run.
UPDATE courses SET teacher_id = NULL;
DROP VIEW IF EXISTS course_summary;
DROP INDEX IF EXISTS idx_enrollments_course;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS teachers;