USE Ventas_Tech_DB
SELECT  MONTH(fecha_venta) AS Mes,COUNT(id_venta) AS count_ventas ,SUM(precio_unitario*cantidad) AS ingresos_totales
FROM Ventas
GROUP BY MONTH(fecha_venta);

USE Ventas_Tech_DB
SELECT TOP 5 id_producto, SUM(cantidad) as count_productos_vendidos,SUM(precio_unitario*cantidad) as total_generado
FROM Ventas
GROUP BY id_producto
ORDER BY total_generado DESC


USE Ventas_Tech_DB
SELECT id_cliente, COUNT(id_venta) AS count_ventas
FROM Ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1


USE Ventas_Tech_DB
SELECT 
id_producto, 
CASE
        WHEN (precio_unitario * cantidad) >=
             (SELECT AVG(precio_unitario * cantidad) FROM Ventas)
        THEN 'Por Encima'
        ELSE 'Por Debajo'
    END AS promedio_facturacion
FROM Ventas