# Student Database Practice Project

This project is a simple Maven + SQLite project for practicing basic database functionality.

You will work with two tables:

1. `courses`
2. `students`

The `students` table has a foreign key that connects each student to a course.

```text
students.course_id → courses.course_id
```

This means every student must belong to an existing course.

---

## Project Structure

Your project should look like this:

```text
student-db-test/
│
├── pom.xml
├── README.md
│
├── student.db
│
└── src/
    └── main/
        ├── java/
        │   └── com/
        │       └── example/
        │           └── DatabaseDemo.java
        │
        └── resources/
            ├── create.sql
            ├── insert.sql
            ├── query.sql
            └── xtra.sql
```

The file `student.db` is the SQLite database file. It is created automatically when the Java program runs.

---

## Files You Will Use

### `create.sql`

This file creates the database tables.

---

### `insert.sql`

This file inserts data into the tables.

---

### `query.sql`

This file is used to practice database queries.

---

### `xtra.sql`

This file is used to test database errors.

---

## How to Run the Project

Run the program by right-clicking on DatabaseDemo class and choosing: `Run DatabaseDemo.main()`

The program will run these files in order:

```text
create.sql
insert.sql
query.sql
```

The output will be printed in the terminal.

---

## How to Test Errors

The file `xtra.sql` is not run automatically.

To run it, open `DatabaseDemo.java` and find this line:

```java
// runSqlFile(connection, "xtra.sql");
```

Remove the `//` so it becomes:

```java
runSqlFile(connection, "xtra.sql");
```

Then run the program again.

You should see error messages in the terminal.

After testing errors, you can comment the line again:

```java
// runSqlFile(connection, "xtra.sql");
```

---

## Student Tasks

### Part 1: `create.sql`

Complete the table creation.

Checklist:

* Create a `courses` table.
* Create a `students` table.
* Add a 'primary key' to both tables.
* Add a 'foreign key' from `students.course_id` to `courses.course_id`.
* Make student 'name' required.
* Make student 'email' required and unique.
* Make student 'age' 18 or older.
* Make course 'name' required.
* Make course 'credits' greater than 0.

---

### Part 2: `insert.sql`

Insert data into the tables.

Checklist:

* Insert course data first.
* Insert 3 courses.
* Insert 5 students.
  * Make sure all students are at least 18 years old.
  * Make sure all emails are unique.
  * Make sure every student uses a valid course ID.

---

### Part 3: `query.sql`

Practice SQL queries.

Checklist:

* Select all courses.
* Select all students.
* Select students older than 20.
* Show students with their course names using `JOIN`.
* Count students in each course.
* Update one student's age.
* Update one student's course.
* Delete one student.
* Show the final result.

---

### Part 4: `xtra.sql`

Run each error example one by one.

For every error, examine the output

---

## Resetting the Database

Every time the program runs, `create.sql` drops and recreates the tables.

This means old data is removed and fresh data is inserted again.

---

## Common Problems

### Problem: Foreign key error

This means you tried to insert a student with a `course_id` that does not exist in the `courses` table.

Fix it by using a valid `course_id`.

---

### Problem: UNIQUE constraint failed

This means you inserted an email that already exists.

Fix it by using a different email.

---

### Problem: CHECK constraint failed

This means you inserted an invalid value.

For example, student age must be 18 or older.

---

### Problem: NOT NULL constraint failed

This means a required value was missing.

For example, student name and email cannot be null.

---

## Learning Goals

By completing this project, you will learn how to:

* create database tables
* use primary keys
* use foreign keys
* insert data
* select data
* join two tables
* update records
* delete records
* understand database error messages



---

## My results

### Final student list (after the update and delete queries)

| id | name | email | age | course |
|---|---|---|---|---|
| 1 | Anna Berzina | anna.berzina@example.com | 20 | Java Fundamentals |
| 2 | Janis Ozols | janis.ozols@example.com | 22 | Web Development |
| 3 | Liga Kalnina | liga.kalnina@example.com | 21 | Databases |
| 4 | Peteris Liepa | peteris.liepa@example.com | 18 | Databases |

### Students per course (before the delete)

| course | students |
|---|---|
| Java Fundamentals | 2 |
| Databases | 3 |
| Web Development | 0 |

### Error tests

| Test | Error message |
|---|---|
| Foreign key (course_id 999) | `FOREIGN KEY constraint failed` |
| Duplicate id | `UNIQUE constraint failed: students.id` |
| Duplicate email | `UNIQUE constraint failed: students.email` |
| NULL name | `NOT NULL constraint failed: students.name` |
| Age 12 | `CHECK constraint failed: age >= 18` |
| Missing table | `no such table: teachers` |
| Missing column | `no such column: phone_number` |

### What I learned

- A foreign key stops a student from pointing to a course that does not exist.
- `LEFT JOIN` keeps courses that have no students, so `COUNT` can show 0.
- `UPDATE` and `DELETE` need a `WHERE` clause, or they change every row.
- Constraints (`NOT NULL`, `UNIQUE`, `CHECK`) are enforced by the database, not by Java.


## Additional queries (`extra.sql`)

Extra practice beyond the exercise. It runs after `query.sql`.

**Part A, on the exercise tables:** sorting (`ORDER BY`), ranges (`BETWEEN`), text search (`LIKE`),
aggregates (`AVG`, `MIN`, `MAX`), group filters (`HAVING`), rows without a match (`LEFT JOIN ... IS NULL`),
a subquery, `CASE`, `GROUP_CONCAT`, percentages and a window function (`RANK`).
A transaction that is rolled back shows atomicity: the age is 99 inside it and 20 again afterwards.

**Part B, a bigger design:** a `teachers` table linked to `courses` with a foreign key, and an `enrollments`
table that links students and courses (many-to-many, with a grade). It adds a three-table join, a view,
an index, `ON DELETE CASCADE` and a committed transaction. The new tables are dropped at the end of the
file, so the main exercise can run again from a clean database.

Notes:
- "Courses that have no students" returns no rows, because every course has a student after the update.
- `extra.sql` must run after `query.sql` (see `DatabaseDemo.java`).
- If a run is ever stopped halfway, delete `student.db` and run again.