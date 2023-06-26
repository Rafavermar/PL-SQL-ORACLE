

------------------------------------------------------------------------
------------------------- START WITH / CONNECT BY PRIOR  --------------------------------------


CREATE TABLE TEmpleados 
(
    idEmpleado NUMBER    (2), 
    dsNombre   VARCHAR2 (30), 
    dsCargo    VARCHAR2 (30), 
    idJefe     NUMBER    (2)
);

INSERT INTO TEmpleados VALUES (1, 'Pedro',   'Director',   NULL);
INSERT INTO TEmpleados VALUES (2, 'Laura',   'Supervisor', 1);
INSERT INTO TEmpleados VALUES (3, 'Silvia',  'Supervisor', 1);
INSERT INTO TEmpleados VALUES (4, 'Gema',    'Supervisor', 1);
INSERT INTO TEmpleados VALUES (5, 'Juan',    'Becario',    2);
INSERT INTO TEmpleados VALUES (6, 'Paco',    'Becario',    2);
INSERT INTO TEmpleados VALUES (7, 'Eduardo', 'Becario',    3);
INSERT INTO TEmpleados VALUES (8, 'Enrique', 'Becario',    4);

COMMIT;


--- Para realizar consultas recursivas ---
    -- START WITH inicio de busqueda --
    -- CONNECT BY PRIOR establece relacion padre-hijo --
    -- LEVEL contiene el nivel de recursividad --
    -- SYS_CONNECT_BY_PATH sacamos el camino
    

SELECT idEmpleado, dsNombre, dsCargo, idJefe, LEVEL, SYS_CONNECT_BY_PATH (dsNombre, '>') "Camino"
   FROM TEmpleados
  START WITH dsNombre = 'Pedro'
CONNECT BY PRIOR idEmpleado = idJefe;

--- Para llenar una tabla de prueba con muchos registros ---
    -- no se establece inicio de búsqueda ni relacion padre-hijo --
    -- la tabla no está creada --
    
INSERT INTO TGrande (idTabla, dsTabla) 
 SELECT ROWNUM, LPAD ('X', 500, 'A') 
   FROM DUAL 
CONNECT BY LEVEL <= 1000000;

------------------------------------------------------------------------
------------------------- SUBCONSULTAS  --------------------------------------

-- Se pueden añadir subconsultas WHERE con operadores IN (NOT IN) y EXISTS (NOT EXISTS)

INSERT INTO TDOMCLI (idCliente, IdDomicilio) VALUES (43, 1);

--

SELECT D.*
   FROM TDOMCLI D, TCLIENTESX C
  WHERE D.idCliente = C.idCliente;
  
  --
  
  SELECT *
   FROM TDomCli
  WHERE idCliente IN (SELECT idCliente
                        FROM TCLIENTESX);


--

 SELECT *
   FROM TDomCli D
  WHERE EXISTS (SELECT 1
                  FROM TCLIENTESX C
                 WHERE C.idCliente = D.idCliente);
                 

------------------------------------------------------------------------
------------------------- UNION DE CONSULTAS  --------------------------------------

 --La tabla no la cree con el campo inActivo
 
SELECT idCliente, dsCliente
   FROM TCLIENTESX
  WHERE inActivo = 'S'
  UNION
 SELECT idCliente, dsCliente
   FROM TCLIENTESX
  WHERE inActivo = 'N';


------------------------------------------------------------------------
------------------------- PAGINACION  --------------------------------------


-- modo antiguo con psedudocolumna ROWNUM

SELECT *
FROM 
      (
       SELECT ROWNUM rn, a.*
         FROM (SELECT * FROM TCLIENTESX ORDER BY idCliente) a 
      )
 WHERE
    rn BETWEEN 1 AND 10; -- Valores mínimo y máximo


-- ultimas versiones - Metodos OFFSET (Determina los registros a saltar, antes de empezar a devolver resultados (medido en número o en porcentaje) 
                    -- FETCH NEXT... ONLY (Determina el número o porcentaje de registros a devolver después de la cláusula)

SELECT * 
   FROM TClientes 
  ORDER BY idCliente 
  FETCH NEXT 10 ROWS ONLY; -- Devuelve los 10 primeros registros
  
  SELECT * 
  FROM TClientes 
 ORDER BY idCliente 
OFFSET 0 ROWS
 FETCH NEXT 10 ROWS ONLY; -- Devuelve los 10 primeros registros
 
 SELECT * 
  FROM TClientes 
 ORDER BY idCliente 
OFFSET 5 ROWS
 FETCH NEXT 25 PERCENT ROWS ONLY; -- Salta los primeros 5 registros y devuelve el siguiente 25%



------------------------------------------------------------------------
------------------------- WITH  --------------------------------------


-- EJEMPLO1: 
-- Realizar una consulta que devuelva un listado de los países que han ganado más de 2 medallas, junto con el número de medallas obtenido, y ordenado descendentemente por el número de medallas

SELECT dsPais, COUNT (1) Contador 
  FROM TMedallero M, TPaises P 
 WHERE M.idPaisM = P.idPais 
   AND (SELECT COUNT (1) FROM TMedallero M WHERE M.idPaisM = P.idPais) > 1
 GROUP BY dsPais
 ORDER BY 2 DESC;

  WITH alias AS (SELECT idPAISM, COUNT (1) contador FROM TMedallero GROUP BY idPaisM)
SELECT dsPais, alias.contador
  FROM TPaises P, alias
 WHERE P.idPais = alias.idPaisM
   AND alias.contador > 2
 ORDER BY 2 DESC;
 
 
 -- EJEMPLO2:
 -- Realizar una consulta que devuelva un listado de los clientes junto con el número de sus facturas, el importe total de las facturas y la media de las facturas
 
SELECT dsCliente,
        (SELECT COUNT (1)     FROM TFacturasX F WHERE F.idCliente = C.idCliente) "Número Fact.",
        (SELECT SUM (importe) FROM TFacturasX F WHERE F.idCliente = C.idCliente) "Total Fact.",
        (SELECT AVG (importe) FROM TFacturasX F WHERE F.idCliente = C.idCliente) "Media Fact."
   FROM TCLIENTESX C
   ORDER BY 2;
   
   
 WITH alias AS
    (SELECT idCliente,
            COUNT (1)     Contador,
            SUM (importe) TotalFact,
            AVG (importe) MediaFacturas
       FROM TFacturasX
      GROUP BY idCliente)
SELECT C.dsCliente, Contador "Número Fact.", alias.TotalFact "Total Fact.", MediaFacturas "Media Fact."
  FROM TClientesX C, alias
 WHERE C.idCliente = alias.idCliente    
 ORDER BY alias.Contador
;


-- EJEMPLO3:
 -- Si analizamos el plan de ejecución de estas 2 últimas consultas, vemos que sin la claúsula WITH se accede 3 veces a la tabla TFacturas,
 -- mientras que con WITH sólo 1 vez (se reduce sensiblemente el coste de la query con WITH)
 
 -- PULSAR F10 SOBRE CADA QUERY ANTERIOR
 
 
 
 ------------------------------------------------------------------------
------------------------- QUERIES COMO GENERADOR DE SENTENCIAS  ---------
 --Mediante esta técnica podemos sacar, ejecutando una query, un listado de sentencias, que podemos ejecutar a posteriori.

-- Para hacer un borrado de nuestras tablas
SELECT 'DROP TABLE ' || table_name || ';'
  FROM user_tables
 ORDER BY 1; 

-- Para eliminar los registros de nuestras tablas
SELECT 'DELETE FROM ' || table_name || ';'
  FROM user_tables
 ORDER BY 1; 

-- Para duplicar los registros de una tabla
SELECT 'INSERT INTO TClientes (idCliente, dsCliente, fxAlta, fxBaja) VALUES (' || 
       Seq_Clientes.NEXTVAL || ', UPPER (''' || dsCliente || '_Repetido' || '''), SYSDATE, NULL);'
  FROM TClientes;


 
 
 

