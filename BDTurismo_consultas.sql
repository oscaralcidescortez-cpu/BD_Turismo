-- Consultas guiadas para la base de datos BDTurismo
-- Ejecutar en PostgreSQL sobre la base de datos accommodations_tourism

-- 01 INSERT Insertar propietario - Agregar un nuevo propietario
INSERT INTO owners (owner_id, first_name, last_name, email, phone, country, city, address_line1, created_at, updated_at)
VALUES (21, 'Mariana', 'Rojas', 'mariana.rojas@example.com', '+56 9 1234 5678', 'Chile', 'Santiago', 'Av. Providencia 123', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 02 INSERT Insertar alojamiento - Crear alojamiento vinculado
INSERT INTO accommodations (accommodation_id, owner_id, accommodation_type_id, location_id, name, description, max_guests, bedroom_count, bathroom_count, base_price_per_night, currency_code, check_in_time, check_out_time, is_active, created_at, updated_at)
VALUES (21, 21, 3, 20, 'Andes Boutique Apart', 'Apartamento moderno cerca de la montaña.', 4, 2, 2, 180.00, 'USD', '15:00:00', '11:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 03 INSERT Huésped y reserva - Registrar huésped y reserva
INSERT INTO guests (guest_id, first_name, last_name, email, phone, nationality, created_at, updated_at)
VALUES (101, 'Camila', 'Torres', 'camila.torres@example.com', '+56 9 8765 4321', 'Chile', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO bookings (booking_id, guest_id, accommodation_id, room_id, booking_status_id, check_in_date, check_out_date, adult_count, child_count, subtotal_amount, tax_amount, discount_amount, total_amount, special_requests, booking_reference, booked_at, created_at, updated_at)
VALUES (101, 101, 21, NULL, 1, '2026-07-10', '2026-07-15', 2, 0, 900.00, 108.00, 0.00, 1008.00, 'Solicita vista al cerro.', 'BK-CHILE101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 04 INSERT Insertar pago - Registrar pago
INSERT INTO payments (payment_id, booking_id, payment_date, amount, payment_method, payment_status, transaction_reference, notes, created_at)
VALUES (91, 101, CURRENT_TIMESTAMP, 1008.00, 'CreditCard', 'Completed', 'tx-CHILE-101', 'Pago de reserva chilena.', CURRENT_TIMESTAMP);

-- 05 SELECT Alojamientos activos - Filtrar activos
SELECT accommodation_id, name, base_price_per_night, currency_code
FROM accommodations
WHERE is_active = TRUE
ORDER BY accommodation_id;

-- 06 SELECT Huéspedes por país - Filtrar por nacionalidad
SELECT guest_id, first_name, last_name, nationality
FROM guests
WHERE nationality = 'Mexico'
ORDER BY last_name;

-- 07 SELECT Reservas por fechas - Uso de BETWEEN
SELECT booking_id, guest_id, accommodation_id, check_in_date, check_out_date, total_amount
FROM bookings
WHERE check_in_date BETWEEN '2025-12-01' AND '2026-01-31'
ORDER BY check_in_date;

-- 08 UPDATE Actualizar precio - Modificar precio
UPDATE accommodations
SET base_price_per_night = base_price_per_night * 1.10
WHERE accommodation_id = 21;

-- 09 UPDATE Estado reserva - Actualizar estado
UPDATE bookings
SET booking_status_id = 2
WHERE booking_id = 101;

-- 10 DELETE Eliminar reseña - DELETE WHERE
DELETE FROM reviews
WHERE review_id = 60;

-- 11 JOIN Reservas + huésped - INNER JOIN
SELECT b.booking_id,
       g.first_name || ' ' || g.last_name AS guest_name,
       a.name AS accommodation_name,
       b.check_in_date,
       b.check_out_date,
       bs.status_name
FROM bookings b
INNER JOIN guests g ON b.guest_id = g.guest_id
INNER JOIN accommodations a ON b.accommodation_id = a.accommodation_id
INNER JOIN booking_statuses bs ON b.booking_status_id = bs.booking_status_id
WHERE b.booking_status_id = 2
ORDER BY b.booking_id;

-- 12 JOIN Alojamiento completo - INNER JOIN múltiple
SELECT a.accommodation_id,
       a.name AS accommodation_name,
       o.first_name || ' ' || o.last_name AS owner_name,
       l.country,
       l.city,
       l.address_line1
FROM accommodations a
INNER JOIN owners o ON a.owner_id = o.owner_id
INNER JOIN locations l ON a.location_id = l.location_id
ORDER BY a.accommodation_id;

-- 13 JOIN Pagos + reservas - JOIN combinado
SELECT p.payment_id,
       p.amount,
       p.payment_status,
       b.booking_reference,
       b.total_amount
FROM payments p
INNER JOIN bookings b ON p.booking_id = b.booking_id
WHERE p.payment_status = 'Completed'
ORDER BY p.payment_id;

-- 14 LEFT JOIN Sin reseñas - Incluye nulls
SELECT a.accommodation_id,
       a.name,
       r.review_id
FROM accommodations a
LEFT JOIN reviews r ON a.accommodation_id = r.accommodation_id
WHERE r.review_id IS NULL
ORDER BY a.accommodation_id
LIMIT 20;

-- 15 LEFT JOIN Sin reservas - Filtrar null
SELECT a.accommodation_id,
       a.name,
       b.booking_id
FROM accommodations a
LEFT JOIN bookings b ON a.accommodation_id = b.accommodation_id
WHERE b.booking_id IS NULL
ORDER BY a.accommodation_id;

-- 16 AGG Total, ingresos - SUM
SELECT SUM(amount) AS total_ingresos
FROM payments
WHERE payment_status = 'Completed';

-- 17 AGG Promedio rating - AVG
SELECT accommodation_id,
       ROUND(AVG(rating)::numeric, 2) AS promedio_rating,
       COUNT(*) AS cantidad_reviews
FROM reviews
GROUP BY accommodation_id
ORDER BY promedio_rating DESC
LIMIT 10;

-- 18 AGG Top alojamientos - COUNT + LIMIT
SELECT accommodation_id,
       COUNT(*) AS reservas
FROM bookings
GROUP BY accommodation_id
ORDER BY reservas DESC
LIMIT 5;

-- 19 HAVING Más de 3 reservas - GROUP BY + HAVING
SELECT accommodation_id,
       COUNT(*) AS reservas
FROM bookings
GROUP BY accommodation_id
HAVING COUNT(*) > 3
ORDER BY reservas DESC;

-- 20 Subconsulta Alojamiento más caro - Subquery
SELECT accommodation_id, name, base_price_per_night
FROM accommodations
WHERE base_price_per_night = (
    SELECT MAX(base_price_per_night)
    FROM accommodations
);
