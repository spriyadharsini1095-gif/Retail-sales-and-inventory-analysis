# Retail Sales & Inventory Analysis

End-to-end retail sales and inventory analytics project built on nine related tables. Raw data was cleaned in Excel, modelled and queried in MySQL (with an 11-relationship ER diagram), and visualised in a multi-page Power BI dashboard covering sales, products, customers, staff, and inventory.

## Tech Stack
- **Excel** — initial cleaning of nine raw tables (null handling, data-type fixes, text normalisation)
- **MySQL** — database setup, ER modelling (11 relationships), and analytical queries
- **Power BI** — relational model, DAX measures, and an interactive multi-page dashboard

## Dataset — Nine Tables
| Table | Rows | Role |
|-------|------|------|
| customers | 1,445 | Customer master |
| products | 321 | Product catalog |
| orders | 1,615 | Order header |
| order_items | 4,722 | Order line items |
| staffs | 10 | Staff / managers |
| stores | 3 | Store locations |
| brands | 9 | Product brands |
| categories | 7 | Product categories |
| stocks | 939 | Per-store inventory |

## Pipeline
1. **Excel cleaning:** removed empty columns, handled NULLs (phone, shipped_date, manager_id), corrected data types (zip codes as text, discount/price formatting), normalised text fields, and verified there were no true duplicates.
2. **MySQL:** created the `retail_analysis` database, imported all nine tables in dependency order, built an 11-relationship ER diagram, and wrote analytical queries for revenue, store, product, and customer performance.
3. **Power BI:** connected to MySQL, set relationships, defined DAX measures, and built a multi-page dashboard.

## Dashboard Pages
- **Executive Summary** — revenue, orders, average order value, discount %
- **Sales by Store** — store comparison, state map, revenue share
- **Product Performance** — top products, category and brand comparison
- **Customer Analysis** — spending tiers, top spenders
- **Order Analysis** — status, monthly trend, late shipments
- **Stock & Inventory** — low-stock alerts, stock by store

## Key Findings
- **Total net revenue:** ~$6.66M across 1,445 completed orders (avg order value ~$1,581).
- **Baldwin Bikes (NY) drives 67.6% of all revenue** — heavy single-store concentration.
- **Late shipment rate is 31.7% overall** (Santa Cruz worst at 36.6%) — a critical operational issue.
- **Zero repeat customers** — every customer is a one-time buyer, a major retention opportunity.
- **Trek dominates** the catalog (42%); 2018 model-year products outsell all others.

## Key Recommendations
- Audit the fulfilment process to cut the 31.7% late-shipment rate (target <10%).
- Launch a customer loyalty program to address zero repeat purchases.
- Expand marketing in the underperforming Rowlett (TX) market.
- Restock high-revenue Trek road bikes at Baldwin before stockouts occur.
- Set auto-reorder triggers for the top revenue products.

## Repository Contents
- `retail sales and inventory analysis.sql` — MySQL setup and queries
- `retail_analysis.pbix` — Power BI dashboard
- `retail sales and inventory analysis EER diagram` — database ER diagram
- `Retail_Report_Final.pdf` — full project report

---
*Prepared by Priyadharsini S | May 2026*
