USE Ventas_Tech_DB;

-- Consulta 1. Inner join 

SELECT
    Ven.fecha_venta,
    Ven.id_venta,
    Ven.id_cliente,
    C.nombre AS cliente,
    C.email,
    Ven.id_producto,
    P.nombre_producto,
    P.stock,
    Ven.cantidad,
    Ven.precio_unitario,
    Ven.precio_unitario * Ven.cantidad AS total_venta
FROM Ventas AS Ven
INNER JOIN Productos AS P ON Ven.id_producto = P.id_producto
INNER JOIN Clientes  AS C ON Ven.id_cliente  = C.id_cliente;

-- Consulta 2: Left Join Esas dos ventas con NULL son un problema de calidad de datos. Su total_venta calculado (precio_unitario * cantidad) también saldrá NULL,
-- así que conviene revisarlas o excluirlas en los análisis de ingresos.

USE Ventas_Tech_DB;

SELECT
C.id_cliente,
C.nombre AS Cliente,
c.email,
c.fecha_registro,
c.ciudad,
ven.cantidad
FROM Clientes AS C
LEFT JOIN Ventas AS ven ON C.id_cliente = Ven.id_cliente
    WHERE ven.cantidad IS NULL;

--Consulta 3: left Join 2

USE Ventas_Tech_DB;

SELECT
P.id_producto,
P.nombre_producto,
P.id_categoria,
ven.cantidad
FROM Productos AS P
LEFT JOIN Ventas AS ven ON ven.id_producto = P.id_producto
    WHERE ven.cantidad IS NULL;

-- Consulta 4: All union

USE Ventas_Tech_DB;

SELECT canal, SUM(total) AS total_canal
FROM (
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Periodo 1 (5-9 mar)' AS canal
    FROM Ventas
    WHERE fecha_venta < '2024-03-10'

    UNION ALL

    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Periodo 2 (10-15 mar)' AS canal
    FROM Ventas
    WHERE fecha_venta >= '2024-03-10'
) AS consolidado
GROUP BY canal;

-- El período 2 facturó 314 más que el período 1 (cerca de 11%), así que la facturación 
--subió en la segunda parte del mes. Sin embargo, hay que leer la diferencia con cuidado
--El período 1 depende de una sola venta. La venta 1 (2 laptops, 2.400) es el 86% de ese período. Sin ella, el período 1 habría quedado muy por debajo.
--El período 2 es más parejo. Suma 5 ventas válidas (de 390, 380, 1.200, 224 y 900) y no depende de una sola.