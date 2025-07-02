-- usuarios activos
select * from usuario where estado = 'activo';

-- entrenadores con correo
select u.nombre_completo, u.correo
from usuario u
join usuario_rol ur on u.id_usuario = ur.id_usuario
join rol r on ur.id_rol = r.id_rol
where r.nombre_rol = 'entrenador';

-- artículos activos
select * from inventario where estado = 'activo';

-- pagos realizados por el usuario 1
select * from pago where pagado_por = 1;

-- total usado por fecha
select fecha_uso, sum(cantidad_usada) as total_usado
from uso_detalle
group by fecha_uso;

-- roles asignados por usuario
select u.nombre_completo, r.nombre_rol
from usuario u
join usuario_rol ur on u.id_usuario = ur.id_usuario
join rol r on ur.id_rol = r.id_rol;

-- usuarios sin teléfono 2
select nombre_completo from usuario where telefono_2 is null;

-- artículos con menos de 5 unidades
select * from inventario where cantidad_total < 5;

-- cantidad de pagos por método
select metodo_pago, count(*) as cantidad
from pago
group by metodo_pago;

-- solo los nombres de los usuarios
select nombre_completo from usuario;

use codegol;
/*Vistas*/
create view vista_asistencia_con_nombres as
select 
    detalles_asiste.id_asiste,
    usuario.nombre_completo as nombre_jugador,
    detalles_asiste.tipo_asistencia,
    detalles_asiste.justificacion,
    detalles_asiste.observaciones,
    entrenamiento.fecha as fecha_entrenamiento,
    entrenamiento.descripcion as descripcion_entrenamiento,
    entrenamiento.estado as estado_entrenamiento
from detalles_asiste
join usuario on detalles_asiste.id_jugador = usuario.id_usuario
join entrenamiento on detalles_asiste.id_entrenamiento = entrenamiento.id_entrenamiento
where entrenamiento.estado = 'activo'
order by usuario.nombre_completo asc;

/*-------Consulta Especifica-----*/

delimiter //

create procedure consultar_asistencia_por_nombre(
    in p_nombre_jugador varchar(100)
)
begin
    select 
        detalles_asiste.id_asiste,
        usuario.nombre_completo as nombre_jugador,
        detalles_asiste.tipo_asistencia,
        detalles_asiste.justificacion,
        detalles_asiste.observaciones,
        entrenamiento.fecha as fecha_entrenamiento,
        entrenamiento.descripcion as descripcion_entrenamiento,
        entrenamiento.estado as estado_entrenamiento
    from detalles_asiste
    join usuario on detalles_asiste.id_jugador = usuario.id_usuario
    join entrenamiento on detalles_asiste.id_entrenamiento = entrenamiento.id_entrenamiento
    where entrenamiento.estado = 'activo'
      and usuario.nombre_completo like concat('%', p_nombre_jugador, '%')
    order by usuario.nombre_completo asc;
end //

delimiter ;

/*------Entrenamiento------*/
create view vista_entrenamientos_con_responsable as
select 
    entrenamiento.id_entrenamiento,
    entrenamiento.descripcion,
    entrenamiento.fecha,
    entrenamiento.hora_inicio,
    entrenamiento.hora_fin,
    entrenamiento.lugar,
    entrenamiento.estado,
    entrenamiento.observaciones,
    usuario.nombre_completo as nombre_registrador
from entrenamiento
join usuario on entrenamiento.registrado_por = usuario.id_usuario
where entrenamiento.estado = 'activo'
order by entrenamiento.fecha desc;

/*Consulta Especifica*/
delimiter //

create procedure consultar_entrenamientos_por_registrador(
    in p_id_registrador tinyint
)
begin
    select 
        entrenamiento.id_entrenamiento,
        entrenamiento.descripcion,
        entrenamiento.fecha,
        entrenamiento.hora_inicio,
        entrenamiento.hora_fin,
        entrenamiento.lugar,
        entrenamiento.estado,
        entrenamiento.observaciones,
        usuario.nombre_completo as nombre_registrador
    from entrenamiento
    join usuario on entrenamiento.registrado_por = usuario.id_usuario
    where entrenamiento.estado = 'activo'
      and entrenamiento.registrado_por = p_id_registrador
    order by entrenamiento.fecha desc;
end //

delimiter ;

/*------------------------------------------*/
delimiter //

create procedure consultar_entrenamientos_por_nombre_registrador(
    in p_nombre_registrador varchar(100)
)
begin
    select 
        entrenamiento.id_entrenamiento,
        entrenamiento.descripcion,
        entrenamiento.fecha,
        entrenamiento.hora_inicio,
        entrenamiento.hora_fin,
        entrenamiento.lugar,
        entrenamiento.estado,
        entrenamiento.observaciones,
        usuario.nombre_completo as nombre_registrador
    from entrenamiento
    join usuario on entrenamiento.registrado_por = usuario.id_usuario
    where entrenamiento.estado = 'activo'
      and usuario.nombre_completo like concat('%', p_nombre_registrador, '%')
    order by entrenamiento.fecha desc;
end //

delimiter ;

/*---Rendimiento----.*/
create view vista_rendimientos as
select 
    rendimiento.id_rendimiento,
    rendimiento.fecha_evaluacion,
    rendimiento.posicion,
    rendimiento.unidad_medida,
    rendimiento.velocidad,
    rendimiento.potencia_tiro,
    rendimiento.defensa,
    rendimiento.regate,
    rendimiento.pase,
    rendimiento.tecnica,
    rendimiento.promedio,
    rendimiento.observaciones,
    usuario.nombre_completo as nombre_jugador
from rendimiento
join usuario on rendimiento.id_jugador = usuario.id_usuario
where rendimiento.estado = 'activo'
order by rendimiento.fecha_evaluacion desc;

/*Consulta Especifica*/
delimiter //

create procedure consultar_rendimientos_por_nombre_jugador(
    in p_nombre_jugador varchar(100)
)
begin
    select 
        rendimiento.id_rendimiento,
        rendimiento.fecha_evaluacion,
        rendimiento.posicion,
        rendimiento.unidad_medida,
        rendimiento.velocidad,
        rendimiento.potencia_tiro,
        rendimiento.defensa,
        rendimiento.regate,
        rendimiento.pase,
        rendimiento.tecnica,
        rendimiento.promedio,
        rendimiento.observaciones,
        usuario.nombre_completo as nombre_jugador
    from rendimiento
    join usuario on rendimiento.id_jugador = usuario.id_usuario
    where rendimiento.estado = 'activo'
      and usuario.nombre_completo like concat('%', p_nombre_jugador, '%')
    order by rendimiento.fecha_evaluacion desc;
end //

delimiter ;

/*---Matricula----.*/
create view vista_matriculas as
select 
    matricula.id_matricula,
    matricula.fecha_matricula,
    matricula.fecha_inicio,
    matricula.fecha_fin,
    matricula.estado,
    matricula.observaciones,
    usuario.nombre_completo as nombre_jugador
from matricula
join usuario on matricula.id_jugador = usuario.id_usuario
where matricula.estado = 'activo'
order by matricula.fecha_matricula desc;

/*Consulta Especifica*/

delimiter //

create procedure consultar_matriculas_por_nombre(
    in p_nombre_jugador varchar(100)
)
begin
    select 
        matricula.id_matricula,
        matricula.fecha_matricula,
        matricula.fecha_inicio,
        matricula.fecha_fin,
        matricula.estado,
        matricula.observaciones,
        usuario.nombre_completo as nombre_jugador
    from matricula
    join usuario on matricula.id_jugador = usuario.id_usuario
    where matricula.estado = 'activo'
      and usuario.nombre_completo like concat('%', p_nombre_jugador, '%')
    order by matricula.fecha_matricula desc;
end //

delimiter ;

/*--------------------------------*/
delimiter //

create procedure consultar_mi_matricula(
    in p_id_jugador tinyint
)
begin
    select 
        matricula.id_matricula,
        matricula.fecha_matricula,
        matricula.fecha_inicio,
        matricula.fecha_fin,
        matricula.estado,
        matricula.observaciones,
        usuario.nombre_completo as nombre_jugador
    from matricula
    join usuario on matricula.id_jugador = usuario.id_usuario
    where matricula.estado = 'activo'
      and matricula.id_jugador = p_id_jugador;
end //

delimiter ;

/*----------------------------------------------------------------*/
delimiter //

create procedure consultar_matriculas_de_mis_jugadores(
    in p_id_responsable tinyint
)
begin
    select 
        matricula.id_matricula,
        matricula.fecha_matricula,
        matricula.fecha_inicio,
        matricula.fecha_fin,
        matricula.estado,
        matricula.observaciones,
        usuario.nombre_completo as nombre_jugador
    from matricula
    join usuario on matricula.id_jugador = usuario.id_usuario
    where matricula.estado = 'activo'
      and usuario.id_responsable = p_id_responsable
    order by matricula.fecha_matricula desc;
end //

delimiter ;

