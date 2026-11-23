-- RN08: un alumno que accede por Selectividad debe tener al menos 16 años
DELIMITER //
CREATE OR REPLACE TRIGGER t_biu_students_rn08
BEFORE INSERT OR UPDATE ON students
FOR EACH ROW
BEGIN
    DECLARE v_age TINYINT;
    IF NEW.access_method = 'Selectividad' THEN
        -- La edad está en people: el id del alumno es el de la persona (herencia)
        SELECT age INTO v_age FROM people WHERE person_id = NEW.student_id;
        IF v_age < 16 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN08: No se puede acceder por Selectividad con menos de 16 años';
        END IF;
    END IF;
END//
DELIMITER ; 

DELIMITER //
-- RN02: un alumno solo puede tener notas en los grupos a los que pertenece
CREATE OR REPLACE TRIGGER t_biu_grades_rn02
BEFORE INSERT OR UPDATE ON grades
FOR EACH ROW
BEGIN
    DECLARE v_count INT;
    -- ¿Está el alumno en el grupo de la nota?
    SELECT COUNT(*) INTO v_count
    FROM students_groups
    WHERE student_id = NEW.student_id
      AND group_id = NEW.group_id;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN02: El alumno no pertenece al grupo indicado';
    END IF;
END//
DELIMITER ; 

DELIMITER //
-- RN17: un alumno no puede tener más de una nota para la misma asignatura,
-- convocatoria y año académico (aunque sean de grupos distintos)
CREATE OR REPLACE TRIGGER t_biu_grades_rn17
BEFORE INSERT OR UPDATE ON grades
FOR EACH ROW
BEGIN
    DECLARE v_subject_id INT;
    DECLARE v_academic_year YEAR;
    DECLARE v_exists INT;

    -- Asignatura y año académico del grupo de la nota
    SELECT subject_id, academic_year INTO v_subject_id, v_academic_year
    FROM groups
    WHERE group_id = NEW.group_id;

    -- Otras notas del alumno en esa asignatura, convocatoria y año, en cualquier grupo
    SELECT COUNT(*) INTO v_exists
    FROM grades g
    JOIN groups gr ON gr.group_id = g.group_id
    WHERE g.student_id = NEW.student_id
      AND g.exam_call = NEW.exam_call
      AND gr.subject_id = v_subject_id
      AND gr.academic_year = v_academic_year
      -- excluye la propia fila al actualizar (en INSERT, NEW.grade_id vale 0)
      AND g.grade_id <> NEW.grade_id;

    IF v_exists > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN17: Ya existe una nota para la misma asignatura, convocatoria y año académico';
    END IF;
END//
DELIMITER ;

DELIMITER //
-- RN05: una nota no puede modificarse en más de 4 puntos (solo en UPDATE:
-- al insertar no hay valor anterior)
CREATE OR REPLACE TRIGGER t_bu_grades_rn05
BEFORE UPDATE ON grades
FOR EACH ROW
BEGIN
    -- ABS: cuenta igual una subida que una bajada
    IF ABS(NEW.grade_value - OLD.grade_value) > 4 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN05: No se puede modificar la nota en más de 4 puntos';
    END IF;
END//
DELIMITER ;

DELIMITER //
-- RN03: un grupo no puede tener más de 2 profesores
CREATE OR REPLACE TRIGGER t_biu_teaching_loads_rn03
BEFORE INSERT OR UPDATE ON teaching_loads
FOR EACH ROW
BEGIN
    DECLARE v_count INT;

    -- Se comprueba solo si la asignación entra en un grupo:
    -- - en INSERT, OLD.group_id vale NULL: entra siempre
    -- - en UPDATE, entra si cambia de grupo (<=> trata NULL como un valor)
    IF NOT (NEW.group_id <=> OLD.group_id) THEN
        SELECT COUNT(*) INTO v_count
        FROM teaching_loads
        WHERE group_id = NEW.group_id;

        IF v_count >= 2 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN03: El grupo ya tiene 2 profesores asignados';
        END IF;
    END IF;
END//
DELIMITER ;

DELIMITER //
-- RN07: el alumno debe estar matriculado en la asignatura del grupo.
-- RN04: un alumno solo puede estar en un grupo de teoría y en uno de
-- laboratorio por asignatura
CREATE OR REPLACE TRIGGER t_biu_students_groups_rn04_rn07
BEFORE INSERT OR UPDATE ON students_groups
FOR EACH ROW
BEGIN
    DECLARE v_subject_id INT;
    DECLARE v_activity VARCHAR(15);
    DECLARE v_old_subject_id INT;
    DECLARE v_old_activity VARCHAR(15);

    -- Asignatura y actividad del grupo nuevo
    SELECT subject_id, activity INTO v_subject_id, v_activity
    FROM groups
    WHERE group_id = NEW.group_id;

    -- Asignatura y actividad del grupo anterior
    -- (en INSERT, OLD.group_id vale NULL y quedan a NULL)
    SET v_old_subject_id = (SELECT subject_id FROM groups WHERE group_id = OLD.group_id);
    SET v_old_activity = (SELECT activity FROM groups WHERE group_id = OLD.group_id);

    IF NOT f_is_student_enrolled(NEW.student_id, v_subject_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN07: El alumno debe estar matriculado en la asignatura';
    END IF;

    -- RN04 solo se comprueba si el alumno entra en un grupo de otra asignatura
    -- o actividad (cambiar de L1 a L2 de la misma asignatura está permitido).
    -- En INSERT, OLD y las variables v_old_* valen NULL: se comprueba siempre
    IF NOT (NEW.student_id <=> OLD.student_id
            AND v_subject_id <=> v_old_subject_id
            AND v_activity <=> v_old_activity)
       AND f_student_group_limit(NEW.student_id, v_subject_id, v_activity) THEN
        IF v_activity = 'Teoría' THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN04: Solo puede haber un grupo de teoría por asignatura y alumno';
        ELSE
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN04: Solo puede haber un grupo de laboratorio por asignatura y alumno';
        END IF;
    END IF;
END//
DELIMITER ;

DELIMITER //
-- RN06: por asignatura y año académico, como máximo un grupo de teoría y dos
-- de laboratorio
CREATE OR REPLACE TRIGGER t_biu_groups_rn06
BEFORE INSERT OR UPDATE ON groups
FOR EACH ROW
BEGIN
    -- Se comprueba si el grupo entra en otra asignatura, actividad o año:
    -- - en INSERT, OLD vale NULL: se comprueba siempre
    -- - en UPDATE, solo si cambia alguno de los tres (<=> trata NULL como un valor)
    IF NOT (NEW.subject_id <=> OLD.subject_id
            AND NEW.activity <=> OLD.activity
            AND NEW.academic_year <=> OLD.academic_year) THEN
        IF f_subject_group_limit_reached(NEW.subject_id, NEW.activity, NEW.academic_year) THEN
            IF NEW.activity = 'Teoría' THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'RN06: Solo puede existir un grupo de teoría por asignatura y año académico';
            ELSE
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'RN06: Solo pueden existir dos grupos de laboratorio por asignatura y año académico';
            END IF;
        END IF;
    END IF;
END//
DELIMITER ;