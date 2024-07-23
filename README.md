I got the dataset for this analysis from here:https://www.kaggle.com/datasets/arashnic/the-depression-dataset


The dataset, `scores.csv`, contains the following columns:
- number: Patient identifier
- days: Number of measurement days
- gender: 1 for female, 2 for male
- age: Age in grouped categories
- afftype: 1 for bipolar II, 2 for unipolar depressive, 3 for bipolar I
- melanch: 1 for melancholia, 2 for no melancholia
- inpatient: 1 for inpatient, 2 for outpatient
- edu: Education level grouped by years
- marriage: 1 for married/cohabiting, 2 for single
- work: 1 for working/studying, 2 for unemployed/sick leave/pension
- madrs1: MADRS score at the start of measurement
- madrs2: MADRS score at the end of measurement

The dataset contained both NaN values and empty cells. Additionally, there were nonsensical values that needed to be identified and removed. Control rows had empty columns except for number, days, gender, and age, leading to a split between condition and control groups.

Categorical variables:
- Gender, education, afftype, melancholia, inpatient status, marriage, and work status

Continuous variables:
- Average age, average MADRS score, delta MADRS score, madrs1, and madrs2

There was a discrepancy between the number of days reported in `scores.csv` and the actual days recorded in the `control` and `condition` files. The latter had more days than indicated in the days column of `scores.csv`. The original paper mentioned that only the first n days were selected, but did not explain why. Therefore, I excluded days based on my reasoning.

Observations:
- Data Range: On average, we have around 13 days recorded per individual, but the minimum and maximum days vary between groups. For the depressed group, the range is 5 to 18 days, while for the control group, it is 8 to 20 days.
- Group Size: The control group has 32 individuals, whereas the condition group has 23 individuals. The control group also has more females compared to males, while the condition group has more males.

Actigraph Overview:
- The actigraph measures activity using a piezoelectric accelerometer, recording movements with a sampling frequency of 32Hz. It captures intensity, amount, and duration of movement, with a minimum detectable movement of 0.05g.

Data Analysis:
- Threshold for Data Quality: We observed instances where individuals in both groups had multiple days with no meaningful actigraph recordings. Given that the actigraph is highly sensitive, zero activity for a full day seems unrealistic. Therefore, we set a threshold of 10 activity units per day. Days with average activity below this threshold will be excluded from the analysis.
- Patterns: Heatmaps reveal common patterns such as reduced activity during late night and early morning hours. The control group generally shows higher activity compared to the condition group, with a few exceptions.

Discrepancies and Analysis:
- Activity Levels: There is a noticeable discrepancy in average activity levels between the condition and control groups, with an average difference of approximately 86.48 units. Despite this, the relative variability between groups is similar, with only about a 10% difference.
- Data Collection Duration: Both groups have similar data collection durations, averaging around 16 days for the control group and 15.82 days for the condition group.


Data Preparation and Transformation

Initially, our actigraph data exhibited a zero-inflated distribution, characterised by a high frequency of zero values and significant skewness. To address this, we aggregated the minute-by-minute actigraph measurements into two distinct periods: the first half and the second half of the day. This aggregation helped to normalise the distribution.

Additionally, we applied a square root transformation to the actigraph data to further approximate a normal distribution and reduce heteroscedasticity. This transformation aims to minimise the potential for biassed standard errors, thereby enhancing the reliability of p-values and confidence intervals in our model estimates.

Initial Linear Regression Analysis

We began with a simple linear regression model, including only the variables with complete data for both depressed and control participants. The covariates included were average age, gender, and depression status.

Key Findings:
- All three coefficients (average age, gender, and depression status) were statistically significant.
- Interpretation suggested that:
  - Decreased activity is associated with increased average age.
  - As days progressed, decreased activity was linked to a higher likelihood of being male and higher likelihood of being depressed. 

However, this model is highly likely to be misspecified since it does not take into account the variations within individuals across time.

Linear Mixed-Effects Model

Given the repeated measures nature of our data, a linear mixed-effects model was employed to account for patient-specific variability. We explored scatter plots to assess:
- Differences in baseline activity (random intercepts).
- Variation in activity changes over time (random slopes).

The plots indicated that including both random intercepts and slopes would be optimal. As can be seen, slopes were different at ‘day’ level across individuals.:




Mixed-Effects Model Results:
- Correlation: A negative correlation of -0.74 between random intercepts and slopes suggested that participants with higher baseline activity tended to show smaller changes in activity over time.
- Unexplained Variability: The residual variance remained high (20.36154), indicating that the model’s predictors were insufficient in capturing all the variability.
- Significance:The ‘depressed’ group showed significantly reduced actigraph activity. Additionally, activity decreased with the number of days, but gender and age were not significant predictors in this model.

Further Analysis

Testing revealed both homoscedasticity and normality assumptions were not violated.


 To further refine our analysis, we also focused on a cohort of 23 participants with depression, where all covariates were complete.

Revised Model Findings:
- We switched to a random intercept model with days nested within individuals due to convergence issues with the random intercept-slope model.
- Residual variance was reduced to 13%.
- The effect of the number of days on actigraph activity remained significant, though with a weaker association compared to previous models.
- Participants admitted to the hospital for treatment were less likely to engage in activity compared to those not admitted.

