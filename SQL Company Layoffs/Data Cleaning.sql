
SELECT * FROM layoffs;

-- 1. REMOVE DUPICATES
-- 2. Standardize Data
-- 3. Null Values
-- 4. Remove Unnecessary Columns



-- CREATE NEW TABLE AS TO NOT AFFECT RAW TABLE DATA
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT * FROM layoffs;


-- 1. REMOVING DUPLICATES
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date') AS row_num
FROM layoffs_staging
WHERE row_num > 1;

WITH duplicate_cte AS
(
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
Select * FROM duplicate_cte
WHERE row_num > 1;

SELECT * FROM layoffs_staging
WHERE company = 'Casper';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE FROM layoffs_staging2
WHERE row_num > 1;

SELECT * FROM layoffs_staging2
ORDER BY company;




-- 2. STANDARDIZE DATA

-- TRIM cmpany names
SELECT TRIM(company) FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);


-- MERGE common name industries
SELECT DISTINCT(industry) FROM layoffs_staging2
ORDER BY 1;

SELECT * FROM layoffs_staging2
WHERE industry LIKE 'crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'crypto%';

-- DO THE SAME FOR COUNTRIES

SELECT DISTINCT country FROM layoffs_staging2
ORDER BY 1;


UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';


-- Change date column from text data to date data (time series data)

-- REFORMAT DATE
SELECT * FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- CHANGE DATA TYPE TO DATE TYPE
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;



-- 3. NULL VALUES
SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

-- Set blank industries to NULL

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT * FROM layoffs_staging2
WHERE company LIKE 'Bally%'; 

-- To populate null and blank industries with known industries for that company, we will join a table (t1) with all the blank indusries with a table (t2) with all the non-blank industries

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- 4. REMOVE UNECESSARY ROWS/COLUMNS

-- Remove rows with too little information

SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

SELECT * FROM layoffs_staging2;

-- Remove row_num column (no longer needed)

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


-- Data is now quite clean :)