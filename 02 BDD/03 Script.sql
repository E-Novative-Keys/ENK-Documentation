SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `enkwebservice` ;
CREATE SCHEMA IF NOT EXISTS `enkwebservice` ;
USE `enkwebservice` ;

-- -----------------------------------------------------
-- Table `enkwebservice`.`downloads`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `enkwebservice`.`downloads` ;

CREATE TABLE IF NOT EXISTS `enkwebservice`.`downloads` (
  `id` INT(7) UNSIGNED NOT NULL AUTO_INCREMENT,
  `file` TEXT NOT NULL,
  `token` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `enkwebservice`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `enkwebservice`.`users` ;

CREATE TABLE IF NOT EXISTS `enkwebservice`.`users` (
  `id` INT(7) UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(40) NOT NULL,
  `firstname` VARCHAR(30) NOT NULL,
  `lastname` VARCHAR(30) NOT NULL,
  `role` ENUM('employee', 'trainee', 'developer', 'leaddev', 'admin') NOT NULL DEFAULT 'employee',
  `validated` TINYINT(1) NULL DEFAULT 0,
  `token` VARCHAR(40) NULL DEFAULT NULL,
  `token_email` VARCHAR(40) NULL DEFAULT NULL,
  `lastip` VARCHAR(100) NULL DEFAULT NULL,
  `lastlogin` DATETIME NULL DEFAULT NULL,
  `created` DATETIME NOT NULL,
  `updated` DATETIME NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `enkwebservice`.`projects`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `enkwebservice`.`projects` ;

CREATE TABLE IF NOT EXISTS `enkwebservice`.`projects` (
  `id` INT(7) UNSIGNED NOT NULL AUTO_INCREMENT,
  `client_id` INT(7) UNSIGNED NOT NULL,
  `lead_id` INT(7) UNSIGNED NOT NULL,
  `name` VARCHAR(100) NOT NULL DEFAULT 'Project',
  `description` TEXT NULL DEFAULT NULL,
  `deadline` DATETIME NOT NULL,
  `estimation` DOUBLE UNSIGNED NOT NULL DEFAULT 0,
  `budget` DOUBLE UNSIGNED NOT NULL DEFAULT 0,
  `discount` DOUBLE UNSIGNED NOT NULL DEFAULT 0,
  `created` DATETIME NOT NULL,
  `updated` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_projects_has_lead_dev_idx` (`lead_id` ASC),
  CONSTRAINT `fk_projects_has_lead_dev`
    FOREIGN KEY (`lead_id`)
    REFERENCES `enkwebservice`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `enkwebservice`.`notifications`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `enkwebservice`.`notifications` ;

CREATE TABLE IF NOT EXISTS `enkwebservice`.`notifications` (
  `id` INT(7) UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` INT(7) UNSIGNED NOT NULL,
  `content` VARCHAR(255) NOT NULL,
  `created` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_notifications_projects1_idx` (`project_id` ASC),
  CONSTRAINT `fk_notifications_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES `enkwebservice`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `enkwebservice`.`macrotasks`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `enkwebservice`.`macrotasks` ;

CREATE TABLE IF NOT EXISTS `enkwebservice`.`macrotasks` (
  `id` INT(7) UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` INT(7) UNSIGNED NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `deadline` DATETIME NOT NULL,
  `hour` TINYINT(2) NOT NULL DEFAULT 12,
  `minute` TINYINT(2) NOT NULL DEFAULT 0,
  `priority` TINYINT(2) NOT NULL DEFAULT 1,
  `progress` TINYINT(2) UNSIGNED NOT NULL DEFAULT 0,
  `created` DATETIME NOT NULL,
  `updated` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_macrotasks_projects1_idx` (`project_id` ASC),
  CONSTRAINT `fk_macrotasks_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES `enkwebservice`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `enkwebservice`.`tasks`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `enkwebservice`.`tasks` ;

CREATE TABLE IF NOT EXISTS `enkwebservice`.`tasks` (
  `id` INT(7) UNSIGNED NOT NULL AUTO_INCREMENT,
  `macrotask_id` INT(7) UNSIGNED NOT NULL,
  `name` VARCHAR(100) NOT NULL DEFAULT 'Task',
  `priority` TINYINT(2) NOT NULL DEFAULT 1,
  `progress` TINYINT(2) UNSIGNED NOT NULL DEFAULT 0,
  `created` DATETIME NOT NULL,
  `hours` DOUBLE UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `fk_tasks_macrotasks1_idx` (`macrotask_id` ASC),
  CONSTRAINT `fk_tasks_macrotasks1`
    FOREIGN KEY (`macrotask_id`)
    REFERENCES `enkwebservice`.`macrotasks` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `enkwebservice`.`files`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `enkwebservice`.`files` ;

CREATE TABLE IF NOT EXISTS `enkwebservice`.`files` (
  `id` INT(7) UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` INT(7) UNSIGNED NOT NULL,
  `file` VARCHAR(255) NOT NULL,
  `comment` VARCHAR(255) NULL DEFAULT NULL,
  `created` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_files_projects1_idx` (`project_id` ASC),
  CONSTRAINT `fk_files_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES `enkwebservice`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `enkwebservice`.`mails`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `enkwebservice`.`mails` ;

CREATE TABLE IF NOT EXISTS `enkwebservice`.`mails` (
  `id` INT(7) UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` INT(7) UNSIGNED NOT NULL,
  `to` INT(7) UNSIGNED DEFAULT NULL,
  `object` VARCHAR(100) NOT NULL,
  `content` TEXT NOT NULL,
  `created` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_mails_projects1_idx` (`project_id` ASC),
  CONSTRAINT `fk_mails_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES `enkwebservice`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `enkwebservice`.`macrotasks_users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `enkwebservice`.`macrotasks_users` ;

CREATE TABLE IF NOT EXISTS `enkwebservice`.`macrotasks_users` (
  `id` INT(7) UNSIGNED NOT NULL AUTO_INCREMENT,
  `macrotask_id` INT(7) UNSIGNED NOT NULL,
  `user_id` INT(7) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `macrotask_id`, `user_id`),
  INDEX `fk_macrotasks_has_users_users1_idx` (`user_id` ASC),
  INDEX `fk_macrotasks_has_users_macrotasks1_idx` (`macrotask_id` ASC),
  CONSTRAINT `fk_macrotasks_has_users_macrotasks1`
    FOREIGN KEY (`macrotask_id`)
    REFERENCES `enkwebservice`.`macrotasks` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_macrotasks_has_users_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `enkwebservice`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `enkwebservice`.`clients_mails`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `enkwebservice`.`clients_mails` ;

CREATE TABLE IF NOT EXISTS `enkwebservice`.`clients_mails` (
  `id` INT(7) UNSIGNED NOT NULL AUTO_INCREMENT,
  `client_id` INT(7) UNSIGNED NOT NULL,
  `mail_id` INT(7) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `mail_id`, `client_id`),
  INDEX `fk_clients_has_mails_mails1_idx` (`mail_id` ASC),
  CONSTRAINT `fk_clients_has_mails_mails1`
    FOREIGN KEY (`mail_id`)
    REFERENCES `enkwebservice`.`mails` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `enkwebservice`.`users_projects`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `enkwebservice`.`users_projects` ;

CREATE TABLE IF NOT EXISTS `enkwebservice`.`users_projects` (
  `id` INT(7) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT(7) UNSIGNED NOT NULL,
  `project_id` INT(7) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `user_id`, `project_id`),
  INDEX `fk_users_has_projects_projects1_idx` (`project_id` ASC),
  INDEX `fk_users_has_projects_users1_idx` (`user_id` ASC),
  CONSTRAINT `fk_users_has_projects_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `enkwebservice`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_projects_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES `enkwebservice`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `enkwebservice`.`projects_mails`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `enkwebservice`.`projects_mails` ;

CREATE TABLE IF NOT EXISTS `enkwebservice`.`projects_mails` (
  `id` INT(7) UNSIGNED NOT NULL AUTO_INCREMENT,
  `mail_id` INT(7) UNSIGNED NOT NULL,
  `project_id` INT(7) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `mail_id`, `project_id`),
  INDEX `fk_mails_has_projects_projects1_idx` (`project_id` ASC),
  INDEX `fk_mails_has_projects_mails1_idx` (`mail_id` ASC),
  CONSTRAINT `fk_mails_has_projects_mails1`
    FOREIGN KEY (`mail_id`)
    REFERENCES `enkwebservice`.`mails` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_mails_has_projects_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES `enkwebservice`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Data for table `enkwebservice`.`users`
-- -----------------------------------------------------
START TRANSACTION;
USE `enkwebservice`;
INSERT INTO `enkwebservice`.`users` (`id`, `email`, `password`, `firstname`, `lastname`, `role`, `validated`, `token`, `lastip`, `lastlogin`, `created`, `updated`) VALUES (1, 'mathieu@enkeys.com', 'a2a37145faf1571c7012ff5986876014800e88e9', 'Mathieu', 'BOISNARD', 'admin', 1, NULL, '127.0.0.1', '2015-02-27 23:15:43', '2015-02-27 23:15:43', '2015-02-27 23:15:43');

COMMIT;


-- -----------------------------------------------------
-- Data for table `enkwebservice`.`projects`
-- -----------------------------------------------------
START TRANSACTION;
USE `enkwebservice`;
INSERT INTO `enkwebservice`.`projects` (`id`, `client_id`, `lead_id`, `name`, `description`, `deadline`, `estimation`, `budget`, `discount`, `created`, `updated`) VALUES (1, 1, 1, 'Projet Test', 'Test', '2015-05-27 23:15:43', 123456789, 123456789, 0, '2015-02-27 23:15:43', '2015-02-27 23:15:43');

COMMIT;

-- -----------------------------------------------------
-- Data for table `enkwebservice`.`users_projects`
-- -----------------------------------------------------
START TRANSACTION;
USE `enkwebservice`;
INSERT INTO `enkwebservice`.`users_projects` (`id`, `user_id`, `project_id`) VALUES (1, 1, 1);

COMMIT;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
