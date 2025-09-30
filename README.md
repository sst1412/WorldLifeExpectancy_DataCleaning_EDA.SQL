# 🌍 World Life Expectancy — SQL Project   

This project explores **global life expectancy trends (2007–2022)** using **SQL-based data cleaning and exploratory data analysis (EDA)**.  
The workflow demonstrates SQL proficiency in **data quality assurance**, **gap-filling imputation**, and **analytical queries** to uncover relationships between **life expectancy, GDP, health indicators, and development status**.  

---

## 📂 Project Structure  
 
- 📜 **WorldLifeExpectancy_DataCleaning.sql** → SQL scripts for cleaning raw dataset (deduplication, missing value handling, imputation).  
- 📊 **WorldLifeExpectancy_ExploratoryDataAnalysis.sql** → EDA queries analyzing trends, country-level differences, and correlations.  
- 🧾 **Cleaned_Data_WorldLifeExpectancy.csv** → Final, analysis-ready dataset.  

---

## 🗂 Dataset Overview  

- 🔢 **Rows:** ~2,900  
- 📅 **Years:** 2007–2022  
- 📑 **Columns:**  
  - 🌎 `Country`, `Year`, `Status` (Developed/Developing)  
  - ⏳ `Life expectancy`, `Adult Mortality`, `infant deaths`, `BMI`  
  - 💰 `GDP`, 🎓 `Schooling`, 💉 immunization coverage (Polio, Diphtheria, Measles)  
  - 🦠 `HIV/AIDS`, 📉 `thinness`, 💵 `percentage expenditure`, etc.  

---

## 🧹 Data Cleaning in SQL  

Key steps implemented in **`WorldLifeExpectancy_DataCleaning.sql`**:  

### 1️⃣ Remove Duplicates  
- Checked for duplicate rows at `(Country, Year)` level.  
- Used `ROW_NUMBER()` window function to flag duplicates.  
- Deleted all rows where `row_num > 1`.
```sql
DELETE FROM world_life_expectancy
WHERE row_id IN (
  SELECT row_id FROM (
    SELECT row_id,
           ROW_NUMBER() OVER (PARTITION BY Country, Year ORDER BY row_id) AS rn
    FROM world_life_expectancy
  ) t WHERE rn > 1
);

```

### 2️⃣ Handle Missing Status  
- Some countries had missing `Status` (Developed/Developing).  
- Used **self-joins** to backfill missing values from other rows of the same country.  

```sql
UPDATE w1
JOIN w2 ON w1.country = w2.country
SET w1.status = w2.status
WHERE w1.status = '' AND w2.status <> '';

```

3️⃣ Impute Missing Life Expectancy

- Some years had blank Life expectancy values.

- Replaced missing values with the average of the previous and next year for that country.
```sql
UPDATE t1
JOIN t2 ON t1.country=t2.country AND t1.year=t2.year-1
JOIN t3 ON t1.country=t3.country AND t1.year=t3.year+1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1)
WHERE t1.`Life expectancy` = '';
```
### 🔎 Exploratory Data Analysis (EDA) in SQL

Queries in WorldLifeExpectancy_ExploratoryDataAnalysis.sql reveal:

📈 Global trend (2007 → 2022):
Life expectancy rose ~4.8 years (66.8 → 71.6).

🌟 Top improvers by country:

- Haiti: +28.7 years
- Zimbabwe: +22.7 years
- Eritrea: +21.7 years

💰 GDP effect:

- High GDP (≥1500): 74.2 years avg.
- Low GDP (<1500): 64.7 years avg.
- Gap: ~9.5 years

🏷 Status comparison:

- Developed: 79.2 years
- Developing: 66.8 years
- Gap: ~12.4 years

🔗 Correlations:
- BMI ↗ → Life Expectancy (positive, r ≈ 0.51)
- Adult Mortality ↗ → Life Expectancy (negative, r ≈ –0.61)

📊 Key Insights

- 🌍 Global progress: steady improvement in life expectancy worldwide.
- ⚖️ Socioeconomic divide: GDP and development status strongly correlate with longevity.
- 🏥 Public health matters: reducing adult mortality and improving nutrition (BMI) significantly impact outcomes.
- 🚀 Success stories: countries recovering from crises (e.g., Haiti, Zimbabwe) saw dramatic gains.

🛠️ Skills Demonstrated

- 🪟 SQL Window Functions: ROW_NUMBER(), SUM() OVER()
- 🧹 Data Cleaning: deduplication, categorical backfilling, time-series imputation
- 📊 Analytical SQL: cohort comparisons, correlation exploration, bucket analysis
- 🧠 EDA Mindset: translating business/health questions into SQL queries

🚀 How to Reproduce

- ⬇️ Load raw dataset into MySQL (world_life_expectancy).
- 🧹 Run data cleaning SQL → produces cleaned dataset.
- 💾 Export cleaned table → CSV (provided).
- 🔎 Run EDA SQL → generate insights + summary tables.
- 📊 (Optional) Visualize results in Power BI / Tableau.

📌 Future Improvements

- 🔄 Normalize all zeros → NULL for more consistent handling.
- 📈 Add visual dashboards (e.g., GDP vs life expectancy scatter, top-10 country improvements).
- 📉 Test alternative imputation (linear interpolation, regional averages).





