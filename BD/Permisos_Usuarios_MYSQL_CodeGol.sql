-- 1. Vamos a iniciar por crear un usuario nuevo desde la consola de MySQL:

-- CREATE USER 'nombre_usuario'@'localhost' IDENTIFIED BY 'tu_contrasena';

CREATE USER 'jeffersoncas'@'localhost' IDENTIFIED BY 'jeffer123';
CREATE USER 'miguelro'@'localhost' IDENTIFIED BY 'sofia123';
CREATE USER 'sofialoza'@'localhost'IDENTIFIED BY 'miguel123';
CREATE USER 'julianalam''@localhost'IDENTIFIED BY 'julian123';

-- 2. Proporcionar el acceso requerido al usuario con la información que requiere.

GRANT ALL PRIVILEGES ON * . * TO 'jeffersoncas'@'localhost'; 
GRANT ALL PRIVILEGES ON * . * TO 'miguelro'@'localhost';
GRANT ALL PRIVILEGES ON * . * TO 'sofialoza'@'localhost';
GRANT ALL PRIVILEGES ON * . * TO 'julianalam'@'localhost';

-- 3. Una vez otorgado los servicios, hay que asegurarse siempre de refrescar todos los privilegios.
FLUSH PRIVILEGES; 

-- 4. Como se vio en sesiones anteriores ingresamos al motor con el usuario nuevo por medio de la sentencia:

-- mysql -h localhost -u jeffersoncas -p

-- mysql -h localhost -u miguelro -p

-- mysql -h localhost -u sofialoza -p

-- mysql -h localhost -u julianalam -p
