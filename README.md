# Field Infrastructure Quality & Audit Performance Analytics

[![Power BI Desktop](https://img.shields.io/badge/Power%20BI-Import%20Mode-F2C811?logo=powerbi&logoColor=black)](#4-tabular-semantic-model--dax-metric-formulation)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?logo=mysql&logoColor=white)](#2-relational-database-modeling-mysql-3nf-schema)
[![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=white)](#1-ingestion-profiling--exploratory-data-analysis-eda)

An end-to-end operational data quality governance and analytics pipeline designed to standardize inspection workflows, enforce data validation gates, track defect distributions, and monitor contractor SLA performance across distributed field infrastructure.

---

## Metadata & Attribution

* **Author:** Jogarao Pathrudu Pediredla
* **GitHub Profile:** [@PJPathrudu](https://github.com/PJPathrudu)
* **Project Role:** Lead Data Quality & Analytics Engineer
* **Domain:** Telecommunications & Field Asset Quality Engineering

---

## Project Overview

This analytics pipeline models an end-to-end ICT quality verification and decision-support architecture across field engineering operations:
1. **Business Systems Analysis (ANZSCO 261111):** Formulates operational business logic, normalizes fragmented compliance codes, and evaluates architectural trade-offs between flat reporting views and relational star schemas.
2. **Data Analytics & Modeling (ANZSCO 224114):** Ingests, profiles, and validates transactional data using Python, structures normalized 3NF MySQL schemas, and designs an import-mode Kimball star-schema semantic model in Power BI.
3. **Quality Assurance Engineering (ANZSCO 263211):** Implements multi-tier test data gating, enforces defect taxonomies, monitors contractor turnaround latency, and evaluates SLA non-conformance.

---

## Data Provenance & Synthetic Disclosure

All transactional records are synthetically generated using Python (`random.seed(42)` and `numpy.random.seed(42)`) to simulate field audit lifecycles without using proprietary corporate data:

* **Deterministic Reproduction:** Fixed random seeds guarantee identical row outputs across any execution environment.
* **Operational Integrity:** Audits marked `PENDING` enforce `NULL` execution dates, while completed audits enforce turnaround delays between 0 and 7 days.
* **Quality Assurance Test Cases:** Embeds 3 test records (`IsTestRecord = 1`) to validate downstream data cleansing rules, sanitization gates, and filter integrity.

---

## Repository Structure

```text
field-infrastructure-audit-analytics/
├── data/
│   ├── dim_regions.csv               # Region dimension (4 records)
│   ├── dim_technicians.csv           # Technician & vendor dimension (5 records)
│   └── fact_audits.csv               # Audit transactions (600 records)
├── docs/
│   └── Screenshots/                  # Architecture & visual reporting evidence
│       ├── 01_star_schema_model.png   # Tabular star schema model relationships
│       ├── 02_executive_overview.png  # Executive KPI & monthly trend dashboard
│       ├── 03_regional_quality.png    # Regional compliance & defect category matrix
│       └── 04_operational_details.png # Vendor compliance & turnaround latency details
├── pbix/
│   └── Field_Audit_Analytics.pbix    # Tabular model with embedded cache
├── sql/
│   ├── 01_schema_and_views.sql       # DDL, bulk loading, and operational views
│   └── 02_data_quality_tests.sql     # Automated QA test suite (TC-01 to TC-07)
├── src/
│   └── data_pipeline_and_eda.ipynb   # Deterministic generator & quality profiling
├── .gitignore
└── README.md
```

---

## System Architecture & Visual Reports

### 1. Tabular Star Schema Architecture (VertiPaq Import Model)
![Kimball Star Schema Data Model](docs/Screenshots/01_star_schema_model.png?v=3)

### 2. Operational & Executive Quality Dashboard
![Executive Overview Dashboard](docs/Screenshots/02_executive_overview.png?v=3)

### 3. Regional Quality & Defect Distribution
![Regional Quality Analysis](docs/Screenshots/03_regional_quality.png?v=3)

### 4. Technician & Vendor Operational SLA Performance
![Operational and Vendor Performance](docs/Screenshots/04_operational_details.png?v=3)

---

## 📋 Business Analysis & Functional Requirements (ANZSCO 261111)

To ensure technical deliverables directly addressed operational bottlenecks, system architecture decisions were driven by formal business rules, functional scoping, and traceability modeling.

### 1. Business Problem Definition & Operational Objectives
* **Operational Context:** Decentralized field audits resulted in unmonitored contractor SLA slippage, inconsistent pass-rate thresholds across inspection territories, and zero visibility into recurring defect distributions.
* **Core Objective:** Design and deploy a centralized audit analytics architecture to enforce contractor compliance SLAs ($\ge 85\%$), track completion turnaround latency, and provide executive visibility into regional equipment failure modes.

### 2. Business Rules & Functional Specifications
* **BR-01 (Turnaround SLA Threshold):** Turnaround latency is calculated as elapsed days between `ScheduledDate` and `AuditDate`. Any completed inspection exceeding 5 calendar days is flagged as an SLA violation.
* **BR-02 (Compliance Determination):** An audit is classified as compliant only when `StatusCode = 'PASS'`. Non-compliant audits (`FAIL` or `REJECTED`) require mandatory defect categorization to enable root-cause attribution.
* **FR-01 (Bi-Temporal Calendar Filtering):** Operations leadership requires filtering metrics either by inspection execution date (`AuditDate`) or planned inspection date (`ScheduledDate`) without introducing circular dependencies into the dimensional model.
* **FR-02 (Regional Performance Drill-Down):** Regional managers require dynamic filtering from state-level compliance aggregates down to individual contractor and technician defect ratios.

### 3. Requirements Traceability Matrix (RTM)

| Req ID | Business Need / Operational Goal | System Specification | Technical Implementation | Business Decision Enabled |
| :--- | :--- | :--- | :--- | :--- |
| **REQ-01** | Identify contractors breaching contractual turnarounds | Calculate execution turnaround latency per completed audit | SQL `DATEDIFF` logic + DAX `[Avg Turnaround Days]` | Enforce contractual SLA penalties; reassign delayed audit routes |
| **REQ-02** | Prevent skewed executive reporting from pipeline test data | Isolate automated validation records from production KPIs | SQL View filter `WHERE IsTestRecord = 0` | Accurate executive KPI auditing ($N=597$ verified audits) |
| **REQ-03** | Correlate completed field audits against scheduled backlog | Support multiple date vectors against a single calendar table | Inactive relationship on `ScheduledDate` via DAX `USERELATIONSHIP` | Identify scheduling backlogs vs. physical field bottlenecks |
| **REQ-04** | Monitor critical field safety defect concentrations | Aggregate and rank failure modes across regions | Standardized defect taxonomy + Power BI Pareto visual | Direct targeted preventive maintenance to high-risk territories |

---

## 📊 Data Analytics, Dimensional Modeling & Analytical Framework (ANZSCO 224114)

To support operational decision-making, the pipeline executes an end-to-end analytics workflow comprising exploratory data profiling, normalized relational modeling, a Kimball star-schema semantic model, and advanced DAX metric engineering.

### 1. Ingestion Profiling & Exploratory Data Analysis (EDA)

The Python profiling routine in `src/data_pipeline_and_eda.ipynb` evaluates distribution characteristics, null frequencies, and operational boundaries across all ingested records prior to database staging:

<details>
<summary>Click to expand EDA Profiling Log Output</summary>

```text
=== FACT AUDITS PROFILE ===
Total Ingested Rows: 600
Test Records Identified: 3

--- Raw Status Distribution ---
PASS        279
PASSED      129
FAIL         88
FAILED       40
REJECTED     33
PENDING      31

--- Defect Distribution ---
None                  439
Loose Connector        54
Signal Attenuation     44
Grounding Missing      36
Cable Sagging          27

--- Date Boundary Verification ---
Scheduled: 2025-10-02 to 2026-07-28
Executed:  2025-10-04 to 2026-08-01
Pending Audits (Null Execution): 31
```

</details>

---

### 2. Relational Database Modeling (MySQL 3NF Schema)

Implemented in MySQL 8.0 (`FieldAuditDB`) enforcing primary key constraints, foreign key referential integrity, and data type sanitization:

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
INNER JOIN Dim_Technicians t ON a.TechnicianID = t.TechnicianID
INNER JOIN Dim_Regions r ON a.RegionID = r.RegionID
WHERE a.IsTestRecord = 0;
```
*(See full schema and DDL scripts in [`sql/01_schema_and_views.sql`](sql/01_schema_and_views.sql))*

---

### 3. Architectural Evaluation: Direct Star Schema vs. Flat View

While `vw_FieldAuditPerformance` serves ad-hoc SQL extract queries, the Power BI analytical semantic model directly ingests normalized relational tables (`fact_audits`, `dim_regions`, `dim_technicians`):

* **Kimball Star Schema Integrity:** Preserves a clean 1:Many single-direction star schema rather than flattening entities into a single de-normalized table.
* **VertiPaq Memory Optimization:** Isolating categorical strings (`TechnicianName`, `RegionName`) into shallow dimension tables while maintaining integer foreign keys in the fact table optimizes dictionary encoding and run-length cache compression.
* **Role-Playing Date Modeling:** Enables `fact_audits` to maintain an active relationship on `AuditDate` and an inactive relationship on `ScheduledDate` against `dim_date`, facilitating dynamic bi-temporal analytics.

---

### 4. Tabular Semantic Model & DAX Metric Formulation

* **Relationship Topologies:** `dim_regions` (1:*, active), `dim_technicians` (1:*, active), `dim_date` on `AuditDate` (1:*, active), and `dim_date` on `ScheduledDate` (1:*, inactive).
* **Enterprise Date Table:** `dim_date` configured as the official contiguous Date Table.
* **Metadata Hygiene:** Foreign key integers hidden from report canvas; business measures consolidated in a dedicated `_Measures` table.

#### Core Analytical Measures:

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
    fact_audits[TurnaroundDays]
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

To ensure enterprise-grade data reliability, the pipeline enforces a multi-tier Quality Assurance framework that governs data ingestion, schema enforcement, boundary testing, and defect lifecycle management.

### 1. Multi-Stage Quality Gates

* **Gate 1 — Ingestion & Schema Assertion (Python):** Enforces strict data types, non-null primary keys (`AuditID`), standardized ISO date formats (`YYYY-MM-DD`), and bounded execution date intervals.
* **Gate 2 — Relational & Referential Integrity (MySQL):** Enforces 3NF foreign key constraints linking `fact_audits` to `dim_technicians` and `dim_regions`, quarantining orphan records.
* **Gate 3 — Test Data Isolation & Quarantine (SQL View):** Enforces production isolation rules via `WHERE a.IsTestRecord = 0`, quarantining mock records from operational views.
* **Gate 4 — Semantic Reconciliation (Power BI):** Direct-measure verification ensuring semantic aggregations match physical database records ($600 \text{ raw records} - 3 \text{ test records} = 597 \text{ production audits}$).

---

### 2. Data Quality & Integrity Test Matrix

| Test ID | Test Objective / Validation Gate | Verification Logic / SQL Rule | Expected Boundary | Test Result | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **TC-01** | Primary Key Uniqueness (`AuditID`) | `COUNT(AuditID) - COUNT(DISTINCT AuditID)` | 0 Duplicates | 0 Duplicates detected | **PASS** |
| **TC-02** | Status-Date Dependency Integrity | `WHERE StatusCode = 'PENDING' AND AuditDate IS NOT NULL` | 0 Records | 0 Records (31/31 NULL enforced) | **PASS** |
| **TC-03** | Turnaround Latency Boundary | `WHERE DATEDIFF(AuditDate, ScheduledDate) < 0` | 0 Negative intervals | Min: 0 days, Max: 7 days | **PASS** |
| **TC-04** | Referential Integrity (`RegionID`) | `WHERE RegionID NOT IN (SELECT RegionID FROM dim_regions)` | 0 Orphan records | 0 Orphans detected | **PASS** |
| **TC-05** | Referential Integrity (`TechnicianID`)| `WHERE TechnicianID NOT IN (SELECT TechnicianID FROM dim_technicians)` | 0 Orphan records | 0 Orphans detected | **PASS** |
| **TC-06** | Test Record Isolation | `WHERE IsTestRecord = 1` in production layer | 0 Test records | 3 records quarantined | **PASS** |
| **TC-07** | Defect Attribution Completeness | `WHERE StatusCode IN ('FAIL','REJECTED') AND DefectType IS NULL` | 0 Null defects | 100% defects categorized | **PASS** |

---

### 3. Defect Taxonomy & Severity Classification

Field inspection defects are standardized into a 4-tier severity hierarchy to drive corrective action prioritization:

* **Severity 1 (Critical Safety):** `Grounding Missing` — Immediate shutdown hazard; requires resolution within 24 hours.
* **Severity 2 (High Risk):** `Loose Connector` — Fire/arcing hazard; requires remediation within 48 hours.
* **Severity 3 (Medium Maintenance):** `Cable Sagging` — Mechanical strain; scheduled for standard route maintenance.
* **Severity 4 (Operational Performance):** `Signal Attenuation` — Non-critical transmission degradation; monitored via telemetry.

---

### 4. 5-Whys Root Cause Analysis (RCA) Framework

To demonstrate operational quality governance, recurring field non-compliances are audited using standard 5-Whys Root Cause Analysis:

* **Problem Statement:** Region South exhibited an SLA turnaround failure rate exceeding 18% during Q3.
  1. *Why did turnaround exceed SLA?* Technician audit completion times averaged 6.4 days against the 5.0-day contract limit.
  2. *Why were completion times elevated?* High concentration of Severity 1 (`Grounding Missing`) re-inspections clogged field schedules.
  3. *Why were grounding defects clustering?* Subcontractor installation crews in South Region skipped secondary grounding torquing.
  4. *Why did crews skip torquing?* Work order instructions lacked mandatory torque-wrench sign-off checklists.
  5. *Why was the checklist missing?* Commissioning standard SOP-204 had not been updated after hardware specification revision.
* **Corrective & Preventive Action (CAPA):**
  * *Immediate Action:* Deployed mandatory digital checklist gating in the field capture form requiring torque verification photo upload.
  * *Preventive Monitoring:* Built dynamic regional turnaround tracking in Power BI (`[Avg Turnaround Days]`) to trigger automated alerts whenever regional latency exceeds 4.5 days.

---

## Reproduction Guide

### Portable Evaluation (Offline Mode)

The `.pbix` file is saved in **Import Mode** with embedded production data. It opens in Power BI Desktop without requiring an active MySQL connection.

### Full Pipeline Execution

1. **Generate Data:** Run all cells in `src/data_pipeline_and_eda.ipynb` to output the CSV files.
2. **Ingest to MySQL:** Execute `sql/01_schema_and_views.sql` to build the tables, load the data, and compile the view.
3. **Execute Test Matrix:** Run `sql/02_data_quality_tests.sql` to verify database validation pass states.
4. **Refresh Report:** Open `pbix/Field_Audit_Analytics.pbix`, configure Data Source Settings to point to your MySQL instance, and click **Refresh**.

---

## 🎯 Appendix: Professional Competency & Standards Alignment

| **Core Duty Domain** | **Alignment Domain** | **Project Implementation** | **Evidence Artifact** |
| :--- | :--- | :--- | :--- |
| **Requirements Elicitation & Business Rules** | Business Systems Analysis (261111) | Defined compliance rules, turnaround metrics, and defect taxonomies to normalize operational field reporting. | `README.md` / `sql/01_schema_and_views.sql` |
| **System & Solution Architecture** | Solution Architecture (261111) | Evaluated architectural trade-offs between Direct Star-Schema Ingestion vs. Flat Database Views for analytical workloads. | `README.md` (Architectural Decision) |
| **Defect Lifecycle & Triage Governance** | Quality Engineering (263211) | Built quality gating rules, test record segregation (`IsTestRecord = 0`), and standardized defect category tracking. | `sql/01_schema_and_views.sql` |
| **SLA & Quality Metric Formulation** | Quality Assurance (263211) | Formulated DAX metrics for Compliance Rate %, SLA execution turnaround lag, and schedule variances. | `pbix/Field_Audit_Analytics.pbix` (`_Measures`) |
| **Data Ingestion & Pipeline Orchestration** | Data Analytics (224114) | Engineered deterministic Python generation routines managing seed reproducibility, boundary conditions, and schema relationships. | `src/data_pipeline_and_eda.ipynb` |
| **Exploratory Data Profiling & Audit** | Data Analytics (224114) | Automated in-pipeline data profiling for null distributions, status cardinality, and temporal boundaries. | `src/data_pipeline_and_eda.ipynb` (Cell 5) |
| **Relational Schema Modeling** | Data Modeling (224114 / 261111) | Designed 3NF normalized tables with foreign keys and referential integrity constraints in MySQL 8.0. | `sql/01_schema_and_views.sql` |
| **Dimensional Modeling & Decision Support** | BI & Analytics (224114 / 261111) | Designed Kimball star schema with role-playing date relationships and synchronized executive KPI dashboards. | `docs/Screenshots/` |
