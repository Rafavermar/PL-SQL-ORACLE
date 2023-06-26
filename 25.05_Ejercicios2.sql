------------------------------------------------------------------------
------------------------- EJERCICIO 2  -----------------------------------

--Crear una tabla de personas con los campos id, nombre, fecha de nacimiento y sexo (H/M)
--Incluir algunos registros en la tabla
--Obtener la persona de cada sexo de m�s edad
--Extraer, con una sola consulta, el hombre m�s joven, la mujer m�s mayor y los hombres cuyo nombre ocupe m�s de 4 letras. Todo ello, incluyendo un encabezado
--Actualizar la hora de nacimiento de todas las personas (aleatoriamente)
--Sacar un listado con los siguientes campos:
    --Los nombres 
    --Los nombres pasados a may�sculas
    --La longitud de los nombres
    --Un indicador que determine si los nombres empiezan por vocal
    --La fecha de nacimiento en formato a�o-mes-d�a
    --La hora de nacimiento
    --Un indicador que determine las personas que nacieron antes del mediod�a

CREATE TABLE TPersonas
(
	idPersona    NUMBER    (5) GENERATED ALWAYS AS IDENTITY,
	nombre       VARCHAR2 (50),
	fxNacimiento DATE,
	inSexo       CHAR      (1),
	CONSTRAINT pk_Tpersonas PRIMARY KEY (idPersona),
	CONSTRAINT chk_Sexo     CHECK       (inSexo IN ('H', 'M'))
); 

--
INSERT INTO TPersonas (nombre, fxNacimiento, inSexo) VALUES ('Pepe',    SYSDATE - 3500, 'H');
INSERT INTO TPersonas (nombre, fxNacimiento, inSexo) VALUES ('Juan',    SYSDATE - 9500, 'H');
INSERT INTO TPersonas (nombre, fxNacimiento, inSexo) VALUES ('Paco',    SYSDATE - 6500, 'H');
INSERT INTO TPersonas (nombre, fxNacimiento, inSexo) VALUES ('Diego',   SYSDATE - 5300, 'H');
INSERT INTO TPersonas (nombre, fxNacimiento, inSexo) VALUES ('Mario',   SYSDATE -  600, 'H');
INSERT INTO TPersonas (nombre, fxNacimiento, inSexo) VALUES ('Enrique', SYSDATE -  100, 'H');
INSERT INTO TPersonas (nombre, fxNacimiento, inSexo) VALUES ('Mar�a',   SYSDATE - 2500, 'M');
INSERT INTO TPersonas (nombre, fxNacimiento, inSexo) VALUES ('Laura',   SYSDATE -  450, 'M');
INSERT INTO TPersonas (nombre, fxNacimiento, inSexo) VALUES ('Lidia',   SYSDATE -  530, 'M');
INSERT INTO TPersonas (nombre, fxNacimiento, inSexo) VALUES ('Esther',  SYSDATE -  300, 'M');
INSERT INTO TPersonas (nombre, fxNacimiento, inSexo) VALUES ('Gema',    SYSDATE - 5300, 'M');
INSERT INTO TPersonas (nombre, fxNacimiento, inSexo) VALUES ('Irene',   SYSDATE - 1500, 'M');
INSERT INTO TPersonas (nombre, fxNacimiento, inSexo) VALUES ('Silvia',  SYSDATE -   50, 'M');

--
WITH alias1 AS (SELECT ROW_NUMBER () OVER (PARTITION BY inSexo ORDER BY fxNacimiento) rn, 
                       nombre, fxNacimiento, inSexo
                  FROM TPersonas
               )
SELECT nombre, inSexo, ROUND ((SYSDATE - fxNacimiento) / 365) Edad
  FROM alias1
 WHERE rn = 1; 
 
--
 
 WITH alias1 AS (SELECT ROW_NUMBER () OVER (PARTITION BY inSexo ORDER BY fxNacimiento) rn, 
                       nombre, fxNacimiento, inSexo
                  FROM TPersonas
               )
SELECT nombre, inSexo, edad
  FROM
  (
SELECT 'Nombre' nombre, 'Sexo' inSexo, 'Edad' edad, 1 Posicion
  FROM alias1
 UNION
SELECT RPAD ('-', (SELECT MAX (LENGTH (nombre)) FROM alias1), '-'), '----', '----', 2
  FROM DUAL
 UNION
SELECT nombre, inSexo, '' || ROUND ((SYSDATE - fxNacimiento) / 365) Edad, 3
  FROM alias1
 WHERE rn = 1 AND inSexo = 'H'
UNION
SELECT nombre, inSexo, '' || ROUND ((SYSDATE - fxNacimiento) / 365) Edad, 4
  FROM alias1
 WHERE rn = (SELECT MAX (alias1.rn) FROM alias1 WHERE inSexo = 'M')
   AND inSexo = 'M' 
)
ORDER BY posicion;

--

UPDATE TPersonas
   SET fxNacimiento = TO_DATE (TO_CHAR (fxNacimiento, 'dd/mm/yyyy') || ' ' || 
                               ROUND (DBMS_RANDOM.VALUE (0, 23)) || 
                               TO_CHAR (fxNacimiento, ':mi:ss'), 'dd/mm/yyyy hh24:mi:ss')


--

SELECT nombre                                                  "Nombre", 
       UPPER  (nombre)                                         "Nombre en may�sculas", 
       LENGTH (nombre)                                         "Longitud del nombre", 
       DECODE (SUBSTR (UPPER (nombre), 1, 1), 'A', 'S�', 
                                              'E', 'S�', 
                                              'I', 'S�', 
                                              'O', 'S�',
                                              'U', 'S�', 'No') "Empieza por vocal",
       TO_CHAR (fxNacimiento, 'yyyy-mm-dd�)                    "Fecha de nacimiento",
       TO_CHAR (fxNacimiento, 'hh24�)                          "Hora de nacimiento",
       CASE WHEN TO_CHAR (fxNacimiento, 'hh24') < 12 THEN 'S�'
            ELSE 'No'
            END                                                "Naci� antes del mediod�a"
  FROM TPersonas;
