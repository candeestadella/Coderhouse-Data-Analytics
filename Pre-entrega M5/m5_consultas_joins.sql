-- =============================================
-- PROYECTO RETAILPRO
-- PRE-ENTREGA M5: CONSULTAS CON JOINS
-- =============================================

USE Ventas_Tech_DB;
GO


-- =============================================
-- CONSULTA 1: VISTA BASE DEL PROYECTO
-- INNER JOIN
-- =============================================

SELECT
v.fecha_venta,
c.id_cliente,
c.nombre AS nombre_cliente,
c.ciudad,
p.nombre_producto,
cat.nombre_categoria,
v.cantidad,
v.precio_unitario,
v.cantidad * v.precio_unitario AS total_venta
FROM ventas v
INNER JOIN clientes c
ON v.id_cliente = c.id_cliente
INNER JOIN productos p
ON v.id_producto = p.id_producto
INNER JOIN categorias cat
ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;


-- =============================================
-- CONSULTA 2: CLIENTES SIN VENTAS
-- LEFT JOIN
-- =============================================

SELECT
c.nombre,
c.email,
c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;


-- =============================================
-- CONSULTA 3: PRODUCTOS SIN VENTAS
-- LEFT JOIN
-- =============================================

SELECT
p.nombre_producto,
cat.nombre_categoria,
p.precio
FROM productos p
INNER JOIN categorias cat
ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v
ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;


-- =============================================
-- CONSULTA 4: CONSOLIDADO POR PERIODO
-- UNION ALL
-- =============================================

SELECT
consolidado.canal,
SUM(consolidado.total) AS total_canal
FROM (
SELECT
fecha_venta,
cantidad * precio_unitario AS total,
'Primera quincena' AS canal
FROM ventas
WHERE DAY(fecha_venta) <= 15

UNION ALL

SELECT
fecha_venta,
cantidad * precio_unitario AS total,
'Segunda quincena' AS canal
FROM ventas
WHERE DAY(fecha_venta) > 15
) AS consolidado
GROUP BY consolidado.canal
ORDER BY consolidado.canal;

-- =============================================
-- Se separan las ventas en primera y segunda quincena
-- según el día de la fecha de venta.
-- En los datos actuales, todas las ventas corresponden
-- a la primera quincena.
-- =============================================
