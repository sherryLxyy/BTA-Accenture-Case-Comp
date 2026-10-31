-- ============================================================
-- 00_config: environment bootstrap
-- Run order: 1/4
-- Purpose: create catalog / schema / volume. Idempotent, safe to re-run.
-- ============================================================

CREATE CATALOG IF NOT EXISTS ifc;
CREATE SCHEMA IF NOT EXISTS ifc.raw;        -- raw landing zone (traceable to source)
CREATE SCHEMA IF NOT EXISTS ifc.curated;    -- cleaned layer (analysis-ready)
CREATE SCHEMA IF NOT EXISTS ifc.analytics;  -- exposed to Genie / agents

-- Landing volume for the two source CSVs (uploaded manually)
CREATE VOLUME IF NOT EXISTS ifc.raw.raw_files;
