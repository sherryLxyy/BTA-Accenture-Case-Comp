/* ============================================================
   Reviewer access grants

   Source: Submission Access Checklist (Nov 10), page 2 shortcut.
   Deadline: Sunday 15 November 2026, 23:59 EST.

   Reviewers assess the solution inside the team workspace, so every
   object needs its own permission. Workspace admin alone is not enough.

   This file covers checklist steps 2 to 4, which can be done in SQL.
   Steps 1 and 5 to 10 are UI actions and are listed at the bottom.

   One principal per statement. Principals must use backticks, not
   single quotes, or Databricks raises PARSE_SYNTAX_ERROR.
   ============================================================ */

-- Step 1 of the checklist, done in the UI:
-- Settings > Identity and access > Users > Add user, Admin access ON.
--   ag.singh@rotman.utoronto.ca
--   momin.daanish@rotman.utoronto.ca
--   anuradha.rajkumar@accenture.com
--   bta@rotman.utoronto.ca


/* ---------- ag.singh@rotman.utoronto.ca ---------- */
GRANT USE CATALOG ON CATALOG ifc
  TO `ag.singh@rotman.utoronto.ca`;
GRANT USE SCHEMA, SELECT ON SCHEMA ifc.raw
  TO `ag.singh@rotman.utoronto.ca`;
GRANT USE SCHEMA, SELECT ON SCHEMA ifc.curated
  TO `ag.singh@rotman.utoronto.ca`;
GRANT USE SCHEMA, SELECT ON SCHEMA ifc.analytics
  TO `ag.singh@rotman.utoronto.ca`;
GRANT READ VOLUME ON VOLUME ifc.raw.raw_files
  TO `ag.singh@rotman.utoronto.ca`;


/* ---------- momin.daanish@rotman.utoronto.ca ---------- */
GRANT USE CATALOG ON CATALOG ifc
  TO `momin.daanish@rotman.utoronto.ca`;
GRANT USE SCHEMA, SELECT ON SCHEMA ifc.raw
  TO `momin.daanish@rotman.utoronto.ca`;
GRANT USE SCHEMA, SELECT ON SCHEMA ifc.curated
  TO `momin.daanish@rotman.utoronto.ca`;
GRANT USE SCHEMA, SELECT ON SCHEMA ifc.analytics
  TO `momin.daanish@rotman.utoronto.ca`;
GRANT READ VOLUME ON VOLUME ifc.raw.raw_files
  TO `momin.daanish@rotman.utoronto.ca`;


/* ---------- anuradha.rajkumar@accenture.com ---------- */
GRANT USE CATALOG ON CATALOG ifc
  TO `anuradha.rajkumar@accenture.com`;
GRANT USE SCHEMA, SELECT ON SCHEMA ifc.raw
  TO `anuradha.rajkumar@accenture.com`;
GRANT USE SCHEMA, SELECT ON SCHEMA ifc.curated
  TO `anuradha.rajkumar@accenture.com`;
GRANT USE SCHEMA, SELECT ON SCHEMA ifc.analytics
  TO `anuradha.rajkumar@accenture.com`;
GRANT READ VOLUME ON VOLUME ifc.raw.raw_files
  TO `anuradha.rajkumar@accenture.com`;


/* ---------- bta@rotman.utoronto.ca ---------- */
GRANT USE CATALOG ON CATALOG ifc
  TO `bta@rotman.utoronto.ca`;
GRANT USE SCHEMA, SELECT ON SCHEMA ifc.raw
  TO `bta@rotman.utoronto.ca`;
GRANT USE SCHEMA, SELECT ON SCHEMA ifc.curated
  TO `bta@rotman.utoronto.ca`;
GRANT USE SCHEMA, SELECT ON SCHEMA ifc.analytics
  TO `bta@rotman.utoronto.ca`;
GRANT READ VOLUME ON VOLUME ifc.raw.raw_files
  TO `bta@rotman.utoronto.ca`;


/* ============================================================
   UI-only steps, one per reviewer. Not expressible in SQL.

     Step 1  Workspace admin
             Settings > Identity and access > Users > Add user
             with Admin access turned on.

     Step 5  SQL warehouse
             SQL Warehouses > Serverless Starter Warehouse > Permissions
             Grant "Can use".

     Step 6  Genie space
             Genie Agents > our space > Share, grant "Can manage".
             Genie answers using each user's own table permissions,
             so steps 2 to 5 must be in place first or reviewers see
             a permission warning even though the space is shared.

     Step 7  Agents and serving endpoints
             Agents > our agent > Permissions, grant "Can manage".

     Steps 8 to 10 apply only if we build an app, dashboard or secret.
   ============================================================ */

/* Final check from the checklist, run before the deadline:
   a teammate who did NOT build the solution signs in, opens the team
   folder, runs a notebook top to bottom, opens the Genie space and asks
   a question, then asks the agent a question. Any failure is a missing
   permission, not a code problem. */
