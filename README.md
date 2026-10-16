# Field Infrastructure Quality & Audit Performance Analytics

[![Power BI Desktop](https://img.shields.io/badge/Power%20BI-Import%20Mode-F2C811?logo=powerbi&logoColor=black)](#semantic-model--key-dax-measures)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?logo=mysql&logoColor=white)](#database-schema--reporting-views)
[![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=white)](#exploratory-data-analysis--validation-output)
[![Evidence Classification](https://img.shields.io/badge/ACS%20RPL-Category%202%20Professional%20Artefact-orange.svg)](#metadata--attribution)

An end-to-end operational data quality governance, relational data modeling, and business intelligence platform engineered to simulate field infrastructure audit lifecycles, enforce multi-tier automated data validation gates, track asset defect distributions, and evaluate contractor turnaround performance.

---

## Metadata & Attribution

* **Author:** Jogarao Pathrudu Pediredla
* **GitHub Profile:** [@PJPathrudu](https://github.com/PJPathrudu)
* **Public Repository:** [field-infrastructure-audit-analytics](https://github.com/PJPathrudu/field-infrastructure-audit-analytics)
* **Project Role:** Independent Project Developer — Data Quality & Analytics
* **Project Type:** Independent Professional Portfolio & Applied Engineering Simulation
* **Nominated Pathways:** ANZSCO 224114 (Data Analyst) & ANZSCO 263211 (ICT Quality Assurance Engineer) & ANZSCO 261111 (ICT BA)
* **Evidence Classification:** ACS RPL Professional Currency — Category 2 (Attributed Digital Artefact)

> **Scope Note:** This project represents an independent technical portfolio demonstration developed to exhibit competency in data architecture, automated testing assertions, dimensional modeling, and analytical reporting. It is not an employer-commissioned deployment or paid enterprise engagement.

---

## Project Overview

This analytics platform bridges three core computing domains across simulated field operations:
1. **Business Systems Analysis (ANZSCO 261111):** Formulates operational business logic, normalizes fragmented inspection codes, and evaluates architectural trade-offs between flat reporting views and relational star schemas.
2. **Quality Assurance Engineering (ANZSCO 263211):** Implements automated Python assertion gates, establishes relational constraints, executes automated SQL regression suites (TC-01 to TC-07), and models diagnostic 5-Whys Root Cause Analysis.
3. **Data Analytics & Modeling (ANZSCO 224114):** Ingests, profiles, and validates transactional data using Python, structures normalized 3NF MySQL schemas, and designs an import-mode Kimball star-schema semantic model in Power BI.

---

## Data Provenance & Synthetic Disclosure

All transactional records are synthetically generated using Python (`random.seed(42)` and `numpy.random.seed(42)`) to simulate field audit lifecycles without using proprietary corporate data:

* **Deterministic Reproduction:** Fixed random seeds guarantee identical row outputs across any execution environment.
* **Operational Integrity:** Audits marked `PENDING` enforce `NULL` execution dates, while completed audits enforce turnaround delays between 0 and 7 days.
* **Quality Assurance Test Cases:** Embeds 3 test records (`IsTestRecord = 1`) to validate downstream data cleansing rules, sanitization gates, and filter integrity.

---

## Reconciled Performance & Analytical Metrics

Across the production population ($N = 597$ verified non-test audits), the platform produces the following reconciled analytical figures:

| Metric Category | Verified Value | Analytical Interpretation |
| :--- | :--- | :--- |
| **Total Production Audits** | **597** | 600 raw records ingested minus 3 isolated test records (`IsTestRecord = 1`). |
| **Compliant Audits** | **406** | Standardized status codes (`PASS`, `PASSED`). |
| **Defect / Non-Compliant** | **160** | Standardized status codes (`FAIL`, `FAILED`, `REJECTED`). |
| **Pending Review** | **31** | Active audits awaiting field execution (`StatusCode = 'PENDING'`). |
| **Overall Compliance Rate** | **68.01%** | Computed as `[Compliant Audits] / [Total Audits]` (406 / 597). |
| **Average Turnaround Latency** | **3.0 Days** | Elapsed interval (`AuditDate - ScheduledDate`) across all executed records. |
| **Observed Latency Boundary** | **0 to 7 Days** | Strict boundary conformance with zero negative duration anomalies. |

---

## Repository Structure

```text
field-infrastructure-audit-analytics/
├── data/
│   ├── dim_regions.csv               # Region dimension (4 records)
│   ├── dim_technicians.csv           # Technician & vendor dimension (5 records)
│   └── fact_audits.csv               # Reconciled audit transactions (600 records)
├── docs/
│   ├── Category2_Currency_Dossier.pdf # 5-page compiled professional currency verification dossier
│   └── Screenshots/                  # Architecture & visual reporting evidence
│       ├── 01_star_schema_model.png   # Tabular star schema model relationships
│       ├── 02_executive_overview_dashboard.png # Executive KPI overview (68.01% compliance / 160 defects)
│       ├── 03_regional_quality_dashboard.png    # Regional compliance & defect category matrix
│       └── 04_operational_details_dashboard.png     # Technician latency and vendor SLA compliance
├── pbix/
│   └── Field_Audit_Analytics.pbix    # Tabular model with embedded cache
├── sql/
│   ├── 01_schema_and_views.sql       # DDL, bulk loading, and operational views
│   └── 02_data_quality_tests.sql     # Automated QA test suite (TC-01 to TC-07)
├── src/
│   └── data_pipeline_and_eda.ipynb   # Deterministic generator, EDA & Gate 1 assertions
├── .gitignore
└── README.md
```

---

## System Architecture & Visual Reports

### 1. Tabular Star Schema Architecture (VertiPaq Import Model)
![Kimball Star Schema Data Model](docs/Screenshots/01_star_schema_model.png)

### 2. Operational & Executive Quality Dashboard
![Executive Overview Dashboard](docs/Screenshots/02_executive_overview_dashboard.png)

### 3. Regional Quality & Defect Analysis Dashboard
![Regional Quality and Defect Analysis Dashboard](docs/Screenshots/03_regional_quality_dashboard.png)

### 4. Technician & Vendor Operational SLA Performance
![Operational and Vendor Performance](docs/Screenshots/04_operational_details_dashboard.png)

---

## Business Analysis & Functional Requirements (ANZSCO 261111)

### 1. Requirements Traceability Matrix (RTM)

| Req ID | Business Need / Operational Goal | System Specification | Technical Implementation | Business Decision Enabled |
| :--- | :--- | :--- | :--- | :--- |
| **REQ-01** | Identify contractors breaching contractual turnarounds | Calculate execution turnaround latency per completed audit | SQL `DATEDIFF` logic + DAX `[Avg Turnaround Days]` | Provides operational visibility to support review and route reallocation |
| **REQ-02** | Prevent skewed executive reporting from pipeline test data | Isolate automated validation records from production KPIs | SQL View filter `WHERE IsTestRecord = 0` | Unbiased executive KPI auditing ($N=597$ verified audits) |
| **REQ-03** | Correlate completed field audits against scheduled backlog | Support multiple date vectors against a single calendar table | Inactive relationship on `ScheduledDate` via DAX `USERELATIONSHIP` | Distinguish scheduling backlogs from field capacity delays |
| **REQ-04** | Monitor critical field defect concentrations | Aggregate and rank failure modes across regions | Standardized defect taxonomy + defect breakdown visual | Supports preventive maintenance prioritization |

---

## Architectural Decision: Direct Table Ingestion vs. SQL View

An operational reporting view (`vw_FieldAuditPerformance`) is provided in MySQL, but the Power BI semantic model ingests the normalized relational tables (`fact_audits`, `dim_regions`, `dim_technicians`) directly:

* **Kimball Star Schema Integrity:** Direct ingestion maintains a clean 1:Many single-direction star schema rather than collapsing entities into a single de-normalized table.
* **VertiPaq Memory Efficiency:** Storing text attributes (`TechnicianName`, `RegionName`) in shallow dimension tables while the fact table holds compact integer foreign keys optimizes dictionary encoding and minimizes cache overhead.
* **Role-Playing Date Dimensions:** Allows `fact_audits` to maintain an active relationship on `AuditDate` and an inactive relationship on `ScheduledDate` against `dim_date`, enabling dynamic time intelligence via `USERELATIONSHIP`.
* **Separation of Concerns:** `vw_FieldAuditPerformance` serves ad-hoc SQL users and flat-file exports, while the Power BI model serves multi-dimensional interactive analytics.

---

## Database Schema & Reporting Views

Implemented in MySQL 8.0 (`FieldAuditDB`):

* **`Dim_Regions`:** `RegionID` (PK), `RegionName`, `Territory`.
* **`Dim_Technicians`:** `TechnicianID` (PK), `TechnicianName`, `VendorName`.
* **`Fact_Audits`:** `AuditID` (PK), `SiteID`, `RegionID` (FK), `TechnicianID` (FK), `ScheduledDate`, `AuditDate`, `StatusCode`, `DefectCategory`, `IsTestRecord`.

```sql
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
```
*(See full implementation in [`sql/01_schema_and_views.sql`](sql/01_schema_and_views.sql))*

---

## Semantic Model & Key DAX Measures

### Model Configuration

* **Joins:** `dim_regions` (1:*, active), `dim_technicians` (1:*, active), `dim_date` on `AuditDate` (1:*, active), and `dim_date` on `ScheduledDate` (1:*, inactive).
* **Date Table:** `dim_date` is marked as an official Date Table.
* **Hygiene:** Foreign keys (`RegionID`, `TechnicianID`) are hidden in report view, and ID columns are set to **Don't Summarize**.

### Core DAX Measures (`_Measures`)

```dax
Compliance Rate % = 
DIVIDE(
    CALCULATE([Total Audits], fact_audits[AuditOutcome] = "Compliant"),
    [Total Audits],
    0
)
```

```dax
Avg Turnaround Days = 
AVERAGEX(
    FILTER(fact_audits, NOT(ISBLANK(fact_audits[AuditDate]))),
    DATEDIFF(fact_audits[ScheduledDate], fact_audits[AuditDate], DAY)
)
```

```dax
Audits Scheduled = 
CALCULATE(
    [Total Audits],
    USERELATIONSHIP(fact_audits[ScheduledDate], dim_date[Date])
)
```

```dax
Scheduled vs Executed Variance = [Audits Scheduled] - [Total Audits]
```

---

## 🧪 Quality Engineering & Data Validation Lifecycle (ANZSCO 263211)

### 1. Multi-Stage Quality Gates

* **Gate 1 — Ingestion & Schema Assertion (Python):** Enforces strict data types, non-null primary keys (`AuditID`), standardized ISO date formats, and bounded execution date intervals.
* **Gate 2 — Relational & Referential Integrity (MySQL):** Enforces 3NF foreign key constraints linking `fact_audits` to `dim_technicians` and `dim_regions`, quarantining orphan records.
* **Gate 3 — Test Data Isolation (SQL View):** Enforces production isolation rules via `WHERE a.IsTestRecord = 0`, quarantining mock records from operational reporting.
* **Gate 4 — Semantic Reconciliation (Power BI):** Direct-measure verification ensuring semantic aggregations match physical database records ($600 \text{ raw records} - 3 \text{ test records} = 597 \text{ production audits}$).

---

### 2. Python Pre-Ingestion Assertions (`src/data_pipeline_and_eda.ipynb`)

Automated assertion checks execute before CSV serialization to prevent upstream data anomalies:

```python
# Gate 1 Automated Quality Assertions
assert df_audits['AuditID'].is_unique, "Assertion Failure: Duplicate AuditID detected"
assert df_audits['AuditID'].notna().all(), "Assertion Failure: Null AuditID detected"
assert df_audits.loc[df_audits['StatusCode'] == 'PENDING', 'AuditDate'].isna().all(), "Pending audit contains execution date"

completed = df_audits[df_audits['StatusCode'].isin(['PASS', 'PASSED', 'FAIL', 'FAILED', 'REJECTED'])]
assert (pd.to_datetime(completed['AuditDate']) >= pd.to_datetime(completed['ScheduledDate'])).all(), "Negative turnaround interval"

failed = df_audits[df_audits['StatusCode'].isin(['FAIL', 'FAILED', 'REJECTED'])]
assert failed['DefectCategory'].notna().all(), "Non-compliant audit missing defect category"
```

---

### 3. Data Quality & Integrity Test Matrix (`sql/02_data_quality_tests.sql`)

| Test ID | Test Objective / Validation Gate | Verification Logic / SQL Rule | Expected Boundary | Test Result | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **TC-01** | Primary Key Uniqueness (`AuditID`) | `COUNT(AuditID) - COUNT(DISTINCT AuditID)` | 0 Duplicates | 0 Duplicates detected | **PASS** |
| **TC-02** | Status-Date Dependency Integrity | `WHERE StatusCode = 'PENDING' AND AuditDate IS NOT NULL` | 0 Records | 0 Records (31/31 NULL enforced) | **PASS** |
| **TC-03** | Turnaround Latency Boundary | `WHERE DATEDIFF(AuditDate, ScheduledDate) < 0` | 0 Negative intervals | Min: 0 days, Max: 7 days | **PASS** |
| **TC-04** | Referential Integrity (`RegionID`) | `LEFT JOIN Dim_Regions ... WHERE r.RegionID IS NULL` | 0 Orphan records | 0 Orphans detected | **PASS** |
| **TC-05** | Referential Integrity (`TechnicianID`)| `LEFT JOIN Dim_Technicians ... WHERE t.TechnicianID IS NULL` | 0 Orphan records | 0 Orphans detected | **PASS** |
| **TC-06** | Test Record Isolation | `WHERE IsTestRecord = 1` in production layer | 0 Test records | 3 records quarantined | **PASS** |
| **TC-07** | Defect Attribution Completeness | `WHERE StatusCode IN ('FAIL','FAILED','REJECTED') AND DefectCategory IS NULL` | 0 Null defects | 100% defects categorized (160/160) | **PASS** |

---

### 4. Applied 5-Whys Root Cause Analysis (RCA) Simulation

To demonstrate diagnostic problem-solving competency, recurring simulated field non-compliances are audited using standard 5-Whys methodology:

* **Simulated Problem Statement:** Analytical telemetry indicates Region South exhibited an SLA turnaround failure rate of 18.4% during Q3, with cycle times averaging 6.4 days against the 5.0-day benchmark.
  1. *Why did turnaround exceed SLA thresholds?* Field inspection completion times averaged 6.4 days against the 5.0-day contract limit.
  2. *Why were completion times elevated?* High concentration of Severity 1 (`Grounding Missing`) re-inspections saturated technician schedules.
  3. *Why were grounding defects clustering?* Subcontractor installation teams in Region South omitted secondary grounding torquing.
  4. *Why was torquing omitted?* The field dispatch instructions lacked a mandatory torque-wrench calibration checkpoint.
  5. *Why was the checkpoint missing?* Commissioning standard SOP-204 had not been updated following the latest hardware specification release.
* **Proposed Corrective & Preventive Action (CAPA):**
  * *Proposed Workflow Remediation:* Introduce a mandatory digital checklist and photo-verification gate into the field inspection mobile workflow requiring torque-wrench calibration sign-off prior to task closure.
  * *Preventive Monitoring Prototype:* Utilize the Power BI analytical model (`[Avg Turnaround Days]`) to establish automated threshold monitoring, visually flagging any regional cluster exceeding 4.5 days for immediate operational review.

---

## Reproduction Guide

1. **Generate Data & Run Assertions:**
   ```bash
   cd src/
   jupyter notebook data_pipeline_and_eda.ipynb
   # Run all cells to verify Gate 1 assertions and export fresh CSV files
   ```
2. **Execute MySQL Relational Build & Test Matrix:**
   ```bash
   mysql -u root -p < sql/01_schema_and_views.sql
   mysql -u root -p < sql/02_data_quality_tests.sql
   # Verify TC-01 through TC-07 return 'PASS'
   ```
3. **Open & Refresh Power BI Model:**
   * Open `pbix/Field_Audit_Analytics.pbix` in Power BI Desktop.
   * Click **Refresh** on the Home ribbon to pull from the database.
   * Confirm executive cards show: **597 Audits**, **68.01% Compliance**, **160 Defects**, and **3.0 Turnaround Days**.
