Ejemplo

CREATE TABLE TCLIENTESx
(
    idCliente NUMBER (5),
    dsCliente VARCHAR2 (30),
    fxAlta     DATE  DEFAULT SYSDATE,
    fxBaja     DATE,
    inActivo    CHAR(1),
    CONSTRAINT pk_codcliente PRIMARY KEY (idCliente),
    CONSTRAINT chk_descripcion CHECK (dsCliente = UPPER (dsCliente))
   -- CONSTRAINT chk_activo CHECK (inActivo IN ('S','N'))--
);

ALTER TABLE 

DESC TD

----
INSERT INTO TCLIENTES(idClientes, fxAlta, dsCliente) VALUES (5, SYSDATE -1, 'BBVA')
INSERT INTO TCLIENTES(idClientes, fxAlta, dsCliente) VALUES ( 6, SYSDATE -1 FROM DUAL), UPPER ('bbva'));
INSERT INTO TCLIENTES VALUES (8,'AA',SYSDATE,NULL);
--ESTA MANERA ES MAS RAPIDA Y EVITA INTRODUCIR LAS COLUMNAS DONDE SE INTRODUCIRAN LOS DATOS
-- PERO! SI HAY CAMBIOS POSTERIORMENTE DEL ORDEN O NOMBRE DE COLUMNAS FALLARÁ LA QUERY--


INSERT INTO TCLIENTES(idClientes, fxAlta, dsCliente) VALUES ( SeqCliente.NEXTVAL,SELECT(SYSDATE -1 FROM DUAL), UPPER ('bbva'));

INSERT INTO TCLIENTES (idCliente, dsCliente)
(SELECT SeqCliente.NEXTVAL, dsCliente || 'AAA'
FROM TCLIENTES
);


UPDATE TCLIENTES
SET dsClientes = (SELECT 'MERCADONA' FROM DUAL)
WHERE idCliente > 200;

commit;
rollback;
------Mirar diapos--
MERGE INTO TCLIENTES2 A USING (SELECT * FROM TCLIENTES) B
ON (A.idCliente = B.idCliente)
WHEN MATCHED THEN UPDATE
                    SET dsCliente= 'Repetido'
WHEN NOT MATCHED THEN INSERT (A.idCliente, A.dsCliente, ....
                    VALUES ....
----


--DCL--


                    
