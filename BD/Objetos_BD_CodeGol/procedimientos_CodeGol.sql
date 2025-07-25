-- =========================
-- ===== TABLA: USUARIO ===
-- =========================
delimiter //

create procedure loginusuario(
    in p_num_identificacion int unsigned,
    in p_contrasena varchar(60)
)
begin
    select 
        u.id_usuario,
        r.rol_usuario,
        u.estado
    from 
        usuario u
    inner join 
        detalles_usuario_rol dur on u.id_usuario = dur.id_usuario
    inner join 
        rol r on dur.id_rol = r.id_rol
    where 
        u.num_identificacion = p_num_identificacion
        and u.contrasena = p_contrasena;
end //

delimiter ;

delimiter //

create procedure registrar_usuario(
  in p_correo varchar(60),
  in p_nombre_completo varchar(60),
  in p_num_identificacion int unsigned,
  in p_tipo_documento enum('cc','ti','ce','pa','rc','pep','nit','nuip','dni','ppt'),
  in p_telefono_1 bigint unsigned,
  in p_telefono_2 bigint unsigned,
  in p_direccion varchar(50),
  in p_genero enum('m','f','otro'),
  in p_fecha_nacimiento date,
  in p_lugar_nacimiento varchar(50),
  in p_grupo_sanguineo enum('a+','a-','b+','b-','ab+','ab-','o+','o-'),
  in p_foto_perfil blob,
  in p_id_usuario_registro tinyint unsigned,
  in p_id_responsable tinyint unsigned
)
begin
  declare clave_generada varchar(60);

  set clave_generada = substring(md5(rand()), 1, 10);

  insert into usuario (
    correo, contrasena, nombre_completo, num_identificacion, tipo_documento,
    telefono_1, telefono_2, direccion, genero, fecha_nacimiento, lugar_nacimiento,
    grupo_sanguineo, foto_perfil, id_usuario_registro, id_responsable
  ) values (
    p_correo, clave_generada, p_nombre_completo, p_num_identificacion, p_tipo_documento,
    p_telefono_1, p_telefono_2, p_direccion, p_genero, p_fecha_nacimiento, p_lugar_nacimiento,
    p_grupo_sanguineo, p_foto_perfil, p_id_usuario_registro, p_id_responsable
  );
end //

delimiter ;


delimiter //

create procedure actualizar_usuario(
  in p_id_usuario tinyint unsigned,
  in p_correo varchar(60),
  in p_nombre_completo varchar(60),
  in p_num_identificacion int unsigned,
  in p_tipo_documento enum('cc','ti','ce','pa','rc','pep','nit','nuip','dni','ppt'),
  in p_telefono_1 bigint unsigned,
  in p_telefono_2 bigint unsigned,
  in p_direccion varchar(50),
  in p_genero enum('m','f','otro'),
  in p_fecha_nacimiento date,
  in p_lugar_nacimiento varchar(50),
  in p_grupo_sanguineo enum('a+','a-','b+','b-','ab+','ab-','o+','o-'),
  in p_foto_perfil blob,
  in p_id_usuario_registro tinyint unsigned,
  in p_id_responsable tinyint unsigned
)
begin
  update usuario
  set
    correo = p_correo,
    nombre_completo = p_nombre_completo,
    num_identificacion = p_num_identificacion,
    tipo_documento = p_tipo_documento,
    telefono_1 = p_telefono_1,
    telefono_2 = p_telefono_2,
    direccion = p_direccion,
    genero = p_genero,
    fecha_nacimiento = p_fecha_nacimiento,
    lugar_nacimiento = p_lugar_nacimiento,
    grupo_sanguineo = p_grupo_sanguineo,
    foto_perfil = p_foto_perfil,
    id_usuario_registro = p_id_usuario_registro,
    id_responsable = p_id_responsable
  where id_usuario = p_id_usuario;
end //

delimiter ;


delimiter //

create procedure proc_cambiar_contrasena(
  in p_id tinyint unsigned,
  in p_nueva_contrasena varchar(60)
)
begin
  update usuario
  set contrasena = p_nueva_contrasena
  where id_usuario = p_id;
end //

delimiter ;

delimiter //

create procedure proc_cambiar_estado(
  in p_id tinyint unsigned,
  in p_nuevo_estado boolean
)
begin
  update usuario
  set estado = p_nuevo_estado
  where id_usuario = p_id;
end //

delimiter ;

-- =========================
-- ===== TABLA: ROL =======
-- =========================
delimiter //

create procedure proc_insertar_roles()
begin
  insert ignore into rol (rol_usuario) values 
    ("Administrador"),
    ("Entrenador"),
    ("Responsable"),
    ("Jugador");
end //

delimiter ;

delimiter //

create procedure proc_asignar_rol(
  in p_id_usuario tinyint unsigned,
  in p_id_rol tinyint unsigned
)
begin
  insert into detalles_usuario_rol (id_usuario, id_rol)
  values (p_id_usuario, p_id_rol);
end //

delimiter ;


-- =============================
-- ===== TABLA: INVENTARIO ====
-- =============================
delimiter //

create procedure proc_insertar_articulo(
  in p_nombre varchar(50),
  in p_cantidad tinyint unsigned,
  in p_descripcion varchar(100),
  in p_id_usuario tinyint unsigned
)
begin
  insert into inventario (
    nombre_articulo, cantidad_total, descripcion, fecha_ingreso, id_usuario
  ) values (
    p_nombre, p_cantidad, p_descripcion, curdate(), p_id_usuario
  );
end //

delimiter ;

delimiter //

create procedure proc_eliminar_articulo(
  in p_id_inventario tinyint unsigned
)
begin
  update inventario
  set estado = false
  where id_inventario = p_id_inventario;
end //

delimiter ;

delimiter //

create procedure proc_usar_articulo(
  in p_cantidad tinyint unsigned,
  in p_observaciones varchar(100),
  in p_id_entrenamiento tinyint unsigned,
  in p_id_inventario tinyint unsigned
)
begin
  -- Insertar en detalles_utiliza
  insert into detalles_utiliza (
    cantidad_usada, observaciones, id_entrenamiento, id_inventario
  ) values (
    p_cantidad, p_observaciones, p_id_entrenamiento, p_id_inventario
  );

  -- Actualizar la cantidad del inventario
  update inventario
  set cantidad_total = cantidad_total - p_cantidad
  where id_inventario = p_id_inventario;
end //

delimiter ;
delimiter //

create procedure proc_devolver_cantidad_inventario(
  in p_id_inventario tinyint unsigned,
  in p_cantidad_a_sumar tinyint unsigned
)
begin
  update inventario
  set cantidad_total = cantidad_total + p_cantidad_a_sumar
  where id_inventario = p_id_inventario;
end //

delimiter ;


-- =============================
-- ===== TABLA: ENTRENAMIENTO ====
-- =============================
delimiter //

create procedure registrar_entrenamiento(
  in p_descripcion varchar(100),
  in p_fecha date,
  in p_hora_inicio time,
  in p_hora_fin time,
  in p_lugar varchar(50),
  in p_observaciones varchar(100),
  in p_id_usuario tinyint unsigned
)
begin
  insert into entrenamiento(
    descripcion, fecha, hora_inicio, hora_fin, lugar, observaciones, id_usuario
  )
  values (
    p_descripcion, p_fecha, p_hora_inicio, p_hora_fin, p_lugar, p_observaciones, p_id_usuario
  );
end //

delimiter ;


delimiter //

create procedure actualizar_entrenamiento(
  in p_id_entrenamiento tinyint unsigned,
  in p_descripcion varchar(100),
  in p_fecha date,
  in p_hora_inicio time,
  in p_hora_fin time,
  in p_lugar varchar(50),
  in p_observaciones varchar(100)
)
begin
  if exists (
    select 1 from entrenamiento where id_entrenamiento = p_id_entrenamiento
  ) then
    update entrenamiento
    set 
      descripcion = p_descripcion,
      fecha = p_fecha,
      hora_inicio = p_hora_inicio,
      hora_fin = p_hora_fin,
      lugar = p_lugar,
      observaciones = p_observaciones
    where id_entrenamiento = p_id_entrenamiento;
  end if;
end //

delimiter ;

delimiter //

create procedure eliminar_entrenamiento(
  in p_id_entrenamiento tinyint unsigned
)
begin
  update entrenamiento
  set estado = false
  where id_entrenamiento = p_id_entrenamiento;
end //

delimiter ;


-- =========================
-- ===== TABLA: MATRICULA ===
-- =========================
delimiter //

create procedure registrar_matricula(
  in p_fecha_inicio date,
  in p_fecha_fin date,
  in p_observaciones varchar(100),
  in p_id_jugador tinyint unsigned,
  in p_id_usuario tinyint unsigned
)
begin
  insert into matricula (
	fecha_inicio, fecha_fin,
    observaciones, id_jugador, id_usuario
  )
  values (
	p_fecha_inicio, p_fecha_fin,
    p_observaciones, p_id_jugador, p_id_usuario
  );
end //

delimiter ;


delimiter //

create procedure actualizar_matricula(
  in p_id_matricula tinyint unsigned,
  in p_fecha_inicio date,
  in p_fecha_fin date,
  in p_observaciones varchar(100)
)
begin
  update matricula
  set 
    fecha_inicio = p_fecha_inicio,
    fecha_fin = p_fecha_fin,
    observaciones = p_observaciones
  where id_matricula = p_id_matricula;
end //

delimiter ;


delimiter //

create procedure eliminar_matricula(
  in p_id_matricula tinyint unsigned
)
begin
  update matricula
  set estado = false
  where id_matricula = p_id_matricula;
end //

delimiter ;


-- =========================
-- ===== TABLA: PAGO =======
-- =========================
delimiter //

create procedure proc_insertar_pago(
  in p_concepto varchar(100),
  in p_metodo enum('efectivo','transferencia'),
  in p_valor bigint unsigned,
  in p_observaciones varchar(100),
  in p_id_usuario tinyint unsigned,
  in p_id_responsable tinyint unsigned,
  in p_id_matricula tinyint unsigned
)
begin
  declare v_estado boolean;

  if p_metodo = 'efectivo' then
    set v_estado = true;
  else
    set v_estado = false;
  end if;

  insert into pago (
    concepto_pago, fecha_pago, metodo_pago, valor_total,
    observaciones, estado, id_usuario, id_responsable, id_matricula
  )
  values (
    p_concepto, curdate(), p_metodo, p_valor,
    p_observaciones, v_estado, p_id_usuario, p_id_responsable, p_id_matricula
  );
end //

delimiter ;

/*delimiter //

create procedure proc_actualizar_pago(
  in p_id_pago tinyint unsigned,
  in p_concepto varchar(100),
  in p_metodo enum('efectivo','transferencia'),
  in p_valor bigint unsigned,
  in p_observaciones varchar(100)
)
begin
  declare v_estado boolean;

  if p_metodo = 'efectivo' then
    set v_estado = true;
  else
    set v_estado = false;
  end if;

  update pago
  set 
    concepto_pago = p_concepto,
    metodo_pago = p_metodo,
    valor_total = p_valor,
    observaciones = p_observaciones,
    estado = v_estado
  where id_pago = p_id_pago;
end //

delimiter ;*/
delimiter //

create procedure proc_actualizar_pago(
  in p_id_pago tinyint unsigned,
  in p_concepto varchar(100),
  in p_metodo enum('efectivo','transferencia'),
  in p_valor bigint unsigned,
  in p_observaciones varchar(100)
)
begin
  declare v_estado boolean;

  if p_metodo = 'efectivo' then
    set v_estado = true;

    update pago
    set 
      concepto_pago = p_concepto,
      metodo_pago = p_metodo,
      valor_total = p_valor,
      observaciones = p_observaciones,
      estado = v_estado,
      fecha_pago = current_date
    where id_pago = p_id_pago;

  else
    set v_estado = false;

    update pago
    set 
      concepto_pago = p_concepto,
      metodo_pago = p_metodo,
      valor_total = p_valor,
      observaciones = p_observaciones,
      estado = v_estado
    where id_pago = p_id_pago;

  end if;
end //

delimiter ;

delimiter //

create procedure proc_transferencia(
  in p_id_pago tinyint unsigned
)
begin
  update pago
  set 
    metodo_pago = 'transferencia',
    estado = true
  where id_pago = p_id_pago;
end //

delimiter ;


-- ===============================
-- ===== TABLA: RENDIMIENTO =====
-- ===============================
delimiter //

create procedure registrar_rendimiento(
  in p_fecha_evaluacion date,
  in p_posicion varchar(60),
  in p_unidad_medida varchar(20),
  in p_velocidad tinyint,
  in p_potencia_tiro tinyint,
  in p_defensa tinyint,
  in p_regate tinyint,
  in p_pase tinyint,
  in p_tecnica tinyint,
  in p_observaciones varchar(60),
  in p_id_matricula tinyint unsigned,
  in p_id_entrenamiento tinyint unsigned,
  in p_id_usuario tinyint unsigned
)
begin
  insert into rendimiento (
    fecha_evaluacion, posicion, unidad_medida,
    velocidad, potencia_tiro, defensa, regate, pase, tecnica,
    observaciones, id_matricula, id_entrenamiento, id_usuario
  )
  values (
    p_fecha_evaluacion, p_posicion, p_unidad_medida,
    p_velocidad, p_potencia_tiro, p_defensa, p_regate, p_pase, p_tecnica,
    p_observaciones, p_id_matricula, p_id_entrenamiento, p_id_usuario
  );
end //

delimiter ;


delimiter //

create procedure actualizar_rendimiento(
  in p_id_rendimiento tinyint,
  in p_fecha_evaluacion date,
  in p_posicion varchar(60),
  in p_velocidad tinyint,
  in p_potencia_tiro tinyint,
  in p_defensa tinyint,
  in p_regate tinyint,
  in p_pase tinyint,
  in p_tecnica tinyint,
  in p_observaciones varchar(60)
)
begin
  update rendimiento
  set
    fecha_evaluacion = p_fecha_evaluacion,
    posicion = p_posicion,
    unidad_medida = p_unidad_medida,
    velocidad = p_velocidad,
    potencia_tiro = p_potencia_tiro,
    defensa = p_defensa,
    regate = p_regate,
    pase = p_pase,
    tecnica = p_tecnica,
    observaciones = p_observaciones
  where id_rendimiento = p_id_rendimiento;
end //

delimiter ;


delimiter //

create procedure eliminar_rendimiento(
  in p_id_rendimiento tinyint
)
begin
  update rendimiento
  set estado = false
  where id_rendimiento = p_id_rendimiento;
end //

delimiter ;


-- ================================
-- ===== TABLA: DETALLES_ASISTE ===
-- ================================
delimiter //

create procedure registrar_asistencia(
  in p_tipo_asistencia enum('asiste','inasiste','llegada tarde'),
  in p_justificacion varchar(100),
  in p_observaciones varchar(100),
  in p_id_matricula tinyint unsigned,
  in p_id_entrenamiento tinyint unsigned
)
begin
  insert into detalles_asiste (
    tipo_asistencia, justificacion, observaciones, id_matricula, id_entrenamiento
  )
  values (
    p_tipo_asistencia, p_justificacion, p_observaciones, p_id_matricula, p_id_entrenamiento
  );
end //

delimiter ;


delimiter //

create procedure actualizar_asistencia(
  in id_asiste_in tinyint,
  in tipo_asistencia_in enum('asiste','inasiste','llegada tarde'),
  in justificacion_in varchar(100),
  in observaciones_in varchar(100)
)
begin
  update detalles_asiste
  set
    tipo_asistencia = tipo_asistencia_in, 
    justificacion = justificacion_in, 
    observaciones = observaciones_in
  where id_asiste = id_asiste_in;
end //

delimiter ;
