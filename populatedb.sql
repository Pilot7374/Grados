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
