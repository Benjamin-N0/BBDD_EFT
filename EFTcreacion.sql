--SELECT USER AS USUARIO_ACTUAL,
 -- SYS_CONTEXT('USERENV','CON_NAME') AS CONTENEDOR
--FROM DUAL;

-- limpieza
DROP TABLE DOMINIO_IDIOMA CASCADE CONSTRAINTS;
DROP TABLE CONTRATO_CLUB CASCADE CONSTRAINTS;
DROP TABLE PERSONAL_PLANTA CASCADE CONSTRAINTS;
DROP TABLE JUGADOR CASCADE CONSTRAINTS;
DROP TABLE TRABAJADOR CASCADE CONSTRAINTS;
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE REGION CASCADE CONSTRAINTS;
DROP TABLE NACIONALIDAD CASCADE CONSTRAINTS;
DROP TABLE IDIOMA CASCADE CONSTRAINTS;
DROP TABLE CLUB_FUTBOL CASCADE CONSTRAINTS;
DROP TABLE ESCUELA_FORMATIVA CASCADE CONSTRAINTS;
DROP TABLE ASOCIACION CASCADE CONSTRAINTS;
DROP SEQUENCE SEQ_CLUB_FUTBOL;


-- TABLA ASOCIACION FECHA DE CREACION SUPERIOR A 1980-12-31 (CHECK)

CREATE TABLE ASOCIACION 
    ( 
     id_asociacion    NUMBER NOT NULL , 
     nombre_asociacion VARCHAR2 (60) NOT NULL , 
     fecha_creacion    DATE NOT NULL , 
     tipo_asociacion   VARCHAR2 (1) NOT NULL ,
     CONSTRAINT CK_ASOC_FECHA_CREACION CHECK (fecha_creacion >= TO_DATE('1980-12-31', 'YYYY-MM-DD'))
    ) 
;

ALTER TABLE ASOCIACION 
    ADD CONSTRAINT ASOCIACION_PK PRIMARY KEY ( id_asociacion ) ;


-- TABLA CLUB FUTBOL CLUB uso de UNIQUE en club nombre para evitar la repeticion de un club

CREATE TABLE CLUB_FUTBOL 
    ( 
     id_club         NUMBER  NOT NULL , 
     Nombre_Club     VARCHAR2 (70)  NOT NULL , 
     Patrimonio      NUMBER  NOT NULL , 
     Ubicacion_Calle VARCHAR2 (100)  NOT NULL , 
     Tipo_Club       VARCHAR2 (30)  NOT NULL ,
     CONSTRAINT UN_CLUB_NOMBRE UNIQUE (Nombre_Club)
    ) 
;

ALTER TABLE CLUB_FUTBOL 
    ADD CONSTRAINT CLUB_FUTBOL_PK PRIMARY KEY ( id_club ) ;


--TABLA COMUNA
CREATE TABLE COMUNA 
    ( 
     id_comuna        NUMBER  NOT NULL , 
     REGION_Id_Region NUMBER  NOT NULL , 
     nombre           VARCHAR2 (50)  NOT NULL  
    ) 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_PK PRIMARY KEY ( id_comuna ) ;


--TABLA CONTRATO CLUB

CREATE TABLE CONTRATO_CLUB 
    ( 
     Fecha_Inicio            DATE  NOT NULL , 
     Fecha_Fin               DATE , 
     JUGADOR_num_inscripcion NUMBER  NOT NULL , 
     CLUB_FUTBOL_id_club     NUMBER  NOT NULL 
    ) 
;

ALTER TABLE CONTRATO_CLUB 
    ADD CONSTRAINT CONTRATO_CLUB_PK PRIMARY KEY ( Fecha_Inicio, CLUB_FUTBOL_id_club, JUGADOR_num_inscripcion ) ;


--TABLA DOMINIO IDIOMA

CREATE TABLE DOMINIO_IDIOMA 
    ( 
     nivel_dominio           VARCHAR2 (30)  NOT NULL , 
     JUGADOR_num_inscripcion NUMBER  NOT NULL , 
     IDIOMA_Id_Idioma        NUMBER  NOT NULL 
    ) 
;

ALTER TABLE DOMINIO_IDIOMA 
    ADD CONSTRAINT DOMINIO_IDIOMA_PK PRIMARY KEY ( IDIOMA_Id_Idioma, JUGADOR_num_inscripcion ) ;

--TABLA ESCUELA FORMATIVA

CREATE TABLE ESCUELA_FORMATIVA 
    ( 
     id_escuela      NUMBER  NOT NULL , 
     nombre_escuela  VARCHAR2 (50)  NOT NULL , 
     capacidad       NUMBER  NOT NULL , 
     fecha_fundacion DATE  NOT NULL 
    ) 
;

ALTER TABLE ESCUELA_FORMATIVA 
    ADD CONSTRAINT ESCUELA_FORMATIVA_PK PRIMARY KEY ( id_escuela ) ;


--TABLA IDIOMA

CREATE TABLE IDIOMA 
    ( 
     Id_Idioma     NUMBER  NOT NULL , 
     Nombre_Idioma VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE IDIOMA 
    ADD CONSTRAINT IDIOMA_PK PRIMARY KEY ( Id_Idioma ) ;

-- TABLA JUGADOR

CREATE TABLE JUGADOR 
    ( 
     num_inscripcion              NUMBER  NOT NULL , 
     Puesto                       VARCHAR2 (20)  NOT NULL , 
     Monto_Premios                NUMBER  NOT NULL , 
     Anio_Retiro_Amateur          NUMBER , 
     ASOCIACION_id_asociacion     NUMBER  NOT NULL , 
     ESCUELA_FORMATIVA_id_escuela NUMBER 
    ) 
;

ALTER TABLE JUGADOR 
    ADD CONSTRAINT JUGADOR_PK PRIMARY KEY ( num_inscripcion ) ;


--TABLA NACIONALIDAD Id nacion empieza en 210

CREATE TABLE NACIONALIDAD 
    ( 
     Id_Nacion   NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 210 INCREMENT BY 2) NOT NULL , 
     Descripcion VARCHAR2 (50) NOT NULL 
    ) 
;

ALTER TABLE NACIONALIDAD 
    ADD CONSTRAINT NACIONALIDAD_PK PRIMARY KEY ( Id_Nacion ) ;


-- TABLA PERSONAL PLANTA

CREATE TABLE PERSONAL_PLANTA 
    ( 
     num_inscripcion  NUMBER  NOT NULL , 
     horas_trabajadas NUMBER , 
     valor_hora_extra NUMBER 
    ) 
;

ALTER TABLE PERSONAL_PLANTA 
    ADD CONSTRAINT PERSONAL_PLANTA_PK PRIMARY KEY ( num_inscripcion ) ;


--TABLA REGION

CREATE TABLE REGION 
    ( 
     Id_Region NUMBER  NOT NULL , 
     Nombre    VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE REGION 
    ADD CONSTRAINT REGION_PK PRIMARY KEY ( Id_Region ) ;


-- TABLA TRABAJADOR

CREATE TABLE TRABAJADOR 
    ( 
     num_inscripcion        NUMBER  NOT NULL , 
     Rut_Trabajador         NUMBER  NOT NULL , 
     Nombre_Completo        VARCHAR2 (100)  NOT NULL , 
     Sueldo_Base            NUMBER  NOT NULL , 
     Fecha_Nacimiento       DATE  NOT NULL , 
     Genero                 VARCHAR2 (1)  NOT NULL , 
     Estado_Civil           VARCHAR2 (25)  NOT NULL , 
     Telefono_Movil         VARCHAR2 (15)  NOT NULL , 
     Direccion              VARCHAR2 (100)  NOT NULL , 
     COMUNA_id_comuna       NUMBER  NOT NULL , 
     NACIONALIDAD_Id_Nacion NUMBER  NOT NULL 
    ) 
;

ALTER TABLE TRABAJADOR 
    ADD CONSTRAINT TRABAJADOR_PK PRIMARY KEY ( num_inscripcion ) ;

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_REGION_FK FOREIGN KEY 
    ( 
     REGION_Id_Region
    ) 
    REFERENCES REGION 
    ( 
     Id_Region
    ) 
;

ALTER TABLE CONTRATO_CLUB 
    ADD CONSTRAINT CONTRATO_CLUB_CLUB_FUTBOL_FK FOREIGN KEY 
    ( 
     CLUB_FUTBOL_id_club
    ) 
    REFERENCES CLUB_FUTBOL 
    ( 
     id_club
    ) 
;

ALTER TABLE CONTRATO_CLUB 
    ADD CONSTRAINT CONTRATO_CLUB_JUGADOR_FK FOREIGN KEY 
    ( 
     JUGADOR_num_inscripcion
    ) 
    REFERENCES JUGADOR 
    ( 
     num_inscripcion
    ) 
;

ALTER TABLE DOMINIO_IDIOMA 
    ADD CONSTRAINT DOMINIO_IDIOMA_IDIOMA_FK FOREIGN KEY 
    ( 
     IDIOMA_Id_Idioma
    ) 
    REFERENCES IDIOMA 
    ( 
     Id_Idioma
    ) 
;

ALTER TABLE DOMINIO_IDIOMA 
    ADD CONSTRAINT DOMINIO_IDIOMA_JUGADOR_FK FOREIGN KEY 
    ( 
     JUGADOR_num_inscripcion
    ) 
    REFERENCES JUGADOR 
    ( 
     num_inscripcion
    ) 
;

ALTER TABLE JUGADOR 
    ADD CONSTRAINT JUGADOR_ASOCIACION_FK FOREIGN KEY 
    ( 
     ASOCIACION_id_asociacion
    ) 
    REFERENCES ASOCIACION 
    ( 
     id_asociacion
    ) 
;

ALTER TABLE JUGADOR 
    ADD CONSTRAINT JUGADOR_ESCUELA_FORMATIVA_FK FOREIGN KEY 
    ( 
     ESCUELA_FORMATIVA_id_escuela
    ) 
    REFERENCES ESCUELA_FORMATIVA 
    ( 
     id_escuela
    ) 
;

ALTER TABLE JUGADOR 
    ADD CONSTRAINT JUGADOR_TRABAJADOR_FK FOREIGN KEY 
    ( 
     num_inscripcion
    ) 
    REFERENCES TRABAJADOR 
    ( 
     num_inscripcion
    ) 
;

ALTER TABLE PERSONAL_PLANTA 
    ADD CONSTRAINT PERSONAL_PLANTA_TRABAJADOR_FK FOREIGN KEY 
    ( 
     num_inscripcion
    ) 
    REFERENCES TRABAJADOR 
    ( 
     num_inscripcion
    ) 
;

ALTER TABLE TRABAJADOR 
    ADD CONSTRAINT TRABAJADOR_COMUNA_FK FOREIGN KEY 
    ( 
     COMUNA_id_comuna
    ) 
    REFERENCES COMUNA 
    ( 
     id_comuna
    ) 
;

ALTER TABLE TRABAJADOR 
    ADD CONSTRAINT TRABAJADOR_NACIONALIDAD_FK FOREIGN KEY 
    ( 
     NACIONALIDAD_Id_Nacion
    ) 
    REFERENCES NACIONALIDAD 
    ( 
     Id_Nacion
    ) 
;

-- SECUENCIA DE CLUB FUTBOL

CREATE SEQUENCE SEQ_CLUB_FUTBOL
    START WITH 703
    INCREMENT BY 4
    NOCACHE
    NOCYCLE;

COMMIT;

-- -----------------------------
-- INSERT POBLAMIENTO DE TABLAS

-- REGION

INSERT INTO REGION (Id_Region, Nombre) VALUES (1, 'ARICA Y PARINACOTA Y TARAPACA');
INSERT INTO REGION (Id_Region, Nombre) VALUES (2, 'ANTOFAGASTA');
INSERT INTO REGION (Id_Region, Nombre) VALUES (3, 'ATACAMA Y COQUIMBO');
INSERT INTO REGION (Id_Region, Nombre) VALUES (5, 'VALPARAISO');
INSERT INTO REGION (Id_Region, Nombre) VALUES (8, 'BIOBIO');
INSERT INTO REGION (Id_Region, Nombre) VALUES (13, 'METROPOLITANA');
INSERT INTO REGION (Id_Region, Nombre) VALUES (16, 'NUBLE');

-- COMUNA
INSERT INTO COMUNA (id_comuna, REGION_Id_Region, nombre) VALUES (101, 13, 'Santiago');
INSERT INTO COMUNA (id_comuna, REGION_Id_Region, nombre) VALUES (102, 5, 'Valparaiso');
INSERT INTO COMUNA (id_comuna, REGION_Id_Region, nombre) VALUES (103, 8, 'Concepcion');
INSERT INTO COMUNA (id_comuna, REGION_Id_Region, nombre) VALUES (104, 2, 'Antofagasta');
INSERT INTO COMUNA (id_comuna, REGION_Id_Region, nombre) VALUES (105, 16, 'Chillan');

-- asociacion

INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion) 
VALUES (25, 'Asociación de Fútbol de Santiago', TO_DATE('15-05-2001', 'DD-MM-YYYY'), 'P');

INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion) 
VALUES (26, 'Asociación Nacional de Fútbol Amateur', TO_DATE('10-03-1998', 'DD-MM-YYYY'), 'A');

INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion) 
VALUES (27, 'Asociación de Fútbol de Valparaíso', TO_DATE('21-07-1987', 'DD-MM-YYYY'), 'P');

INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion) 
VALUES (28, 'Asociación de Fútbol de Concepción', TO_DATE('30-11-1995', 'DD-MM-YYYY'), 'A');

INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion) 
VALUES (29, 'Asociación de Fútbol de Antofagasta', TO_DATE('25-06-2003', 'DD-MM-YYYY'), 'P');

INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion) 
VALUES (30, 'Asociación de Fútbol de Temuco', TO_DATE('12-01-2010', 'DD-MM-YYYY'), 'A');

INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion) 
VALUES (31, 'Asociación de Fútbol de Rancagua', TO_DATE('08-09-1999', 'DD-MM-YYYY'), 'P');

INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion) 
VALUES (32, 'Asociación de Fútbol de Puerto Montt', TO_DATE('20-04-2005', 'DD-MM-YYYY'), 'A');

INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion) 
VALUES (33, 'Asociación de Fútbol de La Serena', TO_DATE('14-08-2012', 'DD-MM-YYYY'), 'P');

INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion) 
VALUES (34, 'Asociación de Fútbol de Chillán', TO_DATE('01-12-2018', 'DD-MM-YYYY'), 'A');

--NACIONALIDAD

INSERT INTO NACIONALIDAD (Descripcion) VALUES ('Chilena');
INSERT INTO NACIONALIDAD (Descripcion) VALUES ('Argentina');
INSERT INTO NACIONALIDAD (Descripcion) VALUES ('Peruana');
INSERT INTO NACIONALIDAD (Descripcion) VALUES ('Boliviana');
INSERT INTO NACIONALIDAD (Descripcion) VALUES ('Brasileña');


-- CLUB FUTBOL

INSERT INTO CLUB_FUTBOL (id_club, Nombre_Club, Patrimonio, Ubicacion_Calle, Tipo_Club) 
VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'Colo-Colo', 500000000, 'Av. Marathon 5300', 'Profesional');

INSERT INTO CLUB_FUTBOL (id_club, Nombre_Club, Patrimonio, Ubicacion_Calle, Tipo_Club) 
VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'Universidad de Chile', 450000000, 'Av. El Parrón 0931', 'Profesional');

INSERT INTO CLUB_FUTBOL (id_club, Nombre_Club, Patrimonio, Ubicacion_Calle, Tipo_Club) 
VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'Deportes Antofagasta', 180000000, 'Avenida Angamos 01606', 'Profesional');

INSERT INTO CLUB_FUTBOL (id_club, Nombre_Club, Patrimonio, Ubicacion_Calle, Tipo_Club) 
VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'Huachipato', 220000000, 'Avenida Desiderio García 909', 'Profesional');

INSERT INTO CLUB_FUTBOL (id_club, Nombre_Club, Patrimonio, Ubicacion_Calle, Tipo_Club) 
VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'Ñublense', 170000000, 'Avenida Pedro Aguirre Cerda 1003', 'Profesional');

COMMIT;

-- 4 --- RECUPERACION DATOS

-- INFORME 1 asociaciones de tipo profesional que fueron creadas después del 2000, ordenadas de manera descendente por fecha

SELECT 
    'ID:' || id_asociacion || ' * ' || nombre_asociacion AS ASOCIACION,
    TO_CHAR(fecha_creacion, 'DD-MM-YYYY') AS CREADA,
    tipo_asociacion AS TIPO
FROM 
    ASOCIACION
WHERE 
    tipo_asociacion = 'P'
    AND fecha_creacion > TO_DATE('31-12-2000', 'DD-MM-YYYY')
ORDER BY 
    fecha_creacion DESC;
    
    
-- INFORME 2  clubes profesionales con un patrimonio mayor a $200 millones, 
--            cuyo nombre tuviera la letra 'a', 
--            calculo de la conversion de patrimonio a dolares (con un tipo de cambio a $955) y ordenando por ID de club descendente.*

SELECT 
    id_club AS CLUB,
    nombre_club AS "NOMBRE CLUB",
    patrimonio AS "PATRIMONIO EN PESOS",
    ROUND(patrimonio / 955) AS "PATRIMONIO EN DOLARES"
FROM 
    CLUB_FUTBOL
WHERE 
    LOWER(nombre_club) LIKE '%a%'
    AND patrimonio > 200000000
    AND tipo_club = 'Profesional'
ORDER BY 
    id_club DESC;




