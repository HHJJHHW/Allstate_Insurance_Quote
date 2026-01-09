# 🧾 Insurance Pricing & Revenue Optimization (Case Study 2)

This project analyzes **auto insurance pricing** using real-world ALLSTATE-style data, combining **statistical modeling** with **decision-focused analytics** to design an optimal quoting strategy under competition.

---

## 🎯 Problem

* Understand how customer and policy attributes drive insurance costs
* Build a predictive model for insurance quotes
* Design a **pricing strategy** that maximizes **expected revenue** when customers choose the lower quote between us and a competitor

---

## 🛠 Methods

* **Data preparation & feature engineering (R)**

  * Removed ID/time/location variables to avoid leakage
  * Converted categorical variables (e.g., car value, state, risk factor) into factors
  * Explicitly handled missing values by creating NA indicators and meaningful baseline levels

* **Exploratory visualization**

  * Visualized the relationship between **car age and insurance cost** with scatter plots and regression smoothing to validate business intuition

* **Linear regression with interactions**

  * Fit a GLM including **all main effects plus pairwise interactions** among coverage options (A–G)
  * Achieved **R² ≈ 0.48**, showing strong explanatory power for pricing drivers
  * Interpreted marginal effects (e.g., group size ↑ cost, homeowners ↓ cost) from a business-risk perspective

* **Decision-focused pricing via quantile regression**

  * Modeled the **conditional distribution of competitor (ALLSTATE) quotes** using quantile regression
  * Estimated multiple conditional quantiles (τ = 0.10 to 0.90) per customer
  * Converted predictions into **expected revenue = quote × (1 − τ)**
  * Selected the **optimal quote per customer** that maximized expected revenue subject to a price floor

---

## 📈 Main Findings

* Insurance cost **decreases with car age**, consistent with lower repair costs for older vehicles
* Interaction-heavy regression substantially improved fit over simple linear models
* **Quantile regression enabled pricing decisions**, not just prediction, by explicitly modeling competitive uncertainty
* Optimal pricing favored **aggressive quantiles (τ ≈ 0.10)**, balancing higher win probability against per-policy margin
* Demonstrated how **predictive modeling + decision rules** outperform median-based or heuristic pricing

---

## 💡 Key Takeaway

This project shows how analytics can move beyond forecasting to **optimize real business decisions**, translating statistical models into **revenue-maximizing pricing strategies** under competition and uncertainty.

---

## 🔧 Skills Demonstrated

* R (GLM, quantile regression)
* Feature engineering & missing-data handling
* Interaction modeling
* Decision-focused ML / pricing optimization
* Business interpretation of statistical models
