/*PRUEBAS*/
-- insertar 10 usuarios (incluido el administrador base con id_usuario = 1)

insert into usuario (
  correo, contrasena, nombre_completo, num_identificacion, tipo_documento,
  telefono_1, telefono_2, direccion, genero, fecha_nacimiento, lugar_nacimiento,
  grupo_sanguineo, estado, id_usuario_registro
) values (
  'admin@codegol.com', 'admin123', 'Administrador General', 100000001, 'cc',
  3000000001, null, 'Cra 1 #1-01', 'm', '1990-01-01', 'Bogotá',
  'o+', true, 1
);

insert into usuario (
  correo, contrasena, nombre_completo, num_identificacion, tipo_documento,
  telefono_1, telefono_2, direccion, genero, fecha_nacimiento, lugar_nacimiento,
  grupo_sanguineo, estado, id_usuario_registro, id_responsable
) values
-- 2
('jairo123@gmail.com', 'clave123', 'Jairo Mendoza', 100000002, 'cc',
  3000000002, 3100000002, 'Cra 12 #34-56', 'm', '2005-04-15', 'Medellín',
  'a+', true, 1, 1),
-- 3
('laura_lop@example.com', 'pass456', 'Laura López', 100000003, 'ti',
  3000000003, null, 'Cll 45 #67-89', 'f', '2006-08-20', 'Cali',
  'b+', true, 1, 1),
-- 4
('santi_rob@gmail.com', 'abc321', 'Santiago Robles', 100000004, 'ti',
  3000000004, null, 'Av 5 #10-11', 'm', '2007-11-05', 'Barranquilla',
  'ab+', true, 1, 1),
-- 5
('karina.perez@hotmail.com', 'karina2023', 'Karina Pérez', 100000005, 'cc',
  3000000005, 3110000005, 'Cll 100 #20-30', 'f', '2000-03-10', 'Cartagena',
  'o-', true, 1, null),
-- 6
('mario.rivera@gmail.com', 'mario2023', 'Mario Rivera', 100000006, 'ce',
  3000000006, null, 'Calle 7 #89-12', 'm', '1999-07-19', 'Bogotá',
  'b-', true, 1, null),
-- 7
('luciana_b@example.com', 'luciana2024', 'Luciana Botero', 100000007, 'ti',
  3000000007, 3200000007, 'Cra 40 #56-78', 'f', '2008-01-30', 'Pereira',
  'a-', true, 1, 5),
-- 8
('andres.torres@gmail.com', 'torres555', 'Andrés Torres', 100000008, 'cc',
  3000000008, null, 'Av 30 #60-10', 'm', '1998-12-12', 'Manizales',
  'ab-', true, 1, null),
-- 9
('catalina.ruiz@gmail.com', 'cat2023', 'Catalina Ruiz', 100000009, 'cc',
  3000000009, 3120000009, 'Calle 3 #6-70', 'f', '2002-06-18', 'Bucaramanga',
  'o+', true, 1, 6),
-- 10
('jose.martinez@gmail.com', 'jose2023', 'José Martínez', 100000010, 'cc',
  3000000010, null, 'Cll 12A #89-11', 'm', '2001-09-25', 'Tunja',
  'a+', true, 1, 4);
-- asignar roles a los usuarios en detalles_usuario_rol
insert into detalles_usuario_rol (id_rol, id_usuario) values
  (1, 1), -- admin
  (2, 2), -- entrenador
  (3, 5), -- responsable
  (3, 6), -- responsable
  (4, 3), -- jugador
  (4, 4), -- jugador
  (4, 7), -- jugador
  (4, 8), -- jugador
  (4, 9), -- jugador
  (4, 10); -- jugador
-- Inserción de 10 registros en la tabla inventario
insert into inventario (
  nombre_articulo, cantidad_total, descripcion, fecha_ingreso, estado, id_usuario
) values
  ('Balón de fútbol', 20, 'Balón oficial talla 5', '2025-07-01', true, 2),
  ('Conos de entrenamiento', 50, 'Conos plásticos anaranjados', '2025-07-01', true, 2),
  ('Petos verdes', 30, 'Petos de entrenamiento talla M', '2025-07-01', true, 2),
  ('Red de porterías', 2, 'Red de nylon resistente', '2025-07-01', true, 2),
  ('Silbato metálico', 5, 'Silbato profesional de árbitro', '2025-07-01', true, 2),
  ('Escalera de agilidad', 3, 'Escalera para entrenamiento físico', '2025-07-01', true, 2),
  ('Mallas de entrenamiento', 10, 'Mallas para separación de áreas', '2025-07-01', true, 2),
  ('Tacos de fútbol', 15, 'Talla 42, color negro', '2025-07-01', true, 2),
  ('Botiquín de primeros auxilios', 2, 'Incluye insumos básicos', '2025-07-01', true, 2),
  ('Cronómetro digital', 4, 'Cronómetro resistente al agua', '2025-07-01', true, 2);
-- Inserción de 10 registros en la tabla entrenamiento
insert into entrenamiento (
  descripcion, fecha, hora_inicio, hora_fin, lugar, observaciones, estado, id_usuario
) values
  ('Entrenamiento físico general', '2025-07-10', '08:00:00', '10:00:00', 'Cancha A', 'Ejercicios de resistencia', true, 2),
  ('Tácticas defensivas', '2025-07-11', '09:00:00', '11:00:00', 'Cancha B', 'Posicionamiento en zona', true, 2),
  ('Tiros a puerta', '2025-07-12', '07:30:00', '09:00:00', 'Cancha A', null, true, 2),
  ('Trabajo de velocidad', '2025-07-13', '08:00:00', '09:30:00', 'Pista atlética', 'Ejercicios con conos y escaleras', true, 2),
  ('Juego reducido', '2025-07-14', '10:00:00', '12:00:00', 'Cancha B', 'Simulación de partido', true, 2),
  ('Sesión de recuperación', '2025-07-15', '08:30:00', '10:00:00', 'Gimnasio', 'Ejercicios de estiramiento', true, 2),
  ('Entrenamiento técnico', '2025-07-16', '07:00:00', '09:00:00', 'Cancha A', 'Controles y pases', true, 2),
  ('Estrategias ofensivas', '2025-07-17', '09:00:00', '11:00:00', 'Cancha B', 'Ataque por bandas', true, 2),
  ('Trabajo de equipo', '2025-07-18', '08:00:00', '10:00:00', 'Cancha central', 'Ejercicios de comunicación', true, 2),
  ('Simulación de partido', '2025-07-19', '10:30:00', '12:30:00', 'Estadio escolar', 'Partido completo con reglas', true, 2);
  
insert into matricula (
  fecha_matricula, fecha_inicio, fecha_fin, estado, observaciones,
  categoria, nivel, id_jugador, id_usuario
) values
('2025-01-10', '2025-01-15', '2025-06-15', true, 'ninguna', 1, 'bajo', 1, 2),
('2025-02-05', '2025-02-10', '2025-07-10', true, 'entrenamiento especial', 2, 'medio', 2, 3),
('2025-03-01', '2025-03-05', '2025-08-05', true, 'inicio tardío', 3, 'alto', 3, 1),
('2025-01-20', '2025-01-25', '2025-06-25', true, null, 2, 'medio', 4, 5),
('2025-02-15', '2025-02-20', '2025-07-20', true, 'becado', 1, 'bajo', 5, 6),
('2025-03-10', '2025-03-15', '2025-08-15', true, 'renovación', 3, 'alto', 6, 4),
('2025-01-30', '2025-02-01', '2025-07-01', true, 'nuevo ingreso', 2, 'medio', 7, 3),
('2025-02-25', '2025-03-01', '2025-08-01', true, null, 1, 'bajo', 8, 2),
('2025-03-20', '2025-03-25', '2025-08-25', true, 'segundo año', 3, 'alto', 9, 1),
('2025-01-05', '2025-01-10', '2025-06-10', true, 'reincorporado', 2, 'medio', 10, 5);

insert into pago (
  concepto_pago, fecha_pago, metodo_pago, valor_total, observaciones,
  estado, id_usuario, id_responsable, id_matricula
) values
  ('Mensualidad julio', '2025-07-01', 'efectivo', 100000, 'Pago puntual', true, 1, 2, 1),
  ('Uniforme deportivo', '2025-07-02', 'transferencia', 75000, 'Incluye camiseta y pantaloneta', true, 2, 3, 2),
  ('Inscripción torneo', '2025-07-03', 'efectivo', 50000, 'Copa juvenil 2025', true, 3, 4, 3),
  ('Mensualidad julio', '2025-07-04', 'transferencia', 100000, 'Pago tarde', false, 4, 5, 4),
  ('Carnetización', '2025-07-05', 'efectivo', 20000, 'Incluye seguro', true, 5, 6, 5),
  ('Mensualidad julio', '2025-07-06', 'transferencia', 100000, null, true, 6, 7, 6),
  ('Apoyo viaje', '2025-07-07', 'efectivo', 120000, 'Viaje Medellín', false, 7, 8, 7),
  ('Mensualidad julio', '2025-07-08', 'transferencia', 100000, null, true, 8, 9, 8),
  ('Reemplazo uniforme', '2025-07-09', 'efectivo', 75000, 'Camiseta perdida', true, 9, 10, 9),
  ('Mensualidad julio', '2025-07-10', 'transferencia', 100000, null, false, 10, 1, 10);

insert into rendimiento (
  fecha_evaluacion, posicion, velocidad, potencia_tiro, defensa, regate, pase, tecnica, observaciones, estado, id_matricula, id_entrenamiento, id_usuario
) values
('2025-07-01', 'Delantero', 85, 90, 60, 88, 70, 80, 'Jugador con gran proyección ofensiva', true, 1, 1, 2),
('2025-07-02', 'Defensa central', 60, 65, 90, 55, 68, 70, 'Fuerte en defensa, lento en salida', true, 2, 2, 3),
('2025-07-03', 'Volante mixto', 75, 70, 75, 70, 80, 78, 'Buen equilibrio y control de juego', true, 3, 3, 4),
('2025-07-04', 'Extremo derecho', 90, 80, 50, 92, 76, 84, 'Muy ágil y desequilibrante', true, 4, 4, 5),
('2025-07-05', 'Portero', 50, 40, 85, 45, 55, 60, 'Buen posicionamiento, debe mejorar reflejos', true, 5, 5, 6),
('2025-07-06', 'Lateral izquierdo', 82, 60, 75, 70, 72, 74, 'Rápido y sólido en marca', true, 6, 6, 7),
('2025-07-07', 'Delantero', 88, 92, 58, 85, 70, 77, 'Muy buen tiro, debe mejorar pase', true, 7, 7, 8),
('2025-07-08', 'Volante de marca', 70, 65, 80, 68, 74, 76, 'Buen balance defensivo', true, 8, 8, 9),
('2025-07-09', 'Mediapunta', 78, 75, 60, 88, 82, 86, 'Creativo con buena técnica', true, 9, 9, 10),
('2025-07-10', 'Defensa derecho', 68, 55, 82, 65, 66, 70, 'Confiable, pero lento en transición', true, 10, 10, 1);

insert into detalles_utiliza (cantidad_usada, observaciones, id_entrenamiento, id_inventario) values
(2, 'Balones desgastados', 1, 1),
(5, 'Se usaron para calentamiento', 1, 2),
(1, 'Usado por el entrenador', 2, 3),
(3, 'Algunos conos se rompieron', 2, 4),
(4, 'Utilizados en práctica de tiros', 3, 5),
(6, 'Requieren limpieza', 4, 6),
(2, 'Chalecos deteriorados', 4, 7),
(1, 'Uso mínimo', 5, 8),
(2, 'Muy útiles para táctica', 5, 9),
(3, 'Uso intensivo', 5, 10);
insert into detalles_asiste (tipo_asistencia, justificacion, observaciones, id_matricula, id_entrenamiento) values
('asiste', null, 'Puntual', 1, 1),
('inasiste', 'Enfermedad', 'Padres informaron', 2, 1),
('asiste', null, 'Buen desempeño', 3, 1),
('llegada tarde', 'Tráfico', 'Llegó 15 minutos tarde', 4, 1),
('inasiste', 'Cita médica', null, 5, 2),
('asiste', null, null, 6, 2),
('asiste', null, 'Muy participativo', 7, 2),
('inasiste', 'Problemas familiares', 'Se avisó previamente', 8, 3),
('asiste', null, 'Muy puntual', 9, 3),
('llegada tarde', 'Olvidó uniforme', 'Llegó sin equipo', 10, 3);