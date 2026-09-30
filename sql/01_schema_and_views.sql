CREATE DATABASE FieldAuditDB;
USE FieldAuditDB;

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
    AuditDate DATE,
    StatusCode VARCHAR(20),
    DefectCategory VARCHAR(100),
    IsTestRecord INT,
    FOREIGN KEY (RegionID) REFERENCES Dim_Regions(RegionID),
    FOREIGN KEY (TechnicianID) REFERENCES Dim_Technicians(TechnicianID)
);

SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';


LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fact_audits.csv'
INTO TABLE Fact_Audits
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(AuditID, SiteID, RegionID, TechnicianID, ScheduledDate, @vAuditDate, StatusCode, @vDefect, IsTestRecord)
SET 
    AuditDate = NULLIF(@vAuditDate, ''),
    DefectCategory = NULLIF(@vDefect, '');

select count(*) from Fact_Audits;
-- Check total volume and active test rows
SELECT IsTestRecord, COUNT(*) AS RecordCount 
FROM Fact_Audits
GROUP BY IsTestRecord;

-- Check distribution of raw status values
SELECT StatusCode, COUNT(*) AS Total 
FROM Fact_Audits 
GROUP BY StatusCode;
SHOW VARIABLES LIKE 'secure_file_priv';

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

    -- Null defect remediation
    COALESCE(a.DefectCategory, 'No Defect') AS DefectCategory,

    -- Turnaround lag in days (NULL if audit is pending)
    DATEDIFF(a.AuditDate, a.ScheduledDate) AS TurnaroundDays

FROM Fact_Audits a
INNER JOIN dim_technicians t ON a.TechnicianID = t.TechnicianID
INNER JOIN dim_regions r ON a.RegionID = r.RegionID
WHERE a.IsTestRecord = 0;
