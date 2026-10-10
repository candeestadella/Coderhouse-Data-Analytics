-- =============================================
-- PROYECTO RETAILPRO
-- PRE-ENTREGA M4: CONSULTAS SQL DE NEGOCIO
-- =============================================

USE Ventas_Tech_DB;
GO


-- =============================================
-- CONSULTA 1: RESUMEN EJECUTIVO MENSUAL
-- Total facturado, cantidad de pedidos y
-- ticket promedio agrupados por mes.
-- =============================================

SELECT
    MONTH(fecha_venta) AS Mes,
    SUM(cantidad * precio_unitario) AS Total_Facturado,
    COUNT(*) AS Cantidad_Pedidos,
    AVG(cantidad * precio_unitario) AS Ticket_Promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY MONTH(fecha_venta);


-- =============================================
-- CONSULTA 2: RANKING DE PRODUCTOS
-- Top 5 de productos por total facturado.
-- =============================================

SELECT TOP 5
    id_producto AS ID_Producto,
    SUM(cantidad) AS Unidades_Vendidas,
    SUM(cantidad * precio_unitario) AS Total_Generado
FROM ventas
GROUP BY id_producto
ORDER BY Total_Generado DESC;


-- =============================================
-- CONSULTA 3: CLIENTES RECURRENTES
-- Clientes con más de un pedido.
-- =============================================

SELECT
    id_cliente AS ID_Cliente,
    COUNT(*) AS Cantidad_Pedidos,
    SUM(cantidad * precio_unitario) AS Total_Gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY Total_Gastado DESC;


-- =============================================
-- CONSULTA 4: FACTURACION MENSUAL VS. PROMEDIO
-- Compara el total de cada mes con el promedio
-- de facturacion mensual general.
-- =============================================

WITH FacturacionMensual AS (
    SELECT
        MONTH(fecha_venta) AS Mes,
        SUM(cantidad * precio_unitario) AS Total_Facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    Mes,
    Total_Facturado,
    AVG(Total_Facturado) OVER () AS Promedio_Mensual,
    CASE
        WHEN Total_Facturado >
             AVG(Total_Facturado) OVER ()
            THEN 'Por encima'
        WHEN Total_Facturado <
             AVG(Total_Facturado) OVER ()
            THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS Comparacion_Promedio
FROM FacturacionMensual
ORDER BY Mes;


-- =============================================
-- RESULTADOS DEL ANALISIS
-- =============================================

-- 1. El producto 1 genero $3600, aproximadamente
--    el 55,86% de la facturacion total registrada.

-- 2. El producto 3 genero $1350, siendo el segundo
--    producto con mayor facturacion.

-- 3. Los cinco clientes realizaron dos pedidos
--    cada uno durante el periodo registrado.
