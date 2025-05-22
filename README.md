Data Cleaning & Standardization in MySQL
📊 A MySQL-based project to clean, optimize, and transform a layoffs dataset, ensuring data integrity and usability.

Project Overview
This project focuses on data-cleaning techniques to refine a raw dataset for better analysis. Key tasks include:

Removing duplicates using row-number partitioning.

Standardizing data (industry names, date formats, country names).

Handling missing/null values to improve data accuracy.

Optimizing dataset by dropping unnecessary columns.

Technologies Used
🛠️ SQL (MySQL) for data manipulation 📌 Window functions for deduplication 🔤 String operations for data cleaning 📅 Data type conversions for consistency

Dataset Details
The dataset contains layoffs records with attributes like company name, location, industry, number of employees laid off, funding details, and more.

Setup & Usage
🔹 Clone the Repository
bash
git clone https://github.com/your-repo-link-here.git
🔹 Import the Data into MySQL
1️⃣ Open MySQL Workbench or any MySQL interface. 2️⃣ Load the dataset (layoffs_staging).

🔹 Run the Data Cleaning Script (data_cleaning.sql)
Execute the SQL queries step by step to clean and transform the data.

Key SQL Queries Used
✅ Removing Duplicates
sql
INSERT INTO layoffs_staging2
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;
✅ Standardizing Data (Industry & Date Formats)
sql
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2 
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY `date` DATE;
✅ Handling Null & Missing Values
sql
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
✅ Dropping Unnecessary Columns
sql
ALTER TABLE layoffs_staging2
DROP COLUMN `row_number`;
Final Output
After executing the data-cleaning queries, the dataset is fully standardized, deduplicated, and optimized for further analysis.
