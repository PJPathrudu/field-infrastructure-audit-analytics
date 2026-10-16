-- ============================================================================
-- FIELD INFRASTRUCTURE AUDIT ANALYTICS: RELATIONAL SCHEMA & STAGING VIEWS
-- Target Alignment: ANZSCO 224114 (Data Analyst) & ANZSCO 263211 (ICT QA)
-- Database Engine: MySQL 8.0
-- ============================================================================

CREATE DATABASE IF NOT EXISTS FieldAuditDB;
USE FieldAuditDB;

-- ----------------------------------------------------------------------------
-- 1. Table Definitions & Relational Constraints
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS Fact_Audits;
DROP TABLE IF EXISTS Dim_Technicians;
DROP TABLE IF EXISTS Dim_Regions;

CREATE TABLE Dim_Regions (
    RegionID INT PRIMARY KEY,
    RegionName VARCHAR(50) NOT NULL,
    Territory VARCHAR(50) NOT NULL
);

CREATE TABLE Dim_Technicians (
    TechnicianID INT PRIMARY KEY,
    TechnicianName VARCHAR(100) NOT NULL,
    VendorName VARCHAR(100) NOT NULL
);

CREATE TABLE Fact_Audits (
    AuditID INT PRIMARY KEY,
    SiteID VARCHAR(20) NOT NULL,
    RegionID INT,
    TechnicianID INT,
    ScheduledDate DATE NOT NULL,
    AuditDate DATE NULL,
    StatusCode VARCHAR(20) NOT NULL,
    DefectCategory VARCHAR(100) NULL,
    IsTestRecord INT DEFAULT 0,
    FOREIGN KEY (RegionID) REFERENCES Dim_Regions(RegionID),
    FOREIGN KEY (TechnicianID) REFERENCES Dim_Technicians(TechnicianID)
);

-- ----------------------------------------------------------------------------
-- 2. Data Ingestion (Dimensions MUST load prior to Fact table)
-- Note: Replace local paths below with your environment's path to the /data folder.
-- ----------------------------------------------------------------------------
SET GLOBAL local_infile = 1;

-- Ingest Dim_Regions (4 records)
LOAD DATA LOCAL INFILE 'C:/Users/HP/OneDrive/Desktop/field-infrastructure-audit-analytics/data/dim_regions.csv'
INTO TABLE Dim_Regions
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(RegionID, RegionName, Territory);

-- Ingest Dim_Technicians (5 records)
LOAD DATA LOCAL INFILE 'C:/Users/HP/OneDrive/Desktop/field-infrastructure-audit-analytics/data/dim_technicians.csv'
INTO TABLE Dim_Technicians
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(TechnicianID, TechnicianName, VendorName);

-- Ingest Fact_Audits (600 records)
LOAD DATA LOCAL INFILE 'C:/Users/HP/OneDrive/Desktop/field-infrastructure-audit-analytics/data/fact_audits.csv'
INTO TABLE Fact_Audits
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(AuditID, SiteID, RegionID, TechnicianID, ScheduledDate, @vAuditDate, StatusCode, @vDefect, IsTestRecord)
SET 
    AuditDate = NULLIF(@vAuditDate, ''),
    DefectCategory = NULLIF(@vDefect, '');

-- ----------------------------------------------------------------------------
-- 3. Operational Reporting View
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_FieldAuditPerformance AS
SELECT 
    a.AuditID,
    a.SiteID,
    a.ScheduledDate,
    a.AuditDate,
    t.TechnicianID,
    t.TechnicianName,
    t.VendorName,
    r.RegionID,
    r.RegionName,
    r.Territory,
    
    -- Status standardization matching Power BI DAX
    CASE 
        WHEN UPPER(TRIM(a.StatusCode)) IN ('PASS', 'PASSED') THEN 'Compliant'
        WHEN UPPER(TRIM(a.StatusCode)) IN ('FAIL', 'FAILED', 'REJECTED') THEN 'Non-Compliant'
        WHEN UPPER(TRIM(a.StatusCode)) = 'PENDING' OR a.StatusCode IS NULL THEN 'Pending Review'
        ELSE 'Unclassified'
    END AS AuditOutcome,

    -- Defect classification remediation
    CASE
        WHEN UPPER(TRIM(a.StatusCode)) IN ('PASS', 'PASSED') AND a.DefectCategory IS NULL THEN 'No Defect'
        WHEN UPPER(TRIM(a.StatusCode)) IN ('FAIL', 'FAILED', 'REJECTED') AND a.DefectCategory IS NULL THEN 'Missing Classification'
        ELSE COALESCE(a.DefectCategory, 'No Defect')
    END AS DefectCategory,

    -- Turnaround lag in days (NULL if audit is pending)
    DATEDIFF(a.AuditDate, a.ScheduledDate) AS TurnaroundDays

FROM Fact_Audits a
INNER JOIN Dim_Technicians t ON a.TechnicianID = t.TechnicianID
INNER JOIN Dim_Regions r ON a.RegionID = r.RegionID
WHERE a.IsTestRecord = 0;
