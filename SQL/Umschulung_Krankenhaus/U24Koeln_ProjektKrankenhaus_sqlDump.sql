-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Krankenhaus
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Krankenhaus` ;

-- -----------------------------------------------------
-- Schema Krankenhaus
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Krankenhaus` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
USE `Krankenhaus` ;

-- -----------------------------------------------------
-- Table `Krankenhaus`.`VersicherungsStatus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`VersicherungsStatus` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`VersicherungsStatus` (
  `idVersicherungsStatus` INT NOT NULL AUTO_INCREMENT,
  `VersicherungsArt` VARCHAR(45) NULL,
  `Daten` VARCHAR(45) NULL,
  PRIMARY KEY (`idVersicherungsStatus`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Patient`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Patient` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Patient` (
  `idPatient` INT NOT NULL AUTO_INCREMENT,
  `VersicherungsStatus_idVersicherungsStatus` INT NOT NULL,
  `Vorname` VARCHAR(45) NULL,
  `Nachname` VARCHAR(45) NULL,
  `Geburtsdatum` DATE NULL,
  `Geschlecht` ENUM("m", "w", "d") NULL,
  `Krankengeschichte` LONGBLOB NULL,
  `Strasse` VARCHAR(45) NULL,
  `Hausnummer` VARCHAR(45) NULL,
  `PLZ` INT NULL,
  `Ort` VARCHAR(45) NULL,
  PRIMARY KEY (`idPatient`, `VersicherungsStatus_idVersicherungsStatus`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Krankenhaus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Krankenhaus` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Krankenhaus` (
  `idKrankenhaus` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  `Strasse` VARCHAR(45) NULL,
  `Hausnummer` VARCHAR(45) NULL,
  `PLZ` INT NULL,
  `Ort` VARCHAR(45) NULL,
  PRIMARY KEY (`idKrankenhaus`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Mitarbeiter`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Mitarbeiter` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Mitarbeiter` (
  `idMitarbeiter` INT NOT NULL AUTO_INCREMENT,
  `Stellenbezeichnung` VARCHAR(45) NULL,
  `Vorname` VARCHAR(45) NULL,
  `Nachname` VARCHAR(45) NULL,
  `Stundenlohn` DECIMAL(10,2) NULL,
  `Krankenhaus_idKrankenhaus` INT NOT NULL,
  `Arbeitsvertrag` LONGBLOB NULL,
  `Ueberstundenzulage` DECIMAL(4,2) NULL,
  PRIMARY KEY (`idMitarbeiter`, `Krankenhaus_idKrankenhaus`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`RaumArt`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`RaumArt` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`RaumArt` (
  `idRaumart` INT NOT NULL AUTO_INCREMENT,
  `RaumArt` VARCHAR(45) NULL,
  PRIMARY KEY (`idRaumart`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Station`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Station` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Station` (
  `idStation` INT NOT NULL AUTO_INCREMENT,
  `Bezeichnung` VARCHAR(45) NULL,
  PRIMARY KEY (`idStation`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Raum`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Raum` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Raum` (
  `idRaum` INT NOT NULL AUTO_INCREMENT,
  `Stockwerk` INT NULL,
  `RaumNr` INT NULL,
  `Station_idStation` INT NOT NULL,
  `Flaeche` DECIMAL NULL,
  `AnzahlFenster` INT NULL,
  `Raumart_idRaumart` INT NOT NULL,
  `Krankenhaus_idKrankenhaus` INT NOT NULL,
  PRIMARY KEY (`idRaum`, `Station_idStation`, `Raumart_idRaumart`, `Krankenhaus_idKrankenhaus`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`TaetigkeitenKategorie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`TaetigkeitenKategorie` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`TaetigkeitenKategorie` (
  `idTaetigkeitenKategorie` INT NOT NULL AUTO_INCREMENT,
  `KategorieBezeichnung` VARCHAR(45) NULL,
  PRIMARY KEY (`idTaetigkeitenKategorie`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Taetigkeit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Taetigkeit` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Taetigkeit` (
  `idTaetigkeit` INT NOT NULL AUTO_INCREMENT,
  `TaetigkeitenBezeichnung` VARCHAR(45) NULL,
  `Dauer` TIME NULL,
  `Preis` DECIMAL NULL,
  `TaetigkeitenKategorie_idTaetigkeitenKategorie` INT NOT NULL,
  `brauchtPatienten` TINYINT NULL,
  `reserviertPatienten` TINYINT NULL,
  PRIMARY KEY (`idTaetigkeit`, `TaetigkeitenKategorie_idTaetigkeitenKategorie`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Aufgabenplan`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Aufgabenplan` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Aufgabenplan` (
  `idAufgabenplan` INT NOT NULL AUTO_INCREMENT,
  `erledigt` TINYINT NULL DEFAULT 0,
  `Beschreibung` VARCHAR(999) NULL,
  `AufgabenStart` DATETIME NULL,
  `AufgabenEnde` DATETIME NULL,
  `Taetigkeit_idTaetigkeit` INT NOT NULL,
  PRIMARY KEY (`idAufgabenplan`, `Taetigkeit_idTaetigkeit`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`AusstatungsKategorie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`AusstatungsKategorie` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`AusstatungsKategorie` (
  `idAusstatungsKategorie` INT NOT NULL AUTO_INCREMENT,
  `KategorieBezeichnung` VARCHAR(45) NULL,
  PRIMARY KEY (`idAusstatungsKategorie`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Ausstattung`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Ausstattung` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Ausstattung` (
  `idAusstattung` INT NOT NULL AUTO_INCREMENT,
  `ObjektBezeichnung` VARCHAR(45) NULL,
  `MengeImLager` INT NULL,
  `Datum` DATETIME NULL,
  `AusstatungsKategorie_idAusstatungsKategorie` INT NOT NULL,
  PRIMARY KEY (`idAusstattung`, `AusstatungsKategorie_idAusstatungsKategorie`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Raum_has_Ausstattung`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Raum_has_Ausstattung` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Raum_has_Ausstattung` (
  `Ausstattung_idAusstattung` INT NOT NULL,
  `Raum_idRaum` INT NOT NULL,
  `Menge` INT NULL,
  PRIMARY KEY (`Ausstattung_idAusstattung`, `Raum_idRaum`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Aufgabenplan_has_Raum`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Aufgabenplan_has_Raum` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Aufgabenplan_has_Raum` (
  `Raum_idRaum` INT NOT NULL,
  `Aufgabenplan_idArbeitsplan` INT NOT NULL,
  `besetzt` TINYINT NULL,
  PRIMARY KEY (`Raum_idRaum`, `Aufgabenplan_idArbeitsplan`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Zahlungsart`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Zahlungsart` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Zahlungsart` (
  `idZahlungsart` INT NOT NULL AUTO_INCREMENT,
  `Bezeichnung` VARCHAR(45) NULL,
  `ZahlungsInfos` VARCHAR(999) NULL,
  PRIMARY KEY (`idZahlungsart`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Fachkompetenz`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Fachkompetenz` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Fachkompetenz` (
  `idFachkompetenz` INT NOT NULL AUTO_INCREMENT,
  `Bezeichnung` VARCHAR(45) NULL,
  PRIMARY KEY (`idFachkompetenz`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Rechnung`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Rechnung` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Rechnung` (
  `idRechnung` INT NOT NULL AUTO_INCREMENT,
  `Patient_idPatient` INT NOT NULL,
  `Zahlungsart_idZahlungsart` INT NOT NULL,
  `DatumVon` DATE NULL,
  `DatumBis` DATE NULL,
  PRIMARY KEY (`idRechnung`, `Patient_idPatient`, `Zahlungsart_idZahlungsart`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Medikament`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Medikament` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Medikament` (
  `idMedikament` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  `MengeImLager` DECIMAL NULL,
  `Einheit` VARCHAR(45) NULL,
  `Datum` DATETIME NULL,
  PRIMARY KEY (`idMedikament`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Taetigkeit_braucht_Ausstattung`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Taetigkeit_braucht_Ausstattung` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Taetigkeit_braucht_Ausstattung` (
  `Ausstattung_idAusstattung` INT NOT NULL,
  `Taetigkeit_idTaetigkeit` INT NOT NULL,
  `Menge` INT NULL,
  PRIMARY KEY (`Ausstattung_idAusstattung`, `Taetigkeit_idTaetigkeit`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Taetigkeit_braucht_Medikament`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Taetigkeit_braucht_Medikament` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Taetigkeit_braucht_Medikament` (
  `Taetigkeit_idTaetigkeit` INT NOT NULL,
  `Medikament_idMedikament` INT NOT NULL,
  `Menge` DECIMAL NULL,
  `Einheit` VARCHAR(45) NULL,
  PRIMARY KEY (`Taetigkeit_idTaetigkeit`, `Medikament_idMedikament`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Werkzeug`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Werkzeug` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Werkzeug` (
  `idWerkzeug` INT NOT NULL AUTO_INCREMENT,
  `WerkzeugArt` VARCHAR(45) NULL,
  `MengeImLager` INT NULL,
  `Datum` DATETIME NULL,
  PRIMARY KEY (`idWerkzeug`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Taetigkeit_braucht_Werkzeug`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Taetigkeit_braucht_Werkzeug` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Taetigkeit_braucht_Werkzeug` (
  `Werkzeug_idWerkzeug` INT NOT NULL,
  `Taetigkeit_idTaetigkeit` INT NOT NULL,
  `Menge` INT NULL,
  PRIMARY KEY (`Werkzeug_idWerkzeug`, `Taetigkeit_idTaetigkeit`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Chemikalie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Chemikalie` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Chemikalie` (
  `idChemikalie` INT NOT NULL AUTO_INCREMENT,
  `ChemikalienArt` VARCHAR(45) NULL,
  `MengeImLager` DECIMAL NULL,
  `Einheit` VARCHAR(45) NULL,
  `Datum` DATETIME NULL,
  PRIMARY KEY (`idChemikalie`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Taetigkeit_braucht_Chemikalie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Taetigkeit_braucht_Chemikalie` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Taetigkeit_braucht_Chemikalie` (
  `Taetigkeit_idTaetigkeit` INT NOT NULL,
  `Chemikalie_idChemikalie` INT NOT NULL,
  `Menge` DECIMAL NULL,
  `Einheit` VARCHAR(45) NULL,
  PRIMARY KEY (`Taetigkeit_idTaetigkeit`, `Chemikalie_idChemikalie`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Behandlungsplan`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Behandlungsplan` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Behandlungsplan` (
  `idBehandlungsplan` INT NOT NULL AUTO_INCREMENT,
  `Patient_idPatient` INT NOT NULL,
  `Beschreibung` VARCHAR(999) NULL,
  `DatumVon` DATE NULL,
  `DatumBis` DATE NULL,
  PRIMARY KEY (`idBehandlungsplan`, `Patient_idPatient`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Schicht`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Schicht` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Schicht` (
  `idSchicht` INT NOT NULL AUTO_INCREMENT,
  `SchichtStart` TIME NULL,
  `SchichtDauer` TIME NULL DEFAULT TIME("08:00:00"),
  `SchichtBezeichnung` VARCHAR(45) NULL,
  PRIMARY KEY (`idSchicht`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Mitarbeiter_has_Schichtt`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Mitarbeiter_has_Schichtt` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Mitarbeiter_has_Schichtt` (
  `Schichtt_idSchicht` INT NOT NULL,
  `Mitarbeiter_idMitarbeiter` INT NOT NULL,
  `RealSchichtStart` DATETIME NULL,
  `RealSchichtEnde` DATETIME NULL,
  `SchichtDatum` DATETIME NULL,
  PRIMARY KEY (`Schichtt_idSchicht`, `Mitarbeiter_idMitarbeiter`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Aufgabenplan_has_Patient`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Aufgabenplan_has_Patient` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Aufgabenplan_has_Patient` (
  `Aufgabenplan_idAufgabenplan` INT NOT NULL,
  `Patient_idPatient` INT NOT NULL,
  PRIMARY KEY (`Aufgabenplan_idAufgabenplan`, `Patient_idPatient`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Station_has_Taetigkeit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Station_has_Taetigkeit` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Station_has_Taetigkeit` (
  `Station_idStation` INT NOT NULL,
  `Taetigkeit_idTaetigkeit` INT NOT NULL,
  PRIMARY KEY (`Station_idStation`, `Taetigkeit_idTaetigkeit`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Mitarbeiter_has_Fachkompetenz`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Mitarbeiter_has_Fachkompetenz` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Mitarbeiter_has_Fachkompetenz` (
  `Mitarbeiter_idMitarbeiter` INT NOT NULL,
  `Fachkompetenz_idFachkompetenz` INT NOT NULL,
  PRIMARY KEY (`Mitarbeiter_idMitarbeiter`, `Fachkompetenz_idFachkompetenz`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Taetigkeit_braucht_Fachkompetenz`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Taetigkeit_braucht_Fachkompetenz` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Taetigkeit_braucht_Fachkompetenz` (
  `Taetigkeit_idTaetigkeit` INT NOT NULL,
  `Fachkompetenz_idFachkompetenz` INT NOT NULL,
  `Anzahl` INT NULL,
  PRIMARY KEY (`Taetigkeit_idTaetigkeit`, `Fachkompetenz_idFachkompetenz`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Aufgabenplan_has_Mitarbeiter`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Aufgabenplan_has_Mitarbeiter` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Aufgabenplan_has_Mitarbeiter` (
  `Mitarbeiter_idMitarbeiter` INT NOT NULL,
  `Aufgabenplan_idAufgabenplan` INT NOT NULL,
  PRIMARY KEY (`Mitarbeiter_idMitarbeiter`, `Aufgabenplan_idAufgabenplan`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Behandlungsplan_has_Taetigkeit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Behandlungsplan_has_Taetigkeit` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Behandlungsplan_has_Taetigkeit` (
  `Behandlungsplan_idBehandlungsplan` INT NOT NULL,
  `Taetigkeit_idTaetigkeit` INT NOT NULL,
  PRIMARY KEY (`Behandlungsplan_idBehandlungsplan`, `Taetigkeit_idTaetigkeit`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `Krankenhaus`.`Rechnung_has_Aufgabenplan`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Krankenhaus`.`Rechnung_has_Aufgabenplan` ;

CREATE TABLE IF NOT EXISTS `Krankenhaus`.`Rechnung_has_Aufgabenplan` (
  `Aufgabenplan_idAufgabenplan` INT NOT NULL,
  `Rechnung_idRechnung` INT NOT NULL,
  PRIMARY KEY (`Aufgabenplan_idAufgabenplan`, `Rechnung_idRechnung`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
