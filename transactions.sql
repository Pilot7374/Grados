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
