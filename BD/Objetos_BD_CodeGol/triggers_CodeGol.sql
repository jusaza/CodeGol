delimiter //

-- evita correos repetidos
create trigger trg_validar_correo before insert on usuario
for each row begin
  if exists (select 1 from usuario where correo = new.correo) then
    signal sqlstate '45000' set message_text = 'correo repetido';
  end if;
end;
//

-- inactiva artículo si la cantidad llega a 0
create trigger trg_inactivar_articulo after update on inventario
for each row begin
  if new.cantidad_total = 0 then
    update inventario set estado = 'inactivo' where id_inventario = new.id_inventario;
  end if;
end;
//

-- no permite pagos mayores a 1 millón
create trigger trg_limitar_pago before insert on pago
for each row begin
  if new.valor_total > 1000000 then
    signal sqlstate '45000' set message_text = 'pago muy alto';
  end if;
end;
//

-- bloquea eliminación de usuarios
create trigger trg_bloquear_eliminacion before delete on usuario
for each row begin
  signal sqlstate '45000' set message_text = 'no se puede eliminar';
end;
//

-- evita cantidad negativa en inventario
create trigger trg_prevenir_cantidad_negativa before update on inventario
for each row begin
  if new.cantidad_total < 0 then
    signal sqlstate '45000' set message_text = 'cantidad negativa';
  end if;
end;
//

-- no permite artículos duplicados
create trigger trg_articulo_unico before insert on inventario
for each row begin
  if exists (select 1 from inventario where nombre_articulo = new.nombre_articulo) then
    signal sqlstate '45000' set message_text = 'artículo ya existe';
  end if;
end;
//

-- valida longitud mínima del nombre
create trigger trg_validar_nombre before insert on usuario
for each row begin
  if length(new.nombre_completo) < 5 then
    signal sqlstate '45000' set message_text = 'nombre muy corto';
  end if;
end;
//

-- si el usuario se queda sin roles, se inactiva
create trigger trg_usuario_sin_rol after delete on usuario_rol
for each row begin
  declare cantidad int;
  select count(*) into cantidad from usuario_rol where id_usuario = old.id_usuario;
  if cantidad = 0 then
    update usuario set estado = 'inactivo' where id_usuario = old.id_usuario;
  end if;
end;
//

-- evita identificación repetida
create trigger trg_identificacion_unica before insert on usuario
for each row begin
  if exists (select 1 from usuario where num_identificacion = new.num_identificacion) then
    signal sqlstate '45000' set message_text = 'identificación repetida';
  end if;
end;
//

-- evita asignar el mismo rol dos veces
create trigger trg_rol_unico before insert on usuario_rol
for each row begin
  if exists (
    select 1 from usuario_rol
    where id_usuario = new.id_usuario and id_rol = new.id_rol
  ) then
    signal sqlstate '45000' set message_text = 'rol ya asignado';
  end if;
end;
//

delimiter ;

-- Trigger: Validar rendimiento antes de insertar
delimiter //

create trigger trg_validar_rendimiento_insert
before insert on rendimiento
for each row
begin
    if new.velocidad < 0 or new.velocidad > 100 then
        signal sqlstate '45000' set message_text = 'La velocidad debe estar entre 0 y 100.';
    elseif new.potencia_tiro < 0 or new.potencia_tiro > 100 then
        signal sqlstate '45000' set message_text = 'La potencia de tiro debe estar entre 0 y 100.';
    elseif new.defensa < 0 or new.defensa > 100 then
        signal sqlstate '45000' set message_text = 'La defensa debe estar entre 0 y 100.';
    elseif new.regate < 0 or new.regate > 100 then
        signal sqlstate '45000' set message_text = 'El regate debe estar entre 0 y 100.';
    elseif new.pase < 0 or new.pase > 100 then
        signal sqlstate '45000' set message_text = 'El pase debe estar entre 0 y 100.';
    elseif new.tecnica < 0 or new.tecnica > 100 then
        signal sqlstate '45000' set message_text = 'La técnica debe estar entre 0 y 100.';
    end if;
end //

delimiter ;

-- Trigger: Validar rendimiento antes de actualizar
delimiter //

create trigger trg_validar_rendimiento_update
before update on rendimiento
for each row
begin
    if new.velocidad < 0 or new.velocidad > 100 then
        signal sqlstate '45000' set message_text = 'La velocidad debe estar entre 0 y 100.';
    elseif new.potencia_tiro < 0 or new.potencia_tiro > 100 then
        signal sqlstate '45000' set message_text = 'La potencia de tiro debe estar entre 0 y 100.';
    elseif new.defensa < 0 or new.defensa > 100 then
        signal sqlstate '45000' set message_text = 'La defensa debe estar entre 0 y 100.';
    elseif new.regate < 0 or new.regate > 100 then
        signal sqlstate '45000' set message_text = 'El regate debe estar entre 0 y 100.';
    elseif new.pase < 0 or new.pase > 100 then
        signal sqlstate '45000' set message_text = 'El pase debe estar entre 0 y 100.';
    elseif new.tecnica < 0 or new.tecnica > 100 then
        signal sqlstate '45000' set message_text = 'La técnica debe estar entre 0 y 100.';
    end if;
end //

delimiter ;
