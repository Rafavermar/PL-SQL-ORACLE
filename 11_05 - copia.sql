CREATE TABLE TDomicilios
(
    idDomicilio NUMBER (5),
    dsDomicilio VARCHAR2 (100)
    );
    
CREATE TABLE TClientas
(
	idClienta   NUMBER     (5) NOT NULL,
	dsClienta   VARCHAR2 (100),
	fxAlta      DATE           DEFAULT SYSDATE,
	inActivo    CHAR       (1) DEFAULT 'S',
	idDomicilia NUMBER     (5),
-----------------------------------------------------------------------------------
	CONSTRAINT pk_clienta         PRIMARY KEY (idClienta),
	CONSTRAINT fk_dom_cli         FOREIGN KEY (idDomicilia) REFERENCES TDomicilios (idDomiciliox),
	CONSTRAINT chk_cliente_activo CHECK (inActivo IN ('S', 'N'))
);


SELECT * FROM TCLIENTES;
CREATE UNIQUE INDEX indTclienteDesc ON TCLIENTES (dsCliente);
CREATE INDEX indTFacturasTClientesx ON TFACTURAS2(idClienteF);
drop index indTFacturasTClientesx;

INSERT INTO TFacturas2 (idclientef,idfactura, importe)
VALUES (2,9,1055);

// ejecutar con F6 cuando haga insert en la tabla de Factura
SELECT *
FROM TCLIENTES C, TFacturas2 F
WHERE C.idCliente = F.idClienteF;


CREATE TABLE T13
(
A NUMBER(3) GENERATED ALWAYS AS IDENTITY MINVALUE 4,
B VARCHAR2 (50)
);

INSERT INTO T13 (B) VALUES ('A');

SELECT * FROM T13;

CREATE SYNONYM TRAFA FOR T13;

SELECT * FROM TRAFA;
----------------------------
CREATE TABLE TMEDALLAS
(
dsMedalla VARCHAR2 (50),
valorMetal NUMBER(1)
);

CREATE TABLE TPAISES
(
idPais NUMBER(3),
dsPais VARCHAR2(30),
CONSTRAINT pk_TPaises PRIMARY KEY (idPais)
);

COMMENT ON TABLE TPaises IS 'Almacena los países participantes en las Olimpiadas';
COMMENT ON COLUMN TPaises.idPais IS 'Código del país';
COMMENT ON COLUMN TPaises.dsPais IS 'Nombre del país';


CREATE TABLE TMedallas
(
idMedalla NUMBER (3),
dsMedalla VARCHAR2(30),
valorMetal NUMBER (3),
CONSTRAINT pk_TMedallas PRIMARY KEY (idMedalla)
);

COMMENT ON TABLE TMedallas IS 'Almacena los distintos metales de las medallas';
COMMENT ON COLUMN TMedallas.idMedalla IS 'Código de la medalla';
COMMENT ON COLUMN TMedallas.dsMedalla IS 'Color de la medalla';
COMMENT ON COLUMN TMedallas.valorMetal IS 'Valor de la medalla';


CREATE TABLE TDeportes
(
	idDeporte NUMBER    (5),
	dsDeporte VARCHAR2 (30) NOT NULL,
	CONSTRAINT pk_deporte PRIMARY KEY (idDeporte)
);

COMMENT ON TABLE TDeportes IS 'Almacena los deportes de las Olimpiadas';
COMMENT ON COLUMN TDeportes.idDeporte IS 'Código del deporte';
COMMENT ON COLUMN TDeportes.dsDeporte IS 'Nombre del deporte';

CREATE TABLE TMedallero
(
idPaisM NUMBER(3),
idDeporteM NUMBER(3),
idMedallaM NUMBER(3),
CONSTRAINT pk_medallero PRIMARY KEY (idPaisM, idDeporteM),
	CONSTRAINT fk_medallero_pais    FOREIGN KEY (idPaisM)    REFERENCES TPaises   (idPais),
	CONSTRAINT fk_medallero_deporte FOREIGN KEY (idDeporteM) REFERENCES TDeportes (idDeporte),
	CONSTRAINT fk_medallero_medalla FOREIGN KEY (idMedallaM) REFERENCES TMedallas (idMedalla)
);

COMMENT ON TABLE TMedallero IS 'Almacena las medallas que consigue cada país en los deportes'; 
COMMENT ON COLUMN TMedallero.idPaisM    IS 'Código del país';
COMMENT ON COLUMN TMedallero.idDeporteM IS 'Código del deporte';
COMMENT ON COLUMN TMedallero.idMedallaM IS 'Código de la medalla';

ALTER TABLE TDeportes
  ADD precioMedioEntrada NUMBER (6, 2);

COMMENT ON COLUMN TDeportes.precioMedioEntrada IS 'Precio medio de la entrada';

CREATE SEQUENCE Seq_Pais    START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 99999;
CREATE SEQUENCE Seq_Deporte START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 99999;

ALTER TABLE TMedallas
  MODIFY dsMedalla NOT NULL;

ALTER TABLE TMedallas
  MODIFY valorMetal NOT NULL;


INSERT INTO TPaises (idPais, dsPais) VALUES (Seq_Pais.NEXTVAL, 'España');
INSERT INTO TPaises (idPais, dsPais) VALUES (Seq_Pais.NEXTVAL, 'Francia');
INSERT INTO TPaises (idPais, dsPais) VALUES (Seq_Pais.NEXTVAL, 'Brasil');

INSERT INTO TDeportes (idDeporte, dsDeporte) VALUES (Seq_Deporte.NEXTVAL, 'Fútbol');
INSERT INTO TDeportes (idDeporte, dsDeporte) VALUES (Seq_Deporte.NEXTVAL, 'Baloncesto');
INSERT INTO TDeportes (idDeporte, dsDeporte) VALUES (Seq_Deporte.NEXTVAL, 'Tenis');

INSERT INTO TMedallas (idMedalla, dsMedalla, valorMetal) VALUES (1, 'Oro'   , 5);
INSERT INTO TMedallas (idMedalla, dsMedalla, valorMetal) VALUES (2, 'Plata' , 3);
INSERT INTO TMedallas (idMedalla, dsMedalla, valorMetal) VALUES (3, 'Bronce', 1);

INSERT INTO TMedallero (idPaisM, idDeporteM, idMedallaM) VALUES (1, 1, 1);
INSERT INTO TMedallero (idPaisM, idDeporteM, idMedallaM) VALUES (1, 2, 2);
INSERT INTO TMedallero (idPaisM, idDeporteM, idMedallaM) VALUES (1, 3, NULL);
INSERT INTO TMedallero (idPaisM, idDeporteM, idMedallaM) VALUES (2, 1, 2);
INSERT INTO TMedallero (idPaisM, idDeporteM, idMedallaM) VALUES (3, 1, 3);
INSERT INTO TMedallero (idPaisM, idDeporteM, idMedallaM) VALUES (3, 2, 1);

