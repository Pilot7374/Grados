DROP TABLE IF EXISTS people;

CREATE TABLE people (
    person_id INT AUTO_INCREMENT,
    dni CHAR(9) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(150) NOT NULL,
    age TINYINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    PRIMARY KEY (person_id)
);

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS professors;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE professors (
    professor_id INT,
    category VARCHAR(30) NOT NULL,
    PRIMARY KEY (professor_id),
    FOREIGN KEY (professor_id) REFERENCES people(person_id)
);


CREATE TABLE students (
    student_id INT,
    access_method VARCHAR(20) NOT NULL,
    PRIMARY KEY (student_id),
    FOREIGN KEY (student_id) REFERENCES people(person_id)
);

CREATE TABLE degrees (
    degree_id INT AUTO_INCREMENT,
    degree_name VARCHAR(80) NOT NULL,
    duration_years TINYINT NOT NULL,
    PRIMARY KEY (degree_id)
);

CREATE TABLE subjects (
    subject_id INT AUTO_INCREMENT,
    degree_id INT NOT NULL,
    subject_name VARCHAR(120) NOT NULL,
    acronym VARCHAR(12) NOT NULL,
    credits TINYINT NOT NULL,
    course TINYINT NOT NULL,
    subject_type VARCHAR(30) NOT NULL,
    PRIMARY KEY (subject_id),
    FOREIGN KEY (degree_id) REFERENCES degrees(degree_id)
);
