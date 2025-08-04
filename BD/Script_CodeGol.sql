-- --------------------------------------------------------
create database codegol;
use codegol;
-- --------------------------------------------------------

-- tabla: usuario
create table usuario (
  id_usuario tinyint unsigned auto_increment primary key comment 'identificador único del usuario',
  correo varchar(60) not null comment 'correo electrónico del usuario',
  contrasena varchar(60) not null comment 'clave de acceso del usuario',
  nombre_completo varchar(60) not null comment 'nombre y apellidos del usuario',
  num_identificacion int unsigned not null comment 'número de documento del usuario',
  tipo_documento enum('cc','ti','ce','pa','rc','pep','nit','nuip','dni','ppt') not null comment 'tipo de documento',
  telefono_1 bigint unsigned not null comment 'número de contacto principal',
  telefono_2 bigint unsigned null comment 'número de contacto alterno',
  direccion varchar(50) not null comment 'dirección de residencia',
  genero enum('m','f','otro') not null comment 'género del usuario',
  fecha_nacimiento date not null comment 'fecha de nacimiento',
  lugar_nacimiento varchar(50) null comment 'ciudad o país de nacimiento',
  grupo_sanguineo enum('a+','a-','b+','b-','ab+','ab-','o+','o-') not null comment 'tipo de sangre',
  foto_perfil blob default null comment 'imagen del perfil del usuario',
  estado boolean not null default true comment 'estado del usuario',
  id_usuario_registro tinyint unsigned not null default 1 comment 'id del usuario que lo registró',
  id_responsable tinyint unsigned null comment 'id del responsable del usuario (jugador)',
  constraint fk_usuario_registrado_por foreign key (id_usuario_registro) references usuario (id_usuario),
  constraint fk_useresponsable foreign key (id_responsable) references usuario (id_usuario)
);

-- tabla: rol
create table rol (
  id_rol tinyint unsigned auto_increment primary key comment 'identificador único del rol',
  rol_usuario enum("Administrador","Entrenador","Responsable","Jugador") not null unique comment 'nombre del rol asignado'
);

-- tabla: inventario
create table inventario (
  id_inventario tinyint unsigned auto_increment primary key comment 'identificador del artículo',
  nombre_articulo varchar(50) not null comment 'nombre del producto o artículo',
  cantidad_total tinyint unsigned not null comment 'cantidad total disponible',
  descripcion varchar(100) null comment 'detalle adicional del artículo',
  fecha_ingreso date not null comment 'fecha en que se registró el artículo',
  estado boolean not null default true comment 'estado del articulo',
  id_usuario tinyint unsigned not null comment 'usuario que registró el articulo',
  constraint fk_inveregistrado foreign key (id_usuario) references usuario (id_usuario)
);

-- tabla: entrenamiento
create table entrenamiento (
  id_entrenamiento tinyint unsigned auto_increment primary key comment 'identificador del entrenamiento',
  descripcion varchar(100) null comment 'detalle breve del entrenamiento',
  fecha date default current_timestamp not null comment 'fecha programada del entrenamiento',
  hora_inicio time not null comment 'hora de inicio del entrenamiento',
  hora_fin time not null comment 'hora de finalización',
  lugar varchar(50) not null comment 'lugar donde se realiza',
  observaciones varchar(100) null comment 'notas u observaciones',
  estado boolean not null default true comment 'estado del entrenamiento',
  id_usuario tinyint unsigned not null comment 'usuario que registró el entrenamiento',
  constraint fk_entreregistrado foreign key (id_usuario ) references usuario (id_usuario)
);

-- tabla: matricula
create table matricula (
  id_matricula tinyint unsigned auto_increment primary key comment 'identificador de la matrícula',
  fecha_matricula date default current_timestamp not null comment 'fecha en que se hizo la matrícula',
  fecha_inicio date not null comment 'fecha de inicio del proceso',
  fecha_fin date not null comment 'fecha de finalización',
  estado boolean not null default true comment 'estado de la matricula',
  observaciones varchar(100) null comment 'notas u observaciones',
  categoria tinyint not null comment 'categoria a la que pertenece el jugador matriculado',
  nivel enum('Bajo','Medio','Alto') not null comment 'nivel a la que pertenece el jugador matriculado',
  id_jugador tinyint unsigned not null comment 'usuario matriculado',
  id_usuario  tinyint unsigned not null comment 'usuario que hizo el registro',
  constraint lf_usermatricula foreign key (id_jugador) references usuario (id_usuario),
  constraint lf_regmatricula foreign key (id_usuario) references usuario (id_usuario)
);

-- tabla: pago
create table pago (
  id_pago tinyint unsigned auto_increment primary key comment 'identificador del pago',
  concepto_pago varchar(100) not null comment 'concepto o motivo del pago',
  fecha_pago date default current_timestamp not null comment 'fecha en que se registro la factura del pago ',
  metodo_pago enum('efectivo','transferencia') null comment 'método utilizado para el pago',
  valor_total bigint unsigned not null comment 'valor total pagado',
  observaciones varchar(100) null comment 'notas adicionales del pago',
  estado boolean not null default false comment 'estado del pago',
  id_usuario tinyint unsigned not null comment 'usuario que registro el pago',
  id_responsable tinyint unsigned not null comment 'usuario que realizo el pago',
  id_matricula tinyint unsigned not null comment 'matrícula relacionada al pago',
  constraint lf_userpago foreign key (id_usuario ) references usuario (id_usuario),
  constraint lf_userrespo foreign key (id_responsable ) references usuario (id_usuario),
  constraint lf_matricula foreign key (id_matricula) references matricula (id_matricula)
);

-- tabla: rendimiento
create table rendimiento (
  id_rendimiento tinyint unsigned auto_increment primary key comment 'identificador del rendimiento',
  fecha_evaluacion date default current_timestamp not null comment 'fecha en que se evaluó',
  posicion varchar(60) not null comment 'posición del jugador evaluado',
  velocidad tinyint not null comment 'valor de velocidad',
  potencia_tiro tinyint not null comment 'valor de potencia de tiro',
  defensa tinyint not null comment 'valor de defensa',
  regate tinyint not null comment 'valor de regate',
  pase tinyint not null comment 'valor de pase',
  tecnica tinyint not null comment 'valor de técnica',
  promedio decimal(5,2) generated always as ((velocidad + potencia_tiro + defensa + regate + pase + tecnica) / 6) stored comment 'promedio general del jugador',
  observaciones varchar(60) null comment 'notas adicionales',
  estado boolean not null default true comment 'estado del rendimiento',
  id_matricula tinyint unsigned not null comment 'jugador evaluado',
  id_entrenamiento tinyint unsigned not null comment 'en que entrenamiento se hizo ese rendimiento',
  id_usuario tinyint unsigned not null comment 'usuario que hizo la evaluación',
  constraint lf_userendi foreign key (id_matricula) references matricula (id_matricula),
  constraint lf_entrenami foreign key (id_entrenamiento) references entrenamiento (id_entrenamiento),
  constraint lf_regrendi foreign key (id_usuario) references usuario (id_usuario)
);

-- tabla: detalles_usuario_rol
create table detalles_usuario_rol (
  id_rol tinyint unsigned not null comment 'id del rol asignado',
  id_usuario tinyint unsigned not null comment 'id del usuario asociado al rol',
  constraint lf_roles foreign key (id_rol) references rol (id_rol),
  constraint lf_userol foreign key (id_usuario) references usuario (id_usuario)
);

-- tabla: detalles_utiliza
create table detalles_utiliza (
  id_utiliza tinyint unsigned auto_increment primary key comment 'identificador del uso de inventario',
  cantidad_usada tinyint not null comment 'cantidad utilizada del artículo',
  observaciones varchar(100) null comment 'notas u observaciones',
  id_entrenamiento tinyint unsigned not null comment 'usuario que usó el artículo',
  id_inventario tinyint unsigned not null comment 'artículo usado',
  constraint lf_utilientrenador foreign key (id_entrenamiento) references entrenamiento (id_entrenamiento),
  constraint lf_articulo foreign key (id_inventario) references inventario (id_inventario)
);

-- tabla: detalles_asiste
create table detalles_asiste (
  id_asiste tinyint unsigned auto_increment primary key comment 'identificador de la asistencia',
  tipo_asistencia enum('asiste','inasiste','llegada tarde') not null comment 'tipo de asistencia registrada',
  justificacion varchar(100) default null comment 'explicación si no asistió o llegó tarde',
  observaciones varchar(100) null comment 'notas u observaciones',
  id_matricula tinyint unsigned not null comment 'jugador que asistió o no',
  id_entrenamiento tinyint unsigned not null comment 'entrenamiento relacionado',
  constraint lf_asisjugador foreign key (id_matricula) references matricula (id_matricula),
  constraint lf_asisentrena foreign key (id_entrenamiento) references entrenamiento(id_entrenamiento)
);
