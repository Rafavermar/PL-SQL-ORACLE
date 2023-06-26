------------------------------------------------------------------------
------------------------- EJERCICIO 1  -----------------------------------

-- Crear una consulta que devuelva los nombres de todos los clientes que cumplan las siguientes condiciones:
-- Que se hayan dado de alta el a�o pasado
-- Que tengan en el nombre al menos 2 letras "A"
-- Que tengan alguna direcci�n y m�s de 1 factura de este a�o
-- Crear una consulta que devuelva los nombres de los clientes y el importe de sus facturas, teniendo en cuenta:
-- Que s�lo nos interesan los clientes que no est�n dados de baja
-- Que s�lo queremos las facturas de un importe mayor a 100 euros
-- Queremos los registros ordenados por nombre de cliente
-- Crear una consulta que devuelva, por cada domicilio, el tipo de v�a concatenado con el nombre de la calle y el n�mero de clientes activos que tienen
-- Crear una consulta que devuelva, por cada cliente, el n�mero de facturas, el importe total de sus facturas, el n�mero de domicilios y el n�mero de sus domicilios que tengan como tipo de v�a una rotonda
-- Repetir la �ltima consulta, utilizando uniones de consulta


SELECT * 
  FROM TClientes C
 WHERE TO_CHAR (FxAlta, 'YYYY') = TO_CHAR (SYSDATE, 'YYYY') - 1
   AND dsCliente LIKE '%A%A%'
   AND EXISTS (SELECT 1
                 FROM TDomCli DC
                WHERE DC.idCliente = C.idCliente)
   AND (SELECT COUNT (1)
          FROM TFacturasX F
         WHERE C.idCliente = F.idCliente) > 1;



UPDATE TClientesX
SET fxbaja = SYSDATE
WHERE idCliente = 22;


SELECT C.dsCliente, F.importe
  FROM TClientesX C, TFacturasX F
 WHERE C.idCliente = F.idCliente
   AND C.fxBaja IS NOT NULL
   AND F.importe > 100
 ORDER BY C.dsCliente;   
 

SELECT dsTipoVia||''||dsCalle AS "Direcci�n",
       COUNT (1) AS "Num. Clientes"
  FROM TDomCli DC, TClientesX C, TDomicilios D, TTiposVia TV
 WHERE C.fxBaja IS NULL
   AND DC.idCliente   = C.idCliente
   AND DC.idDomicilio = D.idDomicilio
   AND D.idTipoVia    = TV.idTipoVia
 GROUP BY dsTipoVia, dsCalle;


SELECT c.idCliente, c.dsCliente,
       (SELECT COUNT (1)     FROM TFacturas f WHERE  f.idCliente = c.idCliente),
       (SELECT SUM (importe) FROM TFacturas f WHERE  f.idCliente = c.idCliente),
       (SELECT COUNT (1)     FROM TDomCli  dc WHERE dc.idCliente = c.idCliente),
       (SELECT COUNT (1)       
          FROM TDomCli dc, TDomicilios d, TTiposVia tv 
         WHERE dc.idCliente = c.idCliente 
           AND dc.idDomicilio = d.idDomicilio 
           AND d.idTipoVia    = tv.idTipoVia
           AND LOWER (tv.dsTipoVia) = 'rotonda')
  FROM TClientes c;
  
  SELECT A       "C�digo de cliente", 
       B       "Nombre de cliente",
       SUM (C) "N�mero de facturas", 
       SUM (D) "Importe Total de las facturas",
       SUM (E) "N�mero de domicilios", 
       SUM (F) "N�mero de domicilios con rotonda"
  FROM
(  
SELECT c.idCliente A, c.dsCliente B, COUNT (1) C, 0 D, 0 E, 0 F
  FROM TClientes c, TFacturas f
 WHERE c.idCliente = f.idCliente
 GROUP BY c.idCliente, c.dsCliente
 UNION
SELECT c.idCliente, c.dsCliente, 0, SUM (importe), 0, 0
  FROM TClientes c, TFacturas f
 WHERE c.idCliente = f.idCliente
 GROUP BY c.idCliente, c.dsCliente
 UNION
SELECT c.idCliente, c.dsCliente, 0, 0, COUNT (1), 0
  FROM TClientes c, TDomCli dc
 WHERE c.idCliente = dc.idCliente
 GROUP BY c.idCliente, c.dsCliente
 UNION
SELECT c.idCliente, c.dsCliente, 0, 0, 0, COUNT (1)
  FROM TClientes c, TDomCli dc, TDomicilios d, TTiposVia tv 
 WHERE dc.idCliente = c.idCliente 
   AND dc.idDomicilio = d.idDomicilio 
   AND d.idTipoVia    = tv.idTipoVia
   AND LOWER (tv.dsTipoVia) = 'rotonda'
 GROUP BY c.idCliente, c.dsCliente
)
GROUP BY A, B;


