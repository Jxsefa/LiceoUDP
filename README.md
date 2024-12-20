# LiceoUDP - Proyecto de Base de Datos

Este repositorio contiene el proyecto semestral para la asignatura de **Bases de Datos** de la Universidad Diego Portales. La aplicación desarrollada consiste en una **plataforma web** para la gestión de datos de un liceo, incluyendo alumnos, profesores, materias, asistencias, horarios y notas, utilizando una base de datos relacional en PostgreSQL.

## Descripción del Proyecto

El proyecto permite realizar diversas operaciones sobre la base de datos de manera interactiva, mediante una interfaz web desarrollada con tecnologías modernas y conexión directa a PostgreSQL. Las operaciones principales incluyen:

- **Consultas**: Ejecución de queries predeterminadas para recuperar información clave.
- **Inserciones**: Registro de nuevos datos en las tablas disponibles.
- **Actualizaciones**: Modificación de datos existentes.
- **Eliminaciones**: Eliminación de registros específicos según sus identificadores.

## Tecnologías Utilizadas

- **Backend**: Node.js con Express.js.
- **Base de Datos**: PostgreSQL.
- **Frontend**: HTML, CSS (Bootstrap) y JavaScript.
- **Conexión a la BD**: Biblioteca `pg` para Node.js.

## Requisitos de Instalación

### Prerrequisitos

1. Node.js (versión 16 o superior).
2. PostgreSQL (configurado con la base de datos proporcionada).
3. Acceso a una terminal o consola para ejecutar comandos.

### Configuración del Entorno

1. Clona este repositorio:

   git clone https://github.com/Jxsefa/LiceoUDP.git
   cd LiceoUDP
2. Instala las dependencias:

   npm install
3. para efectos de este curso incluimos en el repositorio el archivo .env

4. Ejecuta el siguiente comando para iniciar el servidor:

   node app.js

## Uso de Funcionalidades
1. Consultas: Realiza consultas predefinidas seleccionándolas desde el formulario principal.
2. Ingresos: Agrega nuevos registros seleccionando una tabla y completando el formulario dinámico.
3. Eliminaciones: Elimina registros ingresando el ID o clave primaria.
4. Actualizaciones: Actualiza registros existentes completando el formulario con los datos necesarios.