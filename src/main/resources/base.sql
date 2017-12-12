-- MySQL Script generated by MySQL Workbench
-- Tue Dec 12 17:17:45 2017
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema pharmacy
-- -----------------------------------------------------
-- Система online-аптека. Клиенты выбирают препарат из списка доступных и заказывают определенное количество. Есть препараты, требующие рецепта врача. Врач может назначить клиенту рецепт. Администратор может банить пользоваетелей.

-- -----------------------------------------------------
-- Schema pharmacy
--
-- Система online-аптека. Клиенты выбирают препарат из списка доступных и заказывают определенное количество. Есть препараты, требующие рецепта врача. Врач может назначить клиенту рецепт. Администратор может банить пользоваетелей.
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pharmacy` DEFAULT CHARACTER SET utf8 ;
USE `pharmacy` ;

-- -----------------------------------------------------
-- Table `pharmacy`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pharmacy`.`user` (
  `id` MEDIUMINT(7) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Идентификационный номер пользователя',
  `name` VARCHAR(20) NOT NULL COMMENT 'Имя пользователя',
  `surname` VARCHAR(25) NOT NULL COMMENT 'Фамилия пользователя',
  `patronymic` VARCHAR(45) NULL COMMENT 'Отчество пользователя',
  `login` VARCHAR(20) NOT NULL COMMENT 'Логин пользователя',
  `password` VARCHAR(64) NOT NULL COMMENT 'Пароль пользователя',
  `role` ENUM('doctor', 'user', 'admin', 'pharmacist') NOT NULL DEFAULT 'user' COMMENT 'Роль пользователя в рамках системы, поумолчанию \'client\', так как любой пользователь, только прошедший регистрацию является клиентом',
  `email` VARCHAR(25) NULL,
  `phone` VARCHAR(20) NULL,
  PRIMARY KEY (`id`),
  INDEX `login_idx` (`login` ASC)  COMMENT 'Индексация поля, хранящего логин, нужна так как это в наиболее часто используемых запросах используется данное поле ',
  UNIQUE INDEX `login_UNIQUE` (`login` ASC)  COMMENT 'В системе при авторизации и регистрации происходит поиск по логину ')
ENGINE = InnoDB
COMMENT = 'Таблица, хранящая информацию о пользователях';


-- -----------------------------------------------------
-- Table `pharmacy`.`country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pharmacy`.`country` (
  `id` SMALLINT(3) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Идентификационный номер стран',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Таблица, хранящая страны';


-- -----------------------------------------------------
-- Table `pharmacy`.`manufacturer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pharmacy`.`manufacturer` (
  `id` MEDIUMINT(7) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Идентификацииный номер производителя',
  `phone_number` VARCHAR(20) NULL,
  `country_id` SMALLINT(3) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_country_id_idx` (`country_id` ASC),
  CONSTRAINT `fk_country_id`
    FOREIGN KEY (`country_id`)
    REFERENCES `pharmacy`.`country` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Таблица, хранящая производителей препаратов';


-- -----------------------------------------------------
-- Table `pharmacy`.`drug`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pharmacy`.`drug` (
  `id` MEDIUMINT(7) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Идентификационный номер препарата',
  `manufacurer_id` MEDIUMINT(7) UNSIGNED NOT NULL COMMENT 'Идентификационный номер производителя данного препарата',
  `dosage` VARCHAR(45) NOT NULL COMMENT 'Дозировка препарата',
  `amount` VARCHAR(45) NOT NULL COMMENT 'Количество препарата в упаковке(шт)',
  `number` MEDIUMINT(7) NOT NULL DEFAULT 0 COMMENT 'Количество упаковок перапарата на складе(шт)',
  `price` DECIMAL(6,2) NOT NULL COMMENT 'Цена препарата',
  `need_presciption` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Нужен ли рецепт для заказа',
  PRIMARY KEY (`id`),
  INDEX `manufacturer_id_idx` (`manufacurer_id` ASC),
  CONSTRAINT `fk_manufacturer_id`
    FOREIGN KEY (`manufacurer_id`)
    REFERENCES `pharmacy`.`manufacturer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Таблица, содержащая характеристики препаратов';


-- -----------------------------------------------------
-- Table `pharmacy`.`language`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pharmacy`.`language` (
  `code` VARCHAR(5) NOT NULL COMMENT 'Код языка',
  `name` VARCHAR(15) NOT NULL COMMENT 'Название языка',
  PRIMARY KEY (`code`))
ENGINE = InnoDB
COMMENT = 'Таблица, хранящая языки локализации';


-- -----------------------------------------------------
-- Table `pharmacy`.`drug_translate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pharmacy`.`drug_translate` (
  `drug_id` MEDIUMINT(7) UNSIGNED NOT NULL COMMENT 'Идентификационный номер препарата',
  `lang_code` VARCHAR(5) NOT NULL COMMENT 'Код языка локализации',
  `name` VARCHAR(20) NOT NULL COMMENT 'Наименование препарата',
  `description` VARCHAR(45) NULL COMMENT 'Описание препарата',
  `composition` VARCHAR(45) NULL COMMENT 'Состав препарата',
  INDEX `drug_id_idx` (`drug_id` ASC),
  INDEX `lang_code_idx` (`lang_code` ASC),
  INDEX `name_idx` (`name` ASC)  COMMENT 'Постоянно используется поиск по наименованию, сортировка по наименованию ',
  CONSTRAINT `fk_drug_id`
    FOREIGN KEY (`drug_id`)
    REFERENCES `pharmacy`.`drug` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_language_code`
    FOREIGN KEY (`lang_code`)
    REFERENCES `pharmacy`.`language` (`code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Таблица, хранящая локализованную информацию о препаратах';


-- -----------------------------------------------------
-- Table `pharmacy`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pharmacy`.`order` (
  `client_id` MEDIUMINT(7) UNSIGNED NOT NULL COMMENT 'Идентификационный номер пользователя',
  `drug_id` MEDIUMINT(7) UNSIGNED NOT NULL COMMENT 'Идентификационный номер препарата',
  `number` SMALLINT(3) NOT NULL COMMENT 'Количество упаковок препарата, заказанного пользоваетелем',
  INDEX `drug_id_idx` (`drug_id` ASC),
  INDEX `client_id_idx` (`client_id` ASC),
  CONSTRAINT `a`
    FOREIGN KEY (`drug_id`)
    REFERENCES `pharmacy`.`drug` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `b`
    FOREIGN KEY (`client_id`)
    REFERENCES `pharmacy`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Таблица, хранящая заказы клиентов';


-- -----------------------------------------------------
-- Table `pharmacy`.`manufacturer_translate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pharmacy`.`manufacturer_translate` (
  `language_code` VARCHAR(5) NOT NULL,
  `manufacturer_id` MEDIUMINT(7) UNSIGNED NOT NULL,
  `name` VARCHAR(20) NOT NULL,
  INDEX `language_code_idx` (`language_code` ASC),
  INDEX `manufacturer_id_idx` (`manufacturer_id` ASC),
  CONSTRAINT `fk_manufacturer_id_1`
    FOREIGN KEY (`manufacturer_id`)
    REFERENCES `pharmacy`.`manufacturer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_language_code_1`
    FOREIGN KEY (`language_code`)
    REFERENCES `pharmacy`.`language` (`code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pharmacy`.`country_translate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pharmacy`.`country_translate` (
  `country_id` SMALLINT(3) UNSIGNED NOT NULL COMMENT 'Идентификационный номер страны',
  `language_code` VARCHAR(5) NOT NULL COMMENT 'Код языка',
  `name` VARCHAR(20) NOT NULL,
  INDEX `country_id_idx` (`country_id` ASC),
  INDEX `language_code_idx` (`language_code` ASC),
  CONSTRAINT `fk_country_id2`
    FOREIGN KEY (`country_id`)
    REFERENCES `pharmacy`.`country` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_language_code2`
    FOREIGN KEY (`language_code`)
    REFERENCES `pharmacy`.`language` (`code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Таблица, хранящая локализованные названия стран';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
