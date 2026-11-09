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