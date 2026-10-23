-- ============================================================================
-- FIELD INFRASTRUCTURE AUDIT ANALYTICS: DATA QUALITY & INTEGRITY TEST SUITE
-- Target Alignment: ANZSCO 263211 (ICT Quality Assurance Engineer)
-- Database Engine: MySQL 8.0
-- ============================================================================

USE FieldAuditDB;

-- ----------------------------------------------------------------------------
-- TC-01: Primary Key Uniqueness & Non-Null Constraint
-- Objective: Ensure AuditID contains zero duplicates and zero NULL entries.
-- Expected Boundary: NullViolations = 0, DuplicateViolations = 0
-- ----------------------------------------------------------------------------
SELECT 
    'TC-01' AS TestID,
    'Primary Key Integrity (AuditID)' AS TestObjective,
    COUNT(*) AS TotalRecords,
    SUM(CASE WHEN AuditID IS NULL THEN 1 ELSE 0 END) AS NullViolations,
    COUNT(AuditID) - COUNT(DISTINCT AuditID) AS DuplicateViolations,
    CASE 
        WHEN SUM(CASE WHEN AuditID IS NULL THEN 1 ELSE 0 END) = 0 
         AND COUNT(AuditID) = COUNT(DISTINCT AuditID) 
        THEN 'PASS'
        ELSE 'FAIL'
    END AS QualityStatus
FROM Fact_Audits;

-- ----------------------------------------------------------------------------
-- TC-02: Status-Date Dependency Integrity
-- Objective: Ensure audits marked 'PENDING' strictly enforce NULL execution date.
-- Expected Boundary: ViolationCount = 0 (31/31 enforced)
-- ----------------------------------------------------------------------------
SELECT 
    'TC-02' AS TestID,
    'Pending Audit Execution Date Integrity' AS TestObjective,
    COUNT(*) AS ViolationCount,
    CASE 
        WHEN COUNT(*) = 0 THEN 'PASS' 
        ELSE 'FAIL' 
    END AS QualityStatus
FROM Fact_Audits
WHERE StatusCode = 'PENDING' AND AuditDate IS NOT NULL;

-- ----------------------------------------------------------------------------
-- TC-03: Turnaround Latency Boundary Gating
-- Objective: Verify non-negative execution intervals and bounded Turnaround window (0-7 days).
-- Expected Boundary: MinLatency >= 0, MaxLatency <= 7, Violations = 0
-- ----------------------------------------------------------------------------
SELECT 
    'TC-03' AS TestID,
    'Turnaround Latency Boundary Check' AS TestObjective,
    MIN(DATEDIFF(AuditDate, ScheduledDate)) AS ObservedMinDays,
    MAX(DATEDIFF(AuditDate, ScheduledDate)) AS ObservedMaxDays,
    SUM(CASE WHEN DATEDIFF(AuditDate, ScheduledDate) < 0 THEN 1 ELSE 0 END) AS NegativeLatencyViolations,
    SUM(CASE WHEN DATEDIFF(AuditDate, ScheduledDate) > 7 THEN 1 ELSE 0 END) AS OverSevenDayViolations,
    CASE 
        WHEN SUM(CASE WHEN DATEDIFF(AuditDate, ScheduledDate) < 0 OR DATEDIFF(AuditDate, ScheduledDate) > 7 THEN 1 ELSE 0 END) = 0 
        THEN 'PASS' 
        ELSE 'FAIL' 
    END AS QualityStatus
FROM Fact_Audits
WHERE AuditDate IS NOT NULL;

-- ----------------------------------------------------------------------------
-- TC-04: Referential Foreign Key Integrity (Dim_Regions)
-- Objective: Verify zero orphan records exist linking Fact_Audits to Dim_Regions.
-- Expected Boundary: OrphanCount = 0
-- ----------------------------------------------------------------------------
SELECT 
    'TC-04' AS TestID,
    'Referential Integrity (Dim_Regions)' AS TestObjective,
    COUNT(*) AS OrphanCount,
    CASE 
        WHEN COUNT(*) = 0 THEN 'PASS' 
        ELSE 'FAIL' 
    END AS QualityStatus
FROM Fact_Audits a
LEFT JOIN Dim_Regions r ON a.RegionID = r.RegionID
WHERE r.RegionID IS NULL;

-- ----------------------------------------------------------------------------
-- TC-05: Referential Foreign Key Integrity (Dim_Technicians)
-- Objective: Verify zero orphan records exist linking Fact_Audits to Dim_Technicians.
-- Expected Boundary: OrphanCount = 0
-- ----------------------------------------------------------------------------
SELECT 
    'TC-05' AS TestID,
    'Referential Integrity (Dim_Technicians)' AS TestObjective,
    COUNT(*) AS OrphanCount,
    CASE 
        WHEN COUNT(*) = 0 THEN 'PASS' 
        ELSE 'FAIL' 
    END AS QualityStatus
FROM Fact_Audits a
LEFT JOIN Dim_Technicians t ON a.TechnicianID = t.TechnicianID
WHERE t.TechnicianID IS NULL;

-- ----------------------------------------------------------------------------
-- TC-06: Production Quarantine & Test Record Segregation
-- Objective: Ensure mock/test records are strictly excluded from the reporting view.
-- Expected Boundary: QuarantinedInFact = 3, LeakageIntoProductionView = 0
-- ----------------------------------------------------------------------------
SELECT 
    'TC-06' AS TestID,
    'Test Record Segregation & Quarantine' AS TestObjective,
    (SELECT COUNT(*) FROM Fact_Audits WHERE IsTestRecord = 1) AS QuarantinedInFact,
    (SELECT COUNT(*) FROM vw_FieldAuditPerformance 
     WHERE AuditID IN (SELECT AuditID FROM Fact_Audits WHERE IsTestRecord = 1)) AS LeakageIntoProductionView,
    CASE 
        WHEN (SELECT COUNT(*) FROM vw_FieldAuditPerformance 
              WHERE AuditID IN (SELECT AuditID FROM Fact_Audits WHERE IsTestRecord = 1)) = 0 
             AND (SELECT COUNT(*) FROM Fact_Audits WHERE IsTestRecord = 1) = 3
        THEN 'PASS' 
        ELSE 'FAIL' 
    END AS QualityStatus;

-- ----------------------------------------------------------------------------
-- TC-07: Defect Attribution Completeness
-- Objective: Ensure every non-compliant audit has an explicit defect category.
-- Expected Boundary: UnattributedDefects = 0 (100% defects categorized)
-- ----------------------------------------------------------------------------
SELECT 
    'TC-07' AS TestID,
    'Defect Attribution Completeness' AS TestObjective,
    COUNT(*) AS UnattributedDefects,
    CASE 
        WHEN COUNT(*) = 0 THEN 'PASS' 
        ELSE 'FAIL' 
    END AS QualityStatus
FROM Fact_Audits
WHERE UPPER(TRIM(StatusCode)) IN ('FAIL', 'FAILED', 'REJECTED')
  AND (DefectCategory IS NULL OR TRIM(DefectCategory) = '' OR DefectCategory = 'None');
