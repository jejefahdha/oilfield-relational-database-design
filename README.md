# Relational Database Design and Oilfield Production Analysis

## Project Overview
The original Volve production dataset is provided as a flat table that combines descriptive information (such as wells, fields, and facilities) with operational measurements (such as oil production, gas production, pressure, and temperature). While suitable for data exploration, this structure introduces redundancy and makes maintenance and scalability more challenging.

This project redesigns the dataset into a normalized relational database by developing an Entity Relationship Diagram (ERD), constructing dimension and fact tables, generating surrogate keys, and implementing the schema in SQL. The resulting database is then validated through analytical queries to ensure that the normalization process preserves the original information while providing a more efficient and maintainable structure for analysis.

## Motivation
Many real-world datasets are distributed as flat tables, where descriptive attributes and transactional measurements are stored together in a single structure. Although convenient for exploration, this design can lead to data redundancy, update anomalies, and reduced maintainability.

For example, if information about a well or facility changes, every corresponding record in the flat table may need to be updated. As the dataset grows, this approach becomes increasingly inefficient.

The motivation of this project is to redesign the original flat dataset into a normalized relational database by separating entities into dimension and fact tables. This structure minimizes redundancy, improves data integrity, and provides a scalable foundation for analytical queries and future data warehouse development.

## Objectives
This project aims to:
1. Design an Entity Relationship Diagram (ERD) from the original flat dataset.
2. Apply normalization principles to reduce redundancy.
3. Construct dimension and fact tables with surrogate keys.
4. Implement the relational schema using SQL in BigQuery.
5. Validate the database design through integrity checks and analytical queries.
  
## Dataset
This project uses the **Volve Production Data**, a publicly available oil and gas dataset originally released by Equinor for research and educational purposes. The dataset was accessed through Kaggle and contains daily operational records from the Volve field, including production volumes and well monitoring measurements.

**Dataset Source:** https://www.kaggle.com/datasets/lamyalbert/volve-production-data

## Tools & Technologies
- **Python (Google Colab)**: Data preprocessing and transformation (Pandas)
- **SQL (Google BigQuery)**: SQL implementation, database management, validation, and analysis
- **GitHub**: Documentation and portfolio hosting
- **dbdiagram.io**: Entity Relationship Diagram (ERD) design
  
## Project Workflow
The project follows an end-to-end workflow:
1. Original Volve flat dataset
2. Exploratory data analysis
3. Entity identification & ERD design
4. Normalization
5. Python preprocessing (create dimension & fact tables)
6. Export normalized tables
7. Import into Google BigQuery
8. Perform SQL for validation & analysis
   
## ERD Design
The database schema was designed based on the following principles
- Separate descriptive attributes into dimension tables.
- Store operational measurements in fact tables.
- Use surrogate keys to establish relationships between tables.
- Reduce data redundancy through normalization.
<img width="1005" height="824" alt="image" src="https://github.com/user-attachments/assets/1b82933b-e3bb-427b-8e62-378a48b9f33a" />

## Database Validation
The normalized dimension and fact tables generated through Python preprocessing were exported and imported into Google BigQuery. The imported tables form the relational database based on the previously designed ERD and serve as the foundation for subsequent validation and analytical queries.
<img width="848" height="389" alt="image" src="https://github.com/user-attachments/assets/a77bdab0-6542-4d21-918b-f2da1c72aac2" />

After the normalized tables were imported into Google BigQuery, a series of validation procedures were performed to verify that the transformation from the original flat dataset to the normalized relational database preserved the underlying information correctly.

Rather than focusing solely on database creation, this stage aimed to answer a fundamental question:

> **Does the normalized relational structure represent exactly the same data as the original flat dataset without losing information?**

To answer this question, several validation checks were conducted:

* **Row Count Validation**: The number of records in the normalized tables was compared with the corresponding records generated during Python preprocessing.
* **Primary Key Validation**: Each surrogate key was verified to be unique within its respective dimension table.
* **Foreign Key Validation**: Foreign key columns were checked to ensure that every record correctly references an existing dimension record and contains no invalid or missing relationships.
* **Join Validation**: The normalized tables were joined using SQL to reconstruct the original flat dataset. The reconstructed results were then compared with both the Python-generated tables and the original dataset.

All validation checks produced consistent results, demonstrating that the normalization process preserved the complete information contained in the original dataset while organizing it into a more structured and maintainable relational schema.

## Production Analysis
The normalized relational database was queried using SQL to explore production performance and operational characteristics across wells. The following analyses demonstrate how the relational structure enables efficient integration of information from multiple tables while providing meaningful insights into the production data.
### Production Trend by Year
**Result**
* Oil and gas production showed a consistent decline from **2009 to 2013**.
* Production increased again between **2014 and 2016**.
---
### Which Wells Contribute the Most Production?
**Result**
* Between **2008 and 2012**, the largest production contributor shifted from **NO 15/9-F-12 H** to **NO 15/9-F-14 H**, although both wells experienced declining production over time.
* In **2016**, **NO 15/9-F-11 H** became the dominant producer, contributing approximately **52%** of total production.
---
### Which Wells Are Underutilized?
**Result**
* **NO 15/9-F-15 D** has the lowest production per operating hour among the analyzed wells.
---
### Which Wells Experience the Most Downtime?
**Result**
* **NO 15/9-F-1 C** records the highest average downtime, approximately **10 hours per day**.

## Key Insights
* **The normalized ERD successfully transformed the original flat dataset into a relational database without losing information.** Validation through row counts, primary keys, foreign keys, and table joins confirmed that the redesigned schema preserves the original data while providing a more organized and maintainable structure.
* **The emergence of NO 15/9-F-11 H Well as the source of approximately 52% of total production in 2016 indicates a high dependency on a single well.** Any unexpected downtime on this well could have a substantial impact on overall field production, making it a priority for preventive maintenance.
* **NO 15/9-F-15 D Well operates with the lowest production per hour.** It may indicate operational inefficiencies or reservoir-related limitations. Further investigation by production or mechanical engineers may be required to determine the underlying cause and identify opportunities for optimization.
* **The significantly higher downtime observed for NO 15/9-F-1 C (approximately 10 hours per day) highlights it as a candidate for maintenance and operational review.** Reducing downtime on this well may improve overall production availability.
