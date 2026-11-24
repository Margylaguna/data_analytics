USE Ventas_Tech_DB;

-- Consulta 1: Ventas e ingresos por mes
-- Propósito: medir cuántas ventas hay por mes, cuánto se factura y cuál es el
-- valor promedio de cada venta (ticket promedio).

SELECT
    MONTH(fecha_venta) AS Mes,
    COUNT(id_venta) AS count_ventas,
    SUM(precio_unitario * cantidad) AS ingresos_totales,
    AVG(precio_unitario * cantidad) AS ticket_promedio
FROM Ventas
GROUP BY MONTH(fecha_venta);


-- Hallazgo: todas las ventas ocurren en marzo (10 ventas en un solo mes). Las
-- ventas con cantidad nula no suman al ingreso ni entran al ticket promedio,
-- así que ambos valores quedan subestimados hasta corregir esos registros.


-- Consulta 2: Top 5 de productos por facturación
-- Propósito: identificar los productos que más ingresos generan y compararlos
-- con las unidades vendidas.


SELECT TOP 5
    id_producto,
    SUM(cantidad) AS count_productos_vendidos,
    SUM(precio_unitario * cantidad) AS total_generado
FROM Ventas
GROUP BY id_producto
ORDER BY total_generado DESC;


-- Hallazgo: el producto 1 genera más de la mitad de los ingresos del top 5 con
-- solo 3 unidades. El producto 2 vende más unidades (13) pero factura lo menos,
-- porque cada unidad vale muy poco. Hay que mirar el valor y no el volumen.


-- Consulta 3: Clientes con más de una compra y total gastado
-- Propósito: identificar clientes recurrentes y cuánto ha gastado cada uno.


SELECT
    id_cliente,
    COUNT(id_venta) AS count_ventas,
    SUM(precio_unitario * cantidad) AS total_gastado
FROM Ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;


-- Hallazgo: los 5 clientes compran exactamente 2 veces, así que la frecuencia
-- no los diferencia. Lo que los distingue es cuánto gastan: los clientes 1 y 5
-- concentran el mayor gasto, y son los que conviene fidelizar primero.


-- Consulta 4: Facturación por producto frente al promedio (CTE + CASE WHEN)
-- Propósito: clasificar cada producto según si su facturación total está por
-- encima o por debajo del promedio de facturación de todos los productos.

WITH facturacion_producto AS (
    SELECT
        id_producto,
        SUM(precio_unitario * cantidad) AS total_facturado
    FROM Ventas
    GROUP BY id_producto
)
SELECT
    id_producto,
    total_facturado,
    CASE
        WHEN total_facturado >= (SELECT AVG(total_facturado) FROM facturacion_producto)
        THEN 'Por Encima'
        ELSE 'Por Debajo'
    END AS promedio_facturacion
FROM facturacion_producto;

-- Hallazgo: solo 1 de los 6 productos (el producto 1) factura por encima del
-- promedio; los otros 5 quedan por debajo. La facturación está concentrada en
-- un producto, lo que implica dependencia de una sola línea. El siguiente paso
-- es calcular el margen (precio - costo) para decidir qué productos priorizar.