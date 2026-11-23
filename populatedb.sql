DELETE FROM people;

INSERT INTO people (person_id, dni, first_name, last_name, age, email) VALUES
    (1, '00000001A', 'David', 'Ruiz', 50, 'druiz@us.es'),
    (2, '00000002B', 'Inma', 'Hernández', 40, 'inmahernandez@us.es'),
    (3, '00000003C', 'Fernando', 'Sola', 28, 'fsola@us.es'),
    (4, '00000004D', 'Daniel', 'Ayala', 32, 'dayala1@us.es'),
    (5, '00000005E', 'Pepe', 'Calderón', 43, 'pepecalderon@us.es'),
    (6, '10000006F', 'David', 'Romero', 22, 'david.romero@alum.us.es'),
    (7, '10000007G', 'Lucía', 'Molina', 21, 'lucia.molina@alum.us.es'),
    (8, '10000008H', 'Hugo', 'Paredes', 20, 'hugo.paredes@alum.us.es'),
    (9, '10000009J', 'Sara', 'Campos', 21, 'sara.campos@alum.us.es'),
    (10, '10000010K', 'Mario', 'Galán', 22, 'mario.galan@alum.us.es'),
    (11, '10000011L', 'Elena', 'Torres', 21, 'elena.torres@alum.us.es'),
    (12, '10000012M', 'Rubén', 'Durán', 20, 'ruben.duran@alum.us.es'),
    (13, '10000013N', 'Claudia', 'Soto', 23, 'claudia.soto@alum.us.es'),
    (14, '10000014P', 'Iván', 'Cuesta', 22, 'ivan.cuesta@alum.us.es'),
    (15, '10000015Q', 'Noelia', 'Rey', 21, 'noelia.rey@alum.us.es'),
    (16, '10000016R', 'Pablo', 'Vidal', 22, 'pablo.vidal@alum.us.es'),
    (17, '10000017S', 'Alicia', 'Muñoz', 21, 'alicia.munoz@alum.us.es'),
    (18, '10000018T', 'Sergio', 'Izquierdo', 22, 'sergio.izquierdo@alum.us.es'),
    (19, '10000019U', 'Nerea', 'Saiz', 20, 'nerea.saiz@alum.us.es'),
    (20, '10000020V', 'Álvaro', 'León', 23, 'alvaro.leon@alum.us.es'),
    (21, '10000021W', 'Julia', 'Benito', 21, 'julia.benito@alum.us.es'),
    (22, '10000022X', 'Tomás', 'Rubio', 22, 'tomas.rubio@alum.us.es'),
    (23, '10000023Y', 'Irene', 'Salas', 21, 'irene.salas@alum.us.es'),
    (24, '10000024Z', 'Álex', 'Delgado', 22, 'alex.delgado@alum.us.es'),
    (25, '10000025A', 'Paula', 'Bermejo', 21, 'paula.bermejo@alum.us.es');


DELETE FROM professors;

INSERT INTO professors (professor_id, category) VALUES
    (1, 'Catedrático'),
    (2, 'Titular'),
    (3, 'AyudanteDoctor'),
    (4, 'Titular'),
    (5, 'Ayudante');


INSERT INTO students (student_id, access_method) VALUES
    (6, 'Selectividad'),
    (7, 'Selectividad'),
    (8, 'Selectividad'),
    (9, 'Selectividad'),
    (10, 'Selectividad'),
    (11, 'Selectividad'),
    (12, 'Selectividad'),
    (13, 'Selectividad'),
    (14, 'Selectividad'),
    (15, 'Selectividad'),
    (16, 'Selectividad'),
    (17, 'Selectividad'),
    (18, 'Selectividad'),
    (19, 'Selectividad'),
    (20, 'Selectividad'),
    (21, 'Selectividad'),
    (22, 'Selectividad'),
    (23, 'Selectividad'),
    (24, 'Selectividad'),
    (25, 'Selectividad');

INSERT INTO degrees (degree_id, degree_name, duration_years) VALUES
    (1, 'Ingeniería del Software', 4),
    (2, 'Ingeniería de Computadores', 4),
    (3, 'Tecnologías Informáticas', 4);

INSERT INTO subjects (
    subject_id,
    degree_id,
    subject_name,
    acronym,
    credits,
    course,
    subject_type
) VALUES
    -- Primer curso (Tecnologías Informáticas)
    (1, 3, 'Fundamentos de Programación', 'FP', 12, 1, 'Formación Básica'),
    (2, 3, 'Cálculo Infinitesimal y Numérico', 'CIN', 6, 1, 'Formación Básica'),
    (3, 3, 'Circuitos Electrónicos Digitales', 'CED', 6, 1, 'Formación Básica'),
    (4, 3, 'Fundamentos Físicos de la Informática', 'FFI', 6, 1, 'Formación Básica'),
    (5, 3, 'Introducción a la Matemática Discreta', 'IMD', 6, 1, 'Formación Básica'),
    (6, 3, 'Administración de Empresas', 'ADE', 6, 1, 'Formación Básica'),
    (7, 3, 'Álgebra Lineal y Numérica', 'ALN', 6, 1, 'Formación Básica'),
    (8, 3, 'Estadística', 'EST', 6, 1, 'Formación Básica'),
    (9, 3, 'Estructura de Computadores', 'EC', 6, 1, 'Formación Básica'),
    -- Segundo curso (Tecnologías Informáticas)
    (10, 3, 'Análisis y Diseño de Datos y Algoritmos', 'ADDA', 12, 2, 'Obligatoria'),
    (11, 3, 'Introducción a la Ingeniería del Software y los Sistemas de Información I', 'IISSI-1', 6, 2, 'Obligatoria'),
    (12, 3, 'Matemática Discreta', 'MD', 6, 2, 'Obligatoria'),
    (13, 3, 'Redes de Computadores', 'RC', 6, 2, 'Obligatoria'),
    (14, 3, 'Arquitectura de Computadores', 'AC', 6, 2, 'Obligatoria'),
    (15, 3, 'Introducción a la Ingeniería del Software y los Sistemas de Información II', 'IISSI-2', 6, 2, 'Obligatoria'),
    (16, 3, 'Sistemas Operativos', 'SO', 6, 2, 'Obligatoria'),
    (17, 3, 'Inteligencia Artificial', 'IA', 6, 2, 'Obligatoria');

    INSERT INTO groups (group_id, subject_id, group_name, activity, academic_year) VALUES
    (1, 11, 'T1', 'Teoría', 2024),
    (2, 11, 'L1', 'Laboratorio', 2024),
    (3, 11, 'L2', 'Laboratorio', 2024);

INSERT INTO students_groups (student_id, group_id) VALUES
        -- Teoría
        (6, 1), (7, 1), (8, 1), (9, 1), (10, 1),
        (11, 1), (12, 1), (13, 1), (14, 1), (15, 1),
        (16, 1), (17, 1), (18, 1), (19, 1), (20, 1),
        (21, 1), (22, 1), (23, 1), (24, 1), (25, 1),
        -- Laboratorio L1
        (6, 2), (7, 2), (8, 2), (9, 2), (10, 2),
        (11, 2), (12, 2), (13, 2), (14, 2), (15, 2),
        -- Laboratorio L2
        (16, 3), (17, 3), (18, 3), (19, 3), (20, 3),
        (21, 3), (22, 3), (23, 3), (24, 3), (25, 3);

INSERT INTO group_enrollments (student_id, group_id) VALUES
    (6, 1), (7, 1), (8, 1), (9, 1), (10, 1),
    (11, 1), (12, 1), (13, 1), (14, 1), (15, 1),
    (16, 1), (17, 1), (18, 1), (19, 1), (20, 1),
    (21, 1), (22, 1), (23, 1), (24, 1), (25, 1),
    (6, 2), (7, 2), (8, 2), (9, 2), (10, 2),
    (11, 2), (12, 2), (13, 2), (14, 2), (15, 2),
    (16, 3), (17, 3), (18, 3), (19, 3), (20, 3),
    (21, 3), (22, 3), (23, 3), (24, 3), (25, 3);

INSERT INTO grades (grade_id, student_id, group_id, grade_value, exam_call, with_honors) VALUES
    -- Primera convocatoria: 10 aprobados (2 con MH), 10 suspensos
    (1, 6, 1, 9.8, 'Primera', 1),
    (2, 7, 1, 9.2, 'Primera', 1),
    (3, 8, 1, 5.4, 'Primera', 0),
    (4, 9, 1, 8.0, 'Primera', 0),
    (5, 10, 1, 6.0, 'Primera', 0),
    (6, 11, 1, 5.7, 'Primera', 0),
    (7, 12, 1, 7.0, 'Primera', 0),
    (8, 13, 1, 6.3, 'Primera', 0),
    (9, 14, 1, 5.8, 'Primera', 0),
    (10, 15, 1, 6.1, 'Primera', 0),
    (11, 16, 1, 4.2, 'Primera', 0),
    (12, 17, 1, 3.9, 'Primera', 0),
    (13, 18, 1, 4.5, 'Primera', 0),
    (14, 19, 1, 4.8, 'Primera', 0),
    (15, 20, 1, 4.4, 'Primera', 0),
    (16, 21, 1, 3.5, 'Primera', 0),
    (17, 22, 1, 3.8, 'Primera', 0),
    (18, 23, 1, 4.0, 'Primera', 0),
    (19, 24, 1, 4.3, 'Primera', 0),
    (20, 25, 1, 4.7, 'Primera', 0),
    -- Segunda convocatoria
    (21, 16, 1, 6.2, 'Segunda', 0),
    (22, 17, 1, 5.8, 'Segunda', 0),
    (23, 18, 1, 6.4, 'Segunda', 0),
    (24, 19, 1, 5.9, 'Segunda', 0),
    (25, 20, 1, 6.1, 'Segunda', 0),
    (26, 21, 1, 4.6, 'Segunda', 0),
    (27, 22, 1, 4.9, 'Segunda', 0),
    (28, 23, 1, 4.7, 'Segunda', 0),
    (29, 24, 1, 4.4, 'Segunda', 0),
    (30, 25, 1, 4.3, 'Segunda', 0),
    -- Tercera convocatoria
    (31, 21, 1, 5.6, 'Tercera', 0),
    (32, 22, 1, 5.9, 'Tercera', 0),
    (33, 23, 1, 5.5, 'Tercera', 0),
    (34, 24, 1, 6.0, 'Tercera', 0),
    (35, 25, 1, 5.7, 'Tercera', 0);

INSERT INTO subject_enrollments (student_id, subject_id) VALUES
    (6, 11), (7, 11), (8, 11), (9, 11), (10, 11),
    (11, 11), (12, 11), (13, 11), (14, 11), (15, 11),
    (16, 11), (17, 11), (18, 11), (19, 11), (20, 11),
    (21, 11), (22, 11), (23, 11), (24, 11), (25, 11);

INSERT INTO teaching_loads (professor_id, group_id, credits) VALUES
    (1, 1, 3.0),
    (2, 1, 3.0),
    (3, 2, 3.0),
    (5, 3, 1.5),
    (4, 3, 1.5);


--
-- Autor: David Ruiz
-- Fecha: Octubre de 2026
-- Descripción: Datos adicionales para grades_db para cubrir consultas de L3
--              Este script añade datos sin borrar los existentes de populate_db.sql
-- Se incluye en: iissi1/labs/AN-B
--
USE grades_db;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_populate_grados_extra()
BEGIN
    -- Eliminar datos adicionales si ya existen (hacer el procedimiento idempotente)
    DELETE FROM grades WHERE grade_id >= 36;
    DELETE FROM teaching_loads WHERE group_id >= 4;
    DELETE FROM students_groups WHERE group_id >= 4;
    DELETE FROM students_subjects WHERE subject_id >= 18 OR (student_id >= 6 AND subject_id IN (1, 2, 10));
    DELETE FROM groups WHERE group_id >= 4;
    DELETE FROM subjects WHERE subject_id >= 18;

    -- Añadir más asignaturas a otros grados para consultas de agregación
    INSERT INTO subjects (
        subject_id,
        degree_id,
        subject_name,
        acronym,
        credits,
        course,
        subject_type
    ) VALUES
        -- Ingeniería del Software (degree_id = 1)
        (18, 1, 'Fundamentos de Programación Orientada a Objetos', 'FPOO', 12, 1, 'Formación Básica'),
        (19, 1, 'Bases de Datos', 'BD', 6, 2, 'Obligatoria'),
        (20, 1, 'Ingeniería del Software', 'IS', 6, 2, 'Obligatoria'),
        (21, 1, 'Sistemas de Información', 'SI', 6, 3, 'Obligatoria'),
        (22, 1, 'Gestión de Proyectos', 'GP', 6, 3, 'Obligatoria'),
        (23, 1, 'Calidad del Software', 'CS', 6, 3, 'Obligatoria'),
        -- Ingeniería de Computadores (degree_id = 2)
        (24, 2, 'Fundamentos de Computadores', 'FC', 12, 1, 'Formación Básica'),
        (25, 2, 'Sistemas Digitales', 'SD', 6, 2, 'Obligatoria'),
        (26, 2, 'Arquitectura de Computadores Avanzada', 'ACA', 6, 3, 'Obligatoria'),
        -- Más asignaturas para TI (degree_id = 3)
        (27, 3, 'Fundamentos de Ingeniería del Software', 'FIS', 6, 3, 'Obligatoria'),
        (28, 3, 'Desarrollo de Sistemas de Información', 'DSI', 6, 3, 'Obligatoria'),
        (29, 3, 'Seguridad Informática', 'SEG', 6, 4, 'Optativa');

    -- Añadir más grupos para consultas de DISTINCT, COUNT, etc.
    -- IMPORTANTE: Respetando RN06 (máx. 1 grupo teoría y 2 laboratorio por asignatura)
    INSERT INTO groups (group_id, subject_id, group_name, activity, academic_year) VALUES
        -- Grupos para FP (subject_id = 1) - 1 teoría + 2 laboratorio
        (4, 1, 'T1', 'Teoría', 2024),
        (5, 1, 'L1', 'Laboratorio', 2024),
        (6, 1, 'L2', 'Laboratorio', 2024),
        -- Grupos para ADDA (subject_id = 10) - 1 teoría + 2 laboratorio
        (7, 10, 'T1', 'Teoría', 2024),
        (8, 10, 'L1', 'Laboratorio', 2024),
        (9, 10, 'L2', 'Laboratorio', 2024),
        -- Grupos para CIN (subject_id = 2) - 1 teoría + 2 laboratorio
        (10, 2, 'T1', 'Teoría', 2024),
        (11, 2, 'L1', 'Laboratorio', 2024),
        (12, 2, 'L2', 'Laboratorio', 2024),
        -- Grupos para MD (subject_id = 12) - 1 teoría + 2 laboratorio
        (13, 12, 'T1', 'Teoría', 2024),
        (14, 12, 'L1', 'Laboratorio', 2024),
        (15, 12, 'L2', 'Laboratorio', 2024),
        -- Grupos de años anteriores para consultas de rango
        (16, 11, 'T1', 'Teoría', 2023),
        (17, 11, 'L1', 'Laboratorio', 2023),
        (18, 1, 'T1', 'Teoría', 2023),
        (19, 10, 'T1', 'Teoría', 2023),
        (20, 11, 'T1', 'Teoría', 2022),
        (21, 1, 'T1', 'Teoría', 2022),
        (22, 11, 'T1', 'Teoría', 2021),
        (23, 1, 'T1', 'Teoría', 2020);

    -- Matricular estudiantes en asignaturas adicionales (ANTES de añadirlos a grupos)
    -- RN07: Un alumno sólo puede pertenecer a grupos de asignaturas en las que está matriculado
    INSERT INTO students_subjects (student_id, subject_id) VALUES
        (6, 1), (7, 1), (8, 1), (9, 1), (10, 1),
        (11, 1), (12, 1), (13, 1), (14, 1), (15, 1),
        (16, 1), (17, 1), (18, 1), (19, 1), (20, 1),
        (6, 10), (7, 10), (8, 10), (9, 10), (10, 10),
        (11, 10), (12, 10), (13, 10), (14, 10), (15, 10),
        (6, 2), (7, 2), (8, 2), (9, 2), (10, 2);

    -- Más matrículas en grupos para LEFT JOIN y análisis
    INSERT INTO students_groups (student_id, group_id) VALUES
        -- Estudiantes en grupos de FP (subject_id = 1)
        (6, 4), (7, 4), (8, 4), (9, 4), (10, 4),
        (11, 4), (12, 4), (13, 4), (14, 4), (15, 4),
        (16, 4), (17, 4), (18, 4), (19, 4), (20, 4),
        (6, 5), (7, 5), (8, 5), (9, 5), (10, 5),
        (16, 6), (17, 6), (18, 6), (19, 6), (20, 6),
        -- Estudiantes en grupos de ADDA (subject_id = 10)
        (6, 7), (7, 7), (8, 7), (9, 7), (10, 7),
        (11, 7), (12, 7), (13, 7), (14, 7), (15, 7),
        (6, 8), (7, 8), (8, 8), (9, 8), (10, 8),
        -- Estudiantes en grupos de CIN (subject_id = 2)
        (6, 10), (7, 10), (8, 10), (9, 10), (10, 10),
        (6, 11), (7, 11), (8, 11);

    -- Más cargas docentes (RN03: máximo 2 profesores por grupo)
    INSERT INTO teaching_loads (professor_id, group_id, credits) VALUES
        (1, 4, 3.0),
        (2, 5, 1.5),
        (3, 6, 1.5),
        (4, 7, 6.0),
        (1, 8, 1.5),
        (2, 9, 1.5),
        (3, 10, 3.0),
        (4, 11, 1.5);

    -- Más notas para consultas diversas
    INSERT INTO grades (grade_id, student_id, group_id, grade_value, exam_call, with_honors) VALUES
        -- Notas en grupo 4 (FP Teoría 2024)
        (36, 6, 4, 7.5, 'Primera', 0),
        (37, 7, 4, 8.2, 'Primera', 0),
        (38, 8, 4, 6.5, 'Primera', 0),
        (39, 9, 4, 9.5, 'Primera', 1),
        (40, 10, 4, 9.8, 'Primera', 1),
        (41, 11, 4, 7.0, 'Primera', 0),
        (42, 12, 4, 8.5, 'Primera', 0),
        (43, 13, 4, 9.0, 'Primera', 0),
        (44, 14, 4, 9.2, 'Primera', 1),
        (45, 15, 4, 8.8, 'Primera', 0),
        (46, 16, 4, 7.8, 'Primera', 0),
        (47, 17, 4, 8.0, 'Primera', 0),
        (48, 18, 4, 9.1, 'Primera', 1),
        (49, 19, 4, 8.7, 'Primera', 0),
        (50, 20, 4, 9.3, 'Primera', 1),
        -- Notas en grupo 7 (ADDA Teoría 2024)
        (51, 6, 7, 6.0, 'Primera', 0),
        (52, 7, 7, 7.5, 'Primera', 0),
        (53, 8, 7, 5.5, 'Primera', 0),
        (54, 9, 7, 9.5, 'Primera', 1),
        (55, 10, 7, 7.8, 'Primera', 0),
        (56, 11, 7, 6.2, 'Primera', 0),
        (57, 12, 7, 7.0, 'Primera', 0),
        (58, 13, 7, 8.0, 'Primera', 0),
        (59, 14, 7, 7.2, 'Primera', 0),
        (60, 15, 7, 6.8, 'Primera', 0),
        -- Notas en grupo 10 (CIN Teoría 2024)
        (61, 6, 10, 5.5, 'Primera', 0),
        (62, 7, 10, 6.0, 'Primera', 0),
        (63, 8, 10, 7.5, 'Primera', 0),
        (64, 9, 10, 8.0, 'Primera', 0),
        (65, 10, 10, 6.5, 'Primera', 0);

END //
DELIMITER ;

-- Ejecutar el procedimiento
CALL p_populate_grados_extra();