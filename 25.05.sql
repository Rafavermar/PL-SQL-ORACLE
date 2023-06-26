 ------------------------------------------------------------------------
------------------------- FUNCIONES MAS COMUNES  ------------------------


-- saca todas las funciones
SELECT DISTINCT object_name
  FROM all_arguments
 WHERE package_name = 'STANDARD';


-- CASE --

SELECT CASE WHEN dsCliente LIKE 'TEL%' THEN 'TELEFÓNICA S.A.'
            WHEN dsCliente LIKE 'BAB%' THEN 'BABEL GROUP S.A.'
            ELSE dsCliente
            END "Descripción del cliente"
  FROM TClientesX
;
-- COALESCE -- Devuelve el primer valor de una lista que no sea nulo. Los elementos de la lista deben ser del mismo tipo

SELECT CASE WHEN dsCliente LIKE 'TEL%' THEN 'TELEFÓNICA S.A.'
            WHEN dsCliente LIKE 'BAB%' THEN 'BABEL GROUP S.A.'
            ELSE dsCliente
            END "Descripción del cliente"
  FROM TClientes
;

-- COUNT -- Devuelve el número de filas
  -- mi tabla no tiene campo inActivo --
SELECT COUNT (1)
  FROM TClientesX
 WHERE inActivo = 'S';


-- DECODE --Compara 2 expresiones. Se pueden anidar.

SELECT DECODE (idCliente, 1, 'Cliente 1', 'Otro cliente')
  FROM TClientesX;

SELECT DECODE (idCliente, 1, 'Cliente 1', DECODE (idCliente, 2, 'Cliente 2', 'Otro cliente'))
  FROM TClientesX;
  

-- DISTINCT -- Devuelve los elementos diferentes

SELECT DISTINCT (dsCliente)
  FROM TclientesX;


-- INITCAP -- Pasa la primera letra de cada palabra de la cadena a mayúsculas y el resto a minúsculas
SELECT INITCAP (dsCliente)
  FROM TClienteX;


-- INSTR -- Busca la primera ocurrencia de un carácter dentro de una cadena de texto

SELECT INSTR ('BARCELONA', 'B')
  FROM DUAL;
  

-- LEAST / GREATEST -- Devuelve el valor mínimo/máximo de una lista

SELECT LEAST (1, 3, 2, 8, 12), GREATEST (1, 3, 2, 8, 12)
  FROM DUAL;
  
  
-- LENGHT -- Devuelve la longitud de una cadena

SELECT LENGTH (dsCliente)
  FROM TClienteX;


-- LOWER / UPPER -- Pasa a minúsculas o a mayúsculas una cadena
SELECT LOWER (dsCliente), UPPER (dsCliente)
  FROM TClientesX;
  

-- LPAD / RPAD -- Agrega caracteres a la izquierda/derecha de una cadena
SELECT LPAD (dsCliente, 20, '*')
  FROM TClientesX;

-- MAX/MIN -- Devuelve el valor máximo o mínimo de los elementos
SELECT MAX (idCliente)
  FROM TClientesX;


-- NULLIF -- Compara 2 valores y devuelve NULL si son iguales. En caso contrario, devuelve el primer valor
SELECT NULLIF (dsCliente, 'BBVA')
  FROM TClientesX;

-- NVL -- Devuelve el valor del campo, u otro valor si éste es nulo
SELECT NVL (dsCliente, 'La descripción es NULL')
  FROM TClientesX;


-- REPLACE -- Reemplaza una subcadena de una cadena
SELECT REPLACE ('abccdefcg', 'c', '3')
  FROM DUAL; 


-- ROUND -- Redondea un número
SELECT ROUND (importe)
  FROM TFacturasX;
  

-- SUBSTR -- Devuelve una subcadena
SELECT SUBSTR ('Alameda', 2, 3) -– Cadena, posición inicial, longitud
  FROM DUAL;


-- SUM -- Devuelve el sumatorio
SELECT SUM (importe)
  FROM TFacturasX;


-- TRIM -- Elimina los espacios en blanco a izquierda y derecha de la cadena
SELECT TRIM (dsCliente)
  FROM TClientesX;


-- ROW_NUMBER -- 
--Establece un secuencial a cada fila devuelta en una consulta
--Dicho secuencial puede ser único para cada partición o para el conjunto entero de resultados
--Las particiones son agrupaciones de resultados por un criterio determinado

ROW_NUMBER() OVER (
                   [PARTITION BY <campo partición>] 
                    ORDER BY <campos ordenación>
                  )

--Si no se aplica una partición, esta función sólo tiene sentido para hacer paginaciones (se debe utilizar con la cláusula WITH o dentro de una subconsulta)

WITH alias1 AS (SELECT ROW_NUMBER () OVER (ORDER BY importe DESC) 
                       row_num, idCliente, idFactura, dsFactura, importe
                  FROM TFacturasX)
SELECT idCliente, idFactura, dsFactura, importe 
  FROM alias1
 WHERE row_num BETWEEN 1 and 4;

SELECT idCliente, idFactura, dsFactura, importe 
  FROM
               (SELECT ROW_NUMBER () OVER (ORDER BY importe DESC) 
                       row_num, idCliente, idFactura, dsFactura, importe
                  FROM TFacturasX)
 WHERE row_num BETWEEN 1 and 4;


-- EJEMPLO - cómo se sacaría un listado de las facturas más altas de cada cliente
-- Sin utilizer la función ROW_NUMBER, habría que hacer algo así

SELECT DISTINCT idCliente, 
        (SELECT idFactura 
           FROM TFacturasX 
          WHERE importe = (SELECT MAX (importe) 
                             FROM TFacturasX F2 
                            WHERE F2.idCliente = F.idCliente)) idFactura,
        (SELECT dsFactura 
           FROM TFacturasX 
          WHERE importe = (SELECT MAX (importe) 
                             FROM TFacturasX F2 
                            WHERE F2.idCliente = F.idCliente)) dsFactura,
        (SELECT importe   
           FROM TFacturasX 
          WHERE importe = (SELECT MAX (importe) 
                             FROM TFacturasX F2 
                            WHERE F2.idCliente = F.idCliente)) importe
  FROM TFacturasX F
 GROUP BY idCliente
 ORDER BY 4 DESC;
 

-- Ahora, utilizando la clausula WITH

 WITH alias1 AS (SELECT idCliente, idFactura, dsFactura, importe 
                   FROM TFacturasX F 
                  WHERE importe = (SELECT MAX (importe) 
                                     FROM TFacturasX F2 
                                    WHERE F2.idCliente = F.idCliente)) 
 SELECT alias1.* 
  FROM alias1
 ORDER BY 4 DESC;
 
 
-- Ahora, con ROW_NUMBER

SELECT idCliente, idFactura, dsFactura, importe
  FROM (
        SELECT ROW_NUMBER () OVER (PARTITION BY idCliente ORDER BY importe DESC) rn, 
               idCliente, idFactura, dsFactura, importe
          FROM TFacturasX
       )
 WHERE rn = 1
ORDER BY 4 DESC;


-- Finalmente, con WITH y ROW_NUMBER

WITH alias AS (SELECT ROW_NUMBER () OVER (PARTITION BY idCliente ORDER BY importe DESC) row_num,
                      idCliente, idFactura, dsFactura, importe
                 FROM TFacturasX)
SELECT idCliente, idFactura, dsFactura, importe 
  FROM alias
 WHERE row_num = 1
 ORDER BY 4 DESC;


------------------------------------------------------------------------
------------------------- TIPO DATE  -----------------------------------

TRUNC: Trunca un número o una fecha (la deja en dd/mm/yyyy)
SYSDATE: Devuelve la fecha del sistema

SELECT TO_CHAR (fxAlta, 'dd/mm/yyyy hh24:mi:ss')
  FROM TClientes;

UPDATE TClientes
   SET fxBaja = TO_DATE ('01-01-2023', 'DD-MM-YYYY')
 WHERE idCliente = 1;

SELECT *
  FROM TClientes
 WHERE TO_CHAR (fxAlta, 'YYYY') = '2023';

SELECT TRUNC (SYSDATE) -– Devuelve la fecha actual en formato dd/mm/yyyy
  FROM DUAL;

SELECT * -– Devuelve los clientes dados de alta ayer
  FROM TClientes
 WHERE TRUNC (fxAlta) = SYSDATE - 1;


-- EJEMPLO1 --
-- Realizar una consulta que devuelva la clasificación del medallero, pero teniendo en cuenta que un oro vale más que todas las platas juntas, y que una plata vale más que todos los bronces juntos

SELECT dsPais, SUM (DECODE (M.idMedallaM, 1, 1000000, DECODE (M.idMedallaM, 2, 1000, 1)))
  FROM TPaises P, TDeportes D, TMedallero M, TMedallas M2
 WHERE P.idPais    = M.idPaisM
   AND M.idDeporteM = D.idDeporte
   AND M.idMedallaM = M2.idMedalla
 GROUP BY dsPais
 ORDER BY 2 DESC, 1;
 
 -- EJEMPLO2 --
-- Realizar una consulta que devuelva el número de medallas de cada metal que ha conseguido cada país

SELECT dsPais "País", SUM (Oros) "M. Oro", SUM (Platas) "M. Plata", SUM (Bronces) "M. Bronce"
  FROM
(
SELECT dsPais, COUNT (1) Oros, 0 Platas, 0 Bronces
  FROM TPaises P, TDeportes D, TMedallero M, TMedallas M2
 WHERE P.idPais     = M.idPaisM
   AND M.idDeporteM  = D.idDeporte
   AND M.idMedallaM  = M2.idMedalla
   AND M2.dsMedalla = 'Oro'
 GROUP BY dsPais
UNION
SELECT dsPais, 0, COUNT (1), 0
  FROM TPaises P, TDeportes D, TMedallero M, TMedallas M2
 WHERE P.idPais     = M.idPaisM
   AND M.idDeporteM  = D.idDeporte
   AND M.idMedallaM  = M2.idMedalla
   AND M2.dsMedalla = 'Plata'
 GROUP BY dsPais
UNION
SELECT dsPais, 0, 0, COUNT (1)
  FROM TPaises P, TDeportes D, TMedallero M, TMedallas M2
 WHERE P.idPais     = M.idPaisM
   AND M.idDeporteM  = D.idDeporte
   AND M.idMedallaM  = M2.idMedalla
   AND M2.dsMedalla = 'Bronce'
 GROUP BY dsPais
) 
GROUP BY dsPais
ORDER BY 2 DESC, 3 DESC, 4 DESC, 1;

-- EJEMPLO3 --
-- Añadir registros a las tablas de Países, Deportes y Medallero, pero utilizando secuencias para evitar que haya registros duplicados

INSERT INTO TPaises (idPais, dsPais) VALUES (Seq_Pais.NEXTVAL, 'Turquía');
INSERT INTO TPaises (idPais, dsPais) VALUES (Seq_Pais.NEXTVAL, 'Islandia');
INSERT INTO TPaises (idPais, dsPais) VALUES (Seq_Pais.NEXTVAL, 'Alemania');
INSERT INTO TPaises (idPais, dsPais) VALUES (Seq_Pais.NEXTVAL, 'Luxemburgo');
INSERT INTO TPaises (idPais, dsPais) VALUES (Seq_Pais.NEXTVAL, 'Ucrania');

INSERT INTO TDeportes (idDeporte, dsDeporte) VALUES (Seq_Deporte.NEXTVAL, 'Boxeo');
INSERT INTO TDeportes (idDeporte, dsDeporte) VALUES (Seq_Deporte.NEXTVAL, 'Kárate');
INSERT INTO TDeportes (idDeporte, dsDeporte) VALUES (Seq_Deporte.NEXTVAL, 'Vela');

INSERT INTO TMedallero (idPaisM, idDeporteM, idMedallaM) 
     VALUES (Seq_Pais.CURRVAL - 3, Seq_Deporte.CURRVAL - 1, 1);
INSERT INTO TMedallero (idPaisM, idDeporteM, idMedallaM) 
     VALUES (Seq_Pais.CURRVAL - 3, Seq_Deporte.CURRVAL - 2, 2);
INSERT INTO TMedallero (idPaisM, idDeporteM, idMedallaM) 
     VALUES (Seq_Pais.CURRVAL - 2, Seq_Deporte.CURRVAL  -1,  2);
INSERT INTO TMedallero (idPaisM, idDeporteM, idMedallaM) 
     VALUES (Seq_Pais.CURRVAL - 2, Seq_Deporte.CURRVAL  -2,  1);
INSERT INTO TMedallero (idPaisM, idDeporteM, idMedallaM) 
     VALUES (Seq_Pais.CURRVAL - 1, Seq_Deporte.CURRVAL - 2, 1);
INSERT INTO TMedallero (idPaisM, idDeporteM, idMedallaM) 
     VALUES (Seq_Pais.CURRVAL - 1, Seq_Deporte.CURRVAL - 2, 2);
INSERT INTO TMedallero (idPaisM, idDeporteM, idMedallaM) 
     VALUES (Seq_Pais.CURRVAL,     Seq_Deporte.CURRVAL - 2, 3);
INSERT INTO TMedallero (idPaisM, idDeporteM, idMedallaM) 
     VALUES (Seq_Pais.CURRVAL,     Seq_Deporte.CURRVAL - 1, 3); 
INSERT INTO TMedallero (idPaisM, idDeporteM, idMedallaM) 
     VALUES (Seq_Pais.CURRVAL - 4, Seq_Deporte.CURRVAL - 1, 2);
     
     select * FROM TMEDALLERO;
     select * FROM TDEPORTES;
     SELECT * FROM TPAISES;
     
     
-- EJEMPLO 4 --
--Realizar una consulta que devuelva la primera letra del país en mayúsculas, la descripción del país, si el país contiene, al menos, una letra A y el número total de medallas conseguidas de cada tipo. Hay que añadir alias a los campos del SELECT y ordenar los resultados por el primer campo

SELECT SUBSTR (UPPER (dsPais), 1, 1)                                        "Letra inicial del país", 
       dsPais                                                               "Nombre del país",
       DECODE (INSTR (UPPER (dsPais), 'A'), 0, 'No', 'Sí')                  "Tiene al menos una letra A",
      (SELECT COUNT (1) FROM TMedallero M WHERE M.idPaisM = P.idPais AND M.idMedallaM = 1) "Oros",
      (SELECT COUNT (1) FROM TMedallero M WHERE M.idPaisM = P.idPais AND M.idMedallaM = 2) "Platas",
      (SELECT COUNT (1) FROM TMedallero M WHERE M.idPaisM = P.idPais AND M.idMedallaM = 3) "Bronces"
  FROM TPaises P
 ORDER BY 1; 

    
-- EJEMPLO 5 --
--Añadir a la tabla del Medallero un campo fecha que represente cuándo se han conseguido las medallas. 
--Actualizar las fechas existentes en el Medallero aleatoriamente (se puede utilizar la función DBMS_RANDOM.VALUE (valor mínimo, valor máximo) y combinarlo con SYSDATE
--Realizar una consulta sobre el medallero, obteniendo la primera y la última medalla conseguida por cada país (con formato de fecha y hora). Si sólo tiene 1 medalla, se debe mostrar sólo 1 vez

ALTER TABLE TMedallero
  ADD fxAlta DATE;
   
UPDATE TMedallero 
   SET fxAlta = SYSDATE - DBMS_RANDOM.VALUE (1, 4);

SELECT dsPais                                                            "País", 
       (SELECT MIN (TO_CHAR (fxAlta, 'dd/mm/yyyy hh24:mi:ss')) 
          FROM TMedallero M WHERE M.idPaisM = P.idPais)                   "Primera medalla", 
       DECODE ((SELECT COUNT(1) FROM TMEDALLERO M 
                 WHERE M.IDPAISM = P.IDPAIS), 1, NULL,
               (SELECT MAX (TO_CHAR (fxAlta, 'dd/mm/yyyy hh24:mi:ss')) 
                  FROM TMedallero M 
                 WHERE M.idpaisM = P.idPais))                             "Última medalla"
  FROM TPaises P
 WHERE (SELECT MIN (fxAlta) FROM TMedallero M WHERE M.idPaisM = P.idPais) IS NOT NULL;


-- otra manera de realizar consulta usando WITH

ALTER TABLE TMedallero
ADD fxMedalla DATE;
  
UPDATE TMedallero
   SET fxMedalla = SYSDATE - DBMS_RANDOM.VALUE (1, 4);
   
   
WITH alias1 AS (SELECT MIN (fxAlta) FxPrimera, 
                       MAX (fxAlta) FxUltima, 
                       COUNT (1)       Contador, 
                       idPaisM
                  FROM TMedallero 
                 GROUP BY idPaisM)
SELECT dsPais, 
       DECODE (Contador, 0, NULL,          TO_CHAR (FxPrimera, 'dd/mm/yyyy hh24:mi:ss')), 
       DECODE (Contador, 0, NULL, 1, NULL, TO_CHAR (FxUltima,  'dd/mm/yyyy hh24:mi:ss'))
  FROM TPaises P, alias1 a
WHERE P.idPais = a.idPaisM (+);



    