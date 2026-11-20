USE Ventas_Tech_DB;

-- Consulta 1. Inner join 

SELECT
    Ven.fecha_venta,
    Ven.id_venta,
    Ven.id_cliente,
    C.nombre AS cliente,
    C.email,
    c.ciudad,
    Ven.id_producto,
    P.nombre_producto,
    cat.nombre_categoria AS Categoria_producto,
    P.stock,
    Ven.cantidad,
    Ven.precio_unitario,
    Ven.precio_unitario * Ven.cantidad AS total_venta
FROM Ventas AS Ven
INNER JOIN Productos AS P ON Ven.id_producto = P.id_producto
INNER JOIN Clientes  AS C ON Ven.id_cliente  = C.id_cliente
INNER JOIN Categorias AS Cat ON Cat.id_categoria = P.id_categoria;

-- Hallazgo: se obtienen las 10 ventas registradas, todas con cliente y producto
-- asociados. Las ventas 3 y 9 tienen cantidad nula, por lo que su total_venta
-- sale nulo y conviene corregirlas para no subestimar los ingresos.


-- Consulta 2: Left Join

USE Ventas_Tech_DB;

SELECT
C.id_cliente,
C.nombre AS Cliente,
c.email,
c.fecha_registro,
c.ciudad,
ven.id_venta
FROM Clientes AS C
LEFT JOIN Ventas AS ven ON C.id_cliente = Ven.id_cliente
    WHERE ven.id_venta IS NULL;

-- Hallazgo: la consulta no devuelve clientes, es decir, los 5 clientes
-- registrados tienen al menos una compra válida. No hay clientes inactivos
-- que reactivar con campañas.

--Consulta 3: left Join 2

USE Ventas_Tech_DB;

SELECT
P.id_producto,
P.nombre_producto,
Cat.nombre_categoria,
ven.id_venta,
ven.precio_unitario

FROM Productos AS P
LEFT JOIN Ventas AS ven ON ven.id_producto = P.id_producto
LEFT JOIN Categorias AS Cat ON p.id_categoria = Cat.id_categoria
    WHERE ven.id_venta IS NULL;

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

-- Hallazgo: el período 2 facturó 3.094 frente a 2.780 del período 1, unos 314
-- más. El período 1 depende de una sola venta de laptops (2.400), y las ventas
-- con cantidad nula quedaron fuera del cálculo, así que la diferencia debe
-- leerse con cautela.

-- El período 2 facturó 314 más que el período 1 (cerca de 11%), así que la facturación 
--subió en la segunda parte del mes. Sin embargo, hay que leer la diferencia con cuidado
--El período 1 depende de una sola venta. La venta 1 (2 laptops, 2.400) es el 86% de ese período. Sin ella, el período 1 habría quedado muy por debajo.
--El período 2 es más parejo. Suma 5 ventas válidas (de 390, 380, 1.200, 224 y 900) y no depende de una sola.