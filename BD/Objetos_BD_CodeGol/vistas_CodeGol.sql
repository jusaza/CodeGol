/*Vistas*/

create view vista_asistencia_con_nombres as
select 
    da.id_asiste,
    u.nombre_completo as nombre_jugador,
    da.tipo_asistencia,
    da.justificacion,
    da.observaciones,
    e.fecha as fecha_entrenamiento,
    e.descripcion as descripcion_entrenamiento
from detalles_asiste da
join matricula m on da.id_matricula = m.id_matricula
join usuario u on m.id_jugador = u.id_usuario
join entrenamiento e on da.id_entrenamiento = e.id_entrenamiento
where e.estado = true
order by u.nombre_completo asc;


/*-------Consulta Especifica-----*/

delimiter //

create procedure consultar_asistencia_por_nombre_documento(
    in p_nombre_jugador varchar(100),
    in p_num_documento varchar(20),
    in p_id_entrenamiento tinyint
)
begin
    select 
        da.id_asiste,
        u.nombre_completo as nombre_jugador,
        da.tipo_asistencia,
        da.justificacion,
        da.observaciones,
        e.fecha as fecha_entrenamiento,
        e.descripcion as descripcion_entrenamiento
    from detalles_asiste da
    join matricula m on da.id_matricula = m.id_matricula
    join usuario u on m.id_jugador = u.id_usuario
    join entrenamiento e on da.id_entrenamiento = e.id_entrenamiento
    where e.estado = true
      and e.id_entrenamiento = p_id_entrenamiento
      and (
          p_nombre_jugador is null 
          or p_nombre_jugador = '' 
          or LOWER(u.nombre_completo) like concat('%', LOWER(p_nombre_jugador), '%')
      )
      and (
          p_num_documento is null
          or p_num_documento = ''
          or CAST(u.num_identificacion AS CHAR) like concat('%', p_num_documento, '%')
      )
    order by u.nombre_completo asc;
end //

delimiter ;


/*------Entrenamiento------*/
create view vista_entrenamientos_con_responsable as
select 
    e.id_entrenamiento,
    e.descripcion,
    e.fecha,
    e.hora_inicio,
    e.hora_fin,
    e.lugar,
    e.observaciones,
    u.nombre_completo as nombre_registrador
from entrenamiento e
join usuario u on e.id_usuario = u.id_usuario
where e.estado = true
order by e.fecha desc;


/*Consulta Especifica*/
delimiter //

create procedure consultar_entrenamientos_para_registrador(
    in p_id_usuario tinyint,
    in p_fecha date
)
begin
    select 
        e.id_entrenamiento,
        e.descripcion,
        e.fecha,
        e.hora_inicio,
        e.hora_fin,
        e.lugar,
        e.observaciones,
        u.nombre_completo as nombre_registrador
    from entrenamiento e
    join usuario u on e.id_usuario = u.id_usuario
    where e.estado = true
      and e.id_usuario = p_id_usuario
      and (
        p_fecha is null 
        or e.fecha = p_fecha
      )
    order by e.fecha desc;
end //

delimiter ;


/*------------------------------------------*/
delimiter //

create procedure consultar_entrenamientos_de_jugador(
    in p_id_jugador tinyint,
    in p_nombre_registrador varchar(100),
    in p_fecha date
)
begin
    select 
        e.id_entrenamiento,
        e.descripcion,
        e.fecha,
        e.hora_inicio,
        e.hora_fin,
        e.lugar,
        e.observaciones,
        ur.nombre_completo as nombre_registrador
    from detalles_asiste da
    join matricula m on da.id_matricula = m.id_matricula
    join entrenamiento e on da.id_entrenamiento = e.id_entrenamiento
    join usuario ur on e.id_usuario = ur.id_usuario  -- quien registró el entrenamiento
    where e.estado = true
      and m.id_jugador = p_id_jugador
      and (
        p_fecha is null or e.fecha = p_fecha
      )
      and (
        p_nombre_registrador is null or p_nombre_registrador = '' 
        or lower(ur.nombre_completo) like concat('%', lower(p_nombre_registrador), '%')
      )
    group by e.id_entrenamiento
    order by e.fecha desc;
end //

delimiter ;

/*------------------------------------------*/
delimiter //

create procedure consultar_entrenamientos_de_mis_jugadores(
    in p_id_responsable tinyint,
    in p_nombre_registrador varchar(100),
    in p_fecha date
)
begin
    select 
        e.id_entrenamiento,
        e.descripcion,
        e.fecha,
        e.hora_inicio,
        e.hora_fin,
        e.lugar,
        e.observaciones,
        ur.nombre_completo as nombre_registrador
    from usuario u
    join matricula m on u.id_usuario = m.id_jugador
    join detalles_asiste da on da.id_matricula = m.id_matricula
    join entrenamiento e on da.id_entrenamiento = e.id_entrenamiento
    join usuario ur on e.id_usuario = ur.id_usuario -- quien registró el entrenamiento
    where u.id_responsable = p_id_responsable
      and e.estado = true
      and (p_fecha is null or e.fecha = p_fecha)
      and (
        p_nombre_registrador is null or p_nombre_registrador = ''
        or lower(ur.nombre_completo) like concat('%', lower(p_nombre_registrador), '%')
      )
    group by e.id_entrenamiento
    order by e.fecha desc;
end //

delimiter ;


/*------------------------------------------*/
delimiter //

create procedure consultar_entrenamientos_por_documento_y_opcional(
    in p_num_identificacion int,
    in p_nombre_registrador varchar(100),
    in p_fecha date
)
begin
    select 
        e.id_entrenamiento,
        e.descripcion,
        e.fecha,
        e.hora_inicio,
        e.hora_fin,
        e.lugar,
        e.observaciones,
        u.nombre_completo as nombre_registrador
    from entrenamiento e
    join usuario u on e.id_usuario = u.id_usuario
    where e.estado = true
      and u.num_identificacion like concat('%', p_num_identificacion, '%')
      and (
        p_nombre_registrador is null 
        or lower(u.nombre_completo) like concat('%', lower(p_nombre_registrador), '%')
      )
      and (
        p_fecha is null 
        or e.fecha = p_fecha
      )
    order by e.fecha desc;
end //

delimiter ;

/*-----------------*/
/*Consulta Especifica*/

create view vista_rendimientos as
select 
    r.id_rendimiento,
    r.fecha_evaluacion,
    r.posicion,
    r.velocidad,
    r.potencia_tiro,
    r.defensa,
    r.regate,
    r.pase,
    r.tecnica,
    r.promedio,
    r.observaciones,
    u.nombre_completo as nombre_jugador,
    ur.nombre_completo as registrado_por
from rendimiento r
join matricula m on r.id_matricula = m.id_matricula
join usuario u on m.id_jugador = u.id_usuario         -- Jugador evaluado
join usuario ur on r.id_usuario = ur.id_usuario       -- Usuario que registró
where r.estado = true
order by r.fecha_evaluacion desc;

delimiter //

create procedure consultar_rendimientos_por_nombre_o_documento(
    in p_nombre_jugador varchar(60),
    in p_num_documento varchar(20)  -- para búsqueda parcial
)
begin
    select 
        r.id_rendimiento,
        r.fecha_evaluacion,
        r.posicion,
        r.unidad_medida,
        r.velocidad,
        r.potencia_tiro,
        r.defensa,
        r.regate,
        r.pase,
        r.tecnica,
        r.promedio,
        r.observaciones,
        u.nombre_completo as nombre_jugador,
        ur.nombre_completo as registrado_por
    from rendimiento r
    join matricula m on r.id_matricula = m.id_matricula
    join usuario u on m.id_jugador = u.id_usuario
    join usuario ur on r.id_usuario = ur.id_usuario  -- quien registró el rendimiento
    where r.estado = true
      and (
        (p_nombre_jugador is null or p_nombre_jugador = '' 
         or lower(u.nombre_completo) like concat('%', lower(p_nombre_jugador), '%'))
        and
        (p_num_documento is null or p_num_documento = '' 
         or cast(u.num_identificacion as char) like concat('%', p_num_documento, '%'))
      )
    order by r.fecha_evaluacion desc;
end //

delimiter ;

delimiter //

create procedure consultar_rendimientos_por_registrador(
    in p_id_registrador tinyint,
    in p_nombre_jugador varchar(100),
    in p_num_documento varchar(20)
)
begin
    select 
        r.id_rendimiento,
        r.fecha_evaluacion,
        r.posicion,
        r.unidad_medida,
        r.velocidad,
        r.potencia_tiro,
        r.defensa,
        r.regate,
        r.pase,
        r.tecnica,
        r.promedio,
        r.observaciones,
        u.nombre_completo as nombre_jugador,
        ur.nombre_completo as registrado_por
    from rendimiento r
    join matricula m on r.id_matricula = m.id_matricula
    join usuario u on m.id_jugador = u.id_usuario
    join usuario ur on r.id_usuario = ur.id_usuario
    where r.estado = true
      and r.id_usuario = p_id_registrador
      and (
        (p_nombre_jugador is null or p_nombre_jugador = '' 
         or lower(u.nombre_completo) like concat('%', lower(p_nombre_jugador), '%'))
        and
        (p_num_documento is null or p_num_documento = '' 
         or cast(u.num_identificacion as char) like concat('%', p_num_documento, '%'))
      )
    order by r.fecha_evaluacion desc;
end //

delimiter ;

delimiter //

create procedure consultar_rendimientos_para_jugador(
    in p_id_jugador tinyint,
    in p_fecha date
)
begin
    select 
        r.id_rendimiento,
        r.fecha_evaluacion,
        r.posicion,
        r.unidad_medida,
        r.velocidad,
        r.potencia_tiro,
        r.defensa,
        r.regate,
        r.pase,
        r.tecnica,
        r.promedio,
        r.observaciones,
        u.nombre_completo as nombre_jugador,
        ur.nombre_completo as registrado_por
    from rendimiento r
    join matricula m on r.id_matricula = m.id_matricula
    join usuario u on m.id_jugador = u.id_usuario
    join usuario ur on r.id_usuario = ur.id_usuario
    where r.estado = true
      and u.id_usuario = p_id_jugador
      and (p_fecha is null or r.fecha_evaluacion = p_fecha)
    order by r.fecha_evaluacion desc;
end //

delimiter ;

delimiter //

create procedure consultar_rendimientos_de_mis_jugadores(
    in p_id_responsable tinyint,
    in p_fecha date
)
begin
    select 
        r.id_rendimiento,
        r.fecha_evaluacion,
        r.posicion,
        r.unidad_medida,
        r.velocidad,
        r.potencia_tiro,
        r.defensa,
        r.regate,
        r.pase,
        r.tecnica,
        r.promedio,
        r.observaciones,
        u.nombre_completo as nombre_jugador,
        ur.nombre_completo as registrado_por
    from usuario u
    join matricula m on u.id_usuario = m.id_jugador
    join rendimiento r on r.id_matricula = m.id_matricula
    join usuario ur on r.id_usuario = ur.id_usuario
    where u.id_responsable = p_id_responsable
      and r.estado = true
      and (p_fecha is null or r.fecha_evaluacion = p_fecha)
    order by r.fecha_evaluacion desc;
end //

delimiter ;



/*---Matricula----.*/
create or replace view vista_matriculas as
select 
    m.id_matricula,
    m.fecha_matricula,
    m.fecha_inicio,
    m.fecha_fin,
    m.estado,
    m.observaciones,
    uj.nombre_completo as nombre_jugador,
    ur.nombre_completo as registrado_por
from matricula m
join usuario uj on m.id_jugador = uj.id_usuario
join usuario ur on m.id_usuario = ur.id_usuario
where m.estado = true
order by m.fecha_matricula desc;


/*Consulta Especifica*/

delimiter //

create procedure consultar_matriculas_por_nombre_o_documento(
    in p_nombre_jugador varchar(100),
    in p_num_documento varchar(20)  -- CAMBIADO a varchar para permitir búsqueda parcial
)
begin
    select 
        m.id_matricula,
        m.fecha_matricula,
        m.fecha_inicio,
        m.fecha_fin,
        m.estado,
        m.observaciones,
        u.nombre_completo as nombre_jugador,
        ur.nombre_completo as registrado_por
    from matricula m
    join usuario u on m.id_jugador = u.id_usuario
    join usuario ur on m.id_usuario = ur.id_usuario
    where m.estado = true
      and (
            p_nombre_jugador is null or p_nombre_jugador = '' 
            or lower(u.nombre_completo) like concat('%', lower(p_nombre_jugador), '%')
          )
      and (
            p_num_documento is null or p_num_documento = '' 
            or cast(u.num_identificacion as char) like concat('%', p_num_documento, '%')
          )
    order by m.fecha_matricula desc;
end //

delimiter ;


/*--------------------------------*/
delimiter //

create procedure consultar_mi_matricula(
    in p_id_jugador tinyint
)
begin
    select 
        m.id_matricula,
        m.fecha_matricula,
        m.fecha_inicio,
        m.fecha_fin,
        m.estado,
        m.observaciones,
        u.nombre_completo as nombre_jugador,
        ur.nombre_completo as registrado_por
    from matricula m
    join usuario u on m.id_jugador = u.id_usuario
    join usuario ur on m.id_usuario = ur.id_usuario
    where m.estado = true
      and m.id_jugador = p_id_jugador;
end //

delimiter ;



/*----------------------------------------------------------------*/
delimiter //

create procedure consultar_matriculas_de_mis_jugadores(
    in p_id_responsable tinyint
)
begin
    select 
        m.id_matricula,
        m.fecha_matricula,
        m.fecha_inicio,
        m.fecha_fin,
        m.estado,
        m.observaciones,
        u.nombre_completo as nombre_jugador,
        ur.nombre_completo as registrado_por
    from matricula m
    join usuario u on m.id_jugador = u.id_usuario
    join usuario ur on m.id_usuario = ur.id_usuario
    where m.estado = true
      and u.id_responsable = p_id_responsable
    order by m.fecha_matricula desc;
end //

delimiter ;


/*almanza*/

delimiter //
create procedure proc_info_usuarios_completa_por_estado(in p_estado enum('activo','inactivo'))
begin
  select 
    u.id_usuario,
    u.nombre_completo,
    u.correo,
    u.tipo_documento,
    u.num_identificacion,
    u.genero,
    u.fecha_nacimiento,
    u.direccion,
    u.telefono_1,
    u.telefono_2,
    u.grupo_sanguineo,
    u.estado,
    u.registrado_por,
    r.rol_usuario
  from usuario u
  left join detalles_usuario_rol dur on dur.id_usuario = u.id_usuario
  left join rol r on r.id_rol = dur.id_rol
  where u.estado = p_estado;
end;
//
delimiter ;

delimiter //
create procedure proc_inventario_uso_total_por_articulo(in p_nombre_articulo varchar(100))
begin
  select 
    i.id_inventario,
    i.nombre_articulo,
    i.descripcion,
    i.cantidad_total,
    i.fecha_ingreso,
    i.estado,
    count(du.id_utiliza) as veces_utilizado,
    sum(du.cantidad_usada) as total_utilizado
  from inventario i
  left join detalles_utiliza du on du.id_inventario = i.id_inventario
  where i.nombre_articulo like concat('%', p_nombre_articulo, '%')
  group by i.id_inventario;
end;
//
delimiter ;

delimiter //
create procedure proc_pagos_detalle_por_usuario(in p_usuario int)
begin
  select 
    p.id_pago,
    p.concepto_pago,
    p.fecha_pago,
    p.metodo_pago,
    p.valor_total,
    p.observaciones,
    u.nombre_completo as pagador,
    m.id_matricula,
    m.fecha_matricula,
    m.fecha_inicio,
    m.fecha_fin,
    m.estado as estado_matricula
  from pago p
  join usuario u on u.id_usuario = p.pagado_por
  join matricula m on m.id_matricula = p.id_matricula
  where p.pagado_por = p_usuario;
end;
//
delimiter ;

delimiter //
create procedure proc_inventario_y_uso_por_fecha(in p_fecha date)
begin
  select 
    i.nombre_articulo,
    i.descripcion,
    du.cantidad_usada,
    du.hora_inicio,
    du.hora_fin,
    du.fecha_uso,
    u.nombre_completo as entrenador,
    du.observaciones
  from detalles_utiliza du
  join inventario i on i.id_inventario = du.id_inventario
  join usuario u on u.id_usuario = du.id_entrenador
  where du.fecha_uso = p_fecha;
end;
//
delimiter ;

delimiter //
create procedure proc_usuarios_con_roles_por_tipo_documento(in p_tipo enum('cc','ti','ce','pa','rc','pep','nit','nuip','dni','ppt'))
begin
  select 
    u.id_usuario,
    u.nombre_completo,
    u.tipo_documento,
    u.num_identificacion,
    u.genero,
    r.rol_usuario
  from usuario u
  left join detalles_usuario_rol dur on dur.id_usuario = u.id_usuario
  left join rol r on r.id_rol = dur.id_rol
  where u.tipo_documento = p_tipo;
end;
//
delimiter ;

delimiter //
create procedure proc_resumen_pagos_por_matricula(in p_id_matricula int)
begin
  select 
    m.id_matricula,
    u.nombre_completo as jugador,
    count(p.id_pago) as total_pagos,
    sum(p.valor_total) as total_pagado,
    min(p.fecha_pago) as primer_pago,
    max(p.fecha_pago) as ultimo_pago
  from pago p
  join matricula m on m.id_matricula = p.id_matricula
  join usuario u on u.id_usuario = m.id_jugador
  where p.id_matricula = p_id_matricula
  group by m.id_matricula;
end;
//
delimiter ;

delimiter //
create procedure proc_uso_articulos_por_entrenador_y_rango_fecha(
  in p_id_entrenador int,
  in p_fecha_inicio date,
  in p_fecha_fin date
)
begin
  select 
    du.id_utiliza,
    i.nombre_articulo,
    du.fecha_uso,
    du.cantidad_usada,
    du.hora_inicio,
    du.hora_fin,
    du.observaciones
  from detalles_utiliza du
  join inventario i on i.id_inventario = du.id_inventario
  where du.id_entrenador = p_id_entrenador
    and du.fecha_uso between p_fecha_inicio and p_fecha_fin;
end;
//
delimiter ;

delimiter //
create procedure proc_usuarios_con_roles_y_direccion(in p_ciudad varchar(100))
begin
  select 
    u.nombre_completo,
    u.correo,
    u.direccion,
    r.rol_usuario
  from usuario u
  left join detalles_usuario_rol dur on dur.id_usuario = u.id_usuario
  left join rol r on r.id_rol = dur.id_rol
  where u.direccion like concat('%', p_ciudad, '%');
end;
//
delimiter ;

delimiter //
create procedure proc_pagos_detalle_por_metodo_y_rango(
  in p_metodo enum('efectivo','transferencia'),
  in p_inicio date,
  in p_fin date
)
begin
  select 
    p.concepto_pago,
    p.valor_total,
    p.fecha_pago,
    u.nombre_completo as pagador,
    m.id_matricula
  from pago p
  join usuario u on u.id_usuario = p.pagado_por
  join matricula m on m.id_matricula = p.id_matricula
  where p.metodo_pago = p_metodo
    and p.fecha_pago between p_inicio and p_fin;
end;
//
delimiter ;

delimiter //
create procedure proc_uso_articulos_con_nombre_entrenador(in p_nombre_entrenador varchar(100))
begin
  select 
    du.id_utiliza,
    i.nombre_articulo,
    du.fecha_uso,
    du.cantidad_usada,
    u.nombre_completo as entrenador
  from detalles_utiliza du
  join inventario i on i.id_inventario = du.id_inventario
  join usuario u on u.id_usuario = du.id_entrenador
  where u.nombre_completo like concat('%', p_nombre_entrenador, '%');
end;
//
delimiter ;
