-- Borra todas las notas del alumno con el DNI indicado
DELIMITER //
CREATE OR REPLACE PROCEDURE p_delete_student_grades(
    IN p_student_dni CHAR(9)
)
BEGIN
    DECLARE v_student_id INT;

    -- El DNI está en people; el id del alumno es el de la persona (herencia)
    SELECT student_id INTO v_student_id
    FROM people p
    JOIN students s ON s.student_id = p.person_id
    WHERE p.dni = p_student_dni;

    DELETE FROM grades WHERE student_id = v_student_id;
END // 

DELIMITER ;

--La llamada
-- Borrar las notas del estudiante con DNI '10000006F'
CALL p_delete_student_grades('10000006F');

-- Verificar que se borraron
SELECT * FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE p.dni = '10000006F';



DELIMITER //
-- Borra todos los datos de la BD sin borrar las tablas
CREATE OR REPLACE PROCEDURE p_delete_all_data()
BEGIN
    -- Primero las tablas que referencian a otras y después las referenciadas,
    -- para que ninguna fila se quede apuntando a una que ya no existe (FK)
    DELETE FROM grades;
    DELETE FROM teaching_loads;
    DELETE FROM students_groups;
    DELETE FROM students_subjects;
    DELETE FROM groups;
    DELETE FROM subjects;
    DELETE FROM students;
    DELETE FROM professors;
    DELETE FROM degrees;
    DELETE FROM people;
END //
DELIMITER ;

--LLAMADA
-- Borrar todos los datos (¡cuidado con esta operación!)
CALL p_delete_all_data();

-- Verificar que las tablas están vacías
SELECT COUNT(*) AS total_grades FROM grades;
SELECT COUNT(*) AS total_students FROM students;
SELECT COUNT(*) AS total_people FROM people;


-- Devuelve en el parámetro de salida p_average la nota media del alumno
-- (NULL si no tiene notas). Compárese con la función f_student_average (L5)
CREATE OR REPLACE PROCEDURE p_student_average(
    IN p_student_id INT,
    OUT p_average DECIMAL(4,2)
)
BEGIN
    SELECT AVG(grade_value) INTO p_average
    FROM grades
    WHERE student_id = p_student_id;
END //

--Llamada

-- Consultar la nota media del estudiante con ID 6
CALL p_student_average(6, @avg_student_6);
SELECT @avg_student_6 AS 'Promedio del estudiante 6';

-- Consultar para varios estudiantes
CALL p_student_average(7, @avg_student_7);
CALL p_student_average(8, @avg_student_8);
SELECT @avg_student_6, @avg_student_7, @avg_student_8;



DELIMITER //
-- Sube un 15 % las notas entre 4.5 y 8 de un grupo en una convocatoria
-- (sin pasar de 10) y muestra cuántas notas ha cambiado
CREATE OR REPLACE PROCEDURE p_boost_group_grades(
    IN p_group_id INT,
    IN p_exam_call VARCHAR(20)
)
BEGIN
    DECLARE v_affected_rows INT;
    DECLARE v_group_name VARCHAR(40);

    SELECT group_name INTO v_group_name
    FROM groups
    WHERE group_id = p_group_id;

    UPDATE grades
    -- LEAST devuelve el menor de los dos: la nota no pasa de 10
    SET grade_value = LEAST(grade_value * 1.15, 10.0)
    WHERE group_id = p_group_id
      AND exam_call = p_exam_call
      AND grade_value BETWEEN 4.5 AND 8.0;

    -- ROW_COUNT(): filas modificadas por la última sentencia (el UPDATE)
    SET v_affected_rows = ROW_COUNT();

    SELECT v_group_name AS group_name,
           v_affected_rows AS updated_grades;
END //
DELIMITER ;

--Llamada
-- Ver las notas del grupo 1 antes de la actualización
SELECT g.grade_id, p.first_name, p.last_name, g.grade_value, g.exam_call
FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE g.group_id = 1 AND g.exam_call = 'Primera'
ORDER BY g.grade_value;

-- Subir las notas del grupo 1 en la convocatoria 'Primera'
CALL p_boost_group_grades(1, 'Primera');

-- Verificar las notas después de la actualización
SELECT g.grade_id, p.first_name, p.last_name, g.grade_value, g.exam_call
FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE g.group_id = 1 AND g.exam_call = 'Primera'
ORDER BY g.grade_value;



DELIMITER //
-- Asigna las matrículas de honor de un grupo en una convocatoria: a las
-- mejores notas a partir de 9, como máximo al 5 % de los alumnos del grupo
CREATE OR REPLACE PROCEDURE p_assign_honors(
    IN p_group_id INT,
    IN p_exam_call VARCHAR(20)
)
BEGIN
    DECLARE v_total_students INT;
    DECLARE v_max_honors INT;

    SELECT COUNT(*) INTO v_total_students
    FROM students_groups
    WHERE group_id = p_group_id;

    -- FLOOR redondea hacia abajo: con menos de 20 alumnos no hay matrículas
    SET v_max_honors = FLOOR(v_total_students * 0.05);

    IF v_max_honors = 0 THEN
        SELECT CONCAT('No se pueden asignar matrículas de honor: ',
                      'el 5% de ', v_total_students,
                      ' estudiantes matriculados es 0') AS mensaje;
    ELSE
        -- Se quitan las matrículas anteriores para volver a asignarlas
        UPDATE grades
        SET with_honors = 0
        WHERE group_id = p_group_id
          AND exam_call = p_exam_call;

        -- MariaDB no admite LIMIT en una subconsulta con IN: por eso las notas
        -- elegidas se calculan en una tabla derivada (selected_grades)
        UPDATE grades
        SET with_honors = 1
        WHERE grade_id IN (
            SELECT selected_grades.grade_id
            FROM (
                SELECT grade_id
                FROM grades
                WHERE group_id = p_group_id
                  AND exam_call = p_exam_call
                  AND grade_value >= 9.0
                ORDER BY grade_value DESC
                LIMIT v_max_honors
            ) AS selected_grades
        );
    END IF;
END //
DELIMITER ;

--Llamada 
-- Ver las notas del grupo 1 antes de asignar MH
SELECT g.grade_id, p.first_name, p.last_name, g.grade_value, 
       g.with_honors, g.exam_call
FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE g.group_id = 1 AND g.exam_call = 'Primera'
ORDER BY g.grade_value DESC;

-- Asignar matrículas de honor al grupo 1 en la convocatoria 'Primera'
CALL p_assign_honors(1, 'Primera');

-- Verificar las matrículas asignadas
SELECT g.grade_id, p.first_name, p.last_name, g.grade_value, 
       g.with_honors, g.exam_call
FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE g.group_id = 1 AND g.exam_call = 'Primera' AND g.with_honors = 1
ORDER BY g.grade_value DESC;
