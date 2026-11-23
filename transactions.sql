-- Con AUTOCOMMIT activado (por defecto), START TRANSACTION agrupa las sentencias
-- hasta el COMMIT o el ROLLBACK
CALL p_populate();

SET AUTOCOMMIT = 1;
START TRANSACTION;

INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (6, 1, 4.5, 'Extraordinaria', 0);
INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (7, 1, 7.5, 'Extraordinaria', 0);

SELECT @@in_transaction;  -- 1: hay una transacción abierta
ROLLBACK;                 -- deshace las dos inserciones

-- Con AUTOCOMMIT desactivado, la transacción empieza sola con la primera sentencia:
-- no hace falta START TRANSACTION
CALL p_populate();

SET AUTOCOMMIT = 0;

INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (6, 1, 4.5, 'Extraordinaria', 0);

SELECT @@in_transaction;  -- 1: la transacción ha empezado con el INSERT
ROLLBACK;                 -- deshace la inserción

SET AUTOCOMMIT = 1;

--Comprobacion
SELECT * FROM grades
WHERE student_id IN (6, 7) AND exam_call = 'Extraordinaria';


-- START TRANSACTION con una transacción abierta la confirma antes de abrir la nueva
CALL p_populate();

SET AUTOCOMMIT = 0;

INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (6, 1, 4.5, 'Extraordinaria', 0);

START TRANSACTION;  -- confirma la inserción anterior
ROLLBACK;           -- solo deshace la transacción nueva, que está vacía

SET AUTOCOMMIT = 1;



-- START TRANSACTION con una transacción abierta la confirma antes de abrir la nueva
CALL p_populate();

SET AUTOCOMMIT = 0;

INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (6, 1, 4.5, 'Extraordinaria', 0);

START TRANSACTION;  -- confirma la inserción anterior
ROLLBACK;           -- solo deshace la transacción nueva, que está vacía

SET AUTOCOMMIT = 1;

-- La nota sigue ahí
SELECT * FROM grades WHERE student_id = 6 AND exam_call = 'Extraordinaria';



-- La tercera nota viola ck_grades_rn11_value: MariaDB deshace solo esa sentencia,
-- la transacción sigue abierta y, si el script llega al COMMIT, confirma las otras dos
CALL p_populate();

START TRANSACTION;

INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (6, 1, 4.5, 'Extraordinaria', 0);
INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (7, 1, 7.5, 'Extraordinaria', 0);
INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (8, 1, -7.5, 'Extraordinaria', 0);

COMMIT;

-- Quedan las dos primeras notas
SELECT * FROM grades
WHERE student_id IN (6, 7, 8) AND exam_call = 'Extraordinaria';


-- Las tres notas, todas o ninguna: un bloque anónimo con un manejador de errores
-- deshace la transacción ante el primer error y lo relanza (RESIGNAL)
CALL p_populate();

DELIMITER //
BEGIN NOT ATOMIC
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
    VALUES (6, 1, 4.5, 'Extraordinaria', 0);
    INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
    VALUES (7, 1, 7.5, 'Extraordinaria', 0);
    INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
    VALUES (8, 1, -7.5, 'Extraordinaria', 0);

    COMMIT;
END //
DELIMITER ;

-- No queda ninguna de las tres notas
SELECT * FROM grades
WHERE student_id IN (6, 7, 8) AND exam_call = 'Extraordinaria';

