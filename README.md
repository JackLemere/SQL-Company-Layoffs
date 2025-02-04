# Worldwide Company Layoffs Analysis

## Description

This project aims to seek insights into data involving employee layoffs of approximately 1600 different companies from various countries around the world from March 2020-March 2023 (notably a time period where companies were most affected by COVID-19). SQL is used to clean the data as well as for performing exploratory data analysis. The goal of the analysis 
was to uncover any potential patterns or areas of interest in the companies that were laying off employees, particularly at the maximums where companies saw the highest number of layoffs compared to other companies. Analysis was also performed
on the dates of when employees were laid off, as well as what industry sectors these companies belonged to. The main questions sought to answer were:

- Which companies laid off the most of their employees?
- What regions in the world saw the most layoffs?
- Which industry sectors saw the most layoffs?
- At what times were there a lot of layoffs?

## Results

In this dataset, there were a total of 383,320 layoffs from 1628 different companies: all differing in size, industry, and country of operations. The first part of the EDA was to determine which companies saw 100% of their employees be laid off. There were many companies in this dataset that appeared to "go under", though it was determined that the construction company Katerra was the largest company (measured by number of employees laid off) to layoff 100% of it's 2,434 employees. In terms of sheer total employees laid off though, it was Amazon who saw the most with a total of 18,150 employees laid off: 51% higher than 2nd place Google.

Next was to determine which parts of the world saw the highest number of layoffs. In this dataset, the United States saw the largest number of layoffs by far with 256,420 total, followed by India with just 35,793 in comparison. When zooming in on which cities saw the most layoffs, it was found that the San Fransisco Bay Area saw the highest with 125,551 layoffs. New York City and Seattle rounded out the top 3 with 34,743 and 29,364 layoffs respectively. Bengaluru was 4th with 21,587 making it the city with the
largest number of layoffs outside the USA. The USA was also highest in total number of companies to go under (laying off all employees) with 72 total. Second by this metric was India with 9. In terms of percentage laid off, the United States ranked only 24th out of the 51 countries in the dataset with an average of approximately 25% of employees being laid off per layoff period. The highest by this metric was Vietnam with 83%, though when looking at countries with a minimum of 10 layoff periods the highest becomes Australia with 38.5% and the lowest being Sweden with 15%.

When looking at which industries were most affected, it was found that the top two sectors for most layoffs were Consumer and Retail with 45,182 and 43,613 respectively. Manufacturing saw the least number of layoffs with 20. The top 3 industries by total number of companies to go under or layoff all their employees were companies in Retail, Food, and Finance. Retail and Food both saw 13 companies go out of business during this time, while Finance saw 12.

Finally, when looking at when the most layoffs occurred, the year 2022 saw the highest number of layoffs, though when looking deeper on a month-by-month basis January 2023 saw the highest number of layoffs with a total of 84,514. November 2022 and February 2023 round out the top 3 with 53,392 and 36,493 total layoffs worldwide respectively.

## Conclusions

The goal of this project was primarily to clean and analyse this dataset in order to gather some metrics and answer questions regarding the data. Though it is outside the scope of this project, it can be fun to speculate why certain trends emerge from the analysis. When doing so for this dataset, it is important to consider that there can be a number of reasons why a company may need to layoff employees. It is possible that a company may have simply been outcompeted, suffered from poorly managed finances, legal issues, or a number of other possibilities. Though each company is unique in this regard, we do see some patterns emerge from the results which can provide us with a number of predictors as to what is happening in each of these company's industries.

For starters, the timespan of this data spans the majority of the COVID-19 pandemic. One insight we saw was that two of the top 3 industries to go under during this time belonged to Retail and Food. These are sectors that often rely heavily on face-to-face customer interaction, which would have been greatly impeded during the pandemic. To further analyse this possibility, it would perhaps be important to obtain additional data on different ways industries and companies were impacted by the pandemic specifically. The time periods may also have significance when relating company layoffs to the pandemic. For example, different companies may have experienced more layoffs depending on when lockdown periods were in place, or when COVID-19 cases were peaking in their respective countries. Comparing the time series data here with that of COVID-19 cases would certainly be interesting to examine further.

By looking at location data as well, it may be the case that companies in different countries were able to deal with COVID-19 setbacks better depending on the nation's policies, geography, or infrastructure. This on its own could be a whole separate project, examining data on how companies in specific countries were able to handle the effects of the pandemic and ensure stability over this time period. What was found was that the United States had the largest number of layoffs, though it is important to note that the United States had by far the highest number of reported layoffs in this dataset. This could be due to a variety of factors including the sheer number of large companies that exist in the USA, as well as the differences in the reporting of mass layoffs between various countries. Looking at percentage data helped to overcome this discrepancy, though many countries had very few reported layoffs in this dataset which means making conclusions on this metric less reliable. Still, it revealed some insights including that the United States was not nearly as high in terms of the percentage of company employees being laid off. Differences in this metric may include differences in each countries' lockdown procedures, or perhaps how different countries are affected by supply chain issues.

Although the hypotheses mentioned are merely speculative, the analysis done in this project can serve not only as a base for exploring the data, but also as a way to help generate more questions based on the insights gathered. A number of key questions were answered, though if one wanted to further enrich this project, there are certainly a number of ways this analysis could be explored further and help to answer more specific questions for real-world problems. 

## Credits
The SQL queries in this project were implemented using MySQL Workbench.

This project was completed as part of the Alex the Analyst Data Analyst Bootcamp from which the data was sourced.
