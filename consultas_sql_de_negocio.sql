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

--- Facturación por venta: solo 3 de 10 ventas superan el promedio, y el producto 1 es el único que siempre queda por encima. 
--El promedio lo suben unas pocas ventas grandes.
--Clientes: los 5 compran exactamente 2 veces, así que la frecuencia no los diferencia. Lo que los distingue es cuánto gastan, y eso se ve sumando total_venta por cliente.
--Productos: el producto 1 genera cerca del 59% de los ingresos del top 5 con solo 3 unidades. El producto 2 vende más unidades (13) pero factura lo menos, porque cada unidad vale muy poco.

--La conclusión es que hay que mirar el valor y no el volumen. Para decidir qué productos priorizar, el siguiente paso es calcular el margen (precio − costo).