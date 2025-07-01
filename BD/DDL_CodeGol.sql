-- SELECTS

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
