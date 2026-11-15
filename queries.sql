-- 
-- Autor: [Gonzalo]
-- Fecha: Enero 2026
-- Descripción: Consultas SQL de ejemplo para GradesDB
--              Cubre conceptos de consultas simples y avanzadas
-- 

--CONSULTA BASICA

USE grados;
--Select * el *seleciiona todas las columnas de la tabla sunjects

SELECT * 
FROM subjects;


--consulta con acronymo
-- se usa s de abreviacion
SELECT * 
FROM subjects s
WHERE s.acronym = 'IISSI-1';

--solo las columnas mencionadas en el select
SELECT s.subject_name, s.acronym 
FROM subjects s;

--flitro por tipo
SELECT s.subject_name, s.acronym, s.subject_type
FROM subjects s
WHERE s.subject_type = 'Formación Básica';


--RELACION DE TABLAS CON JOIN:

SELECT p.first_name, p.last_name, st.access_method
FROM students st
--unimos la tabla people a student si st.studentid == p.person_id
--la condicion hace que se unan por esa conexion de los id
--si no se juntaria una columna con todas y asi sucesivamente
JOIN people p ON st.student_id = p.person_id
WHERE st.access_method = 'Selectividad';

--hacemos lo mismo para profesores
SELECT p.first_name, p.last_name, pr.category
FROM professors pr
JOIN people p ON pr.professor_id = p.person_id
WHERE pr.category = 'Catedrático';

--VISTAS

CREATE OR REPLACE VIEW v_professors AS
SELECT 
    pr.professor_id,
    pr.category,
    p.person_id,
    p.dni,
    p.first_name,
    p.last_name,
    p.age,
    p.email
FROM professors pr
JOIN people p ON pr.professor_id = p.person_id;


--Lo mismo con estudiantes

-- Vista: Estudiantes con información completa
CREATE OR REPLACE VIEW v_students AS
SELECT 
    st.student_id,
    st.access_method,
    p.person_id,
    p.dni,
    p.first_name,
    p.last_name,
    p.age,
    p.email
FROM students st
JOIN people p ON st.student_id = p.person_id;

--FUNCIONES AGREGADAS

-- Consulta 7: Media de las notas del grupo con ID 1
SELECT AVG(g.grade_value) AS average_grade
FROM grades g
WHERE g.group_id = 1;

-- Consulta 9: Número total de estudiantes
SELECT COUNT(*) AS total_students
FROM students;

-- Consulta 10: Número de grupos por tipo de actividad
SELECT activity, COUNT(*) AS total_groups
FROM groups
GROUP BY activity;

-- Consulta 11: Máxima nota obtenida
SELECT MAX(g.grade_value) AS max_grade
FROM grades g;

-- Consulta 12: Mínima nota obtenida
SELECT MIN(g.grade_value) AS min_grade
FROM grades g;

--FUNCIONES MULTIPLES

-- Consulta 13: Notas con valor menor que 5 o mayor que 9
SELECT g.grade_id, g.grade_value, g.exam_call
FROM grades g
WHERE g.grade_value < 5 OR g.grade_value > 9;

-- Consulta 14: Notas entre 5 y 7 (inclusive)
SELECT g.grade_id, g.grade_value, g.exam_call
FROM grades g
WHERE g.grade_value BETWEEN 5 AND 7;


-- Consulta 15: Asignaturas de 6 o 12 créditos
SELECT s.subject_name, s.credits
FROM subjects s
WHERE s.credits IN (6, 12);

-- Consulta 16: Personas con edad entre 20 y 30 años
SELECT p.first_name, p.last_name, p.age
FROM people p
WHERE p.age BETWEEN 20 AND 30;

--DISTINT == SIN REPETICIONES

-- Consulta 17: Nombres de grupos diferentes
SELECT DISTINCT g.group_name 
FROM groups g;

-- Consulta 18: Tipos de asignatura diferentes
SELECT DISTINCT s.subject_type
FROM subjects s;

-- Consulta 19: Años académicos registrados
SELECT DISTINCT g.academic_year
FROM groups g
ORDER BY g.academic_year DESC; --ORDER BY = menor a mayor por defecto

--SUBCONSULTAS

-- Consulta 20: Máxima nota del estudiante con ID 6
SELECT MAX(g.grade_value) AS max_grade
FROM grades g
WHERE g.student_id = 6;

-- Consulta 21: IDs de estudiantes del año académico 2024
SELECT DISTINCT ge.student_id
FROM students_groups ge
WHERE ge.group_id IN (
    SELECT g.group_id 
    FROM groups g 
    WHERE g.academic_year = 2024
);

-- Consulta 22: Asignaturas con más créditos que la media
SELECT s.subject_name, s.credits
FROM subjects s
WHERE s.credits > (SELECT AVG(credits) FROM subjects);

--LIKE
--El operador LIKE permite buscar patrones de texto usando comodines:
--% representa cualquier secuencia de caracteres (incluyendo ninguno).
--_ representa exactamente un carácter.

-- Consulta 23: Personas con DNI terminado en 'A'
SELECT p.first_name, p.last_name, p.dni
FROM people p
WHERE p.dni LIKE '%A';

-- Consulta 24: Asignaturas cuyo nombre empieza por 'Fundamentos'
SELECT s.subject_name
FROM subjects s
WHERE s.subject_name LIKE 'Fundamentos%';

-- el % es lo que lo sigue o precede

-- Consulta 25: Personas con nombres de 5 letras (usar 5 guiones bajos)
SELECT p.first_name, p.last_name
FROM people p
WHERE p.first_name LIKE '_____';

-- FILTRO CON FECHAS 
-- Consulta 26: Grupos del año 2024
SELECT g.group_name, g.activity, g.academic_year
FROM groups g
WHERE g.academic_year = 2024;

-- Consulta 27: Grupos entre 2020 y 2023
SELECT g.group_name, g.activity, g.academic_year
FROM groups g
WHERE g.academic_year BETWEEN 2020 AND 2023
ORDER BY g.academic_year;

--CREACION DE VISTAS COMPLEJAS 
-- Vista 1: Notas con matrícula de honor
CREATE OR REPLACE VIEW v_grades_with_honors AS
SELECT g.grade_id, g.student_id, g.group_id, g.grade_value, g.exam_call
FROM grades g
WHERE g.with_honors = 1;

-- Vista 2: Notas de todos los estudiantes con información completa
CREATE OR REPLACE VIEW v_student_grades AS
SELECT 
    p.person_id,
    p.first_name,
    p.last_name,
    p.dni,
    g.grade_value,
    g.exam_call,
    g.with_honors,
    gr.group_name,
    gr.activity,
    gr.academic_year,
    s.subject_name,
    s.acronym,
    s.credits
FROM people p
JOIN students st ON p.person_id = st.student_id
JOIN grades g ON st.student_id = g.student_id
JOIN groups gr ON g.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id;

-- Vista 3: Información de profesores con sus cargas docentes
CREATE OR REPLACE VIEW v_professor_loads AS
SELECT
    p.person_id,
    p.first_name,
    p.last_name,
    pr.category,
    tl.credits AS teaching_credits,
    gr.group_name,
    gr.activity,
    gr.academic_year,
    s.subject_name,
    s.acronym
FROM people p
JOIN professors pr ON p.person_id = pr.professor_id
JOIN teaching_loads tl ON pr.professor_id = tl.professor_id
JOIN groups gr ON tl.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id;

-- Vista 4: Estudiantes por grado
CREATE OR REPLACE VIEW v_degree_students AS
SELECT DISTINCT
    d.degree_id,
    d.degree_name,
    p.person_id,
    p.first_name,
    p.last_name,
    st.access_method,
    gr.academic_year
FROM degrees d
JOIN subjects s ON d.degree_id = s.degree_id
JOIN groups gr ON s.subject_id = gr.subject_id
JOIN students_groups ge ON gr.group_id = ge.group_id
JOIN students st ON ge.student_id = st.student_id
JOIN people p ON st.student_id = p.person_id;

--USO DE LAS VISTAS
-- Consulta 28: Total de matrículas de honor
SELECT COUNT(*) AS total_honors
FROM v_grades_with_honors;

--AGREGACION SOBRE VISTAS
-- Consulta 29: Nota media de cada estudiante
SELECT v.first_name, v.last_name, AVG(v.grade_value) AS average_grade
FROM v_student_grades v
GROUP BY v.person_id, v.first_name, v.last_name;

--CONTROL DE SALIDA
--ORDEN
-- Consulta 30: Notas ordenadas por valor (de menor a mayor)
SELECT g.grade_id, g.student_id, g.grade_value, g.exam_call
FROM grades g
ORDER BY g.grade_value ASC;

-- Consulta 31: Notas ordenadas por valor descendente
SELECT g.grade_id, g.student_id, g.grade_value, g.exam_call
FROM grades g
ORDER BY g.grade_value DESC;
--LIMITACION
-- Consulta 32: Las 5 mejores notas
SELECT g.grade_id, g.student_id, g.grade_value, g.exam_call
FROM grades g
ORDER BY g.grade_value DESC
LIMIT 5;
--ORDENACION MULTIPLE
-- Consulta 33: Notas aprobadas ordenadas por estudiante
SELECT 
    st.first_name,
    st.last_name,
    g.grade_value,
    g.exam_call
FROM grades g
JOIN v_students st ON g.student_id = st.student_id
WHERE g.grade_value >= 5
ORDER BY st.last_name ASC, st.first_name ASC;
--PAGINACION
-- Consulta 34: Paginación - Segunda página de 5 notas
SELECT g.grade_id, g.student_id, g.grade_value
FROM grades g
ORDER BY g.grade_value DESC
LIMIT 5 OFFSET 5; --OFFSET SALTA LAS 5 PRIMERAS FILAS
-- Consulta 35: Tercera página de 5 notas
SELECT g.grade_id, g.student_id, g.grade_value
FROM grades g
ORDER BY g.grade_value DESC
LIMIT 5 OFFSET 10;