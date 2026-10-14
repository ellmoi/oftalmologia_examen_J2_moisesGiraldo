
-- Fuente física definitiva para esta entrega de modelos. MySQL 8.4.
-- No ejecutar sobre la base del borrador.
CREATE DATABASE IF NOT EXISTS oftalmologia_glaucoma CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE oftalmologia_glaucoma;

CREATE TABLE `document_types` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(10) NOT NULL UNIQUE,
  `name` VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `specialties` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL UNIQUE,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `patients` (
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `document_type_id` BIGINT NOT NULL,
  `document_number` VARCHAR(30) NOT NULL,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `birth_date` DATE NOT NULL,
  `sex` VARCHAR(20) NULL,
  `phone` VARCHAR(30) NULL,
  `email` VARCHAR(150) NULL,
  `city` VARCHAR(100) NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`document_type_id`) REFERENCES `document_types`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_document_type_id (document_type_id),
  UNIQUE(document_type_id, document_number)
) ENGINE=InnoDB;

CREATE TABLE `healthcare_professionals` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `specialty_id` BIGINT NOT NULL,
  `document_number` VARCHAR(30) NOT NULL UNIQUE,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`specialty_id`) REFERENCES `specialties`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_specialty_id (specialty_id)
) ENGINE=InnoDB;

CREATE TABLE `clinical_histories` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `patient_id` BIGINT NOT NULL UNIQUE,
  `history_number` VARCHAR(30) NOT NULL UNIQUE,
  `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`patient_id`) REFERENCES `patients`(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `medical_visits` (
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `clinical_history_id` BIGINT NOT NULL,
  `professional_id` BIGINT NOT NULL,
  `visit_date` DATETIME NOT NULL,
  `reason` TEXT NULL,
  `assessment` TEXT NULL,
  `plan` TEXT NULL,
  `observations` TEXT NULL,
  `status` VARCHAR(20) NOT NULL DEFAULT 'OPEN',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`clinical_history_id`) REFERENCES `clinical_histories`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_clinical_history_id (clinical_history_id),
  FOREIGN KEY (`professional_id`) REFERENCES `healthcare_professionals`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_professional_id (professional_id)
) ENGINE=InnoDB;

CREATE TABLE `medical_histories` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `patient_id` BIGINT NOT NULL,
  `history_type` VARCHAR(100) NOT NULL,
  `description` TEXT NOT NULL,
  `recorded_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`patient_id`) REFERENCES `patients`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_patient_id (patient_id)
) ENGINE=InnoDB;

CREATE TABLE `diagnoses` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(30) NOT NULL UNIQUE,
  `name` VARCHAR(150) NOT NULL,
  `glaucoma_type` VARCHAR(100) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `visit_diagnoses` (
  `visit_id` BIGINT NOT NULL,
  `diagnosis_id` BIGINT NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `is_primary` BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (`visit_id`, `diagnosis_id`, `eye`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (`diagnosis_id`) REFERENCES `diagnoses`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CHECK(eye IN ('OD','OI','NA')),
  CHECK(is_primary IN (0,1)),
  primary_visit_eye VARCHAR(80) GENERATED ALWAYS AS (CASE WHEN is_primary = 1 THEN CONCAT(visit_id, ':', eye) ELSE NULL END) STORED,
  UNIQUE(primary_visit_eye)
) ENGINE=InnoDB;

CREATE TABLE `ophthalmologic_exams` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `exam_date` DATETIME NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `visual_acuity` VARCHAR(30) NULL,
  `optic_nerve_notes` TEXT NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  CHECK(eye IN ('OD','OI'))
) ENGINE=InnoDB;

CREATE TABLE `intraocular_pressures` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `measured_at` DATETIME NOT NULL,
  `pressure` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  CHECK(eye IN ('OD','OI')),
  CHECK(pressure >= 0)
) ENGINE=InnoDB;

CREATE TABLE `pachymetry_exams` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `exam_date` DATETIME NOT NULL,
  `corneal_thickness` DECIMAL(7,2) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  CHECK(eye IN ('OD','OI')),
  CHECK(corneal_thickness > 0)
) ENGINE=InnoDB;

CREATE TABLE `gonioscopy_exams` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `exam_date` DATETIME NOT NULL,
  `result` TEXT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  CHECK(eye IN ('OD','OI'))
) ENGINE=InnoDB;

CREATE TABLE `oct_exams` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `exam_date` DATETIME NOT NULL,
  `rnfl` DECIMAL(7,2) NULL,
  `interpretation` TEXT NULL,
  `validated` BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  CHECK(eye IN ('OD','OI')),
  CHECK(rnfl IS NULL OR rnfl >= 0)
) ENGINE=InnoDB;

CREATE TABLE `visual_field_exams` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `exam_date` DATETIME NOT NULL,
  `md` DECIMAL(7,2) NULL,
  `psd` DECIMAL(7,2) NULL,
  `vfi` DECIMAL(5,2) NULL,
  `interpretation` TEXT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  CHECK(eye IN ('OD','OI')),
  CHECK(vfi BETWEEN 0 AND 100)
) ENGINE=InnoDB;

CREATE TABLE `glaucoma_records` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `patient_id` BIGINT NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `opened_at` DATETIME NOT NULL,
  `closed_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`patient_id`) REFERENCES `patients`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_patient_id (patient_id),
  CHECK(eye IN ('OD','OI')),
  CHECK(closed_at IS NULL OR closed_at >= opened_at),
  UNIQUE(patient_id, eye, opened_at)
) ENGINE=InnoDB;

CREATE TABLE `glaucoma_controls` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `glaucoma_record_id` BIGINT NOT NULL,
  `visit_id` BIGINT NOT NULL,
  `control_date` DATETIME NOT NULL,
  `glaucoma_type` VARCHAR(100) NULL,
  `target_pressure` DECIMAL(5,2) NULL,
  `clinical_status` VARCHAR(100) NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`glaucoma_record_id`) REFERENCES `glaucoma_records`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_glaucoma_record_id (glaucoma_record_id),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  CHECK(target_pressure IS NULL OR target_pressure > 0)
) ENGINE=InnoDB;

CREATE TABLE `medications` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL UNIQUE,
  `active` BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `treatments` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `medication_id` BIGINT NULL,
  `eye` CHAR(2) NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL,
  `active` BOOLEAN NOT NULL DEFAULT TRUE,
  `dose` VARCHAR(100) NULL,
  `frequency` VARCHAR(100) NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  FOREIGN KEY (`medication_id`) REFERENCES `medications`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_medication_id (medication_id),
  CHECK(eye IN ('OD','OI','AO','NA')),
  CHECK(end_date IS NULL OR end_date >= start_date)
) ENGINE=InnoDB;

CREATE TABLE `procedures` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `procedure_type` VARCHAR(150) NOT NULL,
  `procedure_date` DATETIME NOT NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  CHECK(eye IN ('OD','OI','AO','NA'))
) ENGINE=InnoDB;

CREATE TABLE `clinical_documents` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `clinical_history_id` BIGINT NOT NULL,
  `document_type` VARCHAR(100) NOT NULL,
  `file_name` VARCHAR(255) NOT NULL,
  `file_uri` VARCHAR(500) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`clinical_history_id`) REFERENCES `clinical_histories`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_clinical_history_id (clinical_history_id)
) ENGINE=InnoDB;

CREATE TABLE `audit_logs` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `table_name` VARCHAR(100) NOT NULL,
  `record_key` VARCHAR(150) NOT NULL,
  `action` VARCHAR(20) NOT NULL,
  `old_data` JSON NULL,
  `new_data` JSON NULL,
  `changed_by` VARCHAR(100) NOT NULL,
  `changed_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CHECK(action IN ('INSERT','UPDATE','DELETE'))
) ENGINE=InnoDB;

DELIMITER $$
CREATE TRIGGER patients_create_history AFTER INSERT ON patients FOR EACH ROW
BEGIN
 INSERT INTO clinical_histories(patient_id, history_number) VALUES(NEW.id, CONCAT('HC-', NEW.id));
END$$
CREATE TRIGGER history_no_delete BEFORE DELETE ON clinical_histories FOR EACH ROW
BEGIN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Conservar historia; cerrar mediante status'; END$$
CREATE TRIGGER history_owner_immutable BEFORE UPDATE ON clinical_histories FOR EACH ROW
BEGIN IF NEW.patient_id <> OLD.patient_id THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Propietario de historia inmutable'; END IF; END$$
CREATE TRIGGER control_patient_insert BEFORE INSERT ON glaucoma_controls FOR EACH ROW
BEGIN
 IF (SELECT patient_id FROM glaucoma_records WHERE id=NEW.glaucoma_record_id) <>
 (SELECT ch.patient_id FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE mv.id=NEW.visit_id)
 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Control y consulta pertenecen a pacientes diferentes'; END IF;
END$$
CREATE TRIGGER control_patient_update BEFORE UPDATE ON glaucoma_controls FOR EACH ROW
BEGIN
 IF (SELECT patient_id FROM glaucoma_records WHERE id=NEW.glaucoma_record_id) <>
 (SELECT ch.patient_id FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE mv.id=NEW.visit_id)
 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Control y consulta pertenecen a pacientes diferentes'; END IF;
END$$
CREATE TRIGGER medical_visits_owner_immutable BEFORE UPDATE ON medical_visits FOR EACH ROW BEGIN IF NEW.clinical_history_id <> OLD.clinical_history_id THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Vinculo de paciente inmutable'; END IF; END$$
CREATE TRIGGER glaucoma_records_owner_immutable BEFORE UPDATE ON glaucoma_records FOR EACH ROW BEGIN IF NEW.patient_id <> OLD.patient_id THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Vinculo de paciente inmutable'; END IF; END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER glaucoma_eye_immutable BEFORE UPDATE ON glaucoma_records FOR EACH ROW
BEGIN IF NEW.eye <> OLD.eye THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Ojo del episodio inmutable'; END IF; END$$

DELIMITER ;

CREATE TABLE notifications (id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY, patient_id BIGINT NOT NULL, message VARCHAR(255) NOT NULL, created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(patient_id) REFERENCES patients(id));
