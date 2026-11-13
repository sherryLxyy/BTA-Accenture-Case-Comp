# IFC WS1 Query Results

> **Run:** produced against the snapshot window, 2026-06-30 with 60 months back
> (2021-07-01 to 2026-06-30), not against calendar years. An earlier run used
> calendar years and returned USD 58,320.4 million for Q1; the snapshot window
> returns 52,375.8 million, which is also the figure quoted in assumption A-01.
> See `02_q1_window_reconciliation.sql` for the comparison.
>
> **Coverage:** Q1 to Q12 and Q18 to Q23. Q13 to Q17 and Q24 to Q30 are not yet
> in this file.

## Q1. Total IFC loan investment by region

Projects approved in the last 5 years.

> **Assumption:** Dropped projects are included. They were approved by the Board, so they belong in an approval-based measure.
>
> **North America shows zero** because no North American project was approved
> inside the window. Existing NA commitments still carry USD 375.9 million
> undisbursed, which is visible in the Q4 view.

|region|total_loan_usd_mm|
|---|---|
|Sub-Saharan Africa|15240.2|
|Latin America|10607.5|
|East Asia & Pacific|7675.1|
|Europe & Central Asia|6988.9|
|South Asia|6531.1|
|Middle East|5333.1|
|North America|0|

Seven regions total USD 52,375.8 million across 1,595 projects.

## Q2. Top 10 projects by total IFC investment

Ranked by total IFC investment as approved by the Board.

|project_name|country|region|status|total_approved_usd_mm|
|---|---|---|---|---|
|Varas Works Pharma 2021|Philippines|East Asia & Pacific|Active|299.9945800508138|
|Berdan Industries Energy Efficiency|Philippines|East Asia & Pacific|Dropped|299.85634837962436|
|Berva Communications Tower Portfolio|Dominican Republic|Latin America|Dropped|299.78115891237917|
|Loven Industries Packaging Line|Jordan|Middle East|Pending|299.7596802844302|
|Zansor Foods Storage|Kyrgyz Republic|Europe & Central Asia|Pending|299.7549211491831|
|Julan Capital Housing Finance II|Bahamas|Latin America|Closed|299.65341043908904|
|Prazanhar Foods Processing Expansion II|Sao Tome and Principe|Sub-Saharan Africa|Pending|299.6138990045855|
|Kaom Manufacturing Packaging Line II|Mongolia|East Asia & Pacific|Active|299.5699319718088|
|Yorzenta Finance Microfinance II|Mexico|Latin America|Active|299.4191322249721|
|Yorzenta Finance Microfinance|Pakistan|South Asia|Active|299.35500036059716|

## Q3. Equity vs loan investment across industries

Excludes Dropped projects.

|industry|loan_usd_mm|equity_usd_mm|loan_to_equity|
|---|---|---|---|
|Agribusiness|29900.9|27046.6|1.11|
|Energy|27771.6|30630.3|0.91|
|Manufacturing|26480|29811.9|0.89|
|Finance|25510.5|26903.2|0.95|
|Telecom|24167.4|25002.2|0.97|

## Q4. Countries with more than USD 1,000 million of IFC loan investment

Across Active and Closed projects.

> **Note:** The column is in USD millions, so the threshold is 1000, not 1e9.

|country|total_loan_usd_mm|
|---|---|
|Brazil|2373.3|
|India|2272.6|
|Turkey|2095.3|
|Vietnam|1794|
|Indonesia|1778.5|
|Georgia|1699.3|
|Bangladesh|1665.5|
|Morocco|1564.2|
|Ghana|1500.9|
|Cambodia|1415.2|
|Jordan|1373.6|
|Tanzania|1303.3|
|Uganda|1298.7|
|Bolivia|1290|
|Egypt|1260.5|
|Malaysia|1195.7|
|Nigeria|1182|
|Colombia|1179.3|
|Paraguay|1148.9|
|Argentina|1088.9|
|Tuvalu|1070.4|
|Mozambique|1017.6|
|Senegal|1016|

## Q5. Trend of IFC approved investment year over year

All statuses are included. The measure is Board approval, and a project was approved regardless of what happened later.

> **Note:** 2026 is a partial year and must be read as such.

|approval_year|projects|approved_usd_mm|yoy_change_usd_mm|
|---|---|---|---|
|2013|25|3391|null|
|2014|203|31685.7|28294.8|
|2015|206|28748.8|-2936.9|
|2016|324|49135.9|20387.1|
|2017|326|50630.7|1494.7|
|2018|373|55306.2|4675.5|
|2019|359|52638.6|-2667.5|
|2020|354|53141.6|503|
|2021|321|46952.9|-6188.7|
|2022|235|33744.3|-13208.5|
|2023|188|27292.9|-6451.4|
|2024|405|58490.8|31197.9|
|2025|483|68116.7|9625.9|
|2026|134|19493.6|-48623|

## Q6. Top performing regions by committed investment

> **Assumption:** "Committed" means agreements signed and not later dropped. Pending projects have no signed date and are excluded by construction.

|region|committed_projects|committed_usd_mm|
|---|---|---|
|Sub-Saharan Africa|753|110208.7|
|Latin America|550|83063.9|
|East Asia & Pacific|492|74426.6|
|Europe & Central Asia|389|57839.4|
|South Asia|273|37889.4|
|Middle East|251|36638.1|
|North America|2|286.9|

## Q7. Top 10 countries by number of Active projects

|country|active_projects|
|---|---|
|India|43|
|Brazil|26|
|Turkey|26|
|Bangladesh|24|
|China|24|
|Argentina|20|
|Indonesia|20|
|Vietnam|19|
|Ghana|18|
|Pakistan|18|

## Q8. Investment split across the four products for East Asia & Pacific

Excludes Dropped projects.

|loan_usd_mm|equity_usd_mm|guarantee_usd_mm|risk_mgmt_usd_mm|total_usd_mm|projects|
|---|---|---|---|---|---|
|22872|26046.5|29033|24046.2|101997.7|670|

## Q9. Ten WB country codes with the longest average time between approval and signing

Minimum 10 signed projects.

|wb_country_code|signed_projects|avg_days_approval_to_sign|
|---|---|---|
|SB|15|236.2|
|RU|15|189.9|
|BF|21|186.5|
|TN|21|182.3|
|SN|22|178.4|
|MY|20|173.3|
|SY|12|173|
|MH|13|172|
|HU|20|171.1|
|UZ|26|169.7|

## Q10. Projects approved and first invested, per industry, 2020-2025

Approved and invested are two different date columns, so they are counted separately and re-joined on a year spine. Counting invested projects by approval_year would answer a different question.

|industry|year|approved_projects|first_invested_projects|
|---|---|---|---|
|Agribusiness|2020|73|60|
|Agribusiness|2021|66|63|
|Agribusiness|2022|57|47|
|Agribusiness|2023|35|29|
|Agribusiness|2024|86|28|
|Agribusiness|2025|90|25|
|Energy|2020|66|51|
|Energy|2021|76|47|
|Energy|2022|39|52|
|Energy|2023|38|33|
|Energy|2024|90|22|
|Energy|2025|110|28|
|Finance|2020|77|52|
|Finance|2021|66|51|
|Finance|2022|50|50|
|Finance|2023|40|29|
|Finance|2024|67|26|
|Finance|2025|104|36|
|Manufacturing|2020|67|53|
|Manufacturing|2021|60|40|
|Manufacturing|2022|50|46|
|Manufacturing|2023|39|37|
|Manufacturing|2024|81|23|
|Manufacturing|2025|88|30|
|Telecom|2020|71|58|
|Telecom|2021|53|67|
|Telecom|2022|39|39|
|Telecom|2023|36|25|
|Telecom|2024|81|25|
|Telecom|2025|91|29|

## Q11. Average time between approval, signing and investment, by region

> **Note:** `COUNT(col)` is used rather than `COUNT(*)` so the denominator is the number of projects that actually have both dates.

|region|projects_approved_and_signed|avg_days_approval_to_sign|projects_signed_and_invested|avg_days_sign_to_invest|
|---|---|---|---|---|
|East Asia & Pacific|527|145|462|116|
|Europe & Central Asia|420|141.5|362|116.5|
|Latin America|591|142.2|512|112.6|
|Middle East|265|139.4|235|126.8|
|North America|2|113.5|2|65.5|
|South Asia|289|134.7|246|110.4|
|Sub-Saharan Africa|808|142.9|700|117.7|

## Q12. Pending projects past their Projected Board Date

Pending projects whose Projected Board Date has passed as of their As of Date, but that have not been approved.

|project_name|country|region|department|projected_board_date|as_of_date|days_past_projected_board_date|total_approved_usd_mm|
|---|---|---|---|---|---|---|---|
|Antek Manufacturing Auto Components|Egypt|Middle East|MAS|2024-03-16|2026-06-30|836|57.85764103480697|
|Lozen Capital Green Credit Line 2024|Burkina Faso|Sub-Saharan Africa|INF|2024-04-04|2026-06-30|817|191.40550836015098|
|Nelzenka Finance Housing Finance|Mexico|Latin America|FIG|2024-04-06|2026-06-30|815|6.630600078341649|
|Rosar Farms Processing Expansion|Mexico|Latin America|CFG|2024-04-18|2026-06-30|803|241.8463648259313|
|Briven Industries Energy Efficiency 2024|Nepal|South Asia|MAS|2024-05-01|2026-06-30|790|296.2214996139554|
|Sorpol Networks Data Center II|Venezuela|Latin America|CBA|2024-05-06|2026-06-30|785|78.66994373640769|
|Zanbriyor Industries Energy Efficiency II|Uzbekistan|Europe & Central Asia|MAS|2024-05-06|2026-06-30|785|183.82362045957305|
|Marnisar Telecom Fiber Rollout|Nigeria|Sub-Saharan Africa|CBA|2024-05-10|2026-06-30|781|152.1004431336079|
|Elzan Farms Storage II|Tunisia|Middle East|CFG|2024-05-15|2026-06-30|776|288.13605086213374|
|Nilomar Networks Data Center|Canada|North America|CBA|2024-05-17|2026-06-30|774|209.37056710441257|
|Zannel Power Thermal 2024|Oman|Middle East|INF|2024-05-21|2026-06-30|770|31.692034932884383|
|Lucor Communications Tower Portfolio 2024|Marshall Islands|East Asia & Pacific|CBA|2024-05-23|2026-06-30|768|229.18635258026777|
|Fentorzan Renewables Distribution III|Egypt|Middle East|FIG|2024-05-27|2026-06-30|764|99.46613273597798|
|Sarmar Finance Housing Finance|Jordan|Middle East|FIG|2024-06-02|2026-06-30|758|62.64759920423518|
|Elom Communications Mobile Expansion|Tunisia|Middle East|CBA|2024-06-11|2026-06-30|749|255.70691638984374|
|Rascor Finance Credit Line 2024|Papua New Guinea|East Asia & Pacific|FIG|2024-06-12|2026-06-30|748|289.31761626205|
|Sorluva Industries Energy Efficiency 2024|Singapore|East Asia & Pacific|MAS|2024-06-19|2026-06-30|741|158.5827839055259|
|Torul Telecom Tower Portfolio 2024|Vietnam|East Asia & Pacific|CBA|2024-06-22|2026-06-30|738|149.03303310577775|
|Raska Finance Housing Finance|Tunisia|Middle East|FIG|2024-03-27|2026-03-31|734|182.16600198476294|
|Vani Capital Green Credit Line 2024|Vanuatu|East Asia & Pacific|FIG|2024-06-27|2026-06-30|733|23.932179555602115|
|Zanbriyor Industries Cement 2024|Cameroon|Sub-Saharan Africa|MAS|2024-06-27|2026-06-30|733|18.547441712392594|
|Brilobri Power Energy Expansion II|Belize|Latin America|INF|2024-06-28|2026-06-30|732|113.63053544654323|
|Galomhar Manufacturing Auto Components III|Bangladesh|South Asia|MAS|2024-07-02|2026-06-30|728|106.55175803213615|
|Mijul Foods Processing Expansion|Uganda|Sub-Saharan Africa|CFG|2024-07-06|2026-06-30|724|143.993924420274|
|Loharlu Works Packaging Line II|Papua New Guinea|East Asia & Pacific|INF|2024-07-07|2026-06-30|723|204.8728703973814|
|Varas Works Auto Components 2024|Mozambique|Sub-Saharan Africa|CBA|2024-07-10|2026-06-30|720|9.016986477302435|
|Anva Communications Fiber Rollout 2024|Ghana|Sub-Saharan Africa|MAS|2024-07-17|2026-06-30|713|74.853610266241|
|Dankor Foods Poultry|Colombia|Latin America|CFG|2024-07-17|2026-06-30|713|238.90644457394023|
|Wenras Telecom Tower Portfolio|Kazakhstan|Europe & Central Asia|CBA|2024-07-18|2026-06-30|712|61.597656476796445|
|Pramidan Bank Agri Finance|India|South Asia|FIG|2024-07-20|2026-06-30|710|102.6185095965992|
|Bribri Energy Distribution|Uzbekistan|Europe & Central Asia|INF|2024-07-24|2026-06-30|706|189.17510322773344|
|Rosar Telecom Mobile Expansion 2024|Bhutan|South Asia|CBA|2024-07-29|2026-06-30|701|72.83333435370695|
|Lulu Networks Mobile Expansion|Madagascar|Sub-Saharan Africa|CBA|2024-07-31|2026-06-30|699|139.66735873232776|
|Nibrilo Works Pharma II|Saint Lucia|Latin America|MAS|2024-08-06|2026-06-30|693|181.28523798493828|
|Zanbriyor Industries Building Materials 2024|Morocco|Middle East|MAS|2024-08-08|2026-06-30|691|112.40299838737081|
|Kani Agro Poultry II|Benin|Sub-Saharan Africa|CFG|2024-08-14|2026-06-30|685|124.23648950722546|
|Vani Capital Green Credit Line 2024|Uzbekistan|Europe & Central Asia|CBA|2024-08-16|2026-06-30|683|73.1933666052765|
|Nelni Foods Processing Expansion|Peru|Latin America|INF|2024-08-16|2026-06-30|683|67.3570106337007|
|Fensor Industries Pharma III|Togo|Sub-Saharan Africa|MAS|2024-08-20|2026-06-30|679|91.93070106154502|
|Zenbri Power Gas-to-Power II|Sweden|Europe & Central Asia|INF|2024-08-21|2026-06-30|678|136.67751886375976|
|Fencor Foods Dairy III|Kazakhstan|Europe & Central Asia|CFG|2024-09-05|2026-06-30|663|271.67929824153344|
|Mijul Farms Dairy 2024|Peru|Latin America|CFG|2024-09-08|2026-06-30|660|17.127067329051815|
|Fenluan Finance Green Credit Line|Turkey|Europe & Central Asia|FIG|2024-09-11|2026-06-30|657|118.72973292058975|
|Omwen Manufacturing Building Materials 2024|Benin|Sub-Saharan Africa|MAS|2024-09-11|2026-06-30|657|281.9451435959813|
|Wenyor Networks Fiber Rollout|Nauru|East Asia & Pacific|CBA|2024-09-12|2026-06-30|656|31.814681940645116|
|Kaom Manufacturing Auto Components II|Macedonia|Europe & Central Asia|MAS|2024-09-14|2026-06-30|654|136.52807331348046|
|Fencor Foods Storage II|Cape Verde|Sub-Saharan Africa|CFG|2024-09-21|2026-06-30|647|34.989516000513255|
|Mijul Farms Dairy 2024|Mali|Sub-Saharan Africa|CFG|2024-09-24|2026-06-30|644|94.28522978496831|
|Polan Manufacturing Building Materials|Saint Vincent and the Grenadines|Latin America|MAS|2024-10-17|2026-06-30|621|253.15205874206214|
|Karo Energy Thermal|Chad|Sub-Saharan Africa|INF|2024-10-23|2026-06-30|615|75.5228566024158|
|Elnel Networks Mobile Expansion|Bolivia|Latin America|CBA|2024-10-26|2026-06-30|612|250.61141884488572|
|Roka Networks Data Center II|Seychelles|Sub-Saharan Africa|CBA|2024-10-29|2026-06-30|609|144.3047309460619|
|Beryor Works Packaging Line|Yemen|Middle East|MAS|2024-10-31|2026-06-30|607|251.76499829620835|
|Rascor Finance Green Credit Line 2024|Micronesia|East Asia & Pacific|FIG|2024-11-03|2026-06-30|604|56.294219942413115|
|Dorlo Telecom Mobile Expansion|Tuvalu|East Asia & Pacific|CBA|2024-11-07|2026-06-30|600|1.4658647476484672|
|Nellu Capital Credit Line|Philippines|East Asia & Pacific|FIG|2024-11-12|2026-06-30|595|192.3690128098942|
|Sarka Industries Pharma|China|East Asia & Pacific|MAS|2024-11-16|2026-06-30|591|66.34862464260095|
|Lozen Capital Green Credit Line 2024|Uruguay|Latin America|FIG|2024-11-18|2026-06-30|589|297.3794507381766|
|Vani Capital Green Credit Line 2024|Senegal|Sub-Saharan Africa|FIG|2024-11-20|2026-06-30|587|132.33371503490804|
|Wenlulo Industries Packaging Line|Kenya|Sub-Saharan Africa|CFG|2024-11-21|2026-06-30|586|165.78425753162622|
|Zannel Power Gas-to-Power 2024|Senegal|Sub-Saharan Africa|MAS|2024-08-24|2026-03-31|584|143.95827622655463|
|Venwen Capital Housing Finance|Brazil|Latin America|MAS|2024-05-31|2025-12-31|579|202.0495686863436|
|Julan Capital Women Entrepreneurs Facility|Nigeria|Sub-Saharan Africa|FIG|2024-12-01|2026-06-30|576|24.32359643027609|
|Zenbri Power Energy Expansion III|Oman|Middle East|INF|2024-12-04|2026-06-30|573|268.7353110819837|
|Zannel Power Gas-to-Power 2024|Barbados|Latin America|INF|2024-12-06|2026-06-30|571|278.6632967960621|
|Varas Works Energy Efficiency 2024|China|East Asia & Pacific|MAS|2024-12-06|2026-06-30|571|19.53001326317922|
|Fensar Manufacturing Energy Efficiency|Brazil|Latin America|MAS|2024-09-10|2026-03-31|567|142.3282822812645|
|Vani Capital Green Credit Line 2024|Jordan|Middle East|FIG|2024-12-11|2026-06-30|566|105.23414972943961|
|Zanlu Agro Edible Oils|Comoros|Sub-Saharan Africa|CFG|2024-12-12|2026-06-30|565|115.72554711716974|
|Ulniwen Networks Mobile Expansion II|Saint Kitts and Nevis|Latin America|CBA|2024-12-21|2026-06-30|556|115.95755434770479|
|Zensor Capital Green Credit Line 2024|Argentina|Latin America|FIG|2024-12-21|2026-06-30|556|156.53859941622684|
|Omneljul Communications Fiber Rollout II|Ukraine|Europe & Central Asia|CBA|2024-12-30|2026-06-30|547|211.75814094101494|
|Ropoldan Farms Poultry 2024|Jamaica|Latin America|CFG|2025-01-03|2026-06-30|543|235.3366024389805|
|Vaul Power Solar|Colombia|Latin America|INF|2025-01-03|2026-06-30|543|95.12960007704586|
|Nelras Foods Edible Oils III|Vietnam|East Asia & Pacific|FIG|2025-01-08|2026-06-30|538|251.29150484262723|
|Ansor Communications Fiber Rollout II|Vanuatu|East Asia & Pacific|CBA|2025-01-11|2026-06-30|535|55.2524936426062|
|Torkor Networks Tower Portfolio II|Brazil|Latin America|CBA|2025-01-13|2026-06-30|533|279.7232535494655|
|Roel Works Pharma III|Rwanda|Sub-Saharan Africa|MAS|2025-01-15|2026-06-30|531|192.0328931316473|
|Danyor Farms Dairy|Gabon|Sub-Saharan Africa|CFG|2025-01-17|2026-06-30|529|283.5717447653402|
|Wenyor Networks Fiber Rollout 2024|Mozambique|Sub-Saharan Africa|CFG|2025-01-23|2026-06-30|523|2.5653933178202206|
|Rosar Telecom Fiber Rollout III|Eritrea|Sub-Saharan Africa|CBA|2025-02-02|2026-06-30|513|197.25937744383086|
|Neldan Works Pharma|Malaysia|East Asia & Pacific|MAS|2025-02-03|2026-06-30|512|157.7688690295284|
|Tekvendor Renewables Grid Connection|Kenya|Sub-Saharan Africa|INF|2025-02-03|2026-06-30|512|5.981722179852333|
|Danmi Agro Processing Expansion|Colombia|Latin America|CFG|2025-02-13|2026-06-30|502|298.5860041182389|
|Berkor Industries Energy Efficiency|Bangladesh|South Asia|MAS|2025-02-15|2026-06-30|500|118.69391241065306|
|Omneljul Communications Fiber Rollout 2024|Mongolia|East Asia & Pacific|CBA|2025-02-19|2026-06-30|496|87.66856397029802|
|Katekom Communications Data Center|Georgia|Europe & Central Asia|CBA|2025-02-20|2026-06-30|495|92.04616912681425|
|Mifenbri Works Energy Efficiency 2024|Senegal|Sub-Saharan Africa|MAS|2025-02-21|2026-06-30|494|281.519427872112|
|Corprael Capital Microfinance|Gabon|Sub-Saharan Africa|FIG|2025-02-23|2026-06-30|492|276.49795761606526|
|Harcor Finance Housing Finance|Cambodia|East Asia & Pacific|FIG|2025-02-25|2026-06-30|490|149.22786791392326|
|Varas Works Building Materials II|Maldives|South Asia|MAS|2025-03-10|2026-06-30|477|243.49213434074954|
|Neldormar Manufacturing Pharma|Turkey|Europe & Central Asia|MAS|2025-03-11|2026-06-30|476|110.28181582120575|
|Nibrilo Works Pharma|Cameroon|Sub-Saharan Africa|MAS|2025-03-12|2026-06-30|475|73.81738542045922|
|Prazanhar Foods Dairy|Mauritius|Sub-Saharan Africa|CFG|2025-03-12|2026-06-30|475|134.4098217067671|
|Harkor Capital Microfinance|Chad|Sub-Saharan Africa|FIG|2025-03-13|2026-06-30|474|87.83425781103303|
|Lucor Communications Data Center 2025|Swaziland|Sub-Saharan Africa|CBA|2025-03-15|2026-06-30|472|265.69106484190735|
|Praro Foods Processing Expansion II|Romania|Europe & Central Asia|CFG|2025-03-16|2026-06-30|471|50.33071764151607|
|Raslu Farms Edible Oils 2025|Uganda|Sub-Saharan Africa|CFG|2025-03-17|2026-06-30|470|5.563388028335485|
|Corprael Capital Green Credit Line|Swaziland|Sub-Saharan Africa|FIG|2024-06-19|2025-09-30|468|150.32261283523826|
|Omni Industries Auto Components|Malaysia|East Asia & Pacific|MAS|2024-03-21|2025-06-30|466|132.37958052197982|
|Prazanhar Foods Edible Oils 2025|Jordan|Middle East|CFG|2025-03-22|2026-06-30|465|78.49862438586445|
|Kapol Works Pharma|Lebanon|Middle East|MAS|2024-12-22|2026-03-31|464|298.7938080321616|
|Mijul Farms Dairy 2025|Tuvalu|East Asia & Pacific|CFG|2025-03-25|2026-06-30|462|257.3006083053474|
|Tekpra Industries Cement|Nigeria|Sub-Saharan Africa|MAS|2025-03-30|2026-06-30|457|260.4252787119475|
|Zenbri Power Transmission II|Costa Rica|Latin America|INF|2025-04-02|2026-06-30|454|203.9095615844692|
|Brinel Energy Gas-to-Power|Guinea|Sub-Saharan Africa|INF|2025-04-05|2026-06-30|451|44.74693969338159|
|Dananpra Agro Dairy 2024|India|South Asia|CFG|2025-04-07|2026-06-30|449|182.87197981515072|
|Danpra Industries Cement II|Georgia|Europe & Central Asia|MAS|2025-04-10|2026-06-30|446|234.0214539863962|
|Valu Energy Distribution III|Romania|Europe & Central Asia|CBA|2025-01-24|2026-03-31|431|15.134820672107919|
|Tekva Industries Energy Efficiency|Sierra Leone|Sub-Saharan Africa|MAS|2025-04-27|2026-06-30|429|156.13867414213993|
|Kata Agro Dairy II|Cape Verde|Sub-Saharan Africa|CFG|2025-05-01|2026-06-30|425|79.5747138781403|
|Omlu Foods Processing Expansion II|South Africa|Sub-Saharan Africa|CFG|2025-05-06|2026-06-30|420|66.39735148362422|
|Berbridan Finance MSME Facility|Belarus|Europe & Central Asia|FIG|2025-05-09|2026-06-30|417|72.66973032270089|
|Rosar Telecom Data Center 2025|Algeria|Middle East|CFG|2025-05-14|2026-06-30|412|41.883952084747904|
|Zenpol Finance Green Credit Line II|Brazil|Latin America|FIG|2024-05-15|2025-06-30|411|263.7618473757174|
|Rodan Works Energy Efficiency 2025|Seychelles|Sub-Saharan Africa|FIG|2025-05-16|2026-06-30|410|148.04579913199535|
|Varas Power Battery Storage II|Tunisia|Middle East|INF|2025-05-16|2026-06-30|410|292.57274082973345|
|Rasva Capital SME Credit Line|Vanuatu|East Asia & Pacific|FIG|2025-05-18|2026-06-30|408|288.7477824730941|
|Nizen Industries Cement II|Malaysia|East Asia & Pacific|CFG|2024-11-21|2025-12-31|405|43.08403988959271|
|Prazanhar Foods Storage|Comoros|Sub-Saharan Africa|CFG|2025-05-21|2026-06-30|405|43.07484380943857|
|Prazanhar Foods Poultry|India|South Asia|CFG|2025-05-23|2026-06-30|403|193.18176648655609|
|Nibrilo Works Packaging Line III|Mozambique|Sub-Saharan Africa|CBA|2025-05-27|2026-06-30|399|37.25934303113366|
|Vani Capital Green Credit Line 2025|Bangladesh|South Asia|FIG|2025-05-29|2026-06-30|397|248.165076502524|
|Torcordan Power Gas-to-Power|Vietnam|East Asia & Pacific|INF|2025-06-03|2026-06-30|392|55.69665362484443|
|Torcordan Power Transmission 2025|Peru|Latin America|FIG|2025-06-09|2026-06-30|386|98.05671244267218|
|Cordanka Capital Housing Finance|Cape Verde|Sub-Saharan Africa|FIG|2025-06-11|2026-06-30|384|171.15828341249332|
|Sarka Industries Cement|Jordan|Middle East|MAS|2024-06-15|2025-06-30|380|10.60297608845441|
|Sarsor Foods Dairy|Congo|Sub-Saharan Africa|CFG|2025-06-16|2026-06-30|379|164.27746992597523|
|Kata Agro Dairy 2025|Cambodia|East Asia & Pacific|CFG|2025-06-20|2026-06-30|375|102.42568927186987|
|Vani Capital Green Credit Line 2024|Honduras|Latin America|FIG|2025-03-21|2026-03-31|375|251.48059957725448|
|Torulhar Communications Tower Portfolio II|Ukraine|Europe & Central Asia|CBA|2025-06-22|2026-06-30|373|25.35572139980324|
|Rosar Farms Storage|Serbia|Europe & Central Asia|CFG|2025-06-24|2026-06-30|371|120.33421633024086|
|Sarpra Networks Data Center II|Lao People's Democratic Republic|East Asia & Pacific|INF|2025-06-26|2026-06-30|369|215.40895704739432|
|Vayor Networks Mobile Expansion|Rwanda|Sub-Saharan Africa|CBA|2025-06-28|2026-06-30|367|58.660751956672506|
|Vani Capital Green Credit Line 2025|Nigeria|Sub-Saharan Africa|FIG|2025-07-01|2026-06-30|364|128.25671589950565|
|Omtek Communications Tower Portfolio II|Saint Lucia|Latin America|CBA|2025-07-03|2026-06-30|362|69.37433662772152|
|Omwen Manufacturing Auto Components|Egypt|Middle East|MAS|2025-07-05|2026-06-30|360|97.11123332937517|
|Elom Communications Data Center|Ukraine|Europe & Central Asia|CBA|2025-07-07|2026-06-30|358|170.16420496116913|
|Fentorzan Renewables Thermal II|Micronesia|East Asia & Pacific|INF|2025-07-11|2026-06-30|354|42.02130901302826|
|Gallo Renewables Transmission|Swaziland|Sub-Saharan Africa|INF|2025-07-14|2026-06-30|351|12.922705424060858|
|Dansarel Manufacturing Pharma|Croatia|Europe & Central Asia|MAS|2025-07-16|2026-06-30|349|54.42985546353755|
|Sorbri Works Packaging Line 2025|Mexico|Latin America|MAS|2025-07-16|2026-06-30|349|174.30713966185576|
|Nelni Power Thermal|Somalia|Sub-Saharan Africa|INF|2024-07-19|2025-06-30|346|134.73657433193722|
|Varas Power Energy Expansion|Sierra Leone|Sub-Saharan Africa|INF|2025-07-27|2026-06-30|338|254.4896958204422|
|Fenul Foods Edible Oils|Tanzania|Sub-Saharan Africa|CFG|2025-07-28|2026-06-30|337|78.7694625256679|
|Rodan Works Energy Efficiency 2025|Belize|Latin America|MAS|2025-07-29|2026-06-30|336|187.59708399597866|
|Torulras Manufacturing Packaging Line 2025|China|East Asia & Pacific|MAS|2025-08-01|2026-06-30|333|258.97742930900813|
|Marsornel Bank Credit Line 2025|Jamaica|Latin America|FIG|2025-08-09|2026-06-30|325|234.6060496893636|
|Torcor Finance SME Credit Line|Moldova|Europe & Central Asia|FIG|2025-08-09|2026-06-30|325|282.3985881803596|
|Dananpra Agro Processing Expansion|Cambodia|East Asia & Pacific|CFG|2025-08-17|2026-06-30|317|235.3572799827367|
|Varas Works Energy Efficiency 2025|Congo|Sub-Saharan Africa|CBA|2025-08-25|2026-06-30|309|144.7950138471677|
|Tektor Renewables Transmission III|Chad|Sub-Saharan Africa|INF|2025-08-25|2026-06-30|309|281.45555931956534|
|Lucor Communications Data Center 2024|Bhutan|South Asia|CBA|2024-11-25|2025-09-30|309|39.02534254896495|
|Zendanras Farms Poultry III|Algeria|Middle East|CFG|2025-08-29|2026-06-30|305|105.05713735268635|
|Yoryor Telecom Tower Portfolio II|Pakistan|South Asia|CBA|2025-08-29|2026-06-30|305|203.98949835770404|
|Galomhar Manufacturing Auto Components 2025|Bangladesh|South Asia|MAS|2025-09-07|2026-06-30|296|152.20620944195443|
|Loven Industries Packaging Line|Jordan|Middle East|MAS|2025-09-11|2026-06-30|292|299.7596802844302|
|Mijul Farms Processing Expansion|Namibia|Sub-Saharan Africa|CFG|2025-09-12|2026-06-30|291|249.1885747164095|
|Galtor Agro Edible Oils|Uruguay|Latin America|CFG|2025-09-19|2026-06-30|284|53.910709502935056|
|Rosar Telecom Tower Portfolio 2024|Tunisia|Middle East|CBA|2024-12-23|2025-09-30|281|239.09945792327122|
|Rolo Finance Trade Finance|Mali|Sub-Saharan Africa|FIG|2025-09-26|2026-06-30|277|246.61188683758513|
|Torcordan Power Distribution 2024|Kazakhstan|Europe & Central Asia|INF|2024-09-27|2025-06-30|276|169.40611829226788|
|Zenbri Power Power Project|Colombia|Latin America|INF|2025-10-01|2026-06-30|272|276.5492611126201|
|Tektek Manufacturing Building Materials III|Mauritius|Sub-Saharan Africa|MAS|2025-10-02|2026-06-30|271|37.08751128529332|
|Ulniwen Networks Tower Portfolio|Nigeria|Sub-Saharan Africa|CBA|2025-07-06|2026-03-31|268|261.94855867073414|
|Wenras Telecom Data Center|Ukraine|Europe & Central Asia|MAS|2025-01-06|2025-09-30|267|138.36082993076397|
|Andoryor Networks Tower Portfolio|Guatemala|Latin America|CBA|2025-10-13|2026-06-30|260|212.05002030760636|
|Nellodan Manufacturing Packaging Line|Samoa|East Asia & Pacific|MAS|2025-10-15|2026-06-30|258|179.79242766473592|
|Lucor Communications Data Center 2025|Mongolia|East Asia & Pacific|CBA|2025-10-18|2026-06-30|255|244.8689780145963|
|Ulkorpol Capital Green Credit Line II|Madagascar|Sub-Saharan Africa|FIG|2025-10-20|2026-06-30|253|168.20111964938948|
|Nibrilo Works Building Materials II|Sao Tome and Principe|Sub-Saharan Africa|MAS|2025-10-23|2026-06-30|250|297.1020708238224|
|Varas Power Power Project|Peru|Latin America|INF|2025-10-25|2026-06-30|248|254.89079131007267|
|Lucor Communications Tower Portfolio 2025|Saint Kitts and Nevis|Latin America|CBA|2025-10-28|2026-06-30|245|268.6220166967994|
|Bripol Farms Poultry|Saint Lucia|Latin America|CFG|2025-10-30|2026-06-30|243|84.31294251348615|
|Anpolmi Renewables Power|Iraq|Middle East|INF|2025-10-31|2026-06-30|242|47.24191671143738|
|Torul Telecom Tower Portfolio 2025|Dominica|Latin America|CBA|2025-11-07|2026-06-30|235|34.94728256285204|
|Dordor Networks Mobile Expansion|Sudan|Sub-Saharan Africa|CBA|2025-11-07|2026-06-30|235|75.32390120422139|
|Zansorzen Renewables Distribution 2025|Burkina Faso|Sub-Saharan Africa|INF|2025-11-09|2026-06-30|233|297.32679375751496|
|Ulkorpol Capital Green Credit Line|Nigeria|Sub-Saharan Africa|FIG|2025-11-14|2026-06-30|228|149.74343324677224|
|Dorsar Capital Green Credit Line|Bolivia|Latin America|FIG|2025-11-17|2026-06-30|225|70.22655935083328|
|Varas Works Building Materials 2025|Kazakhstan|Europe & Central Asia|MAS|2025-11-21|2026-06-30|221|113.38632858743755|
|Marro Farms Dairy III|Burundi|Sub-Saharan Africa|CFG|2025-05-29|2025-12-31|216|157.89224461844537|
|Karo Energy Gas-to-Power II|Barbados|Latin America|INF|2025-11-26|2026-06-30|216|113.58593028626414|
|Venom Agro Edible Oils|Cameroon|Sub-Saharan Africa|CFG|2025-11-27|2026-06-30|215|64.12562408488222|
|Tekpra Industries Cement 2025|Libyan Arab Jamahiriya|Middle East|MAS|2025-11-28|2026-06-30|214|222.9418863512714|
|Bricor Finance Inclusive Finance|Algeria|Middle East|FIG|2025-11-29|2026-06-30|213|278.8554667227193|
|Lokor Renewables Transmission 2025|Trinidad and Tobago|Latin America|INF|2025-12-02|2026-06-30|210|277.86939948645914|
|Rascor Finance Credit Line|Uganda|Sub-Saharan Africa|FIG|2025-12-05|2026-06-30|207|36.40460045300286|
|Raslu Farms Storage II|Honduras|Latin America|CFG|2025-12-05|2026-06-30|207|4.681089052914271|
|Danpra Industries Auto Components|Brazil|Latin America|MAS|2025-12-05|2026-06-30|207|163.820837147985|
|Toryor Power Thermal|Brazil|Latin America|INF|2025-12-09|2026-06-30|203|158.0183115407408|
|Zanbriyor Industries Building Materials II|Benin|Sub-Saharan Africa|CFG|2025-12-20|2026-06-30|192|110.99932601099677|
|Rasva Capital Green Credit Line 2025|Colombia|Latin America|CFG|2026-01-03|2026-06-30|178|42.88040354464597|
|Sorbri Works Packaging Line II|Peru|Latin America|MAS|2026-01-05|2026-06-30|176|81.97325658541723|
|Brilobri Power Power II|Niger|Sub-Saharan Africa|INF|2026-01-07|2026-06-30|174|4.804099181659669|
|Lozen Capital Green Credit Line 2025|Indonesia|East Asia & Pacific|CFG|2026-01-08|2026-06-30|173|213.65364958669673|
|Anro Manufacturing Pharma III|Morocco|Middle East|MAS|2026-01-10|2026-06-30|171|53.97944431770407|
|Zenbrizen Foods Processing Expansion III|Cameroon|Sub-Saharan Africa|CFG|2025-10-18|2026-03-31|164|89.75530335093013|
|Harnian Renewables Gas-to-Power 2025|Burundi|Sub-Saharan Africa|FIG|2026-01-20|2026-06-30|161|145.13643420410446|
|Zanbriyor Industries Packaging Line|Eritrea|Sub-Saharan Africa|MAS|2025-07-26|2025-12-31|158|165.72948330005096|
|Kapol Power Distribution|China|East Asia & Pacific|INF|2026-01-24|2026-06-30|157|57.82749008210784|
|Sardorras Capital Housing Finance|Mexico|Latin America|FIG|2026-01-30|2026-06-30|151|78.89005344870608|
|Sardan Capital MSME Facility|Nepal|South Asia|FIG|2026-02-03|2026-06-30|147|234.49069146451075|
|Ansor Communications Mobile Expansion|Togo|Sub-Saharan Africa|CBA|2026-02-03|2026-06-30|147|12.857965181732276|
|Prazanfen Networks Fiber Rollout|Nicaragua|Latin America|CBA|2026-02-10|2026-06-30|140|218.63287616511292|
|Loharlu Works Auto Components|Kenya|Sub-Saharan Africa|MAS|2025-05-16|2025-09-30|137|270.1414437815948|
|Briomgal Manufacturing Auto Components|Turkey|Europe & Central Asia|MAS|2026-02-16|2026-06-30|134|267.67289460324054|
|Briven Industries Energy Efficiency III|India|South Asia|MAS|2026-02-18|2026-06-30|132|50.28697394764281|
|Loven Industries Packaging Line II|Armenia|Europe & Central Asia|INF|2026-02-28|2026-06-30|122|97.14915965325935|
|Kormi Farms Storage|Nigeria|Sub-Saharan Africa|CFG|2026-03-06|2026-06-30|116|260.17337396876735|
|Mijul Farms Edible Oils 2026|Peru|Latin America|CFG|2026-03-10|2026-06-30|112|35.48696411757448|
|Roka Networks Mobile Expansion 2025|Turkey|Europe & Central Asia|CBA|2026-03-11|2026-06-30|111|46.184085903358294|
|Lucor Communications Tower Portfolio 2025|Maldives|South Asia|CBA|2025-06-18|2025-09-30|104|32.61286626212508|
|Bripol Farms Processing Expansion|Iraq|Middle East|INF|2026-04-06|2026-06-30|85|242.22339865885192|
|Julva Foods Edible Oils|Congo|Sub-Saharan Africa|CFG|2026-04-11|2026-06-30|80|272.27814608111487|
|Nian Agro Dairy|Tajikistan|Europe & Central Asia|CFG|2026-04-14|2026-06-30|77|102.55031497015187|
|Lozen Capital Housing Finance|Korea|East Asia & Pacific|FIG|2025-07-21|2025-09-30|71|293.4887360793164|
|Polcor Foods Processing Expansion III|Pakistan|South Asia|CFG|2026-04-27|2026-06-30|64|101.52133264353037|
|Briven Works Auto Components II|Mexico|Latin America|MAS|2026-04-28|2026-06-30|63|277.11607978632776|
|Roka Networks Mobile Expansion 2026|Nepal|South Asia|CBA|2026-05-04|2026-06-30|57|263.99489942456046|
|Zannel Power Distribution 2026|Equatorial Guinea|Sub-Saharan Africa|INF|2026-05-05|2026-06-30|56|65.6758723153416|
|Mijul Farms Storage 2026|Australia|East Asia & Pacific|CFG|2026-05-08|2026-06-30|53|144.86092226324376|
|Lucor Communications Mobile Expansion 2026|Ukraine|Europe & Central Asia|CBA|2026-05-15|2026-06-30|46|130.70200895079375|
|Galom Networks Fiber Rollout II|Seychelles|Sub-Saharan Africa|CBA|2026-05-18|2026-06-30|43|272.9699954295046|
|Sarsor Foods Edible Oils II|Lao People's Democratic Republic|East Asia & Pacific|CFG|2026-05-22|2026-06-30|39|229.04645629897934|
|Sardan Capital MSME Facility II|Serbia|Europe & Central Asia|FIG|2025-05-23|2025-06-30|38|28.422976687900867|
|Torulras Manufacturing Pharma III|Chad|Sub-Saharan Africa|MAS|2025-08-26|2025-09-30|35|36.925588182101514|
|Mijul Farms Storage 2026|Gambia|Sub-Saharan Africa|CFG|2026-05-29|2026-06-30|32|290.186235728934|
|Valu Energy Transmission|Egypt|Middle East|CFG|2026-06-03|2026-06-30|27|157.58450345499372|
|Pralu Farms Edible Oils|Nicaragua|Latin America|CFG|2026-06-07|2026-06-30|23|160.65207473673593|
|Prazanhar Foods Poultry III|Tuvalu|East Asia & Pacific|CFG|2026-06-10|2026-06-30|20|175.33473483983568|
|Vani Capital Green Credit Line 2026|Vietnam|East Asia & Pacific|FIG|2026-06-12|2026-06-30|18|293.6204913757287|
|Omdan Foods Processing Expansion|Djibouti|Middle East|CFG|2026-06-18|2026-06-30|12|255.242167240139|
|Mijul Farms Dairy 2026|Mozambique|Sub-Saharan Africa|CFG|2026-06-26|2026-06-30|4|101.2708894256087|
|Lucor Communications Fiber Rollout 2026|Indonesia|East Asia & Pacific|CBA|2026-06-28|2026-06-30|2|44.16657086396153|
|Vani Capital Green Credit Line 2025|Paraguay|Latin America|CFG|2026-03-30|2026-03-31|1|121.5895618497093|
|Praro Foods Poultry|Turkey|Europe & Central Asia|CFG|2026-06-29|2026-06-30|1|47.57619085779222|

## Q18. Product Line across regions

Excludes Dropped projects. Returned in long format with both project count and approved amount, because "compare Product Line categories" can mean either. Amounts come from `total_approved_usd_mm`, not from the four product columns, so a project is not double counted.

|region|product_line|projects|approved_usd_mm|
|---|---|---|---|
|East Asia & Pacific|Guarantee|183|28626.9|
|East Asia & Pacific|Equity|168|25622.1|
|East Asia & Pacific|Loan|162|23799.5|
|East Asia & Pacific|Risk Management|157|23798.4|
|Europe & Central Asia|Guarantee|145|21612.2|
|Europe & Central Asia|Equity|127|18547.2|
|Europe & Central Asia|Risk Management|128|18453.1|
|Europe & Central Asia|Loan|127|17362|
|Latin America|Guarantee|198|29510|
|Latin America|Risk Management|183|27955.2|
|Latin America|Equity|188|27870.7|
|Latin America|Loan|181|26326.9|
|Middle East|Equity|93|13886.9|
|Middle East|Risk Management|89|13671.9|
|Middle East|Guarantee|89|12896.2|
|Middle East|Loan|82|11649.9|
|North America|Loan|1|272.1|
|North America|Guarantee|1|209.4|
|North America|Equity|2|164|
|North America|Risk Management|1|4.4|
|South Asia|Guarantee|113|16034.1|
|South Asia|Loan|99|14025.8|
|South Asia|Equity|93|13214.8|
|South Asia|Risk Management|91|13158.8|
|Sub-Saharan Africa|Loan|274|41236.8|
|Sub-Saharan Africa|Equity|261|38919.1|
|Sub-Saharan Africa|Risk Management|264|38480.1|
|Sub-Saharan Africa|Guarantee|268|37809.9|

## Q19. Risk management investment by industry

Industries with the largest risk management investment, and risk management as a share of each industry's total product allocation.

|industry|risk_mgmt_usd_mm|total_product_usd_mm|risk_mgmt_share_pct|
|---|---|---|---|
|Finance|39226.1|148570.5|26.4|
|Telecom|38732.9|143812.6|26.93|
|Manufacturing|36138.1|150328.8|24.04|
|Energy|35076.6|147467.4|23.79|
|Agribusiness|34977.1|152837.5|22.89|

## Q20. Projects approved by Department, yearly 2020-2025

|department|approval_year|approved_projects|
|---|---|---|
|CBA|2020|69|
|CBA|2021|57|
|CBA|2022|43|
|CBA|2023|39|
|CBA|2024|75|
|CBA|2025|92|
|CFG|2020|76|
|CFG|2021|67|
|CFG|2022|62|
|CFG|2023|32|
|CFG|2024|83|
|CFG|2025|92|
|FIG|2020|74|
|FIG|2021|70|
|FIG|2022|49|
|FIG|2023|39|
|FIG|2024|69|
|FIG|2025|103|
|INF|2020|63|
|INF|2021|73|
|INF|2022|35|
|INF|2023|39|
|INF|2024|90|
|INF|2025|109|
|MAS|2020|72|
|MAS|2021|54|
|MAS|2022|46|
|MAS|2023|39|
|MAS|2024|88|
|MAS|2025|87|

## Q21. Dropped projects with more than USD 250 million originally approved

> **Note:** The threshold is in USD millions, so the literal is 250, not 250e6.

|project_name|country|region|industry|date_disclosed|approval_date|total_approved_usd_mm|
|---|---|---|---|---|---|---|
|Berdan Industries Energy Efficiency|Philippines|East Asia & Pacific|Manufacturing|2025-05-23|-|299.85634837962436|
|Berva Communications Tower Portfolio|Dominican Republic|Latin America|Telecom|2018-02-01|2018-06-16|299.78115891237917|
|Nian Bank Green Credit Line|India|South Asia|Finance|2021-10-08|-|298.6032518495589|
|Cordansol Foods Processing Expansion|Georgia|Europe & Central Asia|Agribusiness|2016-03-03|2017-01-13|298.19946035158347|
|Kaomni Bank Green Credit Line|Zambia|Sub-Saharan Africa|Finance|2016-06-14|-|298.16137629648193|
|Mardel Capital Women Entrepreneurs Facility|Lesotho|Sub-Saharan Africa|Finance|2022-06-07|-|297.8899806617944|
|Ommardel Communications Mobile Expansion|Bangladesh|South Asia|Telecom|2015-10-11|2015-11-08|297.8466465305802|
|Vetpol Networks Fiber Rollout|Somalia|Sub-Saharan Africa|Telecom|2024-02-29|2024-07-07|297.64610118316403|
|Vetula Bank Microfinance|Malaysia|East Asia & Pacific|Finance|2017-06-23|-|297.52804897203765|
|Fenkelfen Works Building Materials|Turkey|Europe & Central Asia|Manufacturing|2021-07-18|2022-02-24|296.70570746433964|
|Tamnircor Power Hydro|Mexico|Latin America|Energy|2019-12-19|2020-03-18|296.44619666162|
|Ulatamula Manufacturing Auto Components|Saint Kitts and Nevis|Latin America|Manufacturing|2022-06-29|2022-12-09|296.1633980214832|
|Marpol Manufacturing Energy Efficiency|Nigeria|Sub-Saharan Africa|Manufacturing|2024-06-20|-|295.52003725805565|
|Zensol Communications Mobile Expansion|Tuvalu|East Asia & Pacific|Telecom|2022-09-08|-|295.3319932701413|
|Zenka Finance Trade Finance|Brazil|Latin America|Finance|2020-12-15|2021-03-01|295.18888850459666|
|Zensorvet Manufacturing Pharma|Malawi|Sub-Saharan Africa|Manufacturing|2025-05-05|2025-10-16|295.1277822508997|
|Delva Foods Storage|South Africa|Sub-Saharan Africa|Agribusiness|2017-05-16|2018-01-10|294.28138372123396|
|Rasandan Bank Green Credit Line|Georgia|Europe & Central Asia|Finance|2016-04-15|2016-10-04|294.0482237761412|
|Marmarjul Works Energy Efficiency|Azerbaijan|Europe & Central Asia|Manufacturing|2017-10-06|2018-02-12|293.96476063827157|
|Julori Telecom Fiber Rollout|Thailand|East Asia & Pacific|Telecom|2016-07-28|2016-11-26|293.9274066873529|
|Nirmar Farms Processing Expansion|Brazil|Latin America|Agribusiness|2023-12-31|-|293.6472734501855|
|Omloan Foods Poultry|Benin|Sub-Saharan Africa|Agribusiness|2022-01-29|2022-04-02|293.60168646321927|
|Fenni Networks Fiber Rollout|Philippines|East Asia & Pacific|Telecom|2016-05-30|2016-09-02|293.3157038109236|
|Sollolo Agro Processing Expansion|Mauritius|Sub-Saharan Africa|Agribusiness|2014-01-21|-|293.08251345518033|
|Marmarfen Works Packaging Line|Botswana|Sub-Saharan Africa|Manufacturing|2019-03-21|2019-09-25|292.7809087335217|
|Zendel Networks Mobile Expansion|Ukraine|Europe & Central Asia|Telecom|2023-07-09|-|292.4990506039128|
|Polka Power Energy Expansion|Gabon|Sub-Saharan Africa|Energy|2024-11-15|-|292.23917441135717|
|Tamva Finance Trade Finance|Senegal|Sub-Saharan Africa|Finance|2018-01-29|2019-04-12|291.6582035262275|
|Corvaan Telecom Data Center|Bhutan|South Asia|Telecom|2025-03-21|-|291.5931832437324|
|Vasor Power Efficiency Upgrade|Niger|Sub-Saharan Africa|Energy|2024-04-22|2024-11-25|291.2193061163224|
|Ulasorama Capital Trade Finance|Venezuela|Latin America|Finance|2021-01-16|2021-04-13|291.0409702080748|
|Zenlosol Industries Building Materials|Mauritius|Sub-Saharan Africa|Manufacturing|2018-08-20|2018-11-21|290.6463023086311|
|Soldelan Works Energy Efficiency|Egypt|Middle East|Manufacturing|2018-03-12|2018-06-12|290.63462402015807|
|Cornirkel Telecom Fiber Rollout|Ukraine|Europe & Central Asia|Telecom|2015-02-23|2015-05-18|290.5899061331331|
|Vaamarin Manufacturing Pharma|Malaysia|East Asia & Pacific|Manufacturing|2018-10-13|-|290.43916581155383|
|Zenpol Foods Poultry|Saint Kitts and Nevis|Latin America|Agribusiness|2014-07-31|-|289.7246616658531|
|Niomjul Power Power|Lesotho|Sub-Saharan Africa|Energy|2025-03-17|-|289.72303403764596|
|Lonir Energy Thermal|Togo|Sub-Saharan Africa|Energy|2016-05-21|2016-09-09|289.68620625040654|
|Solamasol Manufacturing Building Materials|Antigua and Barbuda|Latin America|Manufacturing|2016-05-18|-|289.64049108382517|
|Uladeljul Networks Tower Portfolio|Ethiopia|Sub-Saharan Africa|Telecom|2018-02-10|2018-05-11|289.33377254288246|
|Nirpolkel Bank Trade Finance|Dominican Republic|Latin America|Finance|2018-06-29|2018-09-13|289.2664281550899|
|Rinrinan Finance Green Credit Line|Nigeria|Sub-Saharan Africa|Finance|2018-04-24|-|288.8270947999864|
|Dananom Bank SME Credit Line|Central African Republic|Sub-Saharan Africa|Finance|2024-08-10|2025-12-01|288.10549223045865|
|Orisordan Finance Credit Line|China|East Asia & Pacific|Finance|2015-01-13|2016-04-25|287.5849945083309|
|Sarbri Communications Mobile Expansion|Armenia|Europe & Central Asia|Telecom|2015-07-09|2015-08-23|287.541501787373|
|Rinlo Networks Tower Portfolio|Fiji|East Asia & Pacific|Telecom|2020-11-20|2021-01-23|287.3542372959305|
|Sortam Industries Energy Efficiency|Ethiopia|Sub-Saharan Africa|Manufacturing|2015-06-11|-|287.23329523306097|
|Lovabri Networks Tower Portfolio|Suriname|Latin America|Telecom|2022-03-11|2022-05-28|287.0974298272909|
|Sarmarvet Energy Gas-to-Power|Bosnia and Herzegovina|Europe & Central Asia|Energy|2024-11-24|2025-06-03|286.7405069254293|
|Vabri Bank Green Credit Line|Vanuatu|East Asia & Pacific|Finance|2019-05-21|-|286.49805445788877|
|Julrinmi Bank Green Credit Line|Brazil|Latin America|Finance|2022-07-08|-|286.44783889313413|
|Tormi Manufacturing Cement|Antigua and Barbuda|Latin America|Manufacturing|2021-12-14|2022-05-16|286.2413457211164|
|Ularastor Energy Distribution|Jamaica|Latin America|Energy|2021-01-09|2021-03-13|286.1274498637846|
|Kacor Power Gas-to-Power|Lao People's Democratic Republic|East Asia & Pacific|Energy|2015-08-13|-|286.10688472444394|
|Solnirber Bank Green Credit Line|Haiti|Latin America|Finance|2020-08-06|-|285.7462784518843|
|Solkalo Manufacturing Pharma|Nauru|East Asia & Pacific|Manufacturing|2018-02-16|-|285.609509106985|
|Marama Industries Building Materials|Tanzania|Sub-Saharan Africa|Manufacturing|2020-06-15|-|285.5568252633259|
|Keltamula Manufacturing Energy Efficiency|Hungary|Europe & Central Asia|Manufacturing|2023-04-01|2024-03-26|285.3235025159748|
|Polvalo Bank Inclusive Finance|Zimbabwe|Sub-Saharan Africa|Finance|2014-06-26|-|285.1491422005676|
|Amarinan Power Energy Expansion|Mexico|Latin America|Energy|2014-07-19|2015-06-04|285.0010113927871|
|Sardelkel Foods Processing Expansion|Saint Lucia|Latin America|Agribusiness|2015-12-06|2016-01-22|284.8662302197906|
|Nirrinnir Works Energy Efficiency|Georgia|Europe & Central Asia|Manufacturing|2022-08-30|2022-12-11|284.7492260374817|
|Anoriva Power Transmission|Cambodia|East Asia & Pacific|Energy|2024-06-28|2024-11-20|284.73205784467723|
|Midan Farms Dairy|Argentina|Latin America|Agribusiness|2016-01-30|-|284.1516719290363|
|Vetka Communications Data Center|Turkey|Europe & Central Asia|Telecom|2021-04-02|-|284.0701414805572|
|Kaber Farms Storage|Jordan|Middle East|Agribusiness|2024-09-22|-|284.04812816296084|
|Ulaan Communications Mobile Expansion|Jamaica|Latin America|Telecom|2025-10-02|-|283.7030620484899|
|Solcorpol Networks Tower Portfolio|Macedonia|Europe & Central Asia|Telecom|2024-02-09|-|282.4864504551882|
|Torsarrin Manufacturing Energy Efficiency|Benin|Sub-Saharan Africa|Manufacturing|2022-09-10|-|282.1013961463479|
|Tororilo Manufacturing Energy Efficiency|Palestinian Territory|Middle East|Manufacturing|2023-12-27|2024-05-15|282.0396900990262|
|Vakaber Finance Agri Finance|Egypt|Middle East|Finance|2020-02-29|2020-07-07|282.0189729333019|
|Nirmi Finance Credit Line|Togo|Sub-Saharan Africa|Finance|2018-04-27|2018-10-24|281.8936793626407|
|Nirtordan Finance Microfinance|Egypt|Middle East|Finance|2020-12-25|-|281.58154705207676|
|Fenulacor Communications Fiber Rollout|Bulgaria|Europe & Central Asia|Telecom|2019-10-01|-|281.25778989135875|
|Nivarin Bank Green Credit Line|Chad|Sub-Saharan Africa|Finance|2025-11-20|-|280.33931707648264|
|Rinlosor Works Cement|Guyana|Latin America|Manufacturing|2017-08-07|2017-12-24|280.3275362653136|
|Polnirka Farms Poultry|Serbia|Europe & Central Asia|Agribusiness|2017-06-10|2017-08-02|280.02915342218256|
|Ninirnir Communications Data Center|Paraguay|Latin America|Telecom|2018-11-05|-|279.6213473611904|
|Poltam Industries Cement|Ukraine|Europe & Central Asia|Manufacturing|2019-05-31|2019-09-18|279.62108474210777|
|Fenka Farms Poultry|Ukraine|Europe & Central Asia|Agribusiness|2022-11-14|2023-04-04|279.60945736947946|
|Deldanpol Telecom Tower Portfolio|Madagascar|Sub-Saharan Africa|Telecom|2020-08-03|-|279.5486372306032|
|Marorivet Communications Tower Portfolio|Guatemala|Latin America|Telecom|2015-11-12|-|279.0375011212351|
|Sorber Power Solar|Indonesia|East Asia & Pacific|Energy|2021-06-11|2021-07-26|279.01595644169254|
|Vakeldel Farms Processing Expansion|Nigeria|Sub-Saharan Africa|Agribusiness|2022-11-07|2023-03-08|278.99361909343656|
|Solamaras Foods Dairy|Turkey|Europe & Central Asia|Agribusiness|2025-05-02|2025-08-01|278.83905530554284|
|Vaulamar Bank Microfinance|Central African Republic|Sub-Saharan Africa|Finance|2015-01-22|-|278.6378169024925|
|Danvetmi Finance Trade Finance|Jamaica|Latin America|Finance|2017-04-11|2017-07-29|278.47345279791665|
|Julbri Communications Fiber Rollout|Cameroon|Sub-Saharan Africa|Telecom|2020-06-15|2020-07-31|277.92101523259504|
|Rasber Industries Auto Components|Uzbekistan|Europe & Central Asia|Manufacturing|2022-11-17|2023-03-14|277.8087466828542|
|Mika Finance SME Credit Line|Nigeria|Sub-Saharan Africa|Finance|2018-03-07|-|277.4075014995128|
|Lomarber Telecom Fiber Rollout|Kenya|Sub-Saharan Africa|Telecom|2025-07-07|2025-09-20|277.3852425460614|
|Kelorimi Communications Data Center|Peru|Latin America|Telecom|2020-11-28|-|277.1036543752452|
|Torbriber Foods Storage|Equatorial Guinea|Sub-Saharan Africa|Agribusiness|2022-03-03|-|275.9459160819745|
|Rinberni Manufacturing Energy Efficiency|Colombia|Latin America|Manufacturing|2022-04-10|-|275.7893310693579|
|Vaama Networks Fiber Rollout|Cote d'Ivoire|Sub-Saharan Africa|Telecom|2017-01-29|2017-08-18|275.5655964164414|
|Polvarin Telecom Fiber Rollout|India|South Asia|Telecom|2017-02-06|2017-03-03|275.0716116396022|
|Torni Capital Trade Finance|India|South Asia|Finance|2025-04-04|2025-05-10|274.84558150631943|
|Rasni Capital Microfinance|Chile|Latin America|Finance|2014-05-30|-|274.5731814098292|
|Sardel Telecom Fiber Rollout|Somalia|Sub-Saharan Africa|Telecom|2017-12-30|2018-08-21|274.55572608814475|
|Dancorsar Farms Dairy|Uzbekistan|Europe & Central Asia|Agribusiness|2015-01-25|-|274.23723283721506|
|Marsorori Works Auto Components|Brazil|Latin America|Manufacturing|2014-06-19|-|274.22341962872133|
|Delkel Agro Edible Oils|Lebanon|Middle East|Agribusiness|2017-12-10|2018-04-30|273.8500452566938|
|Fenamabri Networks Fiber Rollout|Belarus|Europe & Central Asia|Telecom|2014-05-16|-|273.5921458691842|
|Rinnir Finance Credit Line|Nigeria|Sub-Saharan Africa|Finance|2022-05-09|2022-07-21|273.41669326111935|
|Fenras Energy Distribution|Barbados|Latin America|Energy|2021-05-27|2021-09-05|272.63596815948017|
|Tamamaama Finance Green Credit Line|Russian Federation|Europe & Central Asia|Finance|2015-07-26|2015-12-04|272.55694794632296|
|Corzen Industries Cement|Lesotho|Sub-Saharan Africa|Manufacturing|2019-09-02|-|272.23497591835877|
|Solbercor Telecom Tower Portfolio|Turkey|Europe & Central Asia|Telecom|2024-01-12|2024-04-14|271.96009580254474|
|Kelnirkel Farms Processing Expansion|India|South Asia|Agribusiness|2019-03-02|2020-02-20|271.54911846198956|
|Misol Works Packaging Line|Egypt|Middle East|Manufacturing|2014-10-19|-|271.49757296065826|
|Lozen Bank Green Credit Line|Romania|Europe & Central Asia|Finance|2024-04-21|2024-09-29|270.3815156470427|
|Amava Energy Thermal|Indonesia|East Asia & Pacific|Energy|2016-08-31|-|270.05354425425566|
|Torber Power Solar|Peru|Latin America|Energy|2021-07-05|2021-11-29|269.8649096700035|
|Omanrin Foods Edible Oils|Sri Lanka|South Asia|Agribusiness|2014-12-19|-|269.70285457388917|
|Orioribri Farms Processing Expansion|India|South Asia|Agribusiness|2022-04-21|2022-08-05|269.6847268301386|
|Niranom Energy Energy Expansion|Brazil|Latin America|Energy|2020-03-07|2020-11-09|269.6488617639059|
|Danfenan Power Distribution|Poland|Europe & Central Asia|Energy|2025-02-08|2025-11-14|269.4531150581757|
|Keloribri Networks Mobile Expansion|Guinea|Sub-Saharan Africa|Telecom|2023-05-16|2023-07-30|269.15240595135685|
|Delzen Farms Storage|South Africa|Sub-Saharan Africa|Agribusiness|2019-05-24|2019-09-23|269.07093961825416|
|Rasansor Power Transmission|South Africa|Sub-Saharan Africa|Energy|2015-05-13|-|268.5981503477564|
|Rinnir Works Auto Components|Iran|Middle East|Manufacturing|2020-03-30|-|268.5709754290947|
|Antor Farms Edible Oils|Somalia|Sub-Saharan Africa|Agribusiness|2021-08-25|-|268.4655326358688|
|Orikelni Networks Data Center|Tunisia|Middle East|Telecom|2021-02-03|-|268.4181031995393|
|Nirdel Industries Building Materials|Turkey|Europe & Central Asia|Manufacturing|2015-05-17|2015-08-01|268.37496311637557|
|Omber Communications Fiber Rollout|Croatia|Europe & Central Asia|Telecom|2023-03-27|-|268.31712308378735|
|Rasnir Power Gas-to-Power|Thailand|East Asia & Pacific|Energy|2022-09-01|2023-02-03|268.008775235564|
|Zensar Manufacturing Auto Components|Ukraine|Europe & Central Asia|Manufacturing|2021-04-11|-|267.8848745561196|
|Oriamaula Manufacturing Cement|Niger|Sub-Saharan Africa|Manufacturing|2017-04-07|-|267.63278104665875|
|Zenkelmi Capital Green Credit Line|Ecuador|Latin America|Finance|2023-04-10|2023-09-14|267.5792250003388|
|Raskelcor Power Thermal|India|South Asia|Energy|2017-03-19|-|267.49585515172794|
|Ulabri Finance Green Credit Line|Maldives|South Asia|Finance|2022-06-03|2022-10-11|266.550937698147|
|Sarzen Finance Green Credit Line|Bolivia|Latin America|Finance|2015-04-13|-|265.8416297643229|
|Ulatorber Telecom Fiber Rollout|Uganda|Sub-Saharan Africa|Telecom|2019-11-19|-|265.6709344259661|
|Zenpoljul Foods Storage|Macedonia|Europe & Central Asia|Agribusiness|2017-10-26|-|265.64658014016766|
|Lobri Networks Mobile Expansion|Indonesia|East Asia & Pacific|Telecom|2016-04-25|2016-11-08|265.5355589445168|
|Lova Finance Credit Line|Honduras|Latin America|Finance|2022-06-15|2022-11-13|265.53266171705604|
|Kelsolnir Networks Mobile Expansion|Suriname|Latin America|Telecom|2023-08-27|-|265.1780495747548|
|Brini Communications Fiber Rollout|India|South Asia|Telecom|2020-12-02|-|265.0245900124861|
|Anfen Works Building Materials|Bahamas|Latin America|Manufacturing|2016-02-08|2016-06-27|265.0170952196224|
|Andel Communications Fiber Rollout|Argentina|Latin America|Telecom|2019-10-12|-|264.7017225280943|
|Tormartam Agro Edible Oils|Poland|Europe & Central Asia|Agribusiness|2016-02-15|2016-12-15|264.28576713789965|
|Kelulasol Agro Storage|Suriname|Latin America|Agribusiness|2015-05-19|-|264.0435453002376|
|Corcor Foods Dairy|Philippines|East Asia & Pacific|Agribusiness|2023-03-11|2023-07-10|263.97034911994626|
|Danama Agro Dairy|India|South Asia|Agribusiness|2024-12-19|2025-06-04|263.8765699314387|
|Rasoriber Communications Mobile Expansion|Grenada|Latin America|Telecom|2016-09-05|2017-10-31|263.69817823646116|
|Orisarvet Manufacturing Cement|Mexico|Latin America|Manufacturing|2016-05-10|2016-09-20|263.60795945561244|
|Solberori Telecom Mobile Expansion|Cote d'Ivoire|Sub-Saharan Africa|Telecom|2017-03-03|2017-04-15|263.57890393283924|
|Beran Capital Green Credit Line|Antigua and Barbuda|Latin America|Finance|2021-08-04|2022-09-06|263.49123233417185|
|Amarintam Telecom Mobile Expansion|Cote d'Ivoire|Sub-Saharan Africa|Telecom|2021-04-20|2021-08-01|263.40574536347714|
|Beramajul Bank Trade Finance|Iraq|Middle East|Finance|2016-12-14|2017-04-17|263.07899879701705|
|Amaberkel Power Battery Storage|Guatemala|Latin America|Energy|2024-02-26|-|262.88807516991454|
|Raslocor Telecom Tower Portfolio|Guatemala|Latin America|Telecom|2016-02-02|2016-10-16|262.23776198614|
|Ulasardel Farms Storage|China|East Asia & Pacific|Agribusiness|2023-11-07|-|261.770094757554|
|Tamfenmi Power Distribution|Palestinian Territory|Middle East|Energy|2021-10-02|2021-12-19|261.7580650599084|
|Julzen Energy Transmission|Cambodia|East Asia & Pacific|Energy|2015-10-09|2016-03-26|261.57212986484484|
|Tamsoltam Energy Gas-to-Power|Lebanon|Middle East|Energy|2017-03-04|2017-11-07|261.21983871878746|
|Fendanula Foods Dairy|India|South Asia|Agribusiness|2022-08-07|-|260.87435305463384|
|Tamfen Power Transmission|Samoa|East Asia & Pacific|Energy|2014-12-20|-|260.329388059705|
|Fencormar Finance Microfinance|Thailand|East Asia & Pacific|Finance|2014-10-11|-|260.21055489039225|
|Antammar Power Thermal|Peru|Latin America|Energy|2021-09-07|2023-03-04|260.12151212411976|
|Brisarcor Telecom Fiber Rollout|Venezuela|Latin America|Telecom|2015-03-11|2016-05-24|259.86449465477165|
|Solrin Manufacturing Auto Components|Cote d'Ivoire|Sub-Saharan Africa|Manufacturing|2019-03-10|2019-09-19|259.60397269337216|
|Rastam Works Energy Efficiency|Bosnia and Herzegovina|Europe & Central Asia|Manufacturing|2014-12-09|2015-02-23|259.2943375931319|
|Torommi Communications Fiber Rollout|Vietnam|East Asia & Pacific|Telecom|2014-05-31|2014-09-13|258.75002848422275|
|Polmarka Bank SME Credit Line|Malawi|Sub-Saharan Africa|Finance|2018-03-15|2018-07-02|258.6733622072448|
|Anjuldan Foods Poultry|India|South Asia|Agribusiness|2019-06-20|-|258.578465390309|
|Kelkelvet Power Distribution|Egypt|Middle East|Energy|2023-02-04|2023-09-08|258.57295347001747|
|Marsor Power Power Project|Tunisia|Middle East|Energy|2014-08-09|2015-06-24|258.55487763335174|
|Torka Foods Poultry|Barbados|Latin America|Agribusiness|2014-07-07|2014-08-20|258.4898458891915|
|Bertam Works Auto Components|Egypt|Middle East|Manufacturing|2018-07-14|2018-11-25|258.1842484335763|
|Mardel Finance Microfinance|Egypt|Middle East|Finance|2014-09-19|-|258.11381491606204|
|Marvetni Foods Dairy|Guinea-Bissau|Sub-Saharan Africa|Agribusiness|2018-07-13|2018-09-21|258.091381437825|
|Beruladan Industries Cement|Ecuador|Latin America|Manufacturing|2025-01-01|2025-06-10|258.09092323796995|
|Amavator Works Building Materials|Brazil|Latin America|Manufacturing|2014-11-10|2015-03-27|257.45546792246506|
|Vapolzen Communications Mobile Expansion|Lao People's Democratic Republic|East Asia & Pacific|Telecom|2020-04-04|-|257.2600230956665|
|Julniom Farms Poultry|India|South Asia|Agribusiness|2021-12-09|2022-04-05|257.2283255555747|
|Niva Communications Fiber Rollout|Ukraine|Europe & Central Asia|Telecom|2025-12-22|2026-06-04|257.1591409388772|
|Marzenula Capital Credit Line|Ukraine|Europe & Central Asia|Finance|2022-07-16|-|256.9927482183456|
|Tamni Manufacturing Pharma|Egypt|Middle East|Manufacturing|2020-06-04|-|256.77896514283884|
|Berdel Agro Dairy|Eritrea|Sub-Saharan Africa|Agribusiness|2021-02-08|-|256.7231834239266|
|Polcorbri Manufacturing Cement|Kenya|Sub-Saharan Africa|Manufacturing|2025-11-30|-|256.61817044268736|
|Vetcormi Power Transmission|Equatorial Guinea|Sub-Saharan Africa|Energy|2023-05-24|-|256.5405133934238|
|Antor Bank MSME Facility|Vietnam|East Asia & Pacific|Finance|2023-06-17|-|256.4208285071063|
|Polrastam Works Cement|Uruguay|Latin America|Manufacturing|2016-12-28|-|255.87922955278222|
|Vamizen Farms Dairy|Vanuatu|East Asia & Pacific|Agribusiness|2021-04-06|2021-07-31|255.28619650546045|
|Marsordel Finance Green Credit Line|Uganda|Sub-Saharan Africa|Finance|2017-05-05|-|255.12856764542306|
|Raska Works Building Materials|Georgia|Europe & Central Asia|Manufacturing|2019-10-09|2020-02-14|254.66561272406366|
|Orikelom Energy Transmission|Turkey|Europe & Central Asia|Energy|2022-05-29|-|254.6318308334162|
|Taman Telecom Data Center|Uganda|Sub-Saharan Africa|Telecom|2018-06-10|2018-08-04|254.13189388239832|
|Keldel Telecom Tower Portfolio|Algeria|Middle East|Telecom|2022-06-16|-|253.89589210532228|
|Rinmi Foods Processing Expansion|Vietnam|East Asia & Pacific|Agribusiness|2019-06-17|-|253.6921465914998|
|Solulacor Farms Processing Expansion|Vietnam|East Asia & Pacific|Agribusiness|2019-09-25|-|253.48294377442716|
|Berbrini Farms Dairy|Bangladesh|South Asia|Agribusiness|2015-07-04|2015-10-26|253.4633586089358|
|Marsol Energy Thermal|Pakistan|South Asia|Energy|2016-04-20|2016-07-29|253.07680000551701|
|Omjulrin Telecom Fiber Rollout|Costa Rica|Latin America|Telecom|2017-04-18|2017-09-18|252.86255990275401|
|Anfenori Power Transmission|Malawi|Sub-Saharan Africa|Energy|2024-12-29|-|252.8080869169065|
|Lodel Networks Mobile Expansion|Honduras|Latin America|Telecom|2016-07-21|2016-12-30|252.33337725450966|
|Corpolan Power Transmission|Armenia|Europe & Central Asia|Energy|2015-09-18|-|252.31726465433871|
|Ankel Industries Energy Efficiency|Sri Lanka|South Asia|Manufacturing|2019-06-23|-|251.9735528558898|
|Delniori Telecom Tower Portfolio|Zambia|Sub-Saharan Africa|Telecom|2014-03-26|-|251.45876396959517|
|Nirmar Bank Credit Line|Grenada|Latin America|Finance|2020-06-01|2021-02-09|251.33160563836844|
|Corvetka Bank MSME Facility|Colombia|Latin America|Finance|2014-02-06|2014-05-03|250.88342175613056|
|Lorinsol Communications Mobile Expansion|Haiti|Latin America|Telecom|2014-09-15|-|250.79586133216102|
|Juldanama Bank Credit Line|Honduras|Latin America|Finance|2019-07-07|2019-10-08|250.25029448806015|

## Q22. Active projects with first investment more than two years after approval

> **Note:** `add_months(..., 24)` is used instead of a 730-day comparison so leap years do not move the boundary.

|project_name|country|region|approval_date|invested_date|days_approval_to_invest|total_approved_usd_mm|
|---|---|---|---|---|---|---|
|Vani Capital Green Credit Line 2019|Burkina Faso|Sub-Saharan Africa|2019-10-19|2022-06-03|958|222.85153132651706|
|Praven Bank Trade Finance|Nigeria|Sub-Saharan Africa|2021-10-13|2024-04-07|907|32.928496685776466|
|Korpra Networks Data Center|Lesotho|Sub-Saharan Africa|2017-10-01|2020-01-30|851|181.06530594086607|
|Miras Farms Storage II|Solomon Islands|East Asia & Pacific|2022-06-25|2024-08-03|770|82.79175391164132|
|Coryorjul Agro Poultry|Marshall Islands|East Asia & Pacific|2017-12-04|2019-12-18|744|175.59357709598598|
|Wenva Bank SME Credit Line|Morocco|Middle East|2016-09-08|2018-09-13|735|22.77394207609655|
|Torulras Manufacturing Packaging Line 2020|Jordan|Middle East|2021-02-19|2023-02-23|734|197.09973009726258|

## Q23. Status mix by region

Each region's status shares are a percentage of that region's projects. Each row must sum to 100.0, which is the check.

|region|total_projects|pct_active|pct_closed|pct_pending|pct_dropped|
|---|---|---|---|---|---|
|East Asia & Pacific|891|24.0|28.2|23.0|24.8|
|Europe & Central Asia|702|24.6|27.5|22.9|24.9|
|Latin America|1009|25.1|26.0|23.3|25.7|
|Middle East|468|21.6|28.8|25.0|24.6|
|North America|5|20.0|20.0|60.0|0.0|
|South Asia|510|28.4|20.2|29.0|22.4|
|Sub-Saharan Africa|1415|24.5|25.2|25.7|24.6|
