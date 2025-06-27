-- --------------------------------------------------------
create database codegol;

use codegol;
-- --------------------------------------------------------
-- tabla: usuario
create table usuario (
  id_usuario tinyint unsigned auto_increment primary key,
  correo varchar(60) not null,
  contrasena varchar(60) not null,
  nombre_completo varchar(60) not null,
  num_identificacion int unsigned not null,
  tipo_documento enum('cc','ti','ce','pa','rc','pep','nit','nuip','dni','ppt') not null,
  telefono_1 bigint unsigned not null,
  telefono_2 bigint unsigned null,
  direccion varchar(50) not null,
  genero enum('m','f','otro') not null,
  fecha_nacimiento date not null,
  lugar_nacimiento varchar(50) null,
  grupo_sanguineo enum('a+','a-','b+','b-','ab+','ab-','o+','o-') not null,
  foto_perfil blob default null,
  estado enum('activo','inactivo') not null,
  registrado_por tinyint unsigned not null default 1,
  id_responsable tinyint unsigned not null,
  constraint fk_usuario_registrado_por foreign key (registrado_por) references usuario (id_usuario),
  constraint fk_useresponsable foreign key (id_responsable) references usuario (id_usuario)
);

-- tabla: rol
create table rol (
  id_rol tinyint unsigned auto_increment primary key,
  rol_usuario varchar(30) not null
);

-- tabla: inventario
create table inventario (
  id_inventario tinyint unsigned auto_increment primary key,
  nombre_articulo varchar(50) not null,
  cantidad_total tinyint unsigned not null,
  descripcion varchar(100) null,
  fecha_ingreso date not null,
  estado enum('activo','inactivo') not null
);

-- tabla: entrenamiento
create table entrenamiento (
  id_entrenamiento tinyint unsigned auto_increment primary key,
  descripcion varchar(100) null,
  fecha date default current_timestamp not null,
  hora_inicio time not null,
  hora_fin time not null,
  lugar varchar(50) not null,
  observaciones varchar(100) null,
  estado enum('activo','inactivo') not null,
  registrado_por tinyint unsigned not null,
  constraint fk_entreregistrado foreign key (registrado_por) references usuario (id_usuario)
);

-- tabla: matricula
create table matricula (
  id_matricula tinyint unsigned auto_increment primary key,
  fecha_matricula date default current_timestamp not null,    
  fecha_inicio date not null,
  fecha_fin date not null,
  estado enum('activo','inactivo') not null,
  observaciones varchar(100) null,
  id_jugador tinyint unsigned not null,
  registrado_por tinyint unsigned not null,
  constraint lf_usermatricula foreign key (id_jugador) references usuario (id_usuario),
  constraint lf_regmatricula foreign key (registrado_por) references usuario (id_usuario)
);

-- tabla: pago
create table pago (
  id_pago tinyint unsigned auto_increment primary key,
  concepto_pago varchar(100) not null,
  fecha_pago date default current_timestamp not null,
  metodo_pago enum('efectivo','transferencia') not null,
  valor_total bigint unsigned not null,
  observaciones varchar(100) null,
  pagado_por tinyint unsigned not null,
  id_matricula tinyint unsigned not null,
  constraint lf_userpago foreign key (pagado_por) references usuario (id_usuario),
  constraint lf_matricula foreign key (id_matricula) references matricula (id_matricula)
);

-- tabla: rendimiento
create table rendimiento (
  id_rendimiento tinyint unsigned auto_increment primary key,
  fecha_evaluacion date default current_timestamp not null,
  posicion varchar(60) not null,
  unidad_medida varchar(20) not null,
  velocidad tinyint not null,
  potencia_tiro tinyint not null,
  defensa tinyint not null,
  regate tinyint not null,
  pase tinyint not null,
  tecnica tinyint not null,
  promedio decimal (5,2) generated always as ((velocidad + potencia_tiro + defensa + regate + pase + tecnica) / 6) stored,  observaciones varchar(60) null,
  estado enum('activo','inactivo') not null,
  id_jugador tinyint unsigned not null,
  registrado_por tinyint unsigned not null,
  constraint lf_userendi foreign key (id_jugador) references usuario (id_usuario),
  constraint lf_regrendi foreign key (registrado_por) references usuario (id_usuario)
);

-- tabla: detalles_usuario_rol
create table detalles_usuario_rol (
  id_rol tinyint unsigned not null,
  id_usuario tinyint unsigned not null,
  constraint lf_roles foreign key (id_rol) references rol (id_rol),
  constraint lf_userol foreign key (id_usuario) references usuario (id_usuario)
);

-- tabla: detalles_utiliza
create table detalles_utiliza (
  id_utiliza tinyint unsigned auto_increment primary key,
  fecha_uso date default current_timestamp not null,
  cantidad_usada tinyint not null,
  hora_inicio time not null,
  hora_fin time not null,
  observaciones varchar(100) null,
  id_entrenador tinyint unsigned not null,
  id_inventario tinyint unsigned not null,
  constraint lf_utilientrenador foreign key (id_entrenador) references usuario (id_usuario),
  constraint lf_articulo foreign key (id_inventario) references inventario (id_inventario)
);

-- tabla: detalles_asiste
create table detalles_asiste (
  id_asiste tinyint unsigned auto_increment primary key,
  tipo_asistencia enum('asiste','inasiste','llegada tarde') not null,
  justificacion varchar(100) default null,
  observaciones varchar(100) null,
  id_jugador tinyint unsigned not null,
  id_entrenamiento tinyint unsigned not null,
  constraint lf_asisjugador foreign key (id_jugador) references usuario (id_usuario),
  constraint lf_asisentrena foreign key (id_entrenamiento) references entrenamiento(id_entrenamiento)
);
