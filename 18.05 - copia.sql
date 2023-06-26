-- crear una identidad de manera mas sencilla --
Create table T1
(
    A NUMBER (5) DEFAULT SEQ_AUX.NEXTVAL
    );
    
ALTER TABLE T1 ADD B VARCHAR2 (50);
CREATE SEQUENCE SEQ_AUX;
INSERT INTO T1 (B) VALUES ('A');

-- crear un indice de tipo unico ---
CREATE TABLE T2
(
    A NUMBER (4) PRIMARY KEY,
    B NUMBER (5),
    CONSTRAINT indUnico1 UNIQUE (B)
    );

---- cuando una secuencia llega al maximo se puede modificar la secuancia aumentando el maximo
--- tener en cuenta que la tabla posiblemdente haya que cambiar el numero digitos del NUMBER
CREATE TABLE TPEPINOS
(
    a NUMBER (1)
    
);

CREATE SEQUENCE SeqPepinos MINVALUE 1 MAX Value 9;
INSERT INTO TPEPINOS (a) VALUES (Seq.Pepinos.NEXTVAL);

ALTER SEQUENCE SeqPepinos MAXVALUE 99;

---------------------------------------------------------------------
------------------------- CLAUSULA SELECT ---------------------------

SELECT idCliente, dsCliente
FROM TCLIENTESX;
--

SELECT *
FROM TCLIENTESX;

---------------------------------------------------------------------
------------------------- CLAUSULA WHERE ---------------------------

SELECT idCliente "Código de cliente", dsCliente descripciónCliente, (SELECT COUNT(1) FROM TFACTURASX F  WHERE F.idCliente = C.idCliente) "Num.Facturas"
FROM TCLIENTESX C
WHERE C.idCliente < 24;

--

SELECT *
FROM TCLIENTESX C, TFACTURASX F
WHERE C.idCliente = F.idCliente;

--

SELECT C.idCliente
FROM (SELECT idCliente FROM TCLIENTESX) C;

--

SELECT SYSDATE, 4+5
FROM DUAL;

--

SELECT *
FROM TCLIENTESX
WHERE idCliente >=22;

---

SELECT *
FROM TCLIENTESX
WHERE idCliente BETWEEN 23 AND 25;


--

select *
from TCLIENTESX;
INSERT INTO TCLIENTESX (idCliente, dsCliente, fxAlta, fxBaja) VALUES (SEQ_CLIENTES.NEXTVAL, 'BBVA', SYSDATE, NULL);


SELECT *
FROM TCLIENTESX
WHERE idCliente >=21
AND idCliente <=42
AND NOT (dsCliente = 'BBVA');

--

SELECT *
FROM TCLIENTESX
WHERE idCliente <= 24 OR (dsCliente = 'BBVA' AND idCliente = 41);

--

SELECT *
FROM TCLIENTESX
WHERE idCliente IN (42, 21, 24, 25);

--


INSERT INTO TCLIENTESX (idCliente, dsCliente, fxAlta, fxBaja) VALUES (SEQ_CLIENTES.NEXTVAL, 'Telecom', SYSDATE, NULL);
select *
from TCLIENTESX;

SELECT *
FROM TCLIENTESX
WHERE dsCliente LIKE 'T_L%';


---------------------------------------------------------------------
------------------------- INNER JOIN --------------------------------
-- Devuelve los clientes con sus facturas (si tienen alguna)


SELECT c.idCliente, c.dsCliente, f.idFactura, f.dsFactura, f.Importe
FROM TCLIENTESX c, TFACTURASX f
WHERE c.idCliente = f.idCliente
ORDER BY 1;

--
-- Devuelve los países que han participado en las Olimpiadas

SELECT DISTINCT P.dsPais
FROM TPaises P, TMEDALLERO M
WHERE p.idPais = M.idPaisM
ORDER BY 1;


------------------------------------------------------------------------
------------------------- OUTER JOIN (+) --------------------------------

-- Devuelve todos los clientes con sus facturas (aunque no tengan ninguna

 SELECT c.idCliente, c.dsCliente, f.idFactura, f.Importe
 FROM TClientesX c, TFACTURASX f
 WHERE c.idCliente = f.idCliente (+)
 ORDER BY 1;

 
--

 -- Devuelve los países, hayan participado, o no, en las Olimpiadas 
-- (se obtendría el mismo resultado si consultásemos sólo la tabla TPaises)

INSERT INTO TPAISES (idPais, dsPais) VALUES (4, 'Alemania');
 
 SELECT DISTINCT P.dsPais
FROM TPaises P, TMEDALLERO M
WHERE p.idPais = M.idPaisM (+)
ORDER BY 1;


--


------------------------------------------------------------------------
------------------------- EJEMPLO --------------------------------------

 
   
   
   
   
----------------------------------------------------------
----------------------------------------------------------

SELECT idCliente, SUM(importe)
    FROM TFacturas
    GROUP BY idCliente
    HAVING SUM (importe) > 200
    ORDER BY 1; --ordena por la posicion 1 de columnas es decir por idCliente
-----------------------------------

-- Devuelve los clientes con sus facturas (si tienen alguna)
SELECT c.idCliente, c.dsCliente, f.idFactura, f.importe
  FROM TClientesx c, TFacturasx f
 WHERE c.idCliente = f.idCliente
 ORDER BY 1; 
 
 
 -----
 
 Select sum (NVL (IMPORTE, 0))
 ;
