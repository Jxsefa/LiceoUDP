DROP TABLE IF EXISTS Directiva_de_profesores CASCADE ;
DROP TABLE IF EXISTS Curso CASCADE ;
DROP TABLE IF EXISTS Profesor CASCADE ;
DROP TABLE IF EXISTS Materia CASCADE ;
DROP TABLE IF EXISTS Alumnos CASCADE ;
DROP TABLE IF EXISTS Notas CASCADE ;
DROP TABLE IF EXISTS Asistencia CASCADE ;
DROP TABLE IF EXISTS Horarios CASCADE ;
DROP TABLE IF EXISTS Curso_Materia CASCADE ;
DROP TABLE IF EXISTS Profesor_Materia CASCADE ;


CREATE TABLE Directiva_de_profesores (
                                         ID_Directiva SERIAL PRIMARY KEY,
                                         nombre VARCHAR(100) NOT NULL,
                                         cargo VARCHAR(100) NOT NULL
);

CREATE TABLE Curso (
                       ID_Curso SERIAL PRIMARY KEY,
                       nivel VARCHAR (50),
                       cantidad_alumnos INT NOT NULL
);

CREATE TABLE Profesor (
                          RUT_profesor VARCHAR(15) PRIMARY KEY,
                          nombre VARCHAR(100) NOT NULL,
                          telefono INT NOT NULL,
                          correo VARCHAR(100) NOT NULL,
                          ID_directiva INT REFERENCES Directiva_de_profesores(ID_directiva) ON DELETE SET NULL
);

CREATE TABLE Materia (
                         ID_materia SERIAL PRIMARY KEY,
                         nombre VARCHAR(100) NOT NULL,
                         RUT_profesor VARCHAR(15) REFERENCES Profesor(RUT_profesor) ON DELETE SET NULL
);

CREATE TABLE Alumnos (
                         Rut_alumno VARCHAR(15) PRIMARY KEY,
                         nombre VARCHAR(100) NOT NULL,
                         fecha_nacimiento DATE NOT NULL,
                         direccion VARCHAR(255) NOT NULL,
                         telefono_apoderado INT NOT NULL,
                         ID_curso INT REFERENCES Curso(ID_curso) ON DELETE SET NULL
);

CREATE TABLE Notas(
                      ID_nota SERIAL PRIMARY KEY,
                      calificacion DECIMAL(5, 2) NOT NULL,
                      ID_alumno VARCHAR(15) REFERENCES Alumnos(RUT_alumno) ON DELETE CASCADE,
                      ID_materia INT REFERENCES Materia(ID_materia) ON DELETE CASCADE
);

CREATE TABLE Asistencia (
                            ID_asistencia SERIAL PRIMARY KEY,
                            fecha DATE NOT NULL,
                            estado VARCHAR(15) NOT NULL,
                            RUT_alumno VARCHAR(15) REFERENCES Alumnos(RUT_alumno) ON DELETE CASCADE,
                            RUT_profesor VARCHAR(15) REFERENCES Profesor(RUT_profesor) ON DELETE CASCADE,
                            ID_materia INT REFERENCES Materia(ID_materia) ON DELETE CASCADE
);

CREATE TABLE Horarios (
                          ID_horario SERIAL PRIMARY KEY,
                          dia VARCHAR(15) NOT NULL,
                          hora_inicio TIME NOT NULL,
                          hora_fin TIME NOT NULL,
                          RUT_profesor VARCHAR(15) REFERENCES Profesor(RUT_profesor) ON DELETE CASCADE,
                          ID_curso INT REFERENCES Curso(ID_curso) ON DELETE CASCADE,
                          ID_materia INT REFERENCES Materia(ID_materia) ON DELETE CASCADE
);

CREATE TABLE Curso_Materia (
                               ID_curso INT REFERENCES Curso(ID_curso) ON DELETE CASCADE,
                               ID_materia INT REFERENCES Materia(ID_materia) ON DELETE CASCADE,
                               PRIMARY KEY (ID_curso, ID_materia)
);

CREATE TABLE Profesor_Materia (
                                  RUT_profesor VARCHAR(15) REFERENCES Profesor(RUT_profesor) ON DELETE CASCADE,
                                  ID_materia INT REFERENCES Materia(ID_materia) ON DELETE CASCADE,
                                  PRIMARY KEY (RUT_profesor, ID_materia)
);

--Uso de INSERT para incersiones en las tablas.

INSERT INTO Directiva_de_profesores (ID_directiva, nombre, cargo) VALUES
                                                                      (1, 'Pedro Pérez', 'Director'),
                                                                      (2, 'Ana Gómez', 'Subdirectora');

INSERT INTO Profesor (RUT_profesor, nombre, telefono, correo, ID_directiva) VALUES
                                                                                ('12345678-9', 'Juan Martínez', '987654321', 'juan.martinez@example.com', 1),
                                                                                ('23456789-0', 'María López', '876543210', 'maria.lopez@example.com', 1),
                                                                                ('34567890-1', 'Laura Díaz', '765432109', 'laura.diaz@example.com', 2),
                                                                                ('45678901-2', 'Carlos Ruiz', '654321098', 'carlos.ruiz@example.com', 2);


INSERT INTO Curso (ID_curso, nivel, cantidad_alumnos) VALUES
                                                          (1, '1° Básico', 10),
                                                          (2, '2° Básico', 12),
                                                          (3, '3° Básico', 11),
                                                          (4, '4° Básico', 15);


INSERT INTO Materia (ID_materia, nombre, RUT_profesor) VALUES
                                                           (1, 'Matemáticas', '12345678-9'),
                                                           (2, 'Lenguaje', '23456789-0'),
                                                           (3, 'Inglés', '34567890-1'),
                                                           (4, 'Ciencias', '45678901-2');


INSERT INTO Alumnos (RUT_alumno, nombre, fecha_nacimiento, direccion, telefono_apoderado, ID_curso) VALUES
                                                                                                        ('11111111-1', 'Pedro Alonzo', '2015-05-10', 'Calle A, 123', '987654321', 1),
                                                                                                        ('22222222-2', 'Ana Fernández', '2013-08-20', 'Calle B, 456', '876543210', 2),
                                                                                                        ('33333333-3', 'Luis Martínez', '2016-12-01', 'Calle C, 789', '765432109', 1),
                                                                                                        ('44444444-4', 'Carla Sánchez', '2012-04-15', 'Calle D, 159', '654321098', 3),
                                                                                                        ('55555555-5', 'Roberto Pérez', '2011-11-30', 'Calle E, 753', '543210987', 4);



INSERT INTO Notas (ID_nota, calificacion, ID_alumno, ID_materia) VALUES
                                                                     (1, 6.5, '11111111-1', 1),
                                                                     (2, 5.0, '11111111-1', 2),
                                                                     (3, 4.0, '22222222-2', 1),
                                                                     (4, 7.0, '22222222-2', 3),
                                                                     (5, 3.5, '33333333-3', 4),
                                                                     (6, 6.0, '44444444-4', 2),
                                                                     (7, 4.5, '55555555-5', 3),
                                                                     (8, 6.7, '55555555-5', 4),
                                                                     (9, 5.5, '44444444-4', 1),
                                                                     (10, 4.0, '22222222-2', 2);


INSERT INTO Asistencia (ID_asistencia, fecha, estado, RUT_alumno, RUT_profesor, ID_materia) VALUES
                                                                                                (1, '2024-10-01', 'Presente', '11111111-1', '12345678-9', 1),
                                                                                                (2, '2024-10-01', 'Ausente', '22222222-2', '23456789-0', 2),
                                                                                                (3, '2024-10-01', 'Presente', '33333333-3', '34567890-1', 3),
                                                                                                (4, '2024-10-01', 'Presente', '44444444-4', '45678901-2', 4),
                                                                                                (5, '2024-10-01', 'Ausente', '55555555-5', '12345678-9', 1);


INSERT INTO Horarios (ID_horario, dia, hora_inicio, hora_fin, RUT_profesor, ID_curso, ID_materia) VALUES
                                                                                                      (1, 'Lunes', '08:00', '09:00', '12345678-9', 1, 1),
                                                                                                      (2, 'Lunes', '09:00', '10:00', '23456789-0', 2, 2),
                                                                                                      (3, 'Martes', '10:00', '11:00', '34567890-1', 1, 3),
                                                                                                      (4, 'Martes', '11:00', '12:00', '45678901-2', 4, 4);


--Consultas establecidas en informe para mostrar funcionamiento.

--Nombre de profesores que imparten ingles
SELECT P.nombre AS "Profesor", P.correo AS "Email", P.telefono AS "Telefono",
M.nombre AS "Materia"
FROM Profesor P
JOIN Materia M ON P.RUT_profesor = M.RUT_profesor
WHERE M.nombre = 'Inglés';



--Nombre de alumno que tiene prom < 5
SELECT A.nombre AS "Nombre", C.nivel AS "Curso",
AVG(N.calificacion) AS "Promedio notas"
FROM Notas N
JOIN Alumnos A ON N.ID_alumno = A.RUT_alumno
JOIN Curso C ON A.ID_curso = C.ID_curso
GROUP BY A.nombre, C.nivel
HAVING AVG(N.calificacion) < 5.0
ORDER BY "Promedio notas" ASC;
;

--Promedio de un curso en especifico segun su id (en este caso id=1)
SELECT P.nombre AS "Profesor", P.correo AS "Email", P.telefono AS "Teléfono",
M.nombre AS "Materia"
FROM Profesor P
JOIN Materia M ON P.RUT_profesor = M.RUT_profesor
WHERE M.nombre = 'Lenguaje';


--Nombres de los profesores que imparten lenguaje
SELECT P.nombre AS "Profesor"
FROM Profesor P
JOIN Materia M ON P.RUT_profesor = M.RUT_profesor
WHERE M.nombre = 'Lenguaje';


--En que horario se imparte matematicas
SELECT hora_inicio AS "Inicio", hora_fin AS "Fin" FROM Horarios H
JOIN Materia M ON H.ID_materia = M.ID_materia
WHERE M.nombre = 'Matemáticas';

--Nombre y curso de alumnos que tienen notas sobre 6
SELECT A.nombre AS "Alumno", C.nivel AS "Curso"
FROM Alumnos A
JOIN Notas N ON A.RUT_alumno = N.ID_alumno
JOIN Curso C ON A.ID_curso = C.ID_curso
WHERE N.calificacion > 6.0
GROUP BY A.nombre, C.nivel;


--Nombre de alumnos que tienen menos del 50% de asistencia
SELECT A.nombre AS "Alumno"
FROM Alumnos A
JOIN Asistencia I ON A.RUT_alumno = I.RUT_alumno
GROUP BY A.RUT_alumno, A.nombre
HAVING COUNT(CASE WHEN I.estado = 'Presente' THEN 1 END) < (COUNT(*) * 0.5);


--Porcentaje de asistencia de profesores de matematica
SELECT P.nombre,
(COUNT(CASE WHEN A.estado = 'Presente' THEN 1 END) * 100.0) / COUNT(*) AS porcentaje_asistencia
FROM Asistencia A
JOIN Profesor P ON A.RUT_profesor = P.RUT_profesor
JOIN Materia M ON A.ID_materia = M.ID_materia
WHERE M.nombre = 'Matemáticas'
GROUP BY P.nombre;


--Nombres de los alumnos que tienen entre 5 y 10 anos
SELECT A.nombre AS "Alumno",
DATE_PART('year', AGE(A.fecha_nacimiento)) AS "Edad"
FROM Alumnos A
WHERE DATE_PART('year', AGE(A.fecha_nacimiento)) BETWEEN 5 AND 10;



--Telefono del apoderado de un alumno en especifico segiun su rut (en este caso rut = 44444444-4)
SELECT nombre AS "Alumno", telefono_apoderado AS "Telefono Apoderado"
FROM Alumnos
WHERE RUT_alumno = '44444444-4';



--Obtener el promedio de notas por materia de cada alumno
SELECT A.nombre AS "Alumno", M.nombre AS "Materia",
ROUND(AVG(N.calificacion), 2) AS "Promedio"
FROM Alumnos A
JOIN Notas N ON A.RUT_alumno = N.ID_alumno
JOIN Materia M ON N.ID_materia = M.ID_materia
GROUP BY A.nombre, M.nombre
ORDER BY A.nombre ASC;




--Nombre del curso con mejor promedio
SELECT C.nivel AS nombre_curso, ROUND(AVG(N.calificacion),2) AS promedio_curso
FROM Curso C
JOIN Alumnos A ON C.ID_curso = A.ID_curso
JOIN Notas N ON A.RUT_alumno = N.ID_alumno
GROUP BY C.nivel
ORDER BY promedio_curso DESC
LIMIT 1;


--Cursos que tienen al menos un alumno con nota bajio 4
SELECT C.nivel AS "Curso",
COUNT(DISTINCT A.RUT_alumno) AS "Alumnos con nota < 4",
ROUND(AVG(N.calificacion), 2) AS "Promedio del Curso"
FROM Curso C
JOIN Alumnos A ON C.ID_curso = A.ID_curso
JOIN Notas N ON A.RUT_alumno = N.ID_alumno
WHERE N.calificacion < 4.0
GROUP BY C.nivel
ORDER BY C.nivel ASC;




--Un listado de los profesores y que materia imparte cada uno
SELECT P.nombre AS "Profesor", P.correo AS "Correo", P.telefono AS "Teléfono",
COUNT(DISTINCT M.ID_materia) AS "Total Materias",
COUNT(DISTINCT A.RUT_alumno) AS "Total Alumnos"
FROM Profesor P
JOIN Materia M ON P.RUT_profesor = M.RUT_profesor
LEFT JOIN Notas N ON M.ID_materia = N.ID_materia
LEFT JOIN Alumnos A ON N.ID_alumno = A.RUT_alumno
GROUP BY P.nombre, P.correo, P.telefono
ORDER BY P.nombre ASC;



--Nombres de los profesores con peor asistencia
SELECT P.nombre AS "Profesor",
COUNT(*) AS "Total Clases",
COUNT(CASE WHEN A.estado = 'Presente' THEN 1 END) AS "Asistencias",
COUNT(CASE WHEN A.estado = 'Ausente' THEN 1 END) AS "Ausencias",
ROUND((COUNT(CASE WHEN A.estado = 'Presente' THEN 1 END) * 100.0 / COUNT(*)), 2) AS "Porcentaje Asistencia"
FROM Profesor P
JOIN Asistencia A ON P.RUT_profesor = A.RUT_profesor
GROUP BY P.nombre
ORDER BY "Porcentaje Asistencia" ASC
LIMIT 1;



--Uso de ALTER

ALTER TABLE Profesor ADD COLUMN direccion VARCHAR(255);

--Uso de UPDATE

--Actualizar el nombre y el numero telefonico del apoderado de un alumno especifico
UPDATE Alumnos
SET nombre = 'Pedro Alonso', telefono_apoderado = '987654322'
WHERE Rut_alumno = '11111111-1';

--Uso de ALTER

--Borrar la asistencia de un alumno en una fecha especifica

DELETE FROM Asistencia WHERE RUT_alumno = '11111111-1' AND fecha = '2024-10-01';



