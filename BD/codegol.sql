-- --------------------------------------------------------
CREATE DATABASE codegol;

USE codegol;
-- --------------------------------------------------------
-- Tabla: usuario
CREATE TABLE usuario (
  id_usuario int(10) UNSIGNED NOT NULL COMMENT 'Identificador único del usuario. Es la clave primaria y se genera automáticamente.',
  correo varchar(255) NOT NULL COMMENT 'Correo electrónico del usuario. Debe ser único.',
  contrasena varchar(255) NOT NULL COMMENT 'Contraseña del usuario en formato cifrado.',
  nombre_completo varchar(255) NOT NULL COMMENT 'Nombre y apellidos completos del usuario.',
  num_identificacion int(10) UNSIGNED NOT NULL COMMENT 'Número del documento de identidad del usuario (CC, TI, CE, etc.).Sirve como acceso al sistema.',
  tipo_documento enum('CC','TI','CE','PA','RC','PEP','NIT','NUIP','DNI','PPT') NOT NULL COMMENT 'Tipo de documento de identidad. Valores posibles: ''CC'', ''TI'', ''CE'', ''PA'', ''RC'', ''PEP'', ''NIT'', ''NUIP'', ''DNI'', ''PPT''.',
  telefono_1 int(10) UNSIGNED NOT NULL COMMENT 'Teléfono principal del usuario.',
  telefono_2 int(10) UNSIGNED DEFAULT NULL COMMENT 'Teléfono secundario (opcional). Puede ser NULL.',
  direccion varchar(255) NOT NULL COMMENT 'Dirección de residencia del usuario.',
  genero enum('M','F','Otro') NOT NULL COMMENT 'Género del usuario. Valores: ''M'', ''F'', ''Otro''.',
  fecha_nacimiento date NOT NULL COMMENT 'Fecha de nacimiento del usuario.',
  lugar_nacimiento varchar(255) DEFAULT NULL COMMENT 'Ciudad o lugar donde nació el usuario.',
  grupo_sanguineo enum('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL COMMENT 'Grupo sanguíneo del usuario. Valores: ''A+'', ''A-'', ''B+'', ''B-'', ''AB+'', ''AB-'', ''O+'', ''O-''.',
  foto_perfil blob DEFAULT NULL COMMENT 'Imagen del perfil del usuario en formato binario. Opcional.',
  estado enum('activo','inactivo') NOT NULL COMMENT 'Estado actual del usuario. Valores: ''activo'', ''inactivo''.',
  registrado_por int(10) UNSIGNED NOT NULL COMMENT 'Usuario que realizó el registro de esta persona. Llave foránea a usuario.id_usuario.',
  id_responsable int(10) UNSIGNED NOT NULL COMMENT 'ID del usuario responsable (usado para menores o personas dependientes).'
);

-- --------------------------------------------------------
-- Tabla: rol
CREATE TABLE rol (
  id_rol int(10) UNSIGNED NOT NULL COMMENT 'Identificador único del rol.',
  rol_usuario varchar(255) NOT NULL COMMENT 'Nombre del rol (Administrador, Entrenador, Jugador,Responsable.).'
);

-- --------------------------------------------------------
-- Tabla: inventario
CREATE TABLE inventario (
  id_inventario int(10) UNSIGNED NOT NULL COMMENT 'Identificador del artículo',
  nombre_articulo varchar(255) NOT NULL COMMENT 'Nombre del artículo (balón, conos, camisetas, etc.).',
  cantidad_total tinyint(3) UNSIGNED NOT NULL COMMENT 'Cantidad total disponible del artículo.',
  descripcion varchar(255) DEFAULT NULL COMMENT 'Descripción general del Articulo. Opcional.',
  fecha_ingreso date NOT NULL COMMENT 'Fecha en la que el artículo ingresó al inventario.',
  estado enum('activo','inactivo') NOT NULL COMMENT 'Estado del artículo. Valores: ''activo'', ''inactivo''.'
);

-- --------------------------------------------------------
-- Tabla: entrenamiento
CREATE TABLE entrenamiento (
  id_entrenamiento int(10) UNSIGNED NOT NULL COMMENT 'Identificador único del entrenamiento.',
  descripcion varchar(255) DEFAULT NULL COMMENT 'Descripción general de la actividad realizada en el entrenamiento.',
  fecha date NOT NULL COMMENT 'Fecha en que se realizó el entrenamiento.',
  hora_inicio time NOT NULL COMMENT 'Hora exacta de inicio del entrenamiento.',
  hora_fin time NOT NULL COMMENT 'Hora en que finalizó el entrenamiento.',
  luegar varchar(255) NOT NULL COMMENT 'Lugar físico donde se llevó a cabo el entrenamiento.',
  estado enum('activo','inactivo') NOT NULL COMMENT 'Estado del entrenamiento. Valores: ''activo'', ''inactivo''.',
  observaciones varchar(255) DEFAULT NULL COMMENT 'Comentarios u observaciones adicionales. Opcional.',
  registrado_por int(10) UNSIGNED NOT NULL COMMENT 'ID del usuario que registró la sesión.'
);

-- --------------------------------------------------------
-- Tabla: matricula
CREATE TABLE matricula (
  id_matricula int(10) UNSIGNED NOT NULL COMMENT 'Identificador de la matrícula.',
  fecha_matricula date NOT NULL COMMENT 'Fecha en que se realizó la matrícula.',
  fecha_inicio date NOT NULL COMMENT 'Fecha de inicio de actividades o clases.',
  fecha_fin date NOT NULL COMMENT 'Fecha en que termina la matrícula o el periodo.',
  estado enum('activo','inactivo') NOT NULL COMMENT 'Estado de la matrícula (''activo'', ''inactivo'').',
  observaciones varchar(255) DEFAULT NULL COMMENT 'Notas adicionales relacionadas con la matrícula.',
  id_jugador int(10) UNSIGNED NOT NULL COMMENT 'ID del usuario que se matricula. Llave foránea a usuario.',
  registrado_por int(10) UNSIGNED NOT NULL COMMENT 'Usuario que realizó el registro.'
); 

-- --------------------------------------------------------
-- Tabla: pago
CREATE TABLE pago (
  id_pago int(10) UNSIGNED NOT NULL COMMENT 'Identificador del pago.',
  concepto_pago varchar(255) NOT NULL COMMENT 'Concepto del pago (ej: inscripción, mensualidad, uniforme).',
  fecha_pago date NOT NULL COMMENT 'Fecha en que se realizó el pago.',
  metodo_pago enum('efectivo','transferencia') NOT NULL COMMENT 'Medio de pago usado (efectivo, transferencia).',
  valor_total int(10) UNSIGNED NOT NULL COMMENT 'Valor monetario pagado.',
  observaciones varchar(255) DEFAULT NULL COMMENT 'Comentarios adicionales. Opcional.',
  pagado_por int(10) UNSIGNED NOT NULL COMMENT 'Usuario que realizó el pago.',
  id_matricula int(10) UNSIGNED NOT NULL COMMENT 'Matrícula a la que corresponde el pago.'
);

-- --------------------------------------------------------
-- Tabla: rendimiento
CREATE TABLE rendimiento (
  id_rendimiento int(10) UNSIGNED NOT NULL COMMENT 'Identificador del resultado de rendimiento.',
  fecha_evaluacion date NOT NULL COMMENT 'Fecha en la que se realizó la evaluación.',
  posicion varchar(255) NOT NULL COMMENT 'Posición en la que se desempeña el jugador (portero, defensa, etc.).',
  categoria_test varchar(255) NOT NULL COMMENT 'Tipo de categoría del test (resistencia, velocidad, etc.).',
  tipo_test varchar(255) NOT NULL COMMENT 'Nombre específico del test realizado.',
  unidad tinyint(3) UNSIGNED NOT NULL COMMENT 'Unidad de medida usada (segundos, metros, repeticiones).',
  resultado tinyint(3) UNSIGNED NOT NULL COMMENT 'Resultado obtenido por el jugador en el test.',
  observaciones varchar(255) DEFAULT NULL COMMENT 'Observaciones o notas.',
  id_jugador int(10) UNSIGNED NOT NULL COMMENT 'ID del jugador evaluado.',
  registrado_por int(10) UNSIGNED NOT NULL COMMENT 'Usuario que realizó la evaluación.'
);

-- --------------------------------------------------------
-- Tabla: detalles_usuario_rol
CREATE TABLE detalles_usuario_rol (
  id_rol_usuario int(10) UNSIGNED NOT NULL COMMENT 'Identificador único de la relación entre usuario y rol.',
  id_rol int(10) UNSIGNED NOT NULL COMMENT 'ID del rol asignado al usuario. Llave foránea a rol.id_rol.',
  id_usuario int(10) UNSIGNED NOT NULL COMMENT 'Usuario al que se le asigna el rol. Llave foránea a usuario.id_usuario.'
);

-- --------------------------------------------------------
-- Tabla: detalles_utiliza
CREATE TABLE detalles_utiliza (
  id_utiliza int(10) UNSIGNED NOT NULL COMMENT 'Identificador del uso de un artículo del inventario.',
  fecha_uso date NOT NULL COMMENT 'Fecha en la que se utilizó el artículo.',
  cantidad_usada tinyint(4) NOT NULL COMMENT 'Cantidad del artículo utilizada.',
  hora_inicio time NOT NULL COMMENT 'Hora de inicio del uso.',
  hora_fin time NOT NULL COMMENT 'Hora de finalización del uso.',
  observaciones varchar(255) DEFAULT NULL COMMENT 'Comentarios sobre el uso del artículo.',
  id_entrenador int(10) UNSIGNED NOT NULL COMMENT 'Usuario que utilizó el artículo. Llave foránea a usuario.id_usuario.',
  id_inventario int(10) UNSIGNED NOT NULL COMMENT 'Artículo del inventario que se utilizó. Llave foránea a inventario.id_inventario.'
);

-- --------------------------------------------------------
-- Tabla: detalles_asiste
CREATE TABLE detalles_asiste (
  id_asiste int(10) UNSIGNED NOT NULL COMMENT 'Identificador único de la asistencia (clave primaria).',
  tipo_asistencia enum('Asiste','Inasiste','Llegada tarde') NOT NULL COMMENT 'Estado de asistencia del jugador para un entrenamiento específico.',
  justificacion varchar(255) DEFAULT NULL COMMENT 'Justificación en caso de inasistencia o llegada tarde. Opcional.',
  observaciones varchar(255) DEFAULT NULL COMMENT 'Comentarios adicionales sobre la asistencia. Opcional.',
  id_jugador int(10) UNSIGNED NOT NULL COMMENT 'Usuario que asistió (o no) al entrenamiento. Llave foránea a usuario.id_usuario.',
  registrado_por int(10) UNSIGNED NOT NULL COMMENT 'ID del entrenamiento en el que se registró esta asistencia. Llave foránea a entrenamiento.id_entrenamiento.'
);

-- JEFFERSON

[11:11 p.m., 24/6/2025] El Viejo Jeff 🤪: CREATE VIEW Vista_Asistencia_Con_Nombres AS
SELECT 
    DETALLES_ASISTE.id_asiste,
    USUARIO.nombre_completo AS nombre_jugador,
    DETALLES_ASISTE.tipo_asistencia,
    DETALLES_ASISTE.justificacion,
    DETALLES_ASISTE.observaciones,
    ENTRENAMIENTO.fecha AS fecha_entrenamiento,
    ENTRENAMIENTO.descripcion AS descripcion_entrenamiento,
    ENTRENAMIENTO.estado AS estado_entrenamiento
FROM DETALLES_ASISTE
JOIN USUARIO ON DETALLES_ASISTE.id_jugador = USUARIO.id_usuario
JOIN ENTRENAMIENTO ON DETALLES_ASISTE.registrado_por = ENTRENAMIENTO.id_entrenamiento
WHERE ENTRENAMIENTO.estado = 'activo'
ORDER BY USUARIO.nombre_completo ASC;
/------Entrenamiento------/
CREATE VIEW Vista_Entrenamientos_Con_Responsable AS
SELECT 
    ENTRENAMIENTO.id_entrenamiento,
    ENTRENAMIENTO.descripcion,
    ENTRENAMIENTO.fecha,
    ENTRENAMIENTO.hora_inicio,
    ENTRENAMIENTO.hora_fin,
    ENTRENAMIENTO.luegar,
    ENTRENAMIENTO.estado,
    ENTRENAMIENTO.observaciones,
    USUARIO.nombre_completo AS nombre_registrador
FROM ENTRENAMIENTO
JOIN USUARIO ON ENTRENAMIENTO.registrado_por = USUARIO.id_usuario
WHERE ENTRENAMIENTO.estado = 'activo'
ORDER BY ENTRENAMIENTO.fecha DESC;
/---Rendimiento----./
CREATE VIEW Vista_Rendimientos AS
SELECT 
    RENDIMIENTO.id_rendimiento,
    RENDIMIENTO.fecha_evaluacion,
    RENDIMIENTO.posicion,
    RENDIMIENTO.categoria_test,
    RENDIMIENTO.tipo_test,
    RENDIMIENTO.unidad,
    RENDIMIENTO.resultado,
    RENDIMIENTO.observaciones,
    USUARIO.nombre_completo AS nombre_jugador
FROM RENDIMIENTO
JOIN USUARIO ON RENDIMIENTO.id_jugador = USUARIO.id_usuario
WHERE RENDIMIENTO.estado = 'activo'
ORDER BY RENDIMIENTO.fecha_evaluacion DESC;

/---Matricula----./
CREATE VIEW Vista_Matriculas AS
SELECT 
    MATRICULA.id_matricula,
    MATRICULA.fecha_matricula,
    MATRICULA.fecha_inicio,
    MATRICULA.fecha_fin,
    MATRICULA.estado,
    MATRICULA.observaciones,
    USUARIO.nombre_completo AS nombre_jugador
FROM MATRICULA
JOIN USUARIO ON MATRICULA.id_jugador = USUARIO.id_usuario
WHERE MATRICULA.estado = 'activo'
ORDER BY MATRICULA.fecha_matricula DESC;
[11:11 p.m., 24/6/2025] El Viejo Jeff 🤪: use CODEGOL;
/Procedimiento/
/-------Detalle asiste-------/
/-----Registrar-----/
DELIMITER //

CREATE PROCEDURE RegistrarAsistencia(
    IN p_tipo_asistencia VARCHAR(20),
    IN p_justificacion VARCHAR(255),
    IN p_observaciones VARCHAR(255),
    IN p_id_jugador INT,
    IN p_registrado_por INT
)
BEGIN
    INSERT INTO DETALLES_ASISTE(
        tipo_asistencia, justificacion, observaciones, id_jugador, registrado_por
    )
    VALUES (
        p_tipo_asistencia, p_justificacion, p_observaciones, p_id_jugador, p_registrado_por
    );
END //

DELIMITER ;
/-------Consulta Especifica-----/

DELIMITER //

CREATE PROCEDURE ConsultarAsistenciaPorNombre(
    IN p_nombre_jugador VARCHAR(255)
)
BEGIN
    SELECT 
        DETALLES_ASISTE.id_asiste,
        USUARIO.nombre_completo AS nombre_jugador,
        DETALLES_ASISTE.tipo_asistencia,
        DETALLES_ASISTE.justificacion,
        DETALLES_ASISTE.observaciones,
        ENTRENAMIENTO.fecha AS fecha_entrenamiento,
        ENTRENAMIENTO.descripcion AS descripcion_entrenamiento,
        ENTRENAMIENTO.estado AS estado_entrenamiento
    FROM DETALLES_ASISTE
    JOIN USUARIO ON DETALLES_ASISTE.id_jugador = USUARIO.id_usuario
    JOIN ENTRENAMIENTO ON DETALLES_ASISTE.registrado_por = ENTRENAMIENTO.id_entrenamiento
    WHERE ENTRENAMIENTO.estado = 'activo'
      AND USUARIO.nombre_completo LIKE CONCAT('%', p_nombre_jugador, '%')
    ORDER BY USUARIO.nombre_completo ASC;
END //

DELIMITER ;



/-------Actualizar--------/
DELIMITER //

DELIMITER //

CREATE PROCEDURE ActualizarAsistencia(
	IN p_id_asiste INT,
    IN p_tipo_asistencia VARCHAR(20),
    IN p_justificacion VARCHAR(255),
    IN p_observaciones VARCHAR(255)
)
BEGIN
    UPDATE DETALLES_ASISTE
    SET
        tipo_asistencia = p_tipo_asistencia, 
        justificacion = p_justificacion, 
        observaciones = p_observaciones
    WHERE id_asiste = p_id_asiste;
END //

DELIMITER ;
/---Entrenamiento---/
/Registrar/
DELIMITER //

CREATE PROCEDURE RegistrarEntrenamiento(
    IN p_descripcion VARCHAR(255),
    IN p_fecha DATE,
    IN p_hora_inicio TIME,
    IN p_hora_fin TIME,
    IN p_lugar VARCHAR(255),
    IN p_observaciones VARCHAR(255),
    IN p_registrado_por INT
)
BEGIN
    INSERT INTO ENTRENAMIENTO(
        descripcion, fecha, hora_inicio, hora_fin, luegar, estado, observaciones, registrado_por
    )
    VALUES (
        p_descripcion, p_fecha, p_hora_inicio, p_hora_fin, p_lugar, 'activo', p_observaciones, p_registrado_por
    );
END //

DELIMITER ;
/Consulta Especifica/
DELIMITER //

CREATE PROCEDURE ConsultarEntrenamientosPorRegistrador(
    IN p_id_registrador INT
)
BEGIN
    SELECT 
        ENTRENAMIENTO.id_entrenamiento,
        ENTRENAMIENTO.descripcion,
        ENTRENAMIENTO.fecha,
        ENTRENAMIENTO.hora_inicio,
        ENTRENAMIENTO.hora_fin,
        ENTRENAMIENTO.luegar,
        ENTRENAMIENTO.estado,
        ENTRENAMIENTO.observaciones,
        USUARIO.nombre_completo AS nombre_registrador
    FROM ENTRENAMIENTO
    JOIN USUARIO ON ENTRENAMIENTO.registrado_por = USUARIO.id_usuario
    WHERE ENTRENAMIENTO.estado = 'activo'
      AND ENTRENAMIENTO.registrado_por = p_id_registrador
    ORDER BY ENTRENAMIENTO.fecha DESC;
END //

DELIMITER ;
/------------------------------------------/
DELIMITER //

CREATE PROCEDURE ConsultarEntrenamientosPorNombreRegistrador(
    IN p_nombre_registrador VARCHAR(255)
)
BEGIN
    SELECT 
        ENTRENAMIENTO.id_entrenamiento,
        ENTRENAMIENTO.descripcion,
        ENTRENAMIENTO.fecha,
        ENTRENAMIENTO.hora_inicio,
        ENTRENAMIENTO.hora_fin,
        ENTRENAMIENTO.luegar,
        ENTRENAMIENTO.estado,
        ENTRENAMIENTO.observaciones,
        USUARIO.nombre_completo AS nombre_registrador
    FROM ENTRENAMIENTO
    JOIN USUARIO ON ENTRENAMIENTO.registrado_por = USUARIO.id_usuario
    WHERE ENTRENAMIENTO.estado = 'activo'
      AND USUARIO.nombre_completo LIKE CONCAT('%', p_nombre_registrador, '%')
    ORDER BY ENTRENAMIENTO.fecha DESC;
END //

DELIMITER ;

/Actualizar/
DELIMITER //

CREATE PROCEDURE ActualizarEntrenamiento(
    IN p_id_entrenamiento INT,
    IN p_descripcion VARCHAR(255),
    IN p_fecha DATE,
    IN p_hora_inicio TIME,
    IN p_hora_fin TIME,
    IN p_lugar VARCHAR(255),
    IN p_observaciones VARCHAR(255)
)
BEGIN
    UPDATE ENTRENAMIENTO
    SET 
        descripcion = p_descripcion,
        fecha = p_fecha,
        hora_inicio = p_hora_inicio,
        hora_fin = p_hora_fin,
        luegar = p_lugar,
        observaciones = p_observaciones
    WHERE id_entrenamiento = p_id_entrenamiento;
END //

DELIMITER ;

/Elminar/
DELIMITER //

CREATE PROCEDURE EliminarEntrenamiento(
    IN p_id_entrenamiento INT
)
BEGIN
    UPDATE ENTRENAMIENTO
    SET estado = 'inactivo'
    WHERE id_entrenamiento = p_id_entrenamiento;
END //

DELIMITER ;

/---Rendimiento----./
/Registrar/
DELIMITER //

CREATE PROCEDURE RegistrarRendimiento(
    IN p_fecha_evaluacion DATE,
    IN p_posicion VARCHAR(255),
    IN p_categoria_test VARCHAR(255),
    IN p_tipo_test VARCHAR(255),
    IN p_unidad TINYINT UNSIGNED,
    IN p_resultado TINYINT UNSIGNED,
    IN p_observaciones VARCHAR(255),
    IN p_id_jugador INT,
    IN p_registrado_por INT
)
BEGIN
    INSERT INTO RENDIMIENTO (
        fecha_evaluacion, posicion, categoria_test, tipo_test,
        unidad, resultado, observaciones, id_jugador, registrado_por
    )
    VALUES (
        p_fecha_evaluacion, p_posicion, p_categoria_test, p_tipo_test,
        p_unidad, p_resultado, p_observaciones, p_id_jugador, p_registrado_por
    );
END //

DELIMITER ;

/Consulta Especifica/
DELIMITER //

CREATE PROCEDURE ConsultarRendimientosPorNombreJugador(
    IN p_nombre_jugador VARCHAR(255)
)
BEGIN
    SELECT 
        RENDIMIENTO.id_rendimiento,
        RENDIMIENTO.fecha_evaluacion,
        RENDIMIENTO.posicion,
        RENDIMIENTO.categoria_test,
        RENDIMIENTO.tipo_test,
        RENDIMIENTO.unidad,
        RENDIMIENTO.resultado,
        RENDIMIENTO.observaciones,
        USUARIO.nombre_completo AS nombre_jugador
    FROM RENDIMIENTO
    JOIN USUARIO ON RENDIMIENTO.id_jugador = USUARIO.id_usuario
    WHERE USUARIO.nombre_completo LIKE CONCAT('%', p_nombre_jugador, '%')
    ORDER BY RENDIMIENTO.fecha_evaluacion DESC;
END //

DELIMITER ;

/Actualizar/
DELIMITER //

CREATE PROCEDURE ActualizarRendimiento(
    IN p_id_rendimiento INT,
    IN p_fecha_evaluacion DATE,
    IN p_posicion VARCHAR(255),
    IN p_categoria_test VARCHAR(255),
    IN p_tipo_test VARCHAR(255),
    IN p_unidad TINYINT UNSIGNED,
    IN p_resultado TINYINT UNSIGNED,
    IN p_observaciones VARCHAR(255)
)
BEGIN
    UPDATE RENDIMIENTO
    SET
        fecha_evaluacion = p_fecha_evaluacion,
        posicion = p_posicion,
        categoria_test = p_categoria_test,
        tipo_test = p_tipo_test,
        unidad = p_unidad,
        resultado = p_resultado,
        observaciones = p_observaciones
    WHERE id_rendimiento = p_id_rendimiento;
END //

DELIMITER ;

/Elminar/
DELIMITER //

CREATE PROCEDURE EliminarRendimiento(
    IN p_id_rendimiento INT
)
BEGIN
    UPDATE RENDIMIENTO
    SET estado = 'inactivo'
    WHERE id_rendimiento = p_id_rendimiento;
END //

DELIMITER ;

/---Matricula----./
/Registrar/
DELIMITER //

CREATE PROCEDURE RegistrarMatricula(
    IN p_fecha_matricula DATE,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_observaciones VARCHAR(255),
    IN p_id_jugador INT,
    IN p_registrado_por INT
)
BEGIN
    INSERT INTO MATRICULA(
        fecha_matricula, fecha_inicio, fecha_fin,
        estado, observaciones, id_jugador, registrado_por
    )
    VALUES (
        p_fecha_matricula, p_fecha_inicio, p_fecha_fin,
        'activo', p_observaciones, p_id_jugador, p_registrado_por
    );
END //

DELIMITER ;

/Consulta Especifica/
DELIMITER //

CREATE PROCEDURE ConsultarMatriculasPorNombreJugador(
    IN p_nombre_jugador VARCHAR(255)
)
BEGIN
    SELECT 
        MATRICULA.id_matricula,
        MATRICULA.fecha_matricula,
        MATRICULA.fecha_inicio,
        MATRICULA.fecha_fin,
        MATRICULA.estado,
        MATRICULA.observaciones,
        USUARIO.nombre_completo AS nombre_jugador
    FROM MATRICULA
    JOIN USUARIO ON MATRICULA.id_jugador = USUARIO.id_usuario
    WHERE MATRICULA.estado = 'activo'
      AND USUARIO.nombre_completo LIKE CONCAT('%', p_nombre_jugador, '%')
    ORDER BY MATRICULA.fecha_matricula DESC;
END //

DELIMITER ;
/--------------------------------/
DELIMITER //

CREATE PROCEDURE ConsultarMiMatricula(
    IN p_id_jugador INT
)
BEGIN
    SELECT 
        MATRICULA.id_matricula,
        MATRICULA.fecha_matricula,
        MATRICULA.fecha_inicio,
        MATRICULA.fecha_fin,
        MATRICULA.estado,
        MATRICULA.observaciones,
        USUARIO.nombre_completo AS nombre_jugador
    FROM MATRICULA
    JOIN USUARIO ON MATRICULA.id_jugador = USUARIO.id_usuario
    WHERE MATRICULA.estado = 'activo'
      AND MATRICULA.id_jugador = p_id_jugador;
END //

DELIMITER ;
/----------------------------------------------------------------/
DELIMITER //

CREATE PROCEDURE ConsultarMatriculasDeMisJugadores(
    IN p_id_responsable INT
)
BEGIN
    SELECT 
        MATRICULA.id_matricula,
        MATRICULA.fecha_matricula,
        MATRICULA.fecha_inicio,
        MATRICULA.fecha_fin,
        MATRICULA.estado,
        MATRICULA.observaciones,
        USUARIO.nombre_completo AS nombre_jugador
    FROM MATRICULA
    JOIN USUARIO ON MATRICULA.id_jugador = USUARIO.id_usuario
    WHERE MATRICULA.estado = 'activo'
      AND USUARIO.id_responsable = p_id_responsable
    ORDER BY MATRICULA.fecha_matricula DESC;
END //

DELIMITER ;

/Actualizar/
DELIMITER //

CREATE PROCEDURE ActualizarMatricula(
    IN p_id_matricula INT,
    IN p_fecha_matricula DATE,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_observaciones VARCHAR(255)
)
BEGIN
    UPDATE MATRICULA
    SET 
        fecha_matricula = p_fecha_matricula,
        fecha_inicio = p_fecha_inicio,
        fecha_fin = p_fecha_fin,
        observaciones = p_observaciones
    WHERE id_matricula = p_id_matricula;
END //

DELIMITER ;

/Elminar/
DELIMITER //

CREATE PROCEDURE EliminarMatricula(
    IN p_id_matricula INT
)
BEGIN
    UPDATE MATRICULA
    SET estado = 'inactivo'
    WHERE id_matricula = p_id_matricula;
END //

DELIMITER ;


-- SELECTS - ALMANZA

-- Usuarios activos
SELECT * FROM usuario WHERE estado = 'activo';

-- Entrenadores con correo
SELECT u.nombre_completo, u.correo
FROM usuario u
JOIN detalles_usuario_rol dr ON u.id_usuario = dr.id_usuario
JOIN rol r ON dr.id_rol = r.id_rol
WHERE r.rol_usuario = 'Entrenador';

-- Artículos activos
SELECT * FROM inventario WHERE estado = 'activo';

-- Pagos del usuario 1
SELECT * FROM pago WHERE pagado_por = 1;

-- Total usado por fecha
SELECT fecha_uso, SUM(cantidad_usada) AS total_usado
FROM detalles_utiliza
GROUP BY fecha_uso;

-- Roles por usuario
SELECT u.nombre_completo, r.rol_usuario
FROM usuario u
JOIN detalles_usuario_rol d ON u.id_usuario = d.id_usuario
JOIN rol r ON d.id_rol = r.id_rol;

-- Usuarios sin segundo número
SELECT nombre_completo FROM usuario WHERE telefono_2 IS NULL;

-- Artículos con menos de 5 unidades
SELECT * FROM inventario WHERE cantidad_total < 5;

-- Cantidad de pagos por método
SELECT metodo_pago, COUNT(*) AS cantidad
FROM pago
GROUP BY metodo_pago;

-- Solo nombres
SELECT nombre_completo FROM usuario;

-- TRIGGERS

DELIMITER //

-- Evita correos repetidos al registrar
CREATE TRIGGER trg_escu_correo BEFORE INSERT ON usuario
FOR EACH ROW BEGIN
  IF EXISTS (SELECT 1 FROM usuario WHERE correo = NEW.correo) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Correo repetido';
  END IF;
END;
//

-- Si la cantidad queda en 0, lo marca como inactivo
CREATE TRIGGER trg_escu_inactivo AFTER UPDATE ON inventario
FOR EACH ROW BEGIN
  IF NEW.cantidad_total = 0 THEN
    UPDATE inventario SET estado = 'inactivo' WHERE id_inventario = NEW.id_inventario;
  END IF;
END;
//

-- No deja pagos mayores a 1 millón
CREATE TRIGGER trg_escu_pago_limite BEFORE INSERT ON pago
FOR EACH ROW BEGIN
  IF NEW.valor_total > 1000000 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pago muy alto';
  END IF;
END;
//

-- No se pueden borrar usuarios
CREATE TRIGGER trg_escu_no_delete BEFORE DELETE ON usuario
FOR EACH ROW BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar';
END;
//

-- No deja poner cantidad negativa
CREATE TRIGGER trg_escu_no_negativo BEFORE UPDATE ON inventario
FOR EACH ROW BEGIN
  IF NEW.cantidad_total < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Negativo';
  END IF;
END;
//

-- No deja registrar artículos repetidos
CREATE TRIGGER trg_escu_articulo_uniq BEFORE INSERT ON inventario
FOR EACH ROW BEGIN
  IF EXISTS (SELECT 1 FROM inventario WHERE nombre_articulo = NEW.nombre_articulo) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe';
  END IF;
END;
//

-- El nombre debe tener al menos 5 letras
CREATE TRIGGER trg_escu_nombre_user BEFORE INSERT ON usuario
FOR EACH ROW BEGIN
  IF LENGTH(NEW.nombre_completo) < 5 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nombre corto';
  END IF;
END;
//

-- Si se borra el último rol de un usuario, lo pone inactivo
CREATE TRIGGER trg_escu_sin_rol AFTER DELETE ON detalles_usuario_rol
FOR EACH ROW BEGIN
  DECLARE t INT;
  SELECT COUNT(*) INTO t FROM detalles_usuario_rol WHERE id_usuario = OLD.id_usuario;
  IF t = 0 THEN
    UPDATE usuario SET estado = 'inactivo' WHERE id_usuario = OLD.id_usuario;
  END IF;
END;
//

-- Evita usuarios con mismo número de ID
CREATE TRIGGER trg_escu_identificacion BEFORE INSERT ON usuario
FOR EACH ROW BEGIN
  IF EXISTS (SELECT 1 FROM usuario WHERE num_identificacion = NEW.num_identificacion) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID repetido';
  END IF;
END;
//

-- Bloquea roles duplicados por usuario
CREATE TRIGGER trg_escu_rol_unico BEFORE INSERT ON detalles_usuario_rol
FOR EACH ROW BEGIN
  IF EXISTS (
    SELECT 1 FROM detalles_usuario_rol
    WHERE id_usuario = NEW.id_usuario AND id_rol = NEW.id_rol
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rol duplicado';
  END IF;
END;
//

DELIMITER ;

-- PROCEDIMIENTOS

DELIMITER //

-- Muestra todos los usuarios
CREATE PROCEDURE sp_escu_usuarios()
BEGIN
  SELECT * FROM usuario;
END;
//

-- Muestra todos los roles
CREATE PROCEDURE sp_escu_roles()
BEGIN
  SELECT * FROM rol;
END;
//

-- Inserta un artículo
CREATE PROCEDURE sp_escu_insertar_articulo(IN nom VARCHAR(255), IN cant INT)
BEGIN
  INSERT INTO inventario(nombre_articulo, cantidad_total, fecha_ingreso, estado)
  VALUES(nom, cant, CURDATE(), 'activo');
END;
//

-- Inserta un pago
CREATE PROCEDURE sp_escu_insertar_pago(IN con VARCHAR(255), IN val INT)
BEGIN
  INSERT INTO pago(concepto_pago, fecha_pago, metodo_pago, valor_total, pagado_por, id_matricula)
  VALUES(con, CURDATE(), 'efectivo', val, 1, 1);
END;
//

-- Busca artículos por nombre
CREATE PROCEDURE sp_escu_buscar_articulo(IN nom VARCHAR(255))
BEGIN
  SELECT * FROM inventario WHERE nombre_articulo LIKE CONCAT('%', nom, '%');
END;
//

-- Asigna un rol
CREATE PROCEDURE sp_escu_asignar_rol(IN uid INT, IN rid INT)
BEGIN
  INSERT INTO detalles_usuario_rol(id_usuario, id_rol) VALUES(uid, rid);
END;
//

-- Muestra usos por usuario
CREATE PROCEDURE sp_escu_usos_usuario(IN id INT)
BEGIN
  SELECT * FROM detalles_utiliza WHERE id_entrenador = id;
END;
//

-- Muestra pagos por fecha
CREATE PROCEDURE sp_escu_pagos_fecha(IN f DATE)
BEGIN
  SELECT * FROM pago WHERE fecha_pago = f;
END;
//

-- Cambia estado del usuario
CREATE PROCEDURE sp_escu_estado_usuario(IN id INT, IN est VARCHAR(10))
BEGIN
  UPDATE usuario SET estado = est WHERE id_usuario = id;
END;
//

-- Muestra roles del usuario
CREATE PROCEDURE sp_escu_roles_usuario(IN uid INT)
BEGIN
  SELECT r.rol_usuario FROM detalles_usuario_rol d
  JOIN rol r ON d.id_rol = r.id_rol WHERE d.id_usuario = uid;
END;
//

DELIMITER ;
