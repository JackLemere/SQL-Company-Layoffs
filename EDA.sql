-- EDA

SELECT * FROM layoffs_staging2;

SELECT MAX(total_laid_off) FROM layoffs_staging2;

SELECT * FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`) FROM layoffs_staging2;

SELECT location, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY location
ORDER BY 2 DESC;

SELECT * FROM layoffs_staging2;

SELECT country, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT * FROM layoffs_staging2
WHERE company LIKE "Deliveroo%";

SELECT country, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off) FROM layoffs_staging2
GROUP BY 1
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- Rolling SUM

WITH rolling_total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS roll_total
FROM rolling_total;


WITH tempquery AS
(
SELECT company, SUBSTRING(`date`,1, 4) AS `Date`, SUM(total_laid_off) AS sum FROM layoffs_staging2
GROUP BY company, `Date`
ORDER BY company ASC
)
SELECT MAX(sum) FROM tempquery;

WITH tempquery AS
(
SELECT company, SUBSTRING(`date`,1, 4) AS `Date`, SUM(total_laid_off) AS sum FROM layoffs_staging2
GROUP BY company, `Date`
ORDER BY company ASC
)
SELECT *, MAX(sum) OVER () AS MAX FROM tempquery;

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

-- IDEAS TO CONTINUE


-- Try to find top 5 companies with most layoffs by month, and determine which companies occur in the top 5 the most

SELECT SUBSTRING(`date`,1,7), company, total_laid_off FROM layoffs_staging2
ORDER BY 1;

SELECT `date`, company, total_laid_off FROM layoffs_staging2
ORDER BY 1;

WITH MonthlyLaidOff AS
(
SELECT SUBSTRING(`date`,1,7) AS YearMonth, company, industry, total_laid_off FROM layoffs_staging2
ORDER BY YearMonth
), MonthlyRanking AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY YearMonth ORDER BY total_laid_off DESC) AS Ranking FROM MonthlyLaidOff
)
SELECT * FROM MonthlyRanking
WHERE YearMonth IS NOT NULL AND Ranking <= 5;

-- Companies sometimes have layoffs multiple times in the same month (Uber 2020-05 for example), let's try to merge these into a total for the month


SELECT SUBSTRING(`date`,1,7) AS YearMonth, company, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY YearMonth, company
ORDER BY YearMonth;

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

-- We now have a top 5 ranking of total layoffs in each month, time to find out which companies appear in the top 5 the most

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