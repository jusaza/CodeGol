-- Insertar roles
insert into rol (rol_usuario) values
  ('Administrador'),
  ('Entrenador'),
  ('Responsable'),
  ('Jugador');

-- Insertar usuarios
insert into usuario (
  correo, contrasena, nombre_completo, num_identificacion, tipo_documento,
  telefono_1, telefono_2, direccion, genero, fecha_nacimiento,
  lugar_nacimiento, grupo_sanguineo, foto_perfil, estado,
  id_usuario_registro, id_responsable
) values
  ('admin@codegol.com', 'admin123', 'Juan Pérez', 123456789, 'cc',
   3001234567, null, 'Cra 1 #23-45', 'm', '1985-01-15',
   'Bogotá', 'o+', null, true, 1, null),

  ('coach@codegol.com', 'coach123', 'Ana Gómez', 234567890, 'cc',
   3109876543, 3201234567, 'Cll 12 #34-56', 'f', '1990-06-20',
   'Medellín', 'a+', null, true, 1, null),

  ('responsable@codegol.com', 'resp123', 'Carlos Torres', 345678901, 'cc',
   3204567890, null, 'Av 45 #67-89', 'm', '1980-12-05',
   'Cali', 'b+', null, true, 1, null),

  ('jugador1@codegol.com', 'jugador123', 'Luis Martínez', 456789012, 'cc',
   3007654321, null, 'Cra 5 #12-34', 'm', '2005-03-15',
   'Barranquilla', 'ab+', null, true, 3, 3);

-- Asignar roles a usuarios
insert into detalles_usuario_rol (id_rol, id_usuario) values
  (1, 1),  -- Administrador: Juan Pérez
  (2, 2),  -- Entrenador: Ana Gómez
  (3, 3),  -- Responsable: Carlos Torres
  (4, 4);  -- Jugador: Luis Martínez

-- Insertar inventario
insert into inventario (
  nombre_articulo, cantidad_total, descripcion, fecha_ingreso,
  estado, id_usuario
) values
  ('Balón de fútbol', 20, 'Balones oficiales para entrenamientos', '2025-07-01', true, 1),
  ('Conos de entrenamiento', 50, 'Conos naranjas para circuitos', '2025-07-03', true, 2);

-- Insertar entrenamientos
insert into entrenamiento (
  descripcion, fecha, hora_inicio, hora_fin, lugar, observaciones,
  estado, id_usuario
) values
  ('Entrenamiento táctico', '2025-08-01', '08:00:00', '10:00:00', 'Cancha principal', null, true, 2),
  ('Entrenamiento físico', '2025-08-03', '09:00:00', '11:00:00', 'Gimnasio', 'Enfocado en resistencia', true, 2);

-- Insertar matrícula
insert into matricula (
  fecha_matricula, fecha_inicio, fecha_fin, estado,
  observaciones, categoria, nivel, id_jugador, id_usuario
) values
  ('2025-07-15', '2025-07-15', '2025-12-15', true,
   'Jugador nuevo en categoría juvenil', 1, 'Medio', 4, 3);

-- Insertar pagos
insert into pago (
  concepto_pago, fecha_pago, metodo_pago, valor_total,
  observaciones, estado, id_usuario, id_responsable, id_matricula
) values
  ('Pago matrícula julio-diciembre', '2025-07-16', 'transferencia', 200000,
   'Pago completo', true, 3, 3, 1);

-- Insertar rendimiento
insert into rendimiento (
  fecha_evaluacion, posicion, velocidad, potencia_tiro, defensa,
  regate, pase, tecnica, observaciones, estado,
  id_matricula, id_entrenamiento, id_usuario
) values
  ('2025-08-01', 'Delantero', 80, 85, 70, 75, 80, 78, 'Buen desempeño general', true, 1, 1, 2);

-- Insertar detalles_utiliza (uso de inventario en entrenamientos)
insert into detalles_utiliza (
  cantidad_usada, observaciones, id_entrenamiento, id_inventario
) values
  (5, 'Uso para ejercicios de pase', 1, 1),
  (10, 'Colocados para circuito', 1, 2);

-- Insertar detalles_asiste (asistencia a entrenamientos)
insert into detalles_asiste (
  tipo_asistencia, justificacion, observaciones, id_matricula, id_entrenamiento
) values
  ('asiste', null, null, 1, 1),
  ('llegada tarde', 'Tráfico', 'Llegó 10 minutos tarde', 1, 2);
