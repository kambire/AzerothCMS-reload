-- ================================================================
-- Script de inicialización de bases de datos para FusionCMS
-- Se ejecuta automáticamente la primera vez que arranca MariaDB
-- ================================================================

-- Base de datos del CMS (webespy)
CREATE DATABASE IF NOT EXISTS `webespy`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

-- Base de datos de autenticación WoW (copia local para el CMS)
CREATE DATABASE IF NOT EXISTS `acore_auth`
  CHARACTER SET utf8
  COLLATE utf8_general_ci;

-- Asignar permisos al usuario root (ya tiene acceso total)
-- También al usuario fusioncms por si se necesita
GRANT ALL PRIVILEGES ON `webespy`.* TO 'fusioncms'@'%';
GRANT ALL PRIVILEGES ON `acore_auth`.* TO 'fusioncms'@'%';
GRANT ALL PRIVILEGES ON `fusioncms`.* TO 'fusioncms'@'%';

FLUSH PRIVILEGES;
