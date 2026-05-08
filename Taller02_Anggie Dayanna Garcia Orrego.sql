# TALLER N° 2: Anggie Dayanna García Orrego
# Solución de ejercicios prácticos sobre la Base de Datos Sakila que simula un negocio de alquiler de películas.

# CONEXIÓN: indicamos al sistema que trabaje sobre la base de datos sakila
USE sakila;

# PARTE 1: SELECT Y WHERE

-- 1. Mostrar nombre y apellido de todos los clientes
-- Al ejecutar me muestra un lista con dos columnas con el nombre y apellido de los clientes de la base de datos
SELECT first_name, last_name
FROM customer;

-- 2. Películas con duración mayor a 120 minutos
-- Al ejecutar me muestra una lista con dos columnas con nombre de la pelicula y duración de las mayores a 120 minutos
SELECT title, length
FROM film
WHERE length > 120;

# PARTE 2: ORDER BY

-- 3. Ordenar clientes por apellido --> Por orden alfabetico de la A a la Z
-- Al ejecutar me muestra la misma lista del punto 1, pero ordenada alfabeticamente de la A a la Z
SELECT first_name, last_name
FROM customer
ORDER BY last_name ASC;

-- 4. Top 5 películas más largas --> TIP: Use la palabra LIMIT
-- Al ejecutar me muestra una lista con dos columnas titulo y duración, ordenada de forma Descendente para obtener las 5 de mayor duración
SELECT title, length
FROM film
ORDER BY length DESC
LIMIT 5;

# PARTE 3: INNER JOIN

-- 5. Cantidad pagada y fecha del pago con nombre y apellido del cliente (JOIN entre Payment - Customer)
-- Al ejecutar me muestra nombre y apellido qué valor pagó y en qué fecha, como un historial de ventas
SELECT customer.first_name, customer.last_name, payment.amount, payment.payment_date
FROM payment
INNER JOIN customer 
ON payment.customer_id = customer.customer_id;

-- 6. Películas alquiladas (JOIN entre Rental - Inventory - Film)
-- Al ejecutar me muestra el nombre de la pelicula y la fecha en que fue rentada, como el movimiento de inventario
SELECT film.title, rental.rental_date
FROM rental
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
ON inventory.film_id = film.film_id;

# PARTE 4: LEFT JOIN

-- 7. Nombre y apellido de clientes sin pagos (LEFT JOIN entre Payment - Customer pero usando WHERE)
-- Al ejecutar no me muestra registros, concluyo que todos los clientes han efectuado el respectivo pago
SELECT customer.first_name, customer.last_name
FROM customer
LEFT JOIN payment 
ON customer.customer_id = payment.customer_id
WHERE payment.payment_id IS NULL;

-- 8. Listar los nombres de las peliculas y su duracion de aquellos titulos que no tienen actores
-- Al ejecutar me muestra 3 registros con el titulo y duración que no tienen asignado un actor, puede servir para detectar errores 
-- al cargar los datos
SELECT film.title, film.length 
FROM film
LEFT JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id IS NULL;

# PARTE 5: INSERT, UPDATE, DELETE (Data Definition Language)

-- 9. Insertar actor temporal
-- Al ejecutar inserta el nombre en la fila 201, luego con el select la llame para verificarlo; al eliminarlo y ejecutar nuevamente
-- aparece en la fila 202 y asi sucesivamente, por lo que es necesario modificar el número de fila en el Update
INSERT INTO actor (first_name, last_name) 
VALUES ('ANGGIE', 'GARCIA');

SELECT * FROM actor;

-- 10. Actualizar actor
-- Al ejecutar modifica el nombre que inserté en el codigo anterior, pero debo modificar el número de la fila porque en el punto 11 lo eliminé
-- y el sistema no reutiliza el consecutivo, uso otra vez el select para verificar
UPDATE actor 
SET actor.first_name = 'DAYANNA' , actor.last_name = 'ORREGO'
WHERE actor.actor_id = 203;

SELECT * FROM actor;

-- 11. Eliminar actor
-- Al ejecutar elimina el registro modificado, verifico nuevamente con el select
DELETE FROM actor 
WHERE actor.first_name = 'DAYANNA' AND actor.last_name = 'ORREGO';

SELECT * FROM actor;

# PARTE 6: CONSULTAS AVANZADAS

-- 12. Top 5 clientes con mayor cantidad de dinero pagado al servicio de rentas
-- Al ejecutar me muestra los 5 clientes que mas ingresos le generan al negocio
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS total_pagado
FROM customer
INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY total_pagado DESC
LIMIT 5;

-- 13. Top 5 Películas más alquiladas (JOIN entre Rental - Inventory - Film) --> Agrupar los datos con conteo y tomar las mejores 5
-- Al ejecutar me muestra las peliculas que mas cantidad de veces se han alquilado, son las que tienen mas movimiento
SELECT film.title, COUNT(rental.rental_id) AS total_alquileres
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.film_id, film.title
ORDER BY total_alquileres DESC
LIMIT 5;