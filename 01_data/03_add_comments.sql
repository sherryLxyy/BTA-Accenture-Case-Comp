-- ============================================================
-- 03_add_comments: table and column documentation
-- Run order: 4/4 (after data_quality_checks)
-- Purpose: Genie and the AI agents rely on these comments to
--          interpret business semantics. Also visible evidence
--          for the "architecture and governance" criterion.
-- Note: project_number is documented as a polluted field on purpose.
-- ============================================================

COMMENT ON TABLE ifc.curated.projects IS
'Project disclosure table, one row per project (project_url is unique). All amounts in USD millions. project_number contains duplicated values and must not be used for joins or grouping.';

COMMENT ON TABLE ifc.curated.monitoring IS
'Portfolio monitoring table, one row per monitored project. Covers Active / Closed / Pending only; Dropped projects have no monitoring record.';

COMMENT ON TABLE ifc.curated.portfolio IS
'IFC portfolio master table, one row per project, combining disclosure and monitoring data via LEFT JOIN on project_url. All WS2 / WS3 analysis reads from this table.';

COMMENT ON TABLE ifc.curated.data_quality_checks IS
'Data quality audit results: one row per confirmed issue, with affected row count, share of portfolio and remediation rule.';

-- ---------------- Key columns (semantic source for Genie) ----------------

COMMENT ON COLUMN ifc.curated.portfolio.project_url IS
'Unique project identifier. Primary key and the only valid join key between the two source tables.';

COMMENT ON COLUMN ifc.curated.portfolio.project_number IS
'IFC project number. Duplicated across unrelated projects (1,126 numbers map to multiple projects). Display only -- never use for JOIN, GROUP BY or deduplication.';

COMMENT ON COLUMN ifc.curated.portfolio.status IS
'Lifecycle status: Active (in progress) / Pending (not yet finalised) / Closed (concluded) / Dropped (cancelled; no monitoring record).';

COMMENT ON COLUMN ifc.curated.portfolio.performance_status IS
'Loan performance: Performing / Watchlist (early warning) / Past Due (overdue) / Completed / Exited at a loss. NULL for Pending projects.';

COMMENT ON COLUMN ifc.curated.portfolio.internal_risk_rating IS
'Internal credit rating from 1 (lowest risk) to 6 (highest risk).';

COMMENT ON COLUMN ifc.curated.portfolio.risk_band IS
'Risk band derived from internal_risk_rating: Low (1-2) / Medium (3-4) / High (5-6).';

COMMENT ON COLUMN ifc.curated.portfolio.is_flagged IS
'TRUE when the project is Past Due or on the Watchlist, i.e. requires Board-level attention.';

COMMENT ON COLUMN ifc.curated.portfolio.total_approved_usd_mm IS
'Total amount approved by the Board, in USD millions. Primary measure. Differs from the sum of the four product lines for 146 projects by more than USD 1 million.';

COMMENT ON COLUMN ifc.curated.portfolio.disbursed_usd_mm IS
'Amount actually disbursed to date, in USD millions. NULL for Pending projects; no record for Dropped projects. Use this field, not the approved amount, when sizing loss reserves.';

COMMENT ON COLUMN ifc.curated.portfolio.environmental_category IS
'Environmental and social risk category: A (potentially significant impact) / B (limited) / C (minimal or none).';

COMMENT ON COLUMN ifc.curated.portfolio.region IS
'One of 7 standard regions. Historical variants normalised: Latin America & Caribbean -> Latin America; Middle East & North Africa -> Middle East.';

COMMENT ON COLUMN ifc.curated.portfolio.product_line IS
'Principal financing product: Loan / Equity / Guarantee / Risk Management.';

COMMENT ON COLUMN ifc.curated.portfolio.product_total_diff_usd_mm IS
'Approved total minus the sum of the four product lines, in USD millions. Used to detect inconsistent figures.';

COMMENT ON COLUMN ifc.curated.portfolio.client_id IS
'Unique client identifier. One client can hold multiple projects; this is the grouping key for client-level exposure analysis.';

COMMENT ON COLUMN ifc.curated.portfolio.client_name IS
'Client name, one-to-one with client_id.';

COMMENT ON COLUMN ifc.curated.portfolio.approval_date IS
'Board approval date. NULL means not yet approved. Note: 663 rows have status Pending yet carry an approval date; the status field takes precedence.';

COMMENT ON COLUMN ifc.curated.portfolio.invested_date IS
'Date of first disbursement. NULL means no funds disbursed (naturally NULL for Pending and Dropped projects).';
