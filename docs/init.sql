-- cria o banco, se não existir do Plugin AuthMe
CREATE DATABASE IF NOT EXISTS `authmedb`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
-- cria o usuário e define a senha
CREATE USER IF NOT EXISTS 'authme_user'@'%'
  IDENTIFIED BY 'senhasegura123!';
-- dá todos os privilégios sobre authmedb
GRANT ALL PRIVILEGES ON `authmedb`.* TO 'authme_user'@'%';
FLUSH PRIVILEGES;
-- -------------------------------------------------------------

-- Criacao banco do itemJoin
CREATE DATABASE IF NOT EXISTS `itemjoindb`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
-- 2) Cria (ou redefine) o usuário
CREATE USER IF NOT EXISTS 'itemjoindb_user'@'%' IDENTIFIED BY 'itemjoindb_senha123';
GRANT ALL PRIVILEGES ON `itemjoindb`.* TO 'itemjoindb_user'@'%';
FLUSH PRIVILEGES;

-- ------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS `luckpermsdb`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
-- 2) Cria (ou redefine) o usuário
-- 3. Crie o usuário e defina a senha:
CREATE USER 'luckperms_user'@'%' IDENTIFIED BY 'luckperms_password';
-- 4. Conceda todos os privilégios sobre o banco:
GRANT ALL PRIVILEGES ON `luckpermsdb`.* TO 'luckperms_user'@'%';

-- 5. Aplique as alterações:
FLUSH PRIVILEGES;
-- ------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS `quickshopdb`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
-- 3. Crie o usuário e defina a senha:
CREATE USER 'quickshop_user'@'%' IDENTIFIED BY 'passwd431adwwad123';
-- 4. Conceda todos os privilégios sobre o banco:
GRANT ALL PRIVILEGES ON `quickshopdb`.* TO 'quickshop_user'@'%';

-- 5. Aplique as alterações:
FLUSH PRIVILEGES;