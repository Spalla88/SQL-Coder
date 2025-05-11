CREATE SCHEMA HospitalSynthea;
USE HospitalSynthea;

CREATE TABLE Patients (
    patient_id VARCHAR(36) PRIMARY KEY, -- ok
    birth_date DATE, 
    death_date DATE, 
    gender CHAR(1), 
    first_name VARCHAR(50), 
    last_name VARCHAR(50), 
    marital_status VARCHAR(20), 
    address VARCHAR(255), 
    city VARCHAR(50), 
    state VARCHAR(50), 
    zip VARCHAR(10), 
    healthcare_expenses DECIMAL(10,2),
    healthcare_coverage DECIMAL(10,2)
);

CREATE TABLE Providers (
    provider_id VARCHAR(36) PRIMARY KEY,
    organization_name VARCHAR(100),
    provider_name VARCHAR(100),
    specialty VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    zip VARCHAR(10)
);

CREATE TABLE Encounters (
    encounter_id VARCHAR(36) PRIMARY KEY,
    start_date DATETIME,
    end_date DATETIME,
    patient_id VARCHAR(36),
    provider_id VARCHAR(36),
    encounter_class VARCHAR(50),
    base_cost DECIMAL(10,2),
    total_cost DECIMAL(10,2),
    payer_coverage DECIMAL(10,2),
    reason_code VARCHAR(20),
    reason_description VARCHAR(255),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (provider_id) REFERENCES Providers(provider_id)
);

CREATE TABLE Conditions (
    condition_id INT AUTO_INCREMENT PRIMARY KEY,
    encounter_id VARCHAR(36),
    patient_id VARCHAR(36),
    code VARCHAR(20),
    description VARCHAR(255),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (encounter_id) REFERENCES Encounters(encounter_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

CREATE TABLE Medications (
    medication_id INT AUTO_INCREMENT PRIMARY KEY,
    encounter_id VARCHAR(36), -- ENCOUNTER
    patient_id VARCHAR(36), -- PATIENT
    code VARCHAR(20), -- Eliminar
    description VARCHAR(255),
    start_date DATE, -- START
    end_date DATE, -- STOP
    base_cost DECIMAL(10,2), -- BASE_COST
    payer_coverage DECIMAL(10,2), -- PAYER_COVERAGE
    dispenses INT, -- DISPENSES
    total_cost DECIMAL(10,2), -- TOTALCOST
    reason_code VARCHAR(20), -- REASONCODE
    reason_description VARCHAR(255), -- REASONDESCRIPTION
    FOREIGN KEY (encounter_id) REFERENCES Encounters(encounter_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
); -- Estas son las columnas que no tengo que tener en cuenta: PAYER, DESCRIPTION, CODE

DROP TABLE Medications;

CREATE TABLE Medications (
    medication_id INT AUTO_INCREMENT PRIMARY KEY,
    encounter_id VARCHAR(36), -- ENCOUNTER
    patient_id VARCHAR(36), -- PATIENT
    description VARCHAR(255),
    start_date DATE, -- START
    end_date DATE, -- STOP
    base_cost DECIMAL(10,2), -- BASE_COST
    payer_coverage DECIMAL(10,2), -- PAYER_COVERAGE
    dispenses INT, -- DISPENSES
    total_cost DECIMAL(10,2), -- TOTALCOST
    reason_code VARCHAR(20), -- REASONCODE
    reason_description VARCHAR(255), -- REASONDESCRIPTION
    FOREIGN KEY (encounter_id) REFERENCES Encounters(encounter_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

ALTER TABLE Medications MODIFY COLUMN start_date DATETIME;
ALTER TABLE Medications MODIFY COLUMN end_date DATETIME;

SELECT * from medications limit 5;
SELECT * from conditions limit 5;