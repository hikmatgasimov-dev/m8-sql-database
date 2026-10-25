PRAGMA foreign_keys = ON;

-- TODO 1:
-- Select all courses.
SELECT * FROM courses;


-- TODO 2:
-- Select all students.

SELECT * FROM students;

-- TODO 3:
-- Select students older than 20.
-- Hint: use WHERE.

SELECT * FROM students WHERE age > 20;


-- TODO 4:
-- Show student names together with course names.
-- Show: student name, email, age and course name.
-- Hint: use JOIN ... ON students.course_id = courses.course_id

SELECT students.name, students.email, students.age, courses.course_name
FROM students
         JOIN courses ON students.course_id = courses.course_id;

-- TODO 5:
-- Count how many students are in each course.
-- Courses with 0 students should also be shown.
-- Hint: use COUNT, LEFT JOIN and GROUP BY.
SELECT courses.course_name, COUNT(students.id) AS student_count
FROM courses
         LEFT JOIN students ON students.course_id = courses.course_id
GROUP BY courses.course_id, courses.course_name;


-- TODO 6:
-- Update the first student's age.
-- Then select that student to check the update.
-- Hint: use UPDATE ... SET ... WHERE ...

UPDATE students SET age = 20 WHERE id = 1;

SELECT * FROM students WHERE id = 1;

-- TODO 7:
-- Move the second student to a different course.
-- Then check the update using JOIN to show the new course name.

UPDATE students SET course_id = 3 WHERE id = 2;

SELECT students.id, students.name, courses.course_name
FROM students
         JOIN courses ON students.course_id = courses.course_id
WHERE students.id = 2;

-- TODO 8:
-- Delete one student.
-- Hint: do not forget the WHERE clause, or every student will be deleted!

DELETE FROM students WHERE id = 5;

-- TODO 9:
-- Check the final result.
-- Show id, name, email, age and course name for every student, ordered by id.
-- Hint: use JOIN and ORDER BY.

SELECT students.id, students.name, students.email, students.age, courses.course_name
FROM students
         JOIN courses ON students.course_id = courses.course_id
ORDER BY students.id;

