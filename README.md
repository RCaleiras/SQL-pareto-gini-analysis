# Customer Revenue Analysis: Pareto Principle & Gini Coefficient

## Project Overview
This project analyzes customer spending behavior using a **Pet Shop E-commerce dataset**. The goal is to identify the level of revenue concentration using the **Pareto Principle (80/20 Rule)** and the **Gini Coefficient** to assess business risk and stability.

### Key Findings
Running this analysis on the provided dataset reveals a **diversified revenue model**:
* **The 80% Threshold:** Reached by **57.47%** of the customer base (150 customers).
* **Gini Coefficient:** Low (approx. 0.3), indicating that the business is not overly dependent on a few "whale" customers.
* **Strategic Insight:** High stability. Marketing efforts should focus on broad-base retention rather than just a tiny VIP segment.



<img width="829" height="512" alt="Pareto Analysis" src="https://github.com/user-attachments/assets/a1935442-0648-4e53-9b3f-0d8adc28d8eb" />



---

## Technical Stack & Skills
* **SQL Dialect:** Google BigQuery (Standard SQL).
* **Advanced Logic:** * **Window Functions:** Cumulative sums and rankings.
    * **CTEs:** Modular code structure for readability.
    * **Econometrics:** Implementing the Gini Index in SQL to measure inequality.

---

## Repository Structure
* `/sql`: Main analysis script with detailed comments.
* `/pet_shop_sales.csv`: e-commerce sales dataset.
* `README.md`: Project documentation and business insights.

---

## The Methodology
The script follows a 5-stage pipeline:
1. **Cleaning:** Removing null IDs and invalid transactions.
2. **Aggregation:** Calculating Lifetime Value (LTV) per customer.
3. **Windowing:** Computing the running total of revenue.
4. **Economic Score:** Calculating the **Gini Coefficient** using the Lorenz Curve logic.
5. **Insights:** Filtering the data to find the exact "tipping point" where revenue concentration meets the 80% target.

---

## How to Reproduce
1. Clone this repository.
2. Upload the `pet_shop_sales.csv` to your SQL environment (BigQuery recommended).
3. Run the script found in `sql/pareto_analysis.sql`.
4. Adjust the `target_sales_pct` variable to test different business scenarios (70%, 80%, 90%).

---

## Author
**Rui Caleiras**
* [LinkedIn](www.linkedin.com/in/rui-caleiras-bb5740370)
