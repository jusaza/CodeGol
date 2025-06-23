CREATE DATABASE CODEGOL;

USE CODEGOL;

CREATE TABLE USUARIO(
id_usuario int unsigned auto_increment not null primary key,
correo varchar(255) not null unique,
contrasena varchar(255) not null,
nombre_completo varchar(255) not null,
num_identificacion int unsigned not null,
tipo_documento enum("CC", "TI", "CE", "PA", "RC", "PEP", "NIT", "NUIP", "DNI", "PPT") not null,
telefono_1 int unsigned not null,
telefono_2 int unsigned null,
direccion varchar(255) not null,
genero enum("M","F","Otro") not null,
fecha_nacimiento date not null,
lugar_nacimiento varchar(255) null,
grupo_sanguineo enum("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-") not null,
foto_perfil blob null,
estado enum("activo","inactivo") not null,
registrado_por int unsigned not null,
id_responsable int unsigned not null,
foreign key (registrado_por) references USUARIO (id_usuario),
foreign key (id_responsable) references USUARIO (id_usuario)
);

CREATE TABLE INVENTARIO(
id_inventario int unsigned auto_increment not null primary key,
nombre_articulo varchar(255) not null,
cantidad_total tinyint unsigned not null,
descripcion varchar(255) null,
fecha_ingreso date not null,
estado enum("activo","inactivo") not null
);

CREATE TABLE RENDIMIENTO(
id_rendimiento int unsigned auto_increment not null primary key,
fecha_evaluacion date not null,
posicion varchar(255) not null,
categoria_test varchar(255) not null,
tipo_test varchar(255) not null,
unidad tinyint unsigned not null,
resultado tinyint unsigned not null,
observaciones varchar(255) null,
id_jugador int unsigned not null,
registrado_por int unsigned not null,
foreign key (id_jugador) references USUARIO (id_usuario),
foreign key (registrado_por) references USUARIO (id_usuario)
);

CREATE TABLE MATRICULA(
id_matricula int unsigned auto_increment not null primary key,
fecha_matricula date not null,
fecha_inicio date not null,
fecha_fin date not null,
estado enum("activo","inactivo") not null,
observaciones varchar(255) null,
id_jugador int unsigned not null,
registrado_por int unsigned not null,
foreign key (id_jugador) references USUARIO (id_usuario),
foreign key (registrado_por) references USUARIO (id_usuario)
);

CREATE TABLE ENTRENAMIENTO(
id_entrenamiento int unsigned auto_increment not null primary key,
descripcion varchar(255) null,
fecha date not null,
hora_inicio time not null,
hora_fin time not null,
luegar varchar(255) not null,
estado enum("activo","inactivo") not null,
observaciones varchar(255) null,
registrado_por int unsigned not null,
foreign key (registrado_por) references USUARIO (id_usuario)
);

CREATE TABLE PAGO(
id_pago int unsigned auto_increment not null primary key,
concepto_pago varchar(255) not null,
fecha_pago date not null,
metodo_pago varchar(255) not null,
valor_total int unsigned not null,
observaciones varchar(255) null,
pagado_por int unsigned not null,
id_matricula int unsigned not null,
foreign key (pagado_por) references USUARIO (id_usuario),
foreign key (id_matricula) references MATRICULA (id_matricula)
);

CREATE TABLE DETALLES_UTULIZA(
id_utiliza int unsigned auto_increment not null primary key,
fecha_uso date not null,
cantidad_usada tinyint not null,
hora_inicio time not null,
hora_fin time not null,
observaciones varchar(255) null,
id_entrenador int unsigned not null,
id_inventario int unsigned not null,
foreign key (id_entrenador) references USUARIO (id_usuario),
foreign key (id_inventario) references INVENTARIO (id_inventario)
);

CREATE TABLE DETALLES_ASISTE(
id_asiste int unsigned auto_increment not null primary key,
tipo_asistencia enum("Asiste","Inasiste","Llegada tarde") not null,
justificacion varchar(255) null,
observaciones varchar(255) null,
id_jugador int unsigned not null,
registrado_por int unsigned not null,
foreign key (id_jugador) references USUARIO (id_usuario),
foreign key (registrado_por) references ENTRENAMIENTO (id_entrenamiento)
);

CREATE TABLE ROL(
id_rol int unsigned auto_increment not null primary key,
rol_usuario varchar(255) not null
);

CREATE TABLE DETALLES_USUARIO_ROL(
id_rol_usuario int unsigned auto_increment not null primary key,
id_rol int unsigned not null,
id_usuario int unsigned not null,
foreign key (id_rol) references ROL (id_rol),
foreign key (id_usuario) references USUARIO (id_usuario)
);