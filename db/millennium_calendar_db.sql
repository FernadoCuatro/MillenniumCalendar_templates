DROP DATABASE IF EXISTS millennium_calendar_db;
CREATE DATABASE millennium_calendar_db;
USE millennium_calendar_db;

-- --------------------------------------
-- TABLA [01 / 07] = administrador
-- --------------------------------------
DROP TABLE IF EXISTS administrador;
CREATE TABLE administrador (
    id_administrador            INT                AUTO_INCREMENT NOT NULL,
    nombre                      VARCHAR(30)        NOT NULL,
    apellido                    VARCHAR(30)        NOT NULL,
    estado_administrador        ENUM('A','I')      NOT NULL,
    CONSTRAINT pk_id_administrador PRIMARY KEY (id_administrador)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------
-- TABLA [02 / 07] = facilitador
-- --------------------------------------
DROP TABLE IF EXISTS facilitador;
CREATE TABLE facilitador(
    id_facilitador              INT                AUTO_INCREMENT NOT NULL,
    nombre_facilitador          VARCHAR(50)        NOT NULL,
    estudio                     VARCHAR(300)       NOT NULL,
    estado_facilitador          ENUM('A','I')      NOT NULL,
    CONSTRAINT pk_facilitador PRIMARY KEY (id_facilitador)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------
-- TABLA [03 / 07] = categoría
-- --------------------------------------
CREATE TABLE IF NOT EXISTS categoria(
    id_categoria                INT                AUTO_INCREMENT NOT NULL,
    nombre_categoria            VARCHAR(30)        NOT NULL,
    descripcion                 VARCHAR(300)       NOT NULL,
    estado_categoria            ENUM('A','I')      NOT NULL,
    CONSTRAINT pk_id_categoria PRIMARY KEY(id_categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------
-- TABLA [04 / 07] = login
-- --------------------------------------
DROP TABLE IF EXISTS login;
CREATE TABLE login(
    id_login                    INT                AUTO_INCREMENT NOT NULL,
    id_administrador            INT                NOT NULL UNIQUE,
    correo                      VARCHAR(70)        NOT NULL,
    clave                       VARCHAR(500)       NOT NULL,
    estado_login                ENUM('A','I')      NOT NULL,
    CONSTRAINT pk_id_login PRIMARY KEY(id_login)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------
-- TABLA [05 / 07] = actividad
-- --------------------------------------
DROP TABLE IF EXISTS actividad;
CREATE TABLE actividad(
    id_actividad                INT                AUTO_INCREMENT NOT NULL,
    id_categoria                INT                NOT NULL,
    id_facilitador              INT                NOT NULL,
    nombre_actividad            VARCHAR(45)        NOT NULL,
    fecha_inicio                DATE               NOT NULL,
    fecha_final                 DATE               NOT NULL,
    dias_semana                 VARCHAR(45)        NOT NULL,
    horas_dias                  VARCHAR(45)        NOT NULL,
    descripcion                 VARCHAR(300)       NOT NULL,
    estado_actividad            ENUM('A','I')      NOT NULL,
    CONSTRAINT pk_id_actividad PRIMARY KEY(id_actividad)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------
-- TABLA [06 / 07] = administrador_actividad
-- --------------------------------------
DROP TABLE IF EXISTS administrador_actividad;
CREATE TABLE administrador_actividad(
    id_proceso                  INT                AUTO_INCREMENT NOT NULL,
    id_administrador            INT                NOT NULL,
    id_actividad                INT                NOT NULL,
    fecha_proceso               DATE               NOT NULL,
    CONSTRAINT Pk_id_proceso PRIMARY KEY (id_proceso)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------
-- TABLA [07 / 07] = bitácora
-- --------------------------------------
CREATE TABLE IF NOT EXISTS bitacora (
    id_registro                 INT                AUTO_INCREMENT NOT NULL,
    id_administrador            INT                NOT NULL,
    tipo_registro               ENUM('I','U','D')  NOT NULL,
    fecha_registro              TIMESTAMP          NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    descripcion_registro        TEXT               NOT NULL,
    CONSTRAINT pk_id_categoria PRIMARY KEY(id_registro)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;


-- --------------------------------------
--
-- [CONSTRAINT FOREIGN KEY] [FK]
--
-- --------------------------------------
-- TABLA LOGIN - ADMINISTRADOR
ALTER TABLE login ADD CONSTRAINT fk_login_administrador FOREIGN KEY(id_administrador) REFERENCES administrador(id_administrador);
-- TABLA ADMINISTRADOR ACTIVIDAD - ADMINISTRADOR
ALTER TABLE administrador_actividad ADD CONSTRAINT fk_administrador_actividad FOREIGN KEY(id_administrador) REFERENCES administrador(id_administrador);
-- TABLA ADMINISTRADOR ACTIVIDAD - ACTIVIDAD
ALTER TABLE administrador_actividad ADD CONSTRAINT fk_actividad_administrador FOREIGN KEY(id_actividad) REFERENCES actividad(id_actividad);
-- TABLA ACTIVIDAD - CATEGORIA
ALTER TABLE actividad ADD CONSTRAINT fk_categoria_actividad FOREIGN KEY(id_categoria) REFERENCES categoria(id_categoria);
-- TABLA ACTIVIDAD - FACILITADOR
ALTER TABLE actividad ADD CONSTRAINT fk_actividad_facilitador FOREIGN KEY(id_facilitador) REFERENCES facilitador(id_facilitador);


-- --------------------------------------
--
-- [PROCEDIMIENTOS ALMACENADOS] [SP]
--
-- --------------------------------------

-- --------------------------------------
-- [SP TABLA ADMINISTRADOR]
-- [TABLA ADMINISTRADOR 1/5] INSERT
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_agregar_administrador;
CREATE PROCEDURE SP_agregar_administrador(  
IN nombre                       VARCHAR(30),    
IN apellido                     VARCHAR(30),   
IN estado_administrador         ENUM('A','I')   
) 
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
INSERT INTO administrador VALUES('NULL',nombre,apellido,estado_administrador);

-- [TABLA ADMINISTRADOR 2/5] UPDATE
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_actualizar_administrador;
CREATE PROCEDURE SP_actualizar_administrador(
IN id_administrador2            INT, 
IN nombre2                      VARCHAR(30),    
IN apellido2                    VARCHAR(30),    
IN estado_administrador2        ENUM('A','I')  
) 
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
UPDATE administrador SET nombre = nombre2, apellido = apellido2, estado_administrador = estado_administrador2 WHERE id_administrador = id_administrador2;

-- [TABLA ADMINISTRADOR 3/5] SELECT
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_listar_administrador;
CREATE PROCEDURE SP_listar_administrador()
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
SELECT a.*, l.* FROM administrador a INNER JOIN login l ON a.id_administrador = l.id_administrador;

-- [TABLA ADMINISTRADOR 4/5] SELECT BY ID
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_buscar_administrador;
CREATE PROCEDURE SP_buscar_administrador(
IN id_administrador2            INT   
) 
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
SELECT * FROM administrador WHERE id_administrador = id_administrador2;

-- [TABLA ADMINISTRADOR 5/5] DELETE
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_eliminar_administrador;
CREATE PROCEDURE SP_eliminar_administrador(
IN id_administrador2            INT   
) 
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
UPDATE administrador SET estado_administrador = 'I' WHERE id_administrador = id_administrador2;


-- --------------------------------------
-- [SP TABLA FACILITADOR]
-- [TABLA FACILITADOR 1/5] INSERT
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_agregar_facilitador;  
CREATE PROCEDURE SP_agregar_facilitador (
IN nombre_facilitador           VARCHAR(50),
IN estudio                      VARCHAR(300),
IN estado_facilitador           ENUM('A','I')
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
INSERT INTO facilitador VALUES ('NULL', nombre_facilitador, estudio, estado_facilitador);

-- [TABLA FACILITADOR 2/5] UPDATE
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_actualizar_facilitador;  
CREATE PROCEDURE SP_actualizar_facilitador (
IN id_facilitador2              INT,
IN nombre_facilitador2          VARCHAR(50),
IN estudio2                     VARCHAR(300),
IN estado_facilitador2          ENUM('A','I')
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
UPDATE facilitador SET nombre_facilitador = nombre_facilitador2 ,estudio = estudio2, estado_facilitador = estado_facilitador2 WHERE id_facilitador = id_facilitador2;

-- [TABLA FACILITADOR 3/5] SELECT
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_listar_facilitador;
CREATE PROCEDURE SP_listar_facilitador()
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
SELECT * FROM facilitador WHERE estado_facilitador = 'A';

-- [TABLA FACILITADOR 4/5] SELECT BY ID
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_buscar_facilitador;  
 CREATE PROCEDURE SP_buscar_facilitador(
IN id_facilitador2              INT   
) 
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
SELECT * FROM facilitador WHERE id_facilitador = id_facilitador2;

-- [TABLA FACILITADOR 5/5] DELETE
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_eliminar_facilitador; 
CREATE PROCEDURE SP_eliminar_facilitador(
IN id_facilitador2              INT
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
UPDATE facilitador SET estado_facilitador = 'I' WHERE id_facilitador = id_facilitador2;

-- --------------------------------------
-- [SP TABLA CATEGORIA]
-- [TABLA CATEGORIA 1/5] INSERT
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_agregar_categoria; 
CREATE PROCEDURE SP_agregar_categoria(
in nombre_categoria             VARCHAR(30),
in descripcion                  VARCHAR(300),
in estado_categoria             ENUM('A','I')
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
INSERT INTO categoria
VALUES ('NULL', nombre_categoria, descripcion, estado_categoria);

-- [TABLA CATEGORIA 2/5] UPDATE
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_actualizar_categoria;
CREATE PROCEDURE SP_actualizar_categoria(
in id_categoria_2               INT,
in nombre_categoria_2           VARCHAR(30),
in descripcion_2                VARCHAR(300),
in estado_categoria_2           ENUM('A','I')
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
UPDATE categoria SET nombre_categoria=nombre_categoria_2, descripcion=descripcion_2, estado_categoria=estado_categoria_2 WHERE id_categoria=id_categoria_2;

-- [TABLA CATEGORIA 3/5] SELECT
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_listar_categorias;
CREATE PROCEDURE SP_listar_categorias()
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY 
DEFINER SELECT * FROM categoria WHERE estado_categoria = 'A';

-- [TABLA CATEGORIA 4/5] SELECT BY ID 
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_buscar_categoria;
CREATE PROCEDURE SP_buscar_categoria(
in id_categoria_2               INT
)NOT DETERMINISTIC CONTAINS SQL SQL SECURITY 
DEFINER SELECT * FROM categoria WHERE id_categoria = id_categoria_2;

-- [TABLA CATEGORIA 5/5] DELETE
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_eliminar_categoria;
CREATE PROCEDURE SP_eliminar_categoria(
in id_categoria_2               INT
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY 
DEFINER 
UPDATE categoria SET estado_categoria='I' WHERE id_categoria=id_categoria_2;

-- --------------------------------------
-- [SP TABLA LOGIN]
-- [TABLA LOGIN 1/6] INSERT
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_agregar_login; 
CREATE PROCEDURE SP_agregar_login(
IN id_administrador             INT, 
IN correo                       VARCHAR(70),
IN clave                        VARCHAR(500),
IN estado_login                 ENUM('A','I')
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER 
INSERT INTO login VALUES ('NULL', id_administrador, correo, clave, estado_login);

-- [TABLA LOGIN 2/6] UPDATE
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_actualizar_login; 
CREATE PROCEDURE SP_actualizar_login(
IN id_login2                    INT,
IN id_administrador2            INT, 
IN correo2                      VARCHAR(70),
IN clave2                       VARCHAR(500),
IN estado_login2                ENUM('A','I')
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER 
UPDATE login SET id_administrador = id_administrador2, correo = correo2, clave = clave2, estado_login = estado_login2 WHERE id_login = id_login2;

-- [TABLA LOGIN 3/6] SELECT
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_listar_login;
CREATE PROCEDURE SP_listar_login()
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER 
SELECT * FROM login;

-- [TABLA LOGIN 4/6] SELECT BY ID
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_buscar_login;
CREATE PROCEDURE SP_buscar_login(
IN id_login2                    INT
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER 
SELECT * FROM login WHERE id_login = id_login2;

-- [TABLA LOGIN 5/6] DELETE
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_eliminar_login;
CREATE PROCEDURE SP_eliminar_login(
IN id_login2                    INT
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER 
UPDATE login SET estado_login = 'I' WHERE id_login = id_login2;

-- [TABLA LOGIN 6/6] INICIAR SESION
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS validar_login_administrador;
CREATE PROCEDURE validar_login_administrador(
IN usuario                      VARCHAR(50),
IN psw                          VARCHAR(50)
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
SELECT login.id_administrador, administrador.nombre, administrador.apellido, correo FROM login 
    INNER JOIN administrador ON login.id_administrador = administrador.id_administrador
    WHERE
    login.correo = usuario AND login.clave = psw AND login.estado_login = "A" AND administrador.estado_administrador = "A" ;

-- --------------------------------------
-- [SP TABLA ACTIVIDAD]
-- [TABLA ACTIVIDAD 1/5] INSERT
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_agregar_actividad;
CREATE PROCEDURE SP_agregar_actividad(
IN id_categoria                 INT,
IN id_facilitador               INT,
IN nombre_actividad             VARCHAR(45),
IN fecha_inicio                 DATE,
IN fecha_final                  DATE,
IN dias_semana                  VARCHAR(45),
IN horas_dias                   VARCHAR(45),
IN descripcion                  VARCHAR(300),
IN estado_actividad             ENUM('A','I')
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
INSERT INTO actividad 
VALUES ('NULL', id_categoria, id_facilitador, nombre_actividad, fecha_inicio, fecha_final, dias_semana, horas_dias, descripcion, estado_actividad);

-- [TABLA ACTIVIDAD 2/5] UPDATE
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_actualizar_actividad;
CREATE PROCEDURE SP_actualizar_actividad(
IN id_actividad2                INT,
IN id_categoria2                INT,
IN id_facilitador2              INT,
IN nombre_actividad2            VARCHAR(45),
IN fecha_inicio2                DATE,
IN fecha_final2                 DATE,
IN dias_semana2                 VARCHAR(45),
IN horas_dias2                  VARCHAR(45),
IN descripcion2                 VARCHAR(300),
IN estado_actividad2            ENUM('A','I')
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
UPDATE actividad SET id_categoria = id_categoria2, id_facilitador = id_facilitador2, nombre_actividad = nombre_actividad2, fecha_inicio = fecha_inicio2,
fecha_final = fecha_final2, dias_semana = dias_semana2, horas_dias = horas_dias2, descripcion = descripcion2, estado_actividad = estado_actividad2 WHERE id_actividad = id_actividad2;

-- [TABLA ACTIVIDAD 3/5] SELECT
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_listar_actividad;  
CREATE PROCEDURE SP_listar_actividad()
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
SELECT nombre_categoria, nombre_facilitador, nombre_actividad, fecha_inicio, fecha_final, dias_semana, horas_dias, a.descripcion FROM actividad a INNER JOIN categoria c ON a.id_categoria = c.id_categoria INNER JOIN facilitador f ON a.id_facilitador = f.id_facilitador WHERE estado_actividad = 'A';

-- [TABLA ACTIVIDAD #/#] SELECT ADMINISTRADOR
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_listar_actividad_detalles;  
CREATE PROCEDURE SP_listar_actividad_detalles()
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
SELECT nombre_categoria, nombre_facilitador, a.id_actividad, a.id_categoria, a.id_facilitador, nombre_actividad, fecha_inicio, fecha_final, dias_semana, horas_dias, a.descripcion, estado_actividad  FROM actividad a INNER JOIN categoria c ON a.id_categoria = c.id_categoria INNER JOIN facilitador f ON a.id_facilitador = f.id_facilitador;

-- [TABLA ACTIVIDAD 4/5] SELECT BY ID
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_buscar_actividad;
CREATE PROCEDURE SP_buscar_actividad(
IN id_actividad1                INT
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY 
DEFINER 
SELECT * FROM actividad WHERE id_actividad = id_actividad1;

-- [TABLA ACTIVIDAD #/#] SELECT ADMINISTRADOR
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_buscar_actividad_detalles;  
CREATE PROCEDURE SP_buscar_actividad_detalles(
IN id_actividad1                INT
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
SELECT nombre_categoria, nombre_facilitador, a.id_actividad, a.id_categoria, a.id_facilitador, nombre_actividad, fecha_inicio, fecha_final, dias_semana, horas_dias, a.descripcion, estado_actividad  FROM actividad a INNER JOIN categoria c ON a.id_categoria = c.id_categoria INNER JOIN facilitador f ON a.id_facilitador = f.id_facilitador WHERE a.id_actividad = id_actividad1;

-- [TABLA ACTIVIDAD 5/5] DELETE
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_eliminar_actividad;
CREATE PROCEDURE SP_eliminar_actividad(
IN id_actividad1                INT  
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY 
DEFINER 
UPDATE actividad SET estado_actividad = 'I' WHERE id_actividad = id_actividad1;

-- --------------------------------------
-- [SP TABLA ADMINISTRADOR_ACTIVIDAD]
-- [TABLA ADMINISTRADOR_ACTIVIDAD 1/5] INSERT
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_agregar_administrador_actividad;  
CREATE PROCEDURE SP_agregar_administrador_actividad(
IN id_administrador             INT,
IN id_actividad                 INT,
IN fecha_proceso                DATE
) 
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
INSERT INTO administrador_actividad VALUES('NULL', id_administrador, id_actividad, fecha_proceso);

-- [TABLA ADMINISTRADOR_ACTIVIDAD 2/5] UPDATE
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_actualizar_administrador_actividad;  
CREATE PROCEDURE SP_actualizar_administrador_actividad(
IN id_proceso2                  INT,
IN id_administrador2            INT,
IN id_actividad2                INT,
IN fecha_proceso2               DATE  
) 
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
UPDATE administrador_actividad SET id_administrador = id_administrador2, id_actividad = id_actividad2, fecha_proceso = fecha_proceso2 WHERE id_proceso = id_proceso2;

-- [TABLA ADMINISTRADOR_ACTIVIDAD 3/5] SELECT
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_listar_administrador_actividad;  
CREATE PROCEDURE SP_listar_administrador_actividad()
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
SELECT * FROM administrador_actividad;

-- [TABLA ADMINISTRADOR_ACTIVIDAD 4/5] SELECT BY ID
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_buscar_administrador_actividad;  
 CREATE PROCEDURE SP_buscar_administrador_actividad(
IN id_proceso2                  INT   
) 
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
SELECT * FROM administrador_actividad WHERE id_proceso = id_proceso2;

-- [TABLA ADMINISTRADOR_ACTIVIDAD 5/5] DELETE
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_eliminar_administrador_actividad;  
CREATE PROCEDURE SP_eliminar_administrador_actividad(
IN id_proceso2                  INT   
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
DELETE FROM id_administrador_actividad WHERE id_proceso = id_proceso2;


-- --------------------------------------
-- [SP TABLA BITACORA]
-- [TABLA BITACORA 1/5] INSERT
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_agregar_bitacora; 
CREATE PROCEDURE SP_agregar_bitacora(
in id_administrador       INT,
in tipo_registro          ENUM('I','U','D'),
in descripcion_registro   TEXT
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
INSERT INTO bitacora
VALUES ('NULL', id_administrador, tipo_registro, CURRENT_TIMESTAMP(), descripcion_registro);

-- [TABLA BITACORA 2/5] UPDATE
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_actualizar_bitacora;
CREATE PROCEDURE SP_actualizar_bitacora(
in id_registro_2          INT,
in id_administrador_2     INT,
in tipo_registro_2        ENUM('I','U','D'),
in descripcion_registro_2 TEXT
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY
DEFINER
UPDATE bitacora SET id_administrador=id_administrador_2,tipo_registro=tipo_registro_2,descripcion_registro=descripcion_registro_2 WHERE id_registro=id_registro_2;

-- [TABLA BITACORA 3/5] SELECT
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_listar_bitacora;
CREATE PROCEDURE SP_listar_bitacora()
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY 
DEFINER SELECT * FROM bitacora ORDER BY id_registro DESC;

-- [TABLA BITACORA 4/5] SELECT BY ID 
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_buscar_bitacora;
CREATE PROCEDURE SP_buscar_bitacora(
in id_registro_2          INT
)NOT DETERMINISTIC CONTAINS SQL SQL SECURITY 
DEFINER SELECT * FROM bitacora WHERE id_registro = id_registro_2;

-- [TABLA BITACORA 5/5] DELETE
USE millennium_calendar_db;
DROP PROCEDURE IF EXISTS SP_eliminar_bitacora;
CREATE PROCEDURE SP_eliminar_bitacora(
in id_registro_2         INT
)
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY 
DEFINER 
DELETE FROM bitacora WHERE id_registro = id_registro_2;


-- --------------------------------------
--
-- EXTRAS
-- [Cada tabla contiene al menos un registros]
--
-- --------------------------------------

-- [TABLA ADMINISTRADOR]
CALL SP_agregar_administrador('Melissa Alexandra','Lopez','A');
CALL SP_agregar_administrador('Diego Armando','Echeverria Santacruz','A');
CALL SP_agregar_administrador('Rodolfo Carlos','Menjivar Marroquin','I');
-- CALL SP_actualizar_administrador(1,'Alejandro','Benavides','A');
-- CALL SP_buscar_administrador(1);
-- CALL SP_eliminar_administrador(1);
-- CALL SP_listar_administrador();

-- --------------------------------------
-- [TABLA FACILITADOR]
CALL SP_agregar_facilitador('Juan Pablo Chinchilla','Ingeniero electricista','A');
CALL SP_agregar_facilitador('Miguel Angel Mejia','Desarrollador web','A');
CALL SP_agregar_facilitador('Pamela Ortiz','Licenciada en redes de datos','A');
-- CALL SP_actualizar_facilitador(1, "Carlos","Tecnico automotris","I");
-- CALL SP_buscar_facilitador(1);
-- CALL SP_eliminar_facilitador(1);
-- CALL SP_listar_facilitador();

-- --------------------------------------
-- [TABLA CATEGORIA]
CALL SP_agregar_categoria('Electrónica', 'La electrónica es una rama de la física aplicada que comprende la física, la ingeniería, la tecnología y las aplicaciones que tratan con la emisión, el flujo y el control de los electrones', 'A');
CALL SP_agregar_categoria('Desarrollo web', 'Desarrollo web es un término que define la creación de sitios web para Internet o una intranet. Para conseguirlo se hace uso de tecnologías de software', 'A');
CALL SP_agregar_categoria('Redes de datos', 'Una red o red de datos es una red de telecomunicaciones que permite a los equipos de cómputo intercambiar datos. En las redes de cómputo, dispositivos de computación conectados en red.', 'A');
-- CALL SP_actualizar_categoria(7, 'Hardware', 'Sistema informático, sus componentes eléctricos, electrónicos, electromecánicos', 'A');
-- CALL SP_listar_categorias();
-- CALL SP_buscar_categoria(2);
-- CALL SP_eliminar_categoria(3);

-- --------------------------------------
-- [TABLA LOGIN]
CALL SP_agregar_login (1,'melissa@mail.com','holamundo@','A');
CALL SP_agregar_login (2,'diego@mail.com','holamundo@','A');
CALL SP_agregar_login (3,'rodolfo@mail.com','holamundo@','A');
-- CALL SP_actualizar_login (1,'2','roger1@prueba.com','4321','A');
-- CALL SP_validar_login ('roger1@prueba.com','4321','A');
-- CALL SP_buscar_login(1);
-- CALL SP_eliminar_login (1);
-- CALL SP_listar_login();

-- --------------------------------------
-- [TABLA ACTIVIDAD]
CALL SP_agregar_actividad( 1, 1, 'Análisis de Circuitos Eléctricos', '2022-10-10', '2022-10-10', 'Lunes - Miercoles - Viernes', '11:00 - 13:30', 'Un circuito eléctrico es un grupo de componentes interconectados. El análisis de circuitos es el proceso de calcular los diferentes parámetros del circuito como lo son: intensidades, tensiones o potencias. Existen muchas técnicas para lograrlo', 'A');
CALL SP_agregar_actividad( 1, 1, 'Fundamentos Ley de Ohm', '2022-10-10', '2022-10-10', 'Martes - Jueves', '08:00 - 10:30', 'La intensidad de corriente que atraviesa un circuito es directamente proporcional al voltaje o tensión del mismo e inversamente proporcional a la resistencia que presenta.', 'A');
-- CALL SP_actualizar_actividad(1, 2, 2, 'Python', '2022-9-9', '2022-9-9', 'Miercoles - Viernes', '11:30 - 13:30', 'Python de 0 a experto', 'I');
-- CALL SP_buscar_actividad(1);
-- CALL SP_eliminar_actividad(1);
-- CALL SP_listar_actividad();

-- --------------------------------------
-- [TABLA ADMINISTRADOR_ACTIVIDAD]
-- CALL SP_agregar_administrador_actividad(1,1,'2022-06-03');
-- CALL SP_actualizar_administrador_actividad(1,1,1,'2022-08-07');
-- CALL SP_buscar_administrador_actividad(1);
-- CALL SP_eliminar_administrador_actividad(1);
-- CALL SP_listar_administrador_actividad();

-- --------------------------------------
-- [TABLA BITACORA]
-- CALL SP_agregar_bitacora(1, 'I', 'Carlos Rodolfo inserto una categoría con el nombre: Desarrollo web');
-- CALL SP_actualizar_bitacora(1, 1, 'D', 'Carlos Rodolfo inhabilito una categoría con el nombre: Gestión empresarial');
-- CALL SP_listar_bitacora();
-- CALL SP_buscar_bitacora(4);
-- CALL SP_eliminar_bitacora(7);