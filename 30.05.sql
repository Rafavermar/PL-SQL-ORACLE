------------------------------------------------------------------------
------------------------- PL/SQL  --------------------------------------


------------------------- Tipos de Datos --------------------------------

-- NUMERICOS --
NUMBER         
NUMBER (4)
NUMBER (4, 2)  -- 2 d�gitos para la parte entera y 2 para los decimales

-- ALFANUMERICOS --
VARCHAR2 (100)
CHAR (1) -- se utiliza cuando longitud es 1

-- OTROS --
--El DATE es el que m�s se utiliza para las fechas
--BOOLEAN se utiliza para almacenar TRUE o FALSE
--BLOB se emplea para almacenar datos binarios (anexos)
--CLOB permite guardar una gran cantidad de datos de tipo car�cter (hasta 4 Gb)

-- VARIABLES --

-- NO key sensitive
-- max 30 caracteres
-- por defecto valor inicial NULL (0 para n�mericos)
-- se definen en la parte declarativa del programa
-- Se les puede asociar un tipo simple, complejo, el tipo de un campo (%TYPE) o de un registro de una tabla (%ROWTYPE)

DECLARE
	<nombre_variable> <tipo simple o complejo>;
	<nombre_variable> <tabla>.<campo>%TYPE;
	<nombre_variable> <tabla>%ROWTYPE;

DECLARE
	i          NUMBER;
	fxAlta     DATE;
	strNombre  VARCHAR2 (30):= 'Alicia';
	idCliente  TClientesX.idCliente%TYPE;
	regCliente TClientesX%ROWTYPE;
    
-- CONSTANTES --
DECLARE
	<nombre_constante> CONSTANT <tipo>;

DECLARE
	iMaxResultados CONSTANT NUMBER:= 20;
	fxActual       CONSTANT DATE  := SYSDATE;



-- SENTENCIAS CONDICIONALES -- IF / CASE --

IF <condici�n> THEN
	<instrucciones>
ELSIF <condici�n> THEN
	<instrucciones>
ELSE
	<instrucciones>
END IF;

--

CASE
	WHEN <condicion1> THEN <instrucciones>;
	WHEN <condicion2> THEN <instrucciones>;
	�
	ELSE <instrucciones>
END CASE;

--

-- Resulta bastante confusa la comparaci�n entre NULL y la cadena vac�a

DECLARE
    A VARCHAR2 (10):= '';
    B VARCHAR2 (10):= NULL;
BEGIN
    IF A = B THEN
        DBMS_OUTPUT.PUT_LINE ('Son iguales');
    ELSE
        DBMS_OUTPUT.PUT_LINE ('No son iguales'); -- Se muestra en las trazas
    END IF;
    
    IF A IS NULL THEN
        DBMS_OUTPUT.PUT_LINE ('A es null'); -- Se muestra en las trazas
    END IF;

    IF B IS NULL THEN
        DBMS_OUTPUT.PUT_LINE ('B es null'); -- Se muestra en las trazas
    END IF;

    IF A = '' THEN
        DBMS_OUTPUT.PUT_LINE ('A es cadena vac�a');
    END IF;

    IF B = '' THEN
        DBMS_OUTPUT.PUT_LINE ('B es cadena vac�a');
    END IF;
END;

---

-- ESTRUCTURAS REPETITIVAS WHILE / FOR / LOOP / REVERSE --

WHILE <condici�n> LOOP
    <instrucciones>
END LOOP;

FOR i IN 1..10 LOOP
    <instrucciones>
END LOOP;

FOR i IN REVERSE 1..10 LOOP
    <instrucciones>
END LOOP;


LOOP
    <instrucciones>
    EXIT WHEN <condici�n>;
END LOOP;

-- COMENTARIOS --
create or replace FUNCTION Suma (a NUMBER, b NUMBER) RETURN NUMBER IS
/*********************************/
/** Funci�n que suma 2 valores  **/
/*********************************/
/** Par�metros                  **/
/** --------------------------- **/
/** a: Primer valor a sumar     **/
/** b: Segundo valor a sumar    **/
/*********************************/
/** F. Creaci�n    : 12/03/2023 **/
/** F. Modificaci�n: 24/03/2023 **/
/*********************************/
BEGIN
	-- Sumamos los par�metros y devolvemos el resultado
	RETURN a + b;
END;


-- SINTAXIS --
-- Las sentencias terminan con ;
-- El operador de asignaci�n es el :=
-- Los operadores aritm�ticos son +, -, * y /
-- Los operadores l�gicos son NOT, AND y OR
-- Las cadenas de texto se concatenan con ||

-- TRAZAS DE SALIDA --
--Para poder visualizarlas habr� que, previamente, mostrar la pantalla de trazas (Men� Ver -> Salida de DBMS) y, utilizando el +, seleccionar la conexi�n que corresponda

DBMS_OUTPUT.PUT_LINE ('<comentario>');

-- FUNCIONES --
---------------
-- programas que devuelven un valor
-- no admiten sobrecarga (varias funciones con mismo nombre)
-- tener parametros enrada (IN), salida (OUT)o ambos (IN OUT).
-- Por defecto son entrada
-- pueden ser llamadas como parte de una expresi�n
-- No pueden contener comandos DML (INSERT, DELETE, UPDATE y MERGE)

CREATE OR REPLACE FUNCTION <nombre> (<lista_par�metros>) RETURN <tipo_salida> IS
    -- Declaraci�n de variables
BEGIN 
    -- Cuerpo de la funci�n

    RETURN <dato_salida>;
END;

-- PROCEDIMIENTOS --
--------------------

-- Son programas que no devuelven un valor,
-- como las funciones, pero pueden tener par�metros de entrada (IN), 
-- salida (OUT) o ambos a la vez (IN OUT). No se especifica el tama�o
-- no admiten sobrecarga (varios procedimientos con el mismo nombre y distintos parametros)
-- no pueden ser llamados como parte de una expresi�n
-- si pueden contener los comandos DML
-- se puede ejecutar directamente un procedimiento con el comando EXEC / EXECUTE

CREATE OR REPLACE PROCEDURE <nombre> (<lista_par�metros>) IS
    -- Declaraci�n de variables
BEGIN 
    -- Cuerpo del procedimiento
END;


------------------------------------------------------------------------
------------------------- EJEMPLO 1 --------------------------------------

-- Crear una funci�n que reciba un c�digo de pa�s y un c�digo de medalla 
-- y devuelva el n�mero de medallas de ese tipo obtenidas por dicho pa�s


CREATE OR REPLACE FUNCTION numMedallas (
    idPaisAux    IN TPaises.idPais%TYPE,
    idMedallaAux IN TMedallas.idMedalla%TYPE
) RETURN NUMBER IS
    iContador NUMBER;
BEGIN
    SELECT COUNT(1)
        INTO iContador
        FROM TMedallero
        WHERE idPaisM = idPaisAux
          AND idMedallaM = idMedallaAux; 
    RETURN iContador;
END;


SELECT numMedallas (41,3)
from DUAL;

Select * 
FROM TMEDALLERO;


------------------------------------------------------------------------
------------------------- EJEMPLO 2 --------------------------------------
-- Crear un procedimiento que reciba el nombre de un pa�s y 
-- muestre por pantalla las medallas (separadas por metal) que
-- ha conseguido (utilizando la funci�n anterior)

CREATE OR REPLACE PROCEDURE Mostrarmedallas (descPais IN TPaises.dsPais%TYPE) IS
    codPais TPaises.idPais%TYPE;
    iContador NUMBER;
BEGIN
DBMS_OUTPUT.PUT_LINE ('Medallas obtenidas por ' || descPais);

    SELECT idPais
        INTO codPais
        FROM TPaises
        WHERE dsPais = descPais;

    FOR i IN 1..3 LOOP
        iContador := numMedallas(codPais, i);
        IF i = 1 THEN
            DBMS_OUTPUT.PUT_LINE('Medallas de oro: ' || iContador);
        ELSIF i = 2 THEN
            DBMS_OUTPUT.PUT_LINE('Medallas de Plata: ' || iContador);
        ELSIF i = 3 THEN
            DBMS_OUTPUT.PUT_LINE('Medallas de Bronce: ' || iContador);
        END IF;
    END LOOP;
END;

-- Ejecutando el procedimiento:
EXEC Mostrarmedallas ('Brasil');
    
    
SELECT Medallero (codPais, 3)
INTO iContador
FROM DUAL;
    
    
 
/*
CREATE OR REPLACE PROCEDURE medallasPais (strPais VARCHAR2) IS
	iNumTiposMedalla NUMBER;
	strMedalla       TMedallas.dsMedalla%TYPE;
	iNumMedallas     NUMBER;
BEGIN
	DBMS_OUTPUT.PUT_LINE ('-----------------------------------------');
	DBMS_OUTPUT.PUT_LINE ('Medallas de ' || strPais);

	SELECT COUNT (1)
	  INTO iNumTiposMedalla
	  FROM TMedallas;

	FOR i IN 1..iNumTiposMedalla LOOP
	SELECT dsMedalla, numMedallas (P.idPais, M.idMedalla)
	  INTO strMedalla, iNumMedallas
	  FROM TPaises P, TMedallero M, TMedallas M2
	 WHERE P.dsPais     = strPais
	   AND P.idPais     = M.idPais
	   AND M.idMedalla  = M2.idMedalla
	   AND M2.idMedalla = i;

		DBMS_OUTPUT.PUT_LINE ('Medallas de ' || strMedalla || ': ' || iNumMedallas);
	END LOOP;		
END;

*/


------------------------------------------------------------------------
------------------------- PAQUETES --------------------------------------   

-- Son como librerias para organizar procedimientos y funciones
-- tienen 2 partes: 
  -- La especificaci�n, obligatoria y donde se definen las variables, tipos y m�todos
  -- El cuerpo, no obligatoria y donde vienen especificados los m�todos
  
-- Los procedimientos y funciones no definidos en la cabecera, no ser�n p�blicos. 
-- Si procedimientos se invocan dentro del paquet, deben estar escritos antes del m�todo que lo invoca.
-- Las cabeceras de los procedimientos y funciones tienen que ser id�nticas en ambas partes (incluyendo el tipo y nombre de los par�metros)
-- Permite sobrecarga 
-- Para invocar un m�todo fuera del paquete, se hace con <paquete>.<m�todo>


CREATE OR REPLACE PACKAGE miPaquete IS
	-- Declaraci�n de variables globales a todos los procedimientos y funciones del paquete

	-- Declaraci�n de los procedimientos y funciones del paquete
	PROCEDURE miProcedimiento (idValor NUMBER, strSalida OUT VARCHAR2);
	FUNCTION miFuncion (idValor NUMBER) RETURN NUMBER;
END;

--

CREATE OR REPLACE PACKAGE BODY miPaquete IS

PROCEDURE miProcedimiento (idValor NUMBER, strSalida OUT VARCHAR2) IS
	-- Declaraci�n de variables
BEGIN 
	-- Cuerpo del procedimiento
	NULL;
END;

FUNCTION miFuncion (idValor NUMBER) RETURN NUMBER IS
	-- Declaraci�n de variables
	idValorSalida NUMBER:= 1;

BEGIN 
	-- Cuerpo de la funci�n
	RETURN idValorSalida;
END;
END;

------------------------------------------------------------------------
------------------------- PL's anonimos -------------------------------------- 
-- son script que no se guardan en la base datos. una vez se ejecutan  
-- No tienen cabecera y no se quedan guardados en la BD
-- Se utilizan para lanzar scripts puntuales, m�s o menos complejos, contra la BD
-- El s�mbolo & se utiliza para solicitar datos al usuario por pantalla

DECLARE
	-- Declaraci�n de variables
BEGIN 
	-- Cuerpo
END;

--

DECLARE
	-- Declaraci�n de variables
	codPedido  VARCHAR2 (8):= '&codPedido';
	codCliente VARCHAR2 (8):= '&codCliente';
BEGIN 
	-- Cuerpo
END;

------------------------------------------------------------------------
------------------------- EJEMPLO 3 -------------------------------------- 
 -- Crear un Procedimiento que reciba el c�digo de un pa�s y 
 -- devuelva su descripci�n (en un par�metro de salida).
 -- Crear un PL an�nimo que solicite dicho c�digo al usuario,
 -- invoque al Procedimiento anterior y muestre el resultado por pantalla



CREATE OR REPLACE PROCEDURE DevolverDescripcion (codPais IN TPaises.idPais%TYPE, 
                                                 descPais OUT TPaises.dsPais%TYPE) IS
BEGIN
    SELECT dsPais
      INTO descPais
      FROM TPaises
     WHERE idPais = codPais;
END;

----


DECLARE
    codPais  TPaises.idPais%TYPE:= '&C�digo';
    descPais TPaises.dsPais%TYPE;
BEGIN
    DevolverDescripcion (codPais, descPais);
    DBMS_OUTPUT.PUT_LINE (descPais);
END;

-- el codigo anterior al cerrar el developer se borrar� porque no tiene cabezera.



