--
-- Autor: David Ruiz
-- Fecha: Octubre de 2026
-- Descripción: Tests negativos para la BD de Grados
-- Se incluye en: iissi1/labs/L5 y AN-B
--
USE grados;

-- =============================================================
-- TABLA DE RESULTADOS
-- Un registro por test: PASS si la operación prohibida se rechazó,
-- FAIL si se permitió
-- =============================================================
CREATE OR REPLACE TABLE test_results (
    test_id VARCHAR(20) PRIMARY KEY,
    test_name VARCHAR(200) NOT NULL,
    test_message VARCHAR(500) NOT NULL,
    test_status ENUM('PASS','FAIL') NOT NULL,
    execution_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================
-- PROCEDIMIENTO AUXILIAR
-- Registra el resultado de un test. El nombre es el texto del mensaje
-- anterior a ':' (SUBSTRING_INDEX), por ejemplo 'RN01'
-- =============================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_log_test(
    IN p_test_id VARCHAR(20),
    IN p_message VARCHAR(500),
    IN p_status ENUM('PASS','FAIL')
)
BEGIN
    INSERT INTO test_results(test_id, test_name, test_message, test_status)
    VALUES (p_test_id, SUBSTRING_INDEX(p_message, ':', 1), p_message, p_status);
END //
DELIMITER ;

-- Los tests de restricciones declarativas (RN01, RN09-RN16) se definen en
-- tests_constraints.sql (L4), que debe ejecutarse antes que este script.

-- =============================================================
-- TESTS DE REGLAS PROCEDURALES (RN02-RN08, RN17)
-- Mismo esquema que en tests_constraints.sql: el handler registra PASS si
-- el trigger rechaza la operación; si no, se llega a la última línea: FAIL
-- =============================================================

-- Test RN02: Un alumno solo puede tener notas en grupos a los que pertenece
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_grade_in_group()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02', 'RN02: No se permite una nota en un grupo al que no pertenece el alumno', 'PASS');

    CALL p_populate();

    -- El alumno 6 está en T1 y L1, pero no en L2 (grupo 3)
    INSERT INTO grades (grade_id, student_id, group_id, grade_value, exam_call, with_honors)
        VALUES (102, 6, 3, 7.0, 'Extraordinaria', 0);

    CALL p_log_test('RN02', 'ERROR: Se permitió una nota en un grupo al que no pertenece el alumno', 'FAIL');
END //
DELIMITER ;

-- Test RN17: No se permiten notas duplicadas por asignatura/convocatoria
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn17_duplicate_grade()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN17', 'RN17: No se permiten notas duplicadas por asignatura/convocatoria', 'PASS');

    CALL p_populate();

    INSERT INTO grades (grade_id, student_id, group_id, grade_value, exam_call, with_honors)
        VALUES (101, 6, 1, 6.0, 'Primera', 0);

    CALL p_log_test('RN17', 'ERROR: Se permitió duplicar nota en la misma convocatoria', 'FAIL');
END //
DELIMITER ;

-- Test RN03: Un grupo no puede tener más de 2 profesores
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn03_professors_per_group()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN03', 'RN03: No se permite añadir un tercer profesor al grupo', 'PASS');

    CALL p_populate();

    INSERT INTO teaching_loads (professor_id, group_id, credits) VALUES (5, 1, 1.0);

    CALL p_log_test('RN03', 'ERROR: Se asignó un tercer profesor al grupo', 'FAIL');
END //
DELIMITER ;

-- Test RN04: Un alumno no puede pertenecer a más de un grupo de teoría y uno de laboratorio por asignatura
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn04_student_group_limit()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN04', 'RN04: Un alumno no puede pertenecer a más grupos de los permitidos', 'PASS');

    CALL p_populate();

    INSERT INTO students_groups (student_id, group_id) VALUES (6, 3);

    CALL p_log_test('RN04', 'ERROR: Se permitió un alumno en más grupos de los permitidos', 'FAIL');
END //
DELIMITER ;

-- Test RN05: Una nota no puede alterarse en más de 4 puntos
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn05_grade_delta()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN05', 'RN05: No se puede modificar la nota en más de 4 puntos', 'PASS');

    CALL p_populate();

    UPDATE grades SET grade_value = 0.5 WHERE grade_id = 1;

    CALL p_log_test('RN05', 'ERROR: Se permitió modificar la nota en más de 4 puntos', 'FAIL');
END //
DELIMITER ;

-- Test RN06: No puede haber más de un grupo de teoría y dos de laboratorio por asignatura
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn06_extra_group()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN06', 'RN06: No se permite crear un segundo grupo de teoría para la asignatura', 'PASS');

    CALL p_populate();

    INSERT INTO groups (group_id, subject_id, group_name, activity, academic_year)
        VALUES (11, 11, 'T2', 'Teoría', 2024);

    CALL p_log_test('RN06', 'ERROR: Se creó un segundo grupo de teoría para la misma asignatura', 'FAIL');
END //
DELIMITER ;

-- Test RN07: Un alumno sólo puede pertenecer a grupos de asignaturas en las que está matriculado
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn07_subject_enrollment()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN07', 'RN07: No se puede añadir a un grupo sin matrícula en la asignatura', 'PASS');

    CALL p_populate();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email)
        VALUES (102, '20000002B', 'Test', 'Alumno', 20, 'nuevo@alum.us.es');
    INSERT INTO students (student_id, access_method) VALUES (102, 'Selectividad');
    INSERT INTO students_groups (student_id, group_id) VALUES (102, 1);

    CALL p_log_test('RN07', 'ERROR: Se permitió unir a un grupo sin matrícula en la asignatura', 'FAIL');
END //
DELIMITER ;

-- Test RN08: Un alumno no puede acceder por selectividad con menos de 16 años
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn08_min_age()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN08', 'RN08: No se permite Selectividad con menos de 16 años', 'PASS');

    CALL p_populate();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email)
        VALUES (104, '20000004D', 'Test', 'Menor', 15, 'menor@alum.us.es');
    INSERT INTO students (student_id, access_method) VALUES (104, 'Selectividad');

    CALL p_log_test('RN08', 'ERROR: Se permitió Selectividad para un menor', 'FAIL');
END //
DELIMITER ;

-- =============================================================
-- ORQUESTADOR
-- Sustituye al p_run_tests de tests_constraints.sql para ejecutar todos
-- los tests: los de L4 y los de L5
-- =============================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_tests()
BEGIN
    DELETE FROM test_results;

    -- Restricciones declarativas (tests_constraints.sql, L4)
    CALL p_test_rn01_mh_requirement();
    CALL p_test_rn09_not_null_attributes();
    CALL p_test_rn10_subject_credits();
    CALL p_test_rn11_grade_range();
    CALL p_test_rn12_people_age();
    CALL p_test_rn13_degree_years();
    CALL p_test_rn14_dni_format();
    CALL p_test_rn15_academic_year();
    CALL p_test_rn16_course_range();
    -- Reglas procedurales (triggers, L5)
    CALL p_test_rn02_grade_in_group();
    CALL p_test_rn03_professors_per_group();
    CALL p_test_rn04_student_group_limit();
    CALL p_test_rn05_grade_delta();
    CALL p_test_rn06_extra_group();
    CALL p_test_rn07_subject_enrollment();
    CALL p_test_rn08_min_age();
    CALL p_test_rn17_duplicate_grade();

    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
END //
DELIMITER ;

CALL p_run_tests();