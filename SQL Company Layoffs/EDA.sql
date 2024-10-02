-- EDA

SELECT * FROM layoffs_staging2;

-- Highest Total Laid Off
SELECT MAX(total_laid_off) FROM layoffs_staging2;

-- Companies who laid off all employees
SELECT * FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Companies and their total laid off
SELECT company, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Identify Date Range
SELECT MIN(`date`), MAX(`date`) FROM layoffs_staging2;


-- Locations ordered by most laid off
SELECT location, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY location
ORDER BY 2 DESC;

-- Countries ordered by most layoffs
SELECT country, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Years ordered by most layoffs
SELECT YEAR(`date`), SUM(total_laid_off) FROM layoffs_staging2
GROUP BY 1
ORDER BY 1 DESC;

-- Company stages ordered by most layoffs
SELECT stage, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Industries ordered by most layoffs
SELECT industry, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Months ordered by most layoffs
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- Rolling total of layoffs over time

WITH rolling_total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS roll_total
FROM rolling_total;

-- Top 5 companies with most layoffs by year

WITH Company_Year  (company, years, total_laid_off) AS
(
SELECT company, SUBSTRING(`date`,1, 4) AS `YEAR`, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY company, `Year`
), Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking FROM Company_Year
WHERE years IS NOT NULL
ORDER BY ranking ASC)
SELECT * FROM Company_Year_Rank
WHERE ranking <= 5
ORDER BY years;


-- Top 5 companies with most layoffs by month

WITH MonthlyLaidOff AS
(
SELECT SUBSTRING(`date`,1,7) AS YearMonth, company, industry, SUM(total_laid_off) AS sum_laid_off FROM layoffs_staging2
GROUP BY YearMonth, company, industry
), MonthlyRanking AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY YearMonth ORDER BY sum_laid_off DESC) AS Ranking FROM MonthlyLaidOff
)
SELECT * FROM MonthlyRanking
WHERE YearMonth IS NOT NULL AND Ranking <= 5 AND sum_laid_off IS NOT NULL
ORDER BY YearMonth;


-- Companies who appear most in the top 5 layoffs per month

-- Using a Temp Table

CREATE TEMPORARY TABLE monthly_rankings
WITH MonthlyLaidOff AS
(
SELECT SUBSTRING(`date`,1,7) AS YearMonth, company, industry, SUM(total_laid_off) AS sum_laid_off FROM layoffs_staging2
GROUP BY YearMonth, company, industry
), MonthlyRanking AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY YearMonth ORDER BY sum_laid_off DESC) AS Ranking FROM MonthlyLaidOff
)
SELECT * FROM MonthlyRanking
WHERE YearMonth IS NOT NULL AND Ranking <= 5 AND sum_laid_off IS NOT NULL
ORDER BY YearMonth;

SELECT COUNT(company) AS Times_in_Top_5_layoffs, company, industry FROM monthly_rankings
GROUP BY company, industry
ORDER BY 1 DESC;

-- Alternatively we can use CTEs to achieve the same output

WITH MonthlyLaidOff AS
(
SELECT SUBSTRING(`date`,1,7) AS YearMonth, company, industry, SUM(total_laid_off) AS sum_laid_off FROM layoffs_staging2
GROUP BY YearMonth, company, industry
), MonthlyRanking AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY YearMonth ORDER BY sum_laid_off DESC) AS Ranking FROM MonthlyLaidOff
), TopFiveRanking AS
(
SELECT * FROM MonthlyRanking
WHERE YearMonth IS NOT NULL AND Ranking <= 5 AND sum_laid_off IS NOT NULL
ORDER BY YearMonth
), TopFiveCount AS
(
SELECT COUNT(company) AS Times_in_Top_5_layoffs, company, industry FROM TopFiveRanking
GROUP BY company, industry
ORDER BY 1 DESC
)
SELECT * FROM TopFiveCount;


-- Industries who appear most in the top 5 layoffs per month

SELECT COUNT(industry) AS Times_in_Top_5_layoffs, industry FROM monthly_rankings
GROUP BY industry
ORDER BY 1 DESC;

SELECT * FROM layoffs_staging2;

-- Calculate estimated total number of employees before and after each layoff

SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, 
ROUND(total_laid_off/percentage_laid_off) AS employees_before_layoff, ROUND((total_laid_off/percentage_laid_off)-total_laid_off) AS employees_after_layoff FROM layoffs_staging2;
