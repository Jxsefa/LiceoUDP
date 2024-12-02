const express = require('express');
const app = express();
const port = 3000;

// Configuración de EJS
app.set('view engine', 'ejs');
app.set('views', './views');

// Ruta principal
app.get('/', (req, res) => {
    res.render('index', { title: 'Inicio' });
});

app.listen(port, () => {
    console.log(`Servidor corriendo en http://localhost:${1000}`);
});
