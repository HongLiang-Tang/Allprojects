-- Generated by Oracle SQL Developer Data Modeler 18.4.0.339.1536
--   at:        2019-09-26 10:58:02 AEST
--   site:      Oracle Database 12c
--   type:      Oracle Database 12c

-- Student ID: 27135519
-- Student name: Hongliang Tang
SET ECHO ON

SPOOL tds_schema_output.txt;

DROP TABLE assignment CASCADE CONSTRAINTS;

DROP TABLE cancellation CASCADE CONSTRAINTS;

DROP TABLE country CASCADE CONSTRAINTS;

DROP TABLE demerit CASCADE CONSTRAINTS;

DROP TABLE driver CASCADE CONSTRAINTS;

DROP TABLE engine_type CASCADE CONSTRAINTS;

DROP TABLE license_type CASCADE CONSTRAINTS;

DROP TABLE manufacturer CASCADE CONSTRAINTS;

DROP TABLE offence CASCADE CONSTRAINTS;

DROP TABLE police_officer CASCADE CONSTRAINTS;

DROP TABLE police_station CASCADE CONSTRAINTS;

DROP TABLE registration CASCADE CONSTRAINTS;

DROP TABLE suspension CASCADE CONSTRAINTS;

DROP TABLE type_variation CASCADE CONSTRAINTS;

DROP TABLE types CASCADE CONSTRAINTS;

DROP TABLE vehicle CASCADE CONSTRAINTS;

DROP TABLE vehicle_model CASCADE CONSTRAINTS;

CREATE TABLE assignment (
    officer_id       VARCHAR2(20) NOT NULL,
    from_date        DATE NOT NULL,
    station_number   NUMBER(30) NOT NULL
);

COMMENT ON COLUMN assignment.officer_id IS
    'Police officers are identified by an officer id';

COMMENT ON COLUMN assignment.from_date IS
    'the start date when the officer is assigned to a station';

COMMENT ON COLUMN assignment.station_number IS
    'Police stations are identified by a station number';

ALTER TABLE assignment ADD CONSTRAINT assignment_pk PRIMARY KEY ( officer_id );

CREATE TABLE cancellation (
    lic_num               NUMBER(12) NOT NULL,
    date_cancelled        DATE NOT NULL,
    cancellation_period   NUMBER(4) NOT NULL,
    reason_cancelled      CHAR(100) NOT NULL,
    reinstatement_date    DATE, 
--  Court hearing date
    hearing_date          DATE
);

COMMENT ON COLUMN cancellation.lic_num IS
    ' license number';

COMMENT ON COLUMN cancellation.date_cancelled IS
    'license cancelled date';

COMMENT ON COLUMN cancellation.cancellation_period IS
    'Cancellation Period(months)';

COMMENT ON COLUMN cancellation.reason_cancelled IS
    'the reason cancelled this driver''s license';

COMMENT ON COLUMN cancellation.reinstatement_date IS
    'License Reinstatment date';

ALTER TABLE cancellation ADD CONSTRAINT cancellation_pk PRIMARY KEY ( date_cancelled,
                                                                      lic_num );

CREATE TABLE country (
    manu_country_iso    CHAR(3) NOT NULL,
    manu_country_name   VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN country.manu_country_iso IS
    'ISO 3166 Alpha-3 Code';

ALTER TABLE country ADD CONSTRAINT country_pk PRIMARY KEY ( manu_country_iso );

CREATE TABLE demerit (
    demerit_code    NUMBER(30) NOT NULL,
    d_description   VARCHAR2(100) NOT NULL,
    num_of_points   NUMBER(2) DEFAULT 1 NOT NULL
);

ALTER TABLE demerit ADD CONSTRAINT chk_num_of_points CHECK ( num_of_points > 0 );

COMMENT ON COLUMN demerit.demerit_code IS
    'Demerit code';

COMMENT ON COLUMN demerit.d_description IS
    'The description for this demerit';

COMMENT ON COLUMN demerit.num_of_points IS
    'the number of points incurred for the demerit.';

ALTER TABLE demerit ADD CONSTRAINT demerit_pk PRIMARY KEY ( demerit_code );

CREATE TABLE driver (
    lic_num            NUMBER(12) NOT NULL,
    f_name             VARCHAR2(50) NOT NULL,
    l_name             VARCHAR2(50) NOT NULL,
    address_street     VARCHAR2(50) NOT NULL,
    address_town       VARCHAR2(50) NOT NULL,
    address_postcode   NUMBER(10) NOT NULL,
    d_of_birth         DATE NOT NULL,
    lic_exp_date       DATE NOT NULL,
    accu_demerit_p     NUMBER(3) NOT NULL,
    lic_status         VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN driver.lic_num IS
    ' license number';

COMMENT ON COLUMN driver.f_name IS
    'driver first name';

COMMENT ON COLUMN driver.l_name IS
    'driver last name';

COMMENT ON COLUMN driver.address_street IS
    'driver residential street address';

COMMENT ON COLUMN driver.address_town IS
    'driver residential town address';

COMMENT ON COLUMN driver.address_postcode IS
    'driver residential postcode address';

COMMENT ON COLUMN driver.d_of_birth IS
    'driver date of birth';

COMMENT ON COLUMN driver.lic_exp_date IS
    'the expiry date for a driver''s licence';

COMMENT ON COLUMN driver.accu_demerit_p IS
    'the total number of demerit points the driver has accumulated.';

COMMENT ON COLUMN driver.lic_status IS
    'licence status';

ALTER TABLE driver ADD CONSTRAINT driver_pk PRIMARY KEY ( lic_num );

CREATE TABLE engine_type (
    model_name   CHAR(50) NOT NULL,
    type_code    CHAR(6) NOT NULL
);

COMMENT ON COLUMN engine_type.model_name IS
    'Model name';

COMMENT ON COLUMN engine_type.type_code IS
    'surrogate key to uniquely identify engine type. improve design.';

ALTER TABLE engine_type ADD CONSTRAINT engine_type_pk PRIMARY KEY ( model_name,
                                                                    type_code );

CREATE TABLE license_type (
    lic_num    NUMBER(12) NOT NULL, 
--  added surrogate key to uniquely identifies license type.improve design
    type_num   NUMBER(3) NOT NULL
);

COMMENT ON COLUMN license_type.lic_num IS
    ' license number';

ALTER TABLE license_type ADD CONSTRAINT license_type_pk PRIMARY KEY ( lic_num,
                                                                      type_num );

CREATE TABLE manufacturer (
    manu_code          VARCHAR2(50) NOT NULL,
    manu_name          VARCHAR2(50) NOT NULL,
    manu_country_iso   CHAR(3) NOT NULL
);

COMMENT ON COLUMN manufacturer.manu_code IS
    'manufacturer code';

COMMENT ON COLUMN manufacturer.manu_name IS
    'manufacturer code';

COMMENT ON COLUMN manufacturer.manu_country_iso IS
    'ISO 3166 Alpha-3 Code';

ALTER TABLE manufacturer ADD CONSTRAINT manufacturer_pk PRIMARY KEY ( manu_code );

CREATE TABLE offence (
    offence_num    NUMBER(20) NOT NULL,
    o_location     VARCHAR2(50) NOT NULL,
    o_date         DATE NOT NULL,
    o_time         VARCHAR2(50) NOT NULL,
    officer_id     VARCHAR2(20) NOT NULL,
    demerit_code   NUMBER(30) NOT NULL,
    lic_num        NUMBER(12) NOT NULL,
    v_in           NUMBER(30) NOT NULL
);

COMMENT ON COLUMN offence.offence_num IS
    'Offence number';

COMMENT ON COLUMN offence.o_location IS
    'the location where offence committed';

COMMENT ON COLUMN offence.o_date IS
    'Offence happened date';

COMMENT ON COLUMN offence.o_time IS
    'the time for this offence';

COMMENT ON COLUMN offence.officer_id IS
    'Police officers are identified by an officer id';

COMMENT ON COLUMN offence.demerit_code IS
    'Demerit code';

COMMENT ON COLUMN offence.lic_num IS
    ' license number';

COMMENT ON COLUMN offence.v_in IS
    'Vehicle Identification Number';

ALTER TABLE offence ADD CONSTRAINT offence_pk PRIMARY KEY ( offence_num );

CREATE TABLE police_officer (
    officer_id    VARCHAR2(20) NOT NULL,
    pfirst_name   VARCHAR2(50) NOT NULL,
    plast_name    VARCHAR2(50) NOT NULL,
    poli_rank     VARCHAR2(25) NOT NULL
);

COMMENT ON COLUMN police_officer.officer_id IS
    'Police officers are identified by an officer id';

COMMENT ON COLUMN police_officer.pfirst_name IS
    'police officer first name';

COMMENT ON COLUMN police_officer.plast_name IS
    'police officer last name';

COMMENT ON COLUMN police_officer.poli_rank IS
    'policer officer''s rank';

ALTER TABLE police_officer ADD CONSTRAINT police_officer_pk PRIMARY KEY ( officer_id );

CREATE TABLE police_station (
    station_number    NUMBER(30) NOT NULL,
    station_address   VARCHAR2(50) NOT NULL,
    phone_number      NUMBER(15) NOT NULL,
    is_open_24hours   VARCHAR2(3) NOT NULL,
    officer_id        VARCHAR2(20) NOT NULL
);

ALTER TABLE police_station
    ADD CONSTRAINT chk_is_open_24hours CHECK ( is_open_24hours IN (
        'no',
        'yes'
    ) );

COMMENT ON COLUMN police_station.station_number IS
    'Police stations are identified by a station number';

COMMENT ON COLUMN police_station.station_address IS
    'police station address';

COMMENT ON COLUMN police_station.phone_number IS
    'direct contact phone number to the police  station';

COMMENT ON COLUMN police_station.is_open_24hours IS
    'the station is open 24 hours a day or not';

COMMENT ON COLUMN police_station.officer_id IS
    'Police officers are identified by an officer id';

CREATE UNIQUE INDEX police_station__idx ON
    police_station (
        officer_id
    ASC );

ALTER TABLE police_station ADD CONSTRAINT police_station_pk PRIMARY KEY ( station_number );

CREATE TABLE registration (
    v_in           NUMBER(30) NOT NULL,
    regis_date     DATE NOT NULL,
    regis_num      VARCHAR2(50) NOT NULL,
    deregis_date   DATE
);

COMMENT ON COLUMN registration.v_in IS
    'Vehicle Identification Number';

COMMENT ON COLUMN registration.regis_date IS
    'Date registered';

COMMENT ON COLUMN registration.regis_num IS
    'Registration Number';

COMMENT ON COLUMN registration.deregis_date IS
    'Date DeRegistered';

ALTER TABLE registration ADD CONSTRAINT registration_pk PRIMARY KEY ( regis_date,
                                                                      v_in );

CREATE TABLE suspension (
    lic_num    NUMBER(12) NOT NULL,
    date_sus   DATE NOT NULL,
    end_date   DATE NOT NULL
);

COMMENT ON COLUMN suspension.lic_num IS
    ' license number';

COMMENT ON COLUMN suspension.date_sus IS
    'Date Suspended';

COMMENT ON COLUMN suspension.end_date IS
    'Suspension End Date';

ALTER TABLE suspension ADD CONSTRAINT suspension_pk PRIMARY KEY ( date_sus,
                                                                  lic_num );

CREATE TABLE type_variation ( 
--  added surrogate key to uniquely identifies license type.improve design
    type_num   NUMBER(3) NOT NULL, 
--  license type 
    lic_type   VARCHAR2(50) NOT NULL
);

ALTER TABLE type_variation
    ADD CONSTRAINT chk_lic_type CHECK ( lic_type IN (
        'Multi Combination ',
        'Tractor ',
        'Car',
        'Heavy Combination',
        'Heavy Rigid',
        'Light Rigid',
        'Marine',
        'Medium Rigid',
        'Motorcycle'
    ) );

ALTER TABLE type_variation ADD CONSTRAINT type_variation_pk PRIMARY KEY ( type_num );

ALTER TABLE type_variation ADD CONSTRAINT type_variation_nk UNIQUE ( lic_type );

CREATE TABLE types (
    type_code   CHAR(6) NOT NULL,
    e_type      VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN types.type_code IS
    'surrogate key to uniquely identify engine type. improve design.';

COMMENT ON COLUMN types.e_type IS
    'engine type';

ALTER TABLE types ADD CONSTRAINT type_pk PRIMARY KEY ( type_code );

ALTER TABLE types ADD CONSTRAINT type_nk UNIQUE ( e_type );

CREATE TABLE vehicle (
    v_in         NUMBER(30) NOT NULL,
    v_type       VARCHAR2(50) NOT NULL,
    manu_year    DATE NOT NULL,
    v_colour     VARCHAR2(50) NOT NULL, 
--  added surrogate key to uniquely identifies license type.improve design
    type_num     NUMBER(3) NOT NULL,
    model_name   CHAR(50) NOT NULL
);

ALTER TABLE vehicle
    ADD CONSTRAINT chk_v_type CHECK ( v_type IN (
        'Car',
        'Heavy Combination',
        'Heavy Rigid',
        'Light Rigid',
        'Marine',
        'Medium Rigid',
        'Motorcycle',
        'Multil combination',
        'Tractor'
    ) );

COMMENT ON COLUMN vehicle.v_in IS
    'Vehicle Identification Number';

COMMENT ON COLUMN vehicle.v_type IS
    'type of vehicle';

COMMENT ON COLUMN vehicle.manu_year IS
    'Year manufactured ';

COMMENT ON COLUMN vehicle.v_colour IS
    'vehicle main colour';

COMMENT ON COLUMN vehicle.model_name IS
    'Model name';

ALTER TABLE vehicle ADD CONSTRAINT vehicle_pk PRIMARY KEY ( v_in );

CREATE TABLE vehicle_model (
    model_name           CHAR(50) NOT NULL,
    model_transmission   CHAR(50) NOT NULL,
    engine_size          CHAR(10) NOT NULL,
    laden_height         VARCHAR2(15) NOT NULL,
    unladen_height       VARCHAR2(15) NOT NULL,
    manu_code            VARCHAR2(50) NOT NULL
);

ALTER TABLE vehicle_model
    ADD CONSTRAINT chk_model_transmission CHECK ( model_transmission IN (
        'Automatic Transmission',
        'Manual Transmission'
    ) );

COMMENT ON COLUMN vehicle_model.model_name IS
    'Model name';

COMMENT ON COLUMN vehicle_model.model_transmission IS
    'transmission type in this vehicle';

COMMENT ON COLUMN vehicle_model.engine_size IS
    'Engine size';

COMMENT ON COLUMN vehicle_model.laden_height IS
    'Ground clearance laden height';

COMMENT ON COLUMN vehicle_model.unladen_height IS
    'Ground clearance unladen height';

COMMENT ON COLUMN vehicle_model.manu_code IS
    'manufacturer code';

ALTER TABLE vehicle_model ADD CONSTRAINT vehicle_model_pk PRIMARY KEY ( model_name );

ALTER TABLE assignment
    ADD CONSTRAINT assi_station FOREIGN KEY ( station_number )
        REFERENCES police_station ( station_number );

ALTER TABLE manufacturer
    ADD CONSTRAINT country_manu FOREIGN KEY ( manu_country_iso )
        REFERENCES country ( manu_country_iso );

ALTER TABLE offence
    ADD CONSTRAINT demerit_offence FOREIGN KEY ( demerit_code )
        REFERENCES demerit ( demerit_code );

ALTER TABLE cancellation
    ADD CONSTRAINT driver_cancellation FOREIGN KEY ( lic_num )
        REFERENCES driver ( lic_num );

ALTER TABLE license_type
    ADD CONSTRAINT driver_lic_type FOREIGN KEY ( lic_num )
        REFERENCES driver ( lic_num );

ALTER TABLE offence
    ADD CONSTRAINT driver_offence FOREIGN KEY ( lic_num )
        REFERENCES driver ( lic_num );

ALTER TABLE suspension
    ADD CONSTRAINT driver_suspension FOREIGN KEY ( lic_num )
        REFERENCES driver ( lic_num );

ALTER TABLE engine_type
    ADD CONSTRAINT eng_type_type FOREIGN KEY ( type_code )
        REFERENCES types ( type_code );

ALTER TABLE license_type
    ADD CONSTRAINT lic_type_var FOREIGN KEY ( type_num )
        REFERENCES type_variation ( type_num );

ALTER TABLE vehicle_model
    ADD CONSTRAINT manu_model FOREIGN KEY ( manu_code )
        REFERENCES manufacturer ( manu_code );

ALTER TABLE vehicle
    ADD CONSTRAINT model_vehi FOREIGN KEY ( model_name )
        REFERENCES vehicle_model ( model_name );

ALTER TABLE assignment
    ADD CONSTRAINT offi_assignment FOREIGN KEY ( officer_id )
        REFERENCES police_officer ( officer_id );

ALTER TABLE offence
    ADD CONSTRAINT offi_offence FOREIGN KEY ( officer_id )
        REFERENCES police_officer ( officer_id );

ALTER TABLE police_station
    ADD CONSTRAINT offi_station FOREIGN KEY ( officer_id )
        REFERENCES police_officer ( officer_id );

ALTER TABLE vehicle
    ADD CONSTRAINT type_var_vehi FOREIGN KEY ( type_num )
        REFERENCES type_variation ( type_num );

ALTER TABLE engine_type
    ADD CONSTRAINT veh_mod_eng_type FOREIGN KEY ( model_name )
        REFERENCES vehicle_model ( model_name );

ALTER TABLE offence
    ADD CONSTRAINT vehicle_offence FOREIGN KEY ( v_in )
        REFERENCES vehicle ( v_in );

ALTER TABLE registration
    ADD CONSTRAINT vehicle_registration FOREIGN KEY ( v_in )
        REFERENCES vehicle ( v_in );



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            17
-- CREATE INDEX                             1
-- ALTER TABLE                             42
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
SET ECHO OFF