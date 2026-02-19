# 📊 End-to-End Data Analysis: Customer Satisfaction (CSAT/DSAT)

This repository contains a comprehensive analysis of customer support performance, integrating **SQL**, **Python**, and **Tableau** to identify drivers of customer dissatisfaction.

## 📂 Project Structure
1. **[SQL Analysis](CSAT_Analysis_Project.sql)**: Data cleaning, relational modeling, and agent benchmarking using Window Functions.
2. **[Python Deep Dive](CSAT_Deep_Dive_Analysis.ipynb)**: Statistical validation (T-Tests) confirming the impact of phone calls on DSAT, regardless of resolution time.
3. **[Interactive Dashboard](https://public.tableau.com/views/CustomerExperienceStrategyDashboard/CustomerSupportPerformanceSentimentAnalysis?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)**: Visual storytelling of CX metrics and operational friction points.

## 💡 Key Findings
* **The Communication Paradox**: While resolution time remained constant (~14.5h), proactive phone calls reduced DSAT by **10.4%**.
* **Statistical Significance**: Python analysis confirmed a p-value < 0.05, proving the "Human Touch" is a primary driver of satisfaction.
