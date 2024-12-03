const express = require('express');
const app = express();
const port = 3000;
const { Pool } = require('pg');
require('dotenv').config(); // Carga las variables del archivo .env

// Configuración de la conexión
const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: {
        rejectUnauthorized: false, // Necesario para conexiones SSL en Neon
    },
});

// Configuración para servir archivos estáticos
app.use(express.static('public'));

// Ruta principal para mostrar index.html
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/html/index.html');
});

// Inicia el servidor
app.listen(port, () => {
    console.log(`Servidor corriendo en http://localhost:${port}`);
});
