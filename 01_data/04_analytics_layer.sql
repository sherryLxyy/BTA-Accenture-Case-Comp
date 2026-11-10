-- ============================================================
-- 04_analytics_layer: shared definitions used by the WS1 answers
-- Run after 01_load_and_prepare (needs ifc.curated.projects).
-- Purpose: define each shared rule once, so every answer, Genie
--          and the agents use the same filter, date and text rules.
-- Outputs: ifc.analytics.config_params
--          ifc.analytics.projects_excl_dropped   (view)
--          ifc.analytics.project_text_flags        (text-derived fields)
-- ============================================================

/* Reference date for "last 5 years" (README A-03): the latest As of Date
   in the data, so answers do not change with the day they are run. */
CREATE OR REPLACE TABLE ifc.analytics.config_params AS
SELECT MAX(as_of_date) AS ref_date
FROM ifc.curated.projects;

COMMENT ON TABLE ifc.analytics.config_params IS
'Shared parameters. ref_date is the latest As of Date in the data (snapshot date); "last 5 years" means approval_date after ref_date minus 60 months and up to ref_date.';

/* "Excluding Dropped" is defined here once (README A-04). Questions that
   say "excluding Dropped" read this view instead of repeating the filter. */
CREATE OR REPLACE VIEW ifc.analytics.projects_excl_dropped
COMMENT 'ifc.curated.projects without Dropped projects. Use when a question says "excluding Dropped".'
AS
SELECT * FROM ifc.curated.projects
WHERE status IS NOT NULL AND status <> 'Dropped';

/* ------------------------------------------------------------
   Text-derived fields (README A-11) for Q13, Q24, Q25, Q26.
   Fixed pattern rules over Project Description, not a model.
   Hand-label about 50 descriptions and report the agreement
   next to the answers.
   ------------------------------------------------------------ */
CREATE OR REPLACE TABLE ifc.analytics.project_text_flags AS
WITH t AS (
  SELECT project_url, lower(coalesce(project_description, '')) AS d,
         substr(lower(coalesce(project_description, '')), 1, 110) AS lead
  FROM ifc.curated.projects
),
cap AS (
  SELECT project_url, d, lead,
    -- "expand its existing N MW plant by a further M MW": new capacity is M
    coalesce(
      nullif(regexp_extract(d, 'by a further ([0-9][0-9,.]*) ?(mw|gw|megawatts?)([^a-z]|$)', 1), ''),
      nullif(regexp_extract(d, '([0-9][0-9,.]*) ?(mw|gw|megawatts?)([^a-z]|$)', 1), '')
    ) AS cap_num,
    CASE WHEN regexp_like(d, 'by a further ([0-9][0-9,.]*) ?(mw|gw|megawatts?)([^a-z]|$)')
         THEN regexp_extract(d, 'by a further ([0-9][0-9,.]*) ?(mw|gw|megawatts?)([^a-z]|$)', 2)
         ELSE regexp_extract(d, '([0-9][0-9,.]*) ?(mw|gw|megawatts?)([^a-z]|$)', 2) END AS cap_unit
  FROM t
)
SELECT
  project_url,
  -- the two closing sentences used by new renewable generation projects
  (d LIKE '%add renewable generation to the national grid%'
   OR d LIKE '%clean, zero-emission electricity%')                         AS has_generation_sentence,
  -- new renewable generation: signature sentence OR technology + build verb,
  -- minus decoys (rooftop solar for own use, backup for existing farms,
  -- gas, transmission, energy-efficiency lending)
  ((d LIKE '%add renewable generation to the national grid%'
    OR d LIKE '%clean, zero-emission electricity%')
   OR (regexp_like(d, 'solar|wind|hydropower|geothermal|biomass')
       AND regexp_like(d, 'build|construct|develop|first ')
       AND NOT regexp_like(d, 'rooftop|own use|energy efficiency|gas-fired|transmission|backup|battery storage system')
       AND NOT regexp_like(d, 'lending')))                                  AS is_new_renewable_gen,
  try_cast(replace(cap_num, ',', '') AS DOUBLE)
    * CASE WHEN cap_unit = 'gw' THEN 1000 ELSE 1 END                        AS capacity_mw,
  -- MSME financing: positive wording, not negated, not supplier boilerplate,
  -- not retail microloans to households
  (regexp_like(d, 'micro, small and medium|msme|(^|[^a-z])smes?([^a-z]|$)|small and medium|micro-entrepreneurs|small firms|small businesses in|credit lines for small|small traders|small companies')
   AND NOT regexp_like(d, 'outside the scope|rather than|limited to mortgage|local smes'))  AS is_msme,
  CASE
    WHEN d LIKE '%women%'                                  THEN 'Women-owned or women-led businesses'
    WHEN d LIKE '%rural and agricultural%'                 THEN 'Rural and agricultural small businesses'
    WHEN d LIKE '%young entrepreneurs%'                    THEN 'Young entrepreneurs'
    WHEN d LIKE '%energy efficiency%'                      THEN 'Small businesses investing in energy efficiency / climate'
    WHEN d LIKE '%micro-entrepreneurs%'                    THEN 'Micro-entrepreneurs and small traders'
    WHEN d LIKE '%working capital loans to small firms%'   THEN 'Small firms (working capital)'
    ELSE 'General MSME / SME lending'
  END AS msme_group,
  -- products named in the opening words (IFC product phrases only)
  regexp_like(lead, 'minority shareholding|equity investment|equity participation|equity stake') AS describes_equity,
  regexp_like(lead, 'guarantee')                                                                AS describes_guarantee,
  regexp_like(lead, 'risk management facility|currency hedging|interest rate swap|derivative hedging') AS describes_risk_mgmt,
  regexp_like(lead, 'a-loan|senior loan|long-term loan|debt financing')                         AS describes_loan
FROM cap;

COMMENT ON TABLE ifc.analytics.project_text_flags IS
'Fields derived from Project Description by fixed pattern rules (no model). One row per project_url. Answers that use them require human review.';
COMMENT ON COLUMN ifc.analytics.project_text_flags.is_new_renewable_gen IS
'TRUE when the description says the project builds or expands renewable power generation (solar, wind, hydropower, geothermal, biomass). Excludes rooftop solar for own use, backup for existing farms, gas, transmission and battery-only projects.';
COMMENT ON COLUMN ifc.analytics.project_text_flags.capacity_mw IS
'Stated generation capacity in MW (GW x 1000; for expansions, the added capacity). NULL when the description states none. Never imputed. MWh battery storage is ignored.';
COMMENT ON COLUMN ifc.analytics.project_text_flags.is_msme IS
'TRUE when the description says the financing targets micro, small or medium enterprises. Excludes negated wording and supplier boilerplate.';
COMMENT ON COLUMN ifc.analytics.project_text_flags.msme_group IS
'Rule-based bucket for the business group targeted by MSME financing.';
COMMENT ON COLUMN ifc.analytics.project_text_flags.describes_equity IS
'TRUE when the opening words of the description name an equity product. Same for describes_guarantee, describes_risk_mgmt and describes_loan; used to compare against product_line (Q26).';
