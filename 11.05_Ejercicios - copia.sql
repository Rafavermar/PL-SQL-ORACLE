
------Ejercicio 1a ----------
CREATE TABLE TCLIENTESx
(
    idCliente NUMBER (5),
    dsCliente VARCHAR2 (30),
    fxAlta     DATE  DEFAULT SYSDATE,
    fxBaja     DATE,
    CONSTRAINT pk_codcliente PRIMARY KEY (idCliente),
    CONSTRAINT chk_descripcion CHECK (dsCliente = UPPER (dsCliente))
);

CREATE OR REPLACE TRIGGER trg_uppercase_dsCliente
BEFORE INSERT OR UPDATE ON TCLIENTESx
FOR EACH ROW
BEGIN
    :NEW.dsCliente := UPPER(:NEW.dsCliente);
END;
/


COMMENT ON TABLE TCLIENTESx IS 'Almacena registro de altas y bajas de clientes';
COMMENT ON COLUMN TCLIENTESx.idCliente IS 'Código de cliente';
COMMENT ON COLUMN TCLIENTESx.dsCliente IS 'Descripción del cliente';
COMMENT ON COLUMN TCLIENTESx.fxAlta IS 'Fecha de alta del cliente';
COMMENT ON COLUMN TCLIENTESx.fxBaja IS 'Fecha de baja del cliente';


----- Ejercicio 1b ------

CREATE TABLE TFACTURASx
(
    idFactura NUMBER (5),
    dsFactura VARCHAR2 (30),
    fxAlta    DATE  DEFAULT SYSDATE,
    Importe   NUMBER (6,2),
    idCliente NUMBER (5),
    CONSTRAINT pk_codFactura          PRIMARY KEY (idFactura),
    CONSTRAINT fk_TFactura_codcliente FOREIGN KEY (idCliente) REFERENCES TCLIENTESx (idCliente)
);

COMMENT ON TABLE TFACTURASx IS 'Almacena registro de facturas';
COMMENT ON COLUMN TFACTURASx.idFactura IS 'Código de factura';
COMMENT ON COLUMN TFACTURASx.dsFactura IS 'Descripción del factura';
COMMENT ON COLUMN TFACTURASx.fxAlta IS 'Fecha de alta de la factura';
COMMENT ON COLUMN TFACTURASx.Importe IS 'Importe de la factura';
COMMENT ON COLUMN TFACTURASx.idCliente IS 'Código del cliente';


CREATE TABLE TTIPOSVIA
(
    idTipoVia NUMBER (2),
    dsTipoVia VARCHAR2 (30),
    CONSTRAINT pk_TipoVia PRIMARY KEY (idTipoVia)
);




----- Ejercicio 1c ------

CREATE TABLE TDOMICILIOS
(
    idDomicilio NUMBER (5),
    idTipoVia   NUMBER (5),
    dsCalle     VARCHAR(100),
    CodPostal   NUMBER (5),
    Provincia   VARCHAR(30),
    CONSTRAINT pk_idDomicilio PRIMARY KEY (idDomicilio),
    CONSTRAINT fk_TDomicilios_TipoVia FOREIGN KEY (idTipoVia) REFERENCES TTIPOSVIA (idTipoVia)
);



CREATE TABLE TDomCli
(
    idCliente NUMBER (5),
    idDomicilio NUMBER (5),
    CONSTRAINT pk_TDomCli PRIMARY KEY (idCliente, idDomicilio),
    CONSTRAINT fk_TDomCli_idCliente FOREIGN KEY (idCliente) REFERENCES TCLIENTESx (idCliente),
    CONSTRAINT fk_TDomCli_idDomicilio FOREIGN KEY (idDomicilio) REFERENCES TDOMICILIOS (idDomicilio)
);

CREATE UNIQUE INDEX ind ON TDomCli (idCliente, IdDomicilio);
-- evita que se introduzcan clientes y domicilio por duplicado en el caso de
-- que idcliente e iddomicilio no formaran parte de la primary key
    
----- Ejercicio 2 ------

CREATE SEQUENCE Seq_Facturas START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 99999 NOCYCLE ;
CREATE SEQUENCE Seq_Clientes START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 99999 NOCYCLE;
CREATE SEQUENCE Seq_Domicilios START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 99999 NOCYCLE;

--

INSERT INTO TTIPOSVIA (idTipoVia, dsTipoVia) VALUES (1,'Calle');
INSERT INTO TTIPOSVIA (idTipoVia, dsTipoVia) VALUES (2,'Avenida');
INSERT INTO TTIPOSVIA (idTipoVia, dsTipoVia) VALUES (3,'Plaza');
INSERT INTO TTiposVia (idTipoVia, dsTipoVia) VALUES (4, 'Rotonda');

--

INSERT INTO TCLIENTESx (idCliente, dsCliente, fxAlta, fxBaja) 
	VALUES (Seq_Clientes.NEXTVAL, 'TELEFONICA', SYSDATE, NULL);
INSERT INTO TCLIENTESx (idCliente, dsCliente, fxAlta, fxBaja) 
	VALUES (Seq_Clientes.NEXTVAL, 'BABEL', SYSDATE, NULL);
INSERT INTO TCLIENTESx (idCliente, dsCliente, fxAlta, fxBaja) 
	VALUES (Seq_Clientes.NEXTVAL, 'MERCADONA', SYSDATE, NULL);
INSERT INTO TCLIENTESx (idCliente, dsCliente, fxAlta, fxBaja) 
	VALUES (Seq_Clientes.NEXTVAL, 'EL CORTE INGLÉS', SYSDATE, NULL);


INSERT INTO TFACTURASx (idFactura, dsFactura, fxAlta, Importe, idCliente) 
	VALUES (Seq_Facturas.NEXTVAL, 'compras', SYSDATE, 250, 21);
INSERT INTO TFACTURASx (idFactura, dsFactura, fxAlta, Importe, idCliente) 
	VALUES (Seq_Facturas.NEXTVAL, 'compras', SYSDATE, 100, 22);
INSERT INTO TFACTURASx (idFactura, dsFactura, fxAlta, Importe, idCliente) 
	VALUES (Seq_Facturas.NEXTVAL, 'compras', SYSDATE,  50, 23);
INSERT INTO TFACTURASx (idFactura, dsFactura, fxAlta, Importe, idCliente) 
	VALUES (Seq_Facturas.NEXTVAL, 'compras', SYSDATE, 125, 24);
INSERT INTO TFACTURASx (idFactura, dsFactura, fxAlta, Importe, idCliente) 
	VALUES (Seq_facturas.NEXTVAL, 'compras', SYSDATE, 500, 22);
INSERT INTO TFACTURASx (idFactura, dsFactura, fxAlta, Importe, idCliente) 
	VALUES (Seq_Facturas.NEXTVAL, 'compras', SYSDATE, 110, 21);
 

INSERT INTO TDOMICILIOS (idDomicilio, idTipoVia, dsCalle, codPostal, Provincia) 
	VALUES (Seq_Domicilios.NEXTVAL, 1, 'Juan de Austria', 28053, 'Madrid');
INSERT INTO TDOMICILIOS (idDomicilio, idTipoVia, dsCalle, codPostal, Provincia) 
	VALUES (Seq_Domicilios.NEXTVAL, 2, 'de los Encuartes', 28032, 'Madrid');
INSERT INTO TDomicilios (idDomicilio, idTipoVia, dsCalle, codPostal, Provincia) 
	VALUES (Seq_Domicilios.NEXTVAL, 3, 'de la Habana', 28011, 'Madrid');
INSERT INTO TDOMICILIOS (idDomicilio, idTipoVia, dsCalle, codPostal, Provincia) 
	VALUES (Seq_Domicilios.NEXTVAL, 3, 'Alameda de Osuna', 28042, 'Madrid');
INSERT INTO TDOMICILIOS (idDomicilio, idTipoVia, dsCalle, codPostal, Provincia) 
	VALUES (Seq_Domicilios.NEXTVAL, 4, 'de la Comunicación', 28053, 'Madrid');

--

INSERT INTO TDomCli (idCliente, idDomicilio)
  (SELECT 1, idDomicilio 
     FROM TDOMICILIOS);

--

INSERT INTO TDomCli (idCliente, idDomicilio)
(SELECT idCliente, 1
   FROM TClientes C
  WHERE idCliente != 1);

 select * FROM TFACTURASx
    
    
    
    
    