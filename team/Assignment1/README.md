# MGMT467 – Unit 1 BigQuery E-Commerce Analytics (Project Team 11)

**Team 11:** Zijing Zhang · Qianyue Wang · Louie Ethan · Hiatt Nate  
**Course:** MGMT 467 – AI-Assisted Big Data Analytics in the Cloud  
**Tooling:** Google BigQuery · Colab · Plotly · Looker Studio  
**Dataset:** `bigquery-public-data.thelook_ecommerce`  
**Dashboard:** https://lookerstudio.google.com/u/0/reporting/968692f3-c1ec-4de9-81ae-985dc0c5ccf2/page/NiCbF

---

## Executive Summary

This analysis identified **three core KPIs** driving growth for *The Look E-commerce* platform:

1. **Revenue Growth Trend**  
2. **Average Order Value (AOV)**
3. **Repeat Purchase Rate (RPR)**

### Strategic Focus
- **Boost AOV :** Replicate successful high-AOV bundling and visual merchandising from the Display channel into the high-traffic Search channel (target +10 % AOV gain).  
- **Increase Repeat Rate :** Deploy personalized marketing and exclusive previews for female repeat customers in China to raise RPR from 7 % → 10 % +.  
- **Optimize Product Portfolio :** Analyze premium brand strategies (*Canada Goose*, *The North Face*) to apply high-AOV pricing and positioning insights to other categories.

---

## Analytical Methodology (DIVE Framework)

| Phase | Objective | Output |
| :--- | :--- | :--- |
| **Discover** | Identify top 3 growth KPIs using CTEs + window functions. | KPI dashboard for Revenue, AOV, RPR, MoM/YoY Growth. |
| **Investigate** | Deep dive into product categories & customer segments. | Highlighted *Outerwear & Coats* and repeat-purchasing. |
| **Validate** | Cross-check AI-generated insights via simplified queries and profit ratios. | Corrected discount bias; validated regional profitability consistency (~ 55 %). |
| **Extend** | Communicate results via Plotly visuals and Looker Studio dashboard. | Interactive dashboards & strategic recommendations. |

---

## Prompt Log and Debugging Highlights

| Phase | Key Prompt Log Entry | Outcome |
| :--- | :--- | :--- |
| **P1.0 – P3.0** | Dataset access and KPI trend generation (CTEs + window functions). | Built monthly revenue and 90-day rolling trend visualization. |
| **P4.0 – P4.4** | Deep dive queries failed due to missing columns (`discount`, `device`). | Fixed by schema inspection (`products.retail_price`, `users.traffic_source`). |
| **P5.0** | Validation phase with cross-queries and counterexamples. | Confirmed profitability of *Outerwear & Coats* (≈ 55 % margin). |
| **P6.0 – P6.1** | Visualization build + SQL alias debug (`Unrecognized name: t3`). | Corrected alias ordering and rendered interactive dashboard. |
| **P6.2 – P6.3** | Meta-documentation prompts for final project log. | Produced structured Prompt Log and README reproducibility guide. |

> **Key Learning:**  
> Schema inspection (`client.list_tables()` + `INFORMATION_SCHEMA.COLUMNS`) was the turning point — transforming trial-and-error SQL debugging into systematic data validation.

---

## Dashboard Highlights

| Visualization | Description |
| :--- | :--- |
| **Total Profit by Product Category** | *Outerwear & Coats* and *Jeans* lead in both sales and profit margins. |
| **Total Sales by Outerwear Brand** | *Carhartt* dominates volume; *Canada Goose* and *The North Face* excel in AOV. |
| **90-Day Rolling Revenue Trend** | Continuous growth since 2019 with clear seasonal acceleration. |
| **Interactive Filters** | Category dropdown + date range controls for dynamic insight exploration. |

---

## Actionable Recommendations

| Objective | Recommended Action | Expected Outcome |
| :--- | :--- | :--- |
| **Boost AOV** | Replicate Display-channel bundling and visual merchandising in Search channel. | + 10 % AOV increase (from <$ 89 → $ ~ 98). |
| **Deepen Customer Loyalty** | Personalized offers & exclusive previews for female repeat customers (China). | Repeat rate increase from 7 % → 10 % +. |
| **Optimize Product Portfolio** | Study high-AOV brand strategies (*Canada Goose*, *The North Face*). | Shift focus from volume to profitability growth. |
