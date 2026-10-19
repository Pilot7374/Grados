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
