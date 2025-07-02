delimiter //

-- devuelve todos los usuarios
create procedure proc_usuarios()
begin
  select * from usuario;
end;
//

-- devuelve todos los roles
create procedure proc_roles()
begin
  select * from rol;
end;
//

-- inserta un artículo nuevo
create procedure proc_insertar_articulo(in nombre varchar(255), in cantidad int)
begin
  insert into inventario(nombre_articulo, cantidad_total, fecha_ingreso, estado)
  values(nombre, cantidad, curdate(), 'activo');
end;
//

-- inserta un pago
create procedure proc_insertar_pago(in concepto varchar(255), in valor int)
begin
  insert into pago(concepto_pago, fecha_pago, metodo_pago, valor_total, pagado_por, id_matricula)
  values(concepto, curdate(), 'efectivo', valor, 1, 1);
end;
//

-- busca artículos por nombre
create procedure proc_buscar_articulo(in nombre varchar(255))
begin
  select * from inventario where nombre_articulo like concat('%', nombre, '%');
end;
//

-- asigna un rol a un usuario
create procedure proc_asignar_rol(in id_usuario int, in id_rol int)
begin
  insert into usuario_rol(id_usuario, id_rol) values(id_usuario, id_rol);
end;
//

-- muestra los usos registrados por usuario
create procedure proc_usos_por_usuario(in id int)
begin
  select * from uso_detalle where id_entrenador = id;
end;
//

-- muestra pagos según una fecha
create procedure proc_pagos_por_fecha(in fecha date)
begin
  select * from pago where fecha_pago = fecha;
end;
//

-- cambia el estado de un usuario
create procedure proc_cambiar_estado(in id int, in nuevo_estado varchar(10))
begin
  update usuario set estado = nuevo_estado where id_usuario = id;
end;
//

-- muestra los roles que tiene un usuario
create procedure proc_roles_de_usuario(in id_usuario int)
begin
  select r.nombre_rol
  from usuario_rol ur
  join rol r on ur.id_rol = r.id_rol
  where ur.id_usuario = id_usuario;
end;
//

delimiter ;

use codegol;
/*Procedimiento*/
/*-------Detalle asiste-------*/
/*-----Registrar-----*/
delimiter //

create procedure registrar_asistencia(
    in p_tipo_asistencia varchar(20),
    in p_justificacion varchar(100),
    in p_observaciones varchar(100),
    in p_id_jugador tinyint,
    in p_id_entrenamiento tinyint
)
begin
    insert into detalles_asiste(
        tipo_asistencia, justificacion, observaciones, id_jugador, id_entrenamiento
    )
    values (
        p_tipo_asistencia, p_justificacion, p_observaciones, p_id_jugador, p_id_entrenamiento
    );
end //

delimiter ;


/*-------Actualizar--------*/

delimiter //

create procedure actualizar_asistencia(
	in p_id_asiste tinyint,
    in p_tipo_asistencia varchar(20),
    in p_justificacion varchar(100),
    in p_observaciones varchar(100)
)
begin
    update detalles_asiste
    set
        tipo_asistencia = p_tipo_asistencia, 
        justificacion = p_justificacion, 
        observaciones = p_observaciones
    where id_asiste = p_id_asiste;
end //

delimiter ;

/*---Entrenamiento---*/
/*Registrar*/
delimiter //

create procedure registrar_entrenamiento(
    in p_descripcion varchar(100),
    in p_fecha date,
    in p_hora_inicio time,
    in p_hora_fin time,
    in p_lugar varchar(50),
    in p_observaciones varchar(100),
    in p_registrado_por tinyint
)
begin
    insert into entrenamiento(
        descripcion, fecha, hora_inicio, hora_fin, lugar, estado, observaciones, registrado_por
    )
    values (
        p_descripcion, p_fecha, p_hora_inicio, p_hora_fin, p_lugar, 'activo', p_observaciones, p_registrado_por
    );
end //

delimiter ;



/*Actualizar*/
delimiter //

create procedure actualizar_entrenamiento(
    in p_id_entrenamiento tinyint,
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


/*Elminar*/
delimiter //

create procedure eliminar_entrenamiento(
    in p_id_entrenamiento tinyint
)
begin
    update entrenamiento
    set estado = 'inactivo'
    where id_entrenamiento = p_id_entrenamiento;
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
