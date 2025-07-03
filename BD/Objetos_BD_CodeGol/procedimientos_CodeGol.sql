delimiter //

-- =========================
-- ===== TABLA: USUARIO ===
-- =========================
create procedure registrar_usuario(
  in correo varchar(60),
  in nombre_completo varchar(60),
  in num_identificacion int unsigned,
  in tipo_documento enum('cc','ti','ce','pa','rc','pep','nit','nuip','dni','ppt'),
  in telefono_1 bigint unsigned,
  in telefono_2 bigint unsigned,
  in direccion varchar(50),
  in genero enum('m','f','otro'),
  in fecha_nacimiento date,
  in lugar_nacimiento varchar(50),
  in grupo_sanguineo enum('a+','a-','b+','b-','ab+','ab-','o+','o-'),
  in foto_perfil blob,
  in registrado_por tinyint unsigned,
  in id_responsable tinyint unsigned
)
begin
declare contrasena varchar(60);
  insert into usuario (
    correo, contrasena, nombre_completo, num_identificacion, tipo_documento,
    telefono_1, telefono_2, direccion, genero, fecha_nacimiento, lugar_nacimiento,
    grupo_sanguineo, foto_perfil, registrado_por, id_responsable
  ) values (
    correo, contrasena, nombre_completo, num_identificacion, tipo_documento,
    telefono_1, telefono_2, direccion, genero, fecha_nacimiento, lugar_nacimiento,
    grupo_sanguineo, foto_perfil, registrado_por, id_responsable
  );
end //


create procedure proc_cambiar_estado(
  in id tinyint,
  in nuevo_estado enum('activo','inactivo')
)
begin
  update usuario
  set estado = nuevo_estado
  where id_usuario = id;
end //

delimiter //

create procedure actualizar_usuario(
  in id_usuario_in tinyint unsigned,
  in correo varchar(60),
  in nombre_completo varchar(60),
  in num_identificacion int unsigned,
  in tipo_documento enum('cc','ti','ce','pa','rc','pep','nit','nuip','dni','ppt'),
  in telefono_1 bigint unsigned,
  in telefono_2 bigint unsigned,
  in direccion varchar(50),
  in genero enum('m','f','otro'),
  in fecha_nacimiento date,
  in lugar_nacimiento varchar(50),
  in grupo_sanguineo enum('a+','a-','b+','b-','ab+','ab-','o+','o-'),
  in foto_perfil blob,
  in registrado_por tinyint unsigned,
  in id_responsable tinyint unsigned
)
begin
  update usuario
  set
    correo = correo,
    nombre_completo = nombre_completo,
    num_identificacion = num_identificacion,
    tipo_documento = tipo_documento,
    telefono_1 = telefono_1,
    telefono_2 = telefono_2,
    direccion = direccion,
    genero = genero,
    fecha_nacimiento = fecha_nacimiento,
    lugar_nacimiento = lugar_nacimiento,
    grupo_sanguineo = grupo_sanguineo,
    foto_perfil = foto_perfil,
    registrado_por = registrado_por,
    id_responsable = id_responsable
  where id_usuario = id_usuario_in;
end //


create procedure proc_cambiar_contrasena(
  in id tinyint,
  in nueva_contrasena varchar(60)
)
begin
  update usuario
  set contrasena = nueva_contrasena
  where id_usuario = id;
end //


-- =========================
-- ===== TABLA: ROL =======
-- =========================
create procedure proc_registrar_rol (
  in rol_usuario enum("Administrador","Entrenador","Responsable","Jugador")
)
begin
  insert into rol (rol_usuario) values 
		('Administrador'),
		('Entrenador'),
		('Responsable'),
		('Jugador');
end //

create procedure proc_asignar_rol(
  in id_usuario int,
  in id_rol int
)
begin
  insert into detalles_usuario_rol (id_usuario, id_rol)
  values (id_usuario, id_rol);
end //

-- =============================
-- ===== TABLA: INVENTARIO ====
-- =============================
create procedure proc_insertar_articulo(
  in nombre varchar(50),
  in cantidad tinyint,
  in descripcion varchar(100)
)
begin
  insert into inventario (
    nombre_articulo, cantidad_total, descripcion, fecha_ingreso
  ) values (
    nombre, cantidad, descripcion, curdate()
  );
end //

create procedure proc_usar_articulo(
  in cantidad tinyint,
  in hora_inicio time,
  in hora_fin time,
  in observaciones varchar(100),
  in id_entrenador tinyint unsigned,
  in id_inventario tinyint unsigned
)
begin
  insert into detalles_utiliza (
    cantidad_usada, hora_inicio, hora_fin, observaciones,
    id_entrenador, id_inventario
  ) values (
    cantidad, hora_inicio, hora_fin, observaciones,
    id_entrenador, id_inventario
  );

  update inventario
  set cantidad_total = cantidad_total - cantidad
  where id_inventario = id_inventario;
end //

-- =============================
-- ===== TABLA: ENTRENAMIENTO ====
-- =============================
-- Registrar entrenamiento
create procedure registrar_entrenamiento(
  in descripcion varchar(100),
  in fecha date,
  in hora_inicio time,
  in hora_fin time,
  in lugar varchar(50),
  in observaciones varchar(100),
  in registrado_por tinyint
)
begin
  insert into entrenamiento(
    descripcion, fecha, hora_inicio, hora_fin, lugar, estado, observaciones, registrado_por
  )
  values (
    descripcion, fecha, hora_inicio, hora_fin, lugar, 'activo', observaciones, registrado_por
  );
end //

-- Actualizar entrenamiento
create procedure actualizar_entrenamiento(
  in id_entrenamiento tinyint,
  in descripcion varchar(100),
  in fecha date,
  in hora_inicio time,
  in hora_fin time,
  in lugar varchar(50),
  in observaciones varchar(100)
)
begin
  if exists (
    select 1 from entrenamiento where id_entrenamiento = id_entrenamiento
  ) then
    update entrenamiento
    set 
      descripcion = descripcion,
      fecha = fecha,
      hora_inicio = hora_inicio,
      hora_fin = hora_fin,
      lugar = lugar,
      observaciones = observaciones
    where id_entrenamiento = id_entrenamiento;
  end if;
end //

-- Eliminar entrenamiento (cambio de estado)
create procedure eliminar_entrenamiento(
  in id_entrenamiento tinyint
)
begin
  update entrenamiento
  set estado = 'inactivo'
  where id_entrenamiento = id_entrenamiento;
end //


-- =========================
-- ===== TABLA: MATRICULA ===
-- =========================
create procedure proc_registrar_matricula(
  in fecha_inicio date,
  in fecha_fin date,
  in observaciones varchar(100),
  in id_jugador tinyint unsigned,
  in registrado_por tinyint unsigned
)
begin
  insert into matricula (
    fecha_inicio, fecha_fin, estado, observaciones,
    id_jugador, registrado_por
  ) values (
    fecha_inicio, fecha_fin, 'activo', observaciones,
    id_jugador, registrado_por
  );
end //

-- =========================
-- ===== TABLA: PAGO =======
-- =========================
create procedure proc_insertar_pago(
  in concepto varchar(100),
  in metodo enum('efectivo','transferencia'),
  in valor bigint,
  in observaciones varchar(100),
  in pagado_por tinyint unsigned,
  in id_matricula tinyint unsigned
)
begin
  insert into pago (
    concepto_pago, fecha_pago, metodo_pago, valor_total,
    observaciones, pagado_por, id_matricula
  ) values (
    concepto, curdate(), metodo, valor,
    observaciones, pagado_por, id_matricula
  );
end //

-- ===============================
-- ===== TABLA: RENDIMIENTO =====
-- ===============================
create procedure proc_registrar_rendimiento(
  in posicion varchar(60),
  in unidad_medida varchar(20),
  in velocidad tinyint,
  in potencia_tiro tinyint,
  in defensa tinyint,
  in regate tinyint,
  in pase tinyint,
  in tecnica tinyint,
  in observaciones varchar(60),
  in estado enum('activo','inactivo'),
  in id_jugador tinyint unsigned,
  in registrado_por tinyint unsigned
)
begin
  insert into rendimiento (
    posicion, unidad_medida, velocidad, potencia_tiro, defensa,
    regate, pase, tecnica, observaciones, estado, id_jugador, registrado_por
  ) values (
    posicion, unidad_medida, velocidad, potencia_tiro, defensa,
    regate, pase, tecnica, observaciones, estado, id_jugador, registrado_por
  );
end //

-- ================================
-- ===== TABLA: DETALLES_ASISTE ===
-- ================================
create procedure registrar_asistencia(
  in tipo_asistencia varchar(20),
  in justificacion varchar(100),
  in observaciones varchar(100),
  in id_jugador tinyint,
  in id_entrenamiento tinyint
)
begin
  insert into detalles_asiste(
    tipo_asistencia, justificacion, observaciones, id_jugador, id_entrenamiento
  )
  values (
    tipo_asistencia, justificacion, observaciones, id_jugador, id_entrenamiento
  );
end //

create procedure actualizar_asistencia(
  in id_asiste_in tinyint,
  in tipo_asistencia_in varchar(20),
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


/*---Rendimiento----.*/
/*Registrar*/
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
    in p_id_jugador tinyint,
    in p_registrado_por tinyint
)
begin
    insert into rendimiento (
        fecha_evaluacion, posicion, unidad_medida,
        velocidad, potencia_tiro, defensa, regate, pase, tecnica,
        observaciones, estado, id_jugador, registrado_por
    )
    values (
        p_fecha_evaluacion, p_posicion, p_unidad_medida,
        p_velocidad, p_potencia_tiro, p_defensa, p_regate, p_pase, p_tecnica,
        p_observaciones, 'activo', p_id_jugador, p_registrado_por
    );
end //

delimiter ;




/*Actualizar*/
delimiter //

create procedure actualizar_rendimiento(
    in p_id_rendimiento tinyint,
    in p_fecha_evaluacion date,
    in p_posicion varchar(60),
    in p_unidad_medida varchar(20),
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


/*Elminar*/
delimiter //

create procedure eliminar_rendimiento(
    in p_id_rendimiento tinyint
)
begin
    update rendimiento
    set estado = 'inactivo'
    where id_rendimiento = p_id_rendimiento;
end //

delimiter ;


/*---Matricula----.*/
/*Registrar*/
delimiter //

create procedure registrar_matricula(
    in p_fecha_matricula date,
    in p_fecha_inicio date,
    in p_fecha_fin date,
    in p_observaciones varchar(100),
    in p_id_jugador tinyint,
    in p_registrado_por tinyint
)
begin
    insert into matricula (
        fecha_matricula, fecha_inicio, fecha_fin,
        estado, observaciones, id_jugador, registrado_por
    )
    values (
        p_fecha_matricula, p_fecha_inicio, p_fecha_fin,
        'activo', p_observaciones, p_id_jugador, p_registrado_por
    );
end //

delimiter ;




/*Actualizar*/
delimiter //

create procedure actualizar_matricula(
    in p_id_matricula tinyint,
    in p_fecha_matricula date,
    in p_fecha_inicio date,
    in p_fecha_fin date,
    in p_observaciones varchar(100)
)
begin
    update matricula
    set 
        fecha_matricula = p_fecha_matricula,
        fecha_inicio = p_fecha_inicio,
        fecha_fin = p_fecha_fin,
        observaciones = p_observaciones
    where id_matricula = p_id_matricula;
end //

delimiter ;


/*Elminar*/
delimiter //

create procedure eliminar_matricula(
    in p_id_matricula tinyint
)
begin
    update matricula
    set estado = 'inactivo'
    where id_matricula = p_id_matricula;
end //

delimiter ;

