-- EXTRA 1: oldest students first.
SELECT name, age FROM students ORDER BY age DESC;

-- EXTRA 2: students aged 18 to 21.
SELECT name, age FROM students WHERE age BETWEEN 18 AND 21;

-- EXTRA 3: names that start with A.
SELECT name FROM students WHERE name LIKE 'A%';

-- EXTRA 4: average, youngest and oldest age per course.
SELECT courses.course_name,
       COUNT(students.id) AS students,
       AVG(students.age)  AS average_age,
       MIN(students.age)  AS youngest,
       MAX(students.age)  AS oldest
FROM courses
         LEFT JOIN students ON students.course_id = courses.course_id
GROUP BY courses.course_id, courses.course_name;

-- EXTRA 5: courses with at least 2 students.
SELECT courses.course_name, COUNT(students.id) AS student_count
FROM courses
         JOIN students ON students.course_id = courses.course_id
GROUP BY courses.course_id, courses.course_name
HAVING COUNT(students.id) >= 2;

-- EXTRA 6: courses that have no students.
SELECT courses.course_name
FROM courses
         LEFT JOIN students ON students.course_id = courses.course_id
WHERE students.id IS NULL;

-- EXTRA 7: each student with the credits of their course.
SELECT students.name, courses.credits
FROM students
         JOIN courses ON students.course_id = courses.course_id
ORDER BY courses.credits DESC, students.name;

-- EXTRA 8: a transaction that is rolled back (nothing changes).
BEGIN;
UPDATE students SET age = 99 WHERE id = 1;
SELECT name, age FROM students WHERE id = 1;
ROLLBACK;
SELECT name, age FROM students WHERE id = 1;