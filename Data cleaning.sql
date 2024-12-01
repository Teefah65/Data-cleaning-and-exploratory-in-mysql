-- DATA CLEANING
# WHAT IS DATA CLEANING IT IS WHERE YOU GET YOUR DATA IN A MORE USABLE FORMAT, SO YPU FIX ISSUES IN THE RAW DATA WHEN YOU START CREATING VISUALIZATION OR WHEN YOU START USING IT IN YOUR PRODUCTS THAT THE DATA IS ACTUALLY USEFUL WITHOUT A LOT OF ISSUE

SELECT *
FROM layoffs;

-- REMOVE DUPLICATES
-- STANDARDIZED THE DATA
-- NULL VALUES OR BLANK VALUES
-- REMOVING Any COLUMNS

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `layoffs_staging2` (
`company` text,
`location` text,
`industry` text,
`total_laid_off` int DEFAULT NULL,
`percentage_laid-off` text,
`date` text,
`stage` text,
`country` text,
`funds_raised_millions` int DEFAULT NULL,
`row_num` INT
)ENGINE=InnoDB DEFAULT CHARSET =utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;
 
 
 
 -- STANDARDIZING DATA = FINDING ISSUES IN DATA AMD FIXING IT.
 
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2;  

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%' ;

SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
 
 UPDATE layoffs_staging2
 SET industry = NULL 
 WHERE industry = '';
 
 
SELECT DISTINCT industry
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '' ;

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb' ;

SELECT t1.industry, t2.industry
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


SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

 
