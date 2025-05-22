-- ===================================
-- Data Cleaning & Standardization in MySQL
-- Project: Cleaning Layoffs Dataset
-- Author: Sivakalimuthu R
-- ===================================

-- 1️⃣ Creating the table with necessary fields
CREATE TABLE `layoffs_staging2` (
  `company` TEXT,
  `location` TEXT,
  `industry` TEXT,
  `total_laid_off` INT DEFAULT NULL,
  `percentage_laid_off` TEXT,
  `date` TEXT,
  `stage` TEXT,
  `country` TEXT,
  `funds_raised_millions` INT DEFAULT NULL,
  `row_number` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 2️⃣ Removing duplicates by assigning row numbers
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
  PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;

-- 3️⃣ Extracting distinct industry names for verification
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

-- 4️⃣ Standardizing industry names (correcting inconsistent data)
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Verify standardization changes
SELECT * 
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- 5️⃣ Cleaning country names by removing trailing periods
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) AS cleaned_country
FROM layoffs_staging2
ORDER BY country;

-- 6️⃣ Converting date format from text to MySQL `DATE` format
UPDATE layoffs_staging2 
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY `date` DATE;

-- 7️⃣ Identifying missing values (NULL or blank entries)
SELECT *
FROM layoffs_staging2
WHERE 
  company IS NULL OR company = '' OR
  location IS NULL OR location = '' OR
  industry IS NULL OR industry = '' OR
  total_laid_off IS NULL OR total_laid_off = '' OR
  percentage_laid_off IS NULL OR percentage_laid_off = '' OR
  `date` IS NULL OR
  stage IS NULL OR stage = '' OR
  country IS NULL OR country = '' OR
  funds_raised_millions IS NULL OR funds_raised_millions = '';

-- 8️⃣ Removing rows where both `total_laid_off` and `percentage_laid_off` are NULL
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- 9️⃣ Dropping the unnecessary `row_number` column
ALTER TABLE layoffs_staging2
DROP COLUMN `row_number`;

-- 🔟 Retrieving the cleaned dataset for final review
SELECT * 
FROM layoffs_staging2;
