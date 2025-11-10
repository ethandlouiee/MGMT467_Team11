# Project Prompt Log: BigQuery E-commerce EDA

This log tracks the chronological sequence of prompts and interactions used to complete the e-commerce growth analysis project, highlighting crucial debugging steps and major outcome prompts.

---

## Phase 1: Setup and Initial KPI Trends

| Log No. | User Prompt | Description |
| :--- | :--- | :--- |
| **P1.0** | Initial DB Access: `bigquery-public-data.thelook_ecommerce`. Provide Python code to access the dataset and present the first couple of rows. | Initial connection and data validation using the `orders` table head. |
| **P2.0** | KPI Generation: Identify the top 3 growth KPIs for the business. | Established AOV, RPR, and Net Order Count Growth as core metrics. |
| **P3.0** | KPI Trends: Use CTEs and window functions to compute trends and MoM/YoY growth for Net Order Count Growth. | Executed complex SQL for temporal analysis, confirming technical readiness for advanced functions. |

---

## Phase 2: Deep Dive, Debugging, and Validation

| Log No. | User Prompt | Description |
| :--- | :--- | :--- |
| **P4.0** | Deep Dive: Choose one product catergory and one customer segment. Use SQL to explore drivers (discounts, marketing channel if available, region, device). | **Initial attempt to analyze Repeat Buyers / Jeans.** Led to multiple errors due to incorrect column names (`discount`, `retail_price`, `device`). |
| **P4.1** | *[Error Handling]* Correct the SQL error where `Name discount not found`. | Corrected the discount calculation structure, but relied on the assumption that `retail_price` existed in the `order_items` table. |
| **P4.2** | *[Error Handling]* Correct the SQL error where `Name retail_price not found`. | Attempted further column name guessing, confirming previous attempts were schema-inaccurate. |
| **P4.3** | **CRITICAL DEBUGGING STEP:** Give me the python code to view all tables present in the dataset. Query each table to the table info. | **Schema Inspection Prompt.** Essential intervention to diagnose all subsequent column reference failures simultaneously. |
| **P4.4** | *[Error Handling]* Correct the SQL error where `Name device not found`. | Fixed by replacing the non-existent `device` column with the available `traffic_source` (found via P4.3). |
| **P5.0** | Validate: Lets cross-check all three of these insights with alternative queries or counterexamples. | Initiated the rigorous validation phase (CC 1, CC 2, CC 3) to test the robustness of initial findings. |

---

## Phase 3: Visualization and Documentation

| Log No. | User Prompt | Description |
| :--- | :--- | :--- |
| **P6.0** | Visualize: Build one interactive Plotly chart in Colab with Scorecard, Pie/Donut, and Bar. | Prompt to create the combined dashboard visualization. |
| **P6.1** | *[Error Handling]* Correct the SQL error where `Unrecognized name: t3`. | Fixed a minor alias ordering error in the Bar Chart SQL structure. |
| **P6.2** | Write a log of the prompts used in this project... | Prompt requesting the final meta-analysis log. |
| **P6.3** | Highlight “fail then fix” examples... | Prompt for revised focus on debugging cycles in the log structure. |

---

## Key Takeaways: Failures, Fixes, and Learning

The analysis was defined by three critical failures caused by relying on generalized SQL schema knowledge rather than explicit dataset documentation.

| Initial Failing Prompt | System Error | Fixing Prompt/Action | Impact |
| :--- | :--- | :--- | :--- |
| **P4.0** (Deep Dive: Discount) | `Name discount not found` | **P4.3: Query each table to the table info.** | Confirmed discount calculation required joining **`products`** for `retail_price`, correcting the entire structure. |
| **P4.4** (Deep Dive: Device) | `Name device not found` | **P4.3: Query each table to the table info.** | Confirmed the `orders` table lacked device info, leading to replacement with the validated column **`users.traffic_source`**. |
| **P6.0** (Visualize: Bar Chart) | `Unrecognized name: t3` | **P6.1: Manual SQL correction** (reordering aliases). | Demonstrated the need for meticulous alias management in complex multi-join SQL, even after schema diagnosis. |
| **P6.2** (Write a prompt log:) | `Write a log of the prompts used in this project...` | **P6.3: Highlight “fail then fix” examples...** . | Demonstrated the need for clairity in the desired formatting in prompts |
