# BDTurismo

Repositorio con la base de datos `BDTurismo` y un conjunto de consultas SQL guiadas para PostgreSQL.

## Archivos incluidos

- `BDTurismo.sql` — esquema de la base de datos y datos de ejemplo para la base de datos `accommodations_tourism`.
- `BDTurismo_consultas.sql` — 20 consultas SQL guiadas con enunciados numerados y descripciones.

## Uso

1. Importar el archivo `BDTurismo.sql` en PostgreSQL o PGAdmin4 para crear la base de datos y tablas.
2. Seleccionar la base de datos `accommodations_tourism`.
3. Ejecutar las consultas de `BDTurismo_consultas.sql` en el orden deseado.

## Consultas destacadas

- INSERT: Agregar propietarios, alojamientos, huéspedes, reservas y pagos.
- SELECT: Filtrado por estado, nacionalidad y rango de fechas.
- UPDATE: Actualizar precios y estados de reserva.
- DELETE: Eliminar reseñas.
- JOIN: Consultas relacionales entre reservas, huéspedes, alojamientos y pagos.
- AGG/HAVING: Cálculo de ingresos y agrupar reservas.
- Subconsulta: Obtener el alojamiento más caro.

## Autor

Repositorio creado para el proyecto de base de datos `BDTurismo`.
