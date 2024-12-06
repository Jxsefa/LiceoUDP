const express = require('express');
const app = express();
const port = 3000;
const {Pool} = require('pg');
require('dotenv').config();

// Configuración de la conexión a la base de datos
const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: {
        rejectUnauthorized: false,
    },
});

// Middleware para servir archivos estáticos
app.use(express.static('public'));

// Ruta principal para servir el archivo HTML
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/html/index.html'); // Ajusta la ruta si tu archivo está en otra ubicación
});

// Middleware para procesar JSON
app.use(express.json());

// Ruta POST para manejar consultas (ya configurada previamente)
app.post('/consultas', async (req, res) => {
    const consultaId = req.body.consulta;
    let query = '';

    switch (consultaId) {
        case '1': // Nombres de profesores que imparten inglés
            query = `
                SELECT P.nombre AS "Profesor", P.correo AS "Email", P.telefono AS "Telefono",
                M.nombre AS "Materia"
                FROM Profesor P
                JOIN Materia M ON P.RUT_profesor = M.RUT_profesor
                WHERE M.nombre = 'Inglés'`;
            break;

        case '2': // Nombre de alumnos con promedio menor a 5
            query = `
                SELECT A.nombre AS "Nombre", C.nivel AS "Curso",
                ROUND(AVG(N.calificacion), 2) AS "Promedio notas"
                FROM Notas N
                JOIN Alumnos A ON N.ID_alumno = A.RUT_alumno
                JOIN Curso C ON A.ID_curso = C.ID_curso
                GROUP BY A.nombre, C.nivel
                HAVING AVG(N.calificacion) < 5.0
                ORDER BY "Promedio notas" ASC`;
            break;

        case '3': // Promedio de un curso específico
            query = `
                SELECT C.nivel AS "Curso",
                ROUND(AVG(N.calificacion), 2) AS "Promedio_Notas"
                FROM Notas N
                JOIN Alumnos A ON N.ID_alumno = A.RUT_alumno
                JOIN Curso C ON A.ID_curso = C.ID_curso
                GROUP BY C.nivel
                ORDER BY C.nivel ASC`;
            break;

        case '4': // Nombres de los profesores que imparten lenguaje
            query = `
                SELECT P.nombre AS "Profesor", P.correo AS "Email", P.telefono AS "Teléfono",
                M.nombre AS "Materia"
                FROM Profesor P
                JOIN Materia M ON P.RUT_profesor = M.RUT_profesor
                WHERE M.nombre = 'Lenguaje';`;
            break;

        case '5': // Horario en el que se imparte matemáticas
            query = `
                SELECT hora_inicio AS "Inicio", hora_fin AS "Fin"
                FROM Horarios H
                JOIN Materia M ON H.ID_materia = M.ID_materia
                WHERE M.nombre = 'Matemáticas'`;
            break;

        case '6': // Nombres y cursos de alumnos con notas sobre 6
            query = `
                SELECT A.nombre AS "Alumno", C.nivel AS "Curso"
                FROM Alumnos A
                JOIN Notas N ON A.RUT_alumno = N.ID_alumno
                JOIN Curso C ON A.ID_curso = C.ID_curso
                WHERE N.calificacion > 6.0
                GROUP BY A.nombre, C.nivel`;
            break;

        case '7': // Alumnos con menos del 50% de asistencia
            query = `
                SELECT A.nombre AS "Alumno"
                FROM Alumnos A
                JOIN Asistencia I ON A.RUT_alumno = I.RUT_alumno
                GROUP BY A.RUT_alumno, A.nombre
                HAVING COUNT(CASE WHEN I.estado = 'Presente' THEN 1 END) < (COUNT(*) * 0.5)`;
            break;

        case '8': // Porcentaje de asistencia de profesores de matemáticas
            query = `
                SELECT P.nombre,
                (COUNT(CASE WHEN A.estado = 'Presente' THEN 1 END) * 100.0) / COUNT(*) AS porcentaje_asistencia
                FROM Asistencia A
                JOIN Profesor P ON A.RUT_profesor = P.RUT_profesor
                JOIN Materia M ON A.ID_materia = M.ID_materia
                WHERE M.nombre = 'Matemáticas'
                GROUP BY P.nombre`;
            break;

        case '9': // Nombres de alumnos entre 5 y 10 años
            query = `
                SELECT A.nombre AS "Alumno",
                DATE_PART('year', AGE(A.fecha_nacimiento)) AS "Edad"
                FROM Alumnos A
                WHERE DATE_PART('year', AGE(A.fecha_nacimiento)) BETWEEN 5 AND 10`;
            break;

        case '10': // Teléfono del apoderado de un alumno específico
            query = `
                SELECT nombre AS "Alumno", telefono_apoderado AS "Telefono Apoderado"
                FROM Alumnos
                WHERE RUT_alumno = '44444444-4'`;
            break;

        case '11': // Promedio de notas por materia de cada alumno
            query = `
                SELECT A.nombre AS "Alumno", M.nombre AS "Materia",
                ROUND(AVG(N.calificacion), 2) AS "Promedio"
                FROM Alumnos A
                JOIN Notas N ON A.RUT_alumno = N.ID_alumno
                JOIN Materia M ON N.ID_materia = M.ID_materia
                GROUP BY A.nombre, M.nombre
                ORDER BY A.nombre ASC`;
            break;

        case '12': // Curso con mejor promedio
            query = `
                SELECT C.nivel AS nombre_curso, ROUND(AVG(N.calificacion), 2) AS promedio_curso
                FROM Curso C
                JOIN Alumnos A ON C.ID_curso = A.ID_curso
                JOIN Notas N ON A.RUT_alumno = N.ID_alumno
                GROUP BY C.nivel
                ORDER BY promedio_curso DESC
                LIMIT 1`;
            break;

        case '13': // Cursos con al menos un alumno con nota menor a 4
            query = `
                SELECT C.nivel AS "Curso",
                COUNT(DISTINCT A.RUT_alumno)  AS "Alumnos con nota < 4",
                ROUND(AVG(N.calificacion), 2) AS "Promedio del Curso"
                FROM Curso C
                JOIN Alumnos A ON C.ID_curso = A.ID_curso
                JOIN Notas N ON A.RUT_alumno = N.ID_alumno
                WHERE N.calificacion < 4.0
                GROUP BY C.nivel
                ORDER BY C.nivel ASC`;
            break;

        case '14': // Listado de profesores y las materias que imparten
            query = `
                SELECT P.nombre AS "Profesor", P.correo AS "Correo", P.telefono AS "Teléfono",
                COUNT(DISTINCT M.ID_materia) AS "Total Materias",
                COUNT(DISTINCT A.RUT_alumno) AS "Total Alumnos"
                FROM Profesor P
                JOIN Materia M ON P.RUT_profesor = M.RUT_profesor
                LEFT JOIN Notas N ON M.ID_materia = N.ID_materia
                LEFT JOIN Alumnos A ON N.ID_alumno = A.RUT_alumno
                GROUP BY P.nombre, P.correo, P.telefono
                ORDER BY P.nombre ASC`;
            break;

        case '15': // Profesor con peor asistencia
            query = `
                SELECT P.nombre AS "Profesor",
                COUNT(*) AS "Total Clases",
                COUNT(CASE WHEN A.estado = 'Presente' THEN 1 END) AS "Asistencias",
                COUNT(CASE WHEN A.estado = 'Ausente' THEN 1 END) AS "Ausencias",
                ROUND((COUNT(CASE WHEN A.estado = 'Presente' THEN 1 END) * 100.0 / COUNT(*)),2)                                                                         AS "Porcentaje Asistencia"
                FROM Profesor P
                JOIN Asistencia A ON P.RUT_profesor = A.RUT_profesor
                GROUP BY P.nombre
                ORDER BY "Porcentaje Asistencia" ASC
                LIMIT 1`;
            break;

        default:
            return res.status(400).json({error: 'Consulta no válida.'});
    }

    try {
        const result = await pool.query(query);
        res.json(result.rows);
    } catch (err) {
        console.error('Error ejecutando la consulta:', err);
        res.status(500).send('Error en el servidor.');
    }
});

//PARA INGRESOS MISMA LOGICA QUE CONSULTAS CON LA DIFERENCIA DE QUE QUE EN EL SWITCH HAYA UNA FUNCION QUE ATRAVEZ DE LOS INPUT AGREGUE A LA TABLA (EJEMPLO CASO 1 AGREGAR LOS DATOS QUE SE ESCRIBAN A TABLA SELECCIONADA EN ESTE CASO PROFESOR)
// PARA ELIMINAR LO MISMO SOLO QUE ELIMINE POR ID (EJEMPLO CASO 1 QUE SE ELIMINE ID 1 DE TABLAS ASISTENCIA)
//ACTUALIZAR LO MISMA LOGICA (EJEMPLO TABLA PROFESOR PONES EL ID DEL PROFE Y QUE SE CAMBIA EL NUMERO DE TELEFONO)


//eliminar datos

app.post('/eliminar', async (req, res) => {
const { tabla, valor } = req.body;

if (!tabla || !valor) {
    return res.status(400).json({ error: 'Debe seleccionar una tabla y proporcionar un valor.' });
}

let clavePrimaria;
switch (tabla) {
    case 'Directiva_de_profesores':
        clavePrimaria = 'ID_Directiva';
        break;
    case 'Curso':
        clavePrimaria = 'ID_Curso';
        break;
    case 'Profesor':
        clavePrimaria = 'RUT_profesor';
        break;
    case 'Materia':
        clavePrimaria = 'ID_materia';
        break;
    case 'Alumnos':
        clavePrimaria = 'Rut_alumno';
        break;
    case 'Notas':
        clavePrimaria = 'ID_nota';
        break;
    case 'Asistencia':
        clavePrimaria = 'ID_asistencia';
        break;
    case 'Horarios':
        clavePrimaria = 'ID_horario';
        break;
    default:
        return res.status(400).json({ error: 'Tabla no válida.' });
}

try {
    const query = `DELETE FROM ${tabla} WHERE ${clavePrimaria} = $1`;
    const result = await pool.query(query, [valor]);

    if (result.rowCount === 0) {
        return res.status(404).json({ error: 'No se encontró un registro con ese valor.' });
    }

    res.json({ message: `Registro eliminado de la tabla ${tabla} con ${clavePrimaria} = ${valor}.` });
} catch (err) {
    console.error('Error al eliminar registro:', err);
    res.status(500).json({ error: 'Ocurrió un error al eliminar el registro.' });
}
});


//ingresos.
app.post('/ingresar', async (req, res) => {
    const { tabla, datos } = req.body;

    if (!tabla || !datos) {
        return res.status(400).json({ error: 'Debe seleccionar una tabla y proporcionar los datos.' });
    }

    let query = '';
    let values = [];

    switch (tabla) {
        case 'Directiva_de_profesores':
            query = `INSERT INTO Directiva_de_profesores (nombre, cargo) VALUES ($1, $2)`;
            values = [datos.nombre, datos.cargo];
            break;
        case 'Curso':
            query = `INSERT INTO Curso (nivel, cantidad_alumnos) VALUES ($1, $2)`;
            values = [datos.nivel, datos.cantidad_alumnos];
            break;
        case 'Profesor':
            query = `INSERT INTO Profesor (RUT_profesor, telefono, correo, ID_directiva) VALUES ($1, $2, $3, $4)`;
            values = [datos.RUT_profesor, datos.telefono, datos.correo, datos.ID_directiva];
            break;
        case 'Materia':
            query = `INSERT INTO Materia (nombre, RUT_profesor) VALUES ($1, $2)`;
            values = [datos.nombre, datos.RUT_profesor];
            break;
        case 'Alumnos':
            query = `INSERT INTO Alumnos (RUT_alumno, nombre, fecha_nacimiento, direccion, telefono_apoderado, ID_curso) VALUES ($1, $2, $3, $4, $5, $6)`;
            values = [datos.RUT_alumno, datos.nombre, datos.fecha_nacimiento, datos.direccion, datos.telefono_apoderado, datos.ID_curso];
            break;
        case 'Notas':
            query = `INSERT INTO Notas (nota, ID_alumno, ID_materia) VALUES ($1, $2, $3)`;
            values = [datos.nota, datos.ID_alumno, datos.ID_materia];
            break;
        case 'Asistencia':
            query = `INSERT INTO Asistencia (fecha, ID_alumno) VALUES ($1, $2)`;
            values = [datos.fecha, datos.ID_alumno];
            break;
        case 'Horarios':
            query = `INSERT INTO Horarios (hora, ID_materia, ID_profesor) VALUES ($1, $2, $3)`;
            values = [datos.hora, datos.ID_materia, datos.ID_profesor];
            break;
        default:
            return res.status(400).json({ error: 'Tabla no válida.' });
    }

    try {
        await pool.query(query, values);
        res.json({ message: `Registro ingresado correctamente en la tabla ${tabla}.` });
    } catch (err) {
        console.error('Error al ingresar registro:', err);
        res.status(500).json({ error: 'Ocurrió un error al ingresar el registro.' });
    }
});


app.listen(port, () => {
    console.log(`Servidor corriendo en http://localhost:${port}`);
});
