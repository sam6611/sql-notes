Perfect thinking 👍  
You’ve reached the **MOST IMPORTANT EXAM + PRACTICAL decision layer**:

> **“I know algorithms. Now tell me WHEN to use WHICH METRIC and WHICH ENCODING.”**

Below is a **MASTER TABLE** you can revise before exams, viva, or coding.

---

# 🧠 MASTER DECISION TABLE

## **Algorithm × Task × Metrics × Encoding**

---

## 🔹 1️⃣ REGRESSION ALGORITHMS

| Algorithm                  | Problem Type | Target Type | Metrics to Use     | Metrics ❌ NOT to Use        | Encoding to Use         | Scaling     |
| -------------------------- | ------------ | ----------- | ------------------ | --------------------------- | ----------------------- | ----------- |
| Simple Linear Regression   | Regression   | Continuous  | MAE, MSE, RMSE, R² | Accuracy, Precision, Recall | One-Hot (categorical X) | Optional    |
| Multiple Linear Regression | Regression   | Continuous  | MAE, MSE, RMSE, R² | Accuracy, Confusion Matrix  | One-Hot                 | Recommended |
| Polynomial Regression      | Regression   | Continuous  | MAE, RMSE, R²      | Accuracy                    | One-Hot                 | Recommended |
| Linear Regression (OLS)    | Regression   | Continuous  | RMSE, R²           | Accuracy                    | One-Hot                 | Optional    |

📌 **Golden rule**

> Regression → **NEVER use Accuracy / Confusion Matrix**

---

## 🔹 2️⃣ CLASSIFICATION ALGORITHMS (PROBABILITY / LINEAR)

| Algorithm           | Classification Type | Metrics to Use                                     | When to Prefer Which Metric | Encoding               | Scaling     |
| ------------------- | ------------------- | -------------------------------------------------- | --------------------------- | ---------------------- | ----------- |
| Logistic Regression | Binary              | Accuracy, Precision, Recall, F1, ROC-AUC, Log Loss | Imbalanced → F1 / Recall    | One-Hot                | Required    |
| Naïve Bayes         | Binary / Multi      | Accuracy, Precision, Recall, F1                    | Text → Precision            | Label / Count / TF-IDF | ❌ No        |
| SVM                 | Binary / Multi      | Accuracy, F1, ROC-AUC                              | Small data → F1             | One-Hot                | ✅ Mandatory |

📌 **Golden rule**

> Classification → Accuracy alone is **NOT enough** for imbalanced data

---

## 🔹 3️⃣ TREE-BASED ALGORITHMS

| Algorithm                  | Task           | Metrics                         | Encoding        | Scaling |
| -------------------------- | -------------- | ------------------------------- | --------------- | ------- |
| Decision Tree (Classifier) | Classification | Accuracy, Precision, Recall, F1 | Label / One-Hot | ❌ No    |
| Decision Tree (Regressor)  | Regression     | MAE, RMSE, R²                   | Label / One-Hot | ❌ No    |
| Random Forest              | Both           | Same as DT                      | Label / One-Hot | ❌ No    |

📌 **Golden rule**

> Tree-based models **DO NOT need scaling**

---

## 🔹 4️⃣ DISTANCE-BASED ALGORITHMS (VERY IMPORTANT)

| Algorithm      | Task           | Metrics                        | Encoding | Scaling     |
| -------------- | -------------- | ------------------------------ | -------- | ----------- |
| KNN Classifier | Classification | Accuracy, F1, Confusion Matrix | One-Hot  | ✅ MANDATORY |
| KNN Regressor  | Regression     | MAE, RMSE                      | One-Hot  | ✅ MANDATORY |
|                |                |                                |          |             |

📌 **Golden rule**

> Distance-based → **Scaling is compulsory**

---

## 🔹 5️⃣ NEURAL NETWORKS (MLP / DL)

|Algorithm|Task|Metrics|Encoding|Scaling|
|---|---|---|---|---|
|MLP Classifier|Classification|Accuracy, F1, ROC-AUC, Log Loss|One-Hot|✅ Mandatory|
|MLP Regressor|Regression|MAE, RMSE, R²|One-Hot|✅ Mandatory|

📌 **Golden rule**

> Neural networks **hate unscaled data**

---

# 🧠 METRIC SELECTION TABLE (MOST SCORING)

| Situation          | Use This Metric |
| ------------------ | --------------- |
| Balanced classes   | Accuracy        |
| Imbalanced classes | F1-score        |
| Medical diagnosis  | Recall          |
| Spam / Fraud       | Precision       |
| Probability output | Log Loss        |
| Regression error   | RMSE            |
| Model explanation  | R²              |
| Model comparison   | ROC-AUC         |

---

# 🧠 ENCODING SELECTION TABLE (EXAM FAVORITE)

| Feature Type              | Encoding to Use  | Why                 |
| ------------------------- | ---------------- | ------------------- |
| Nominal (Gender, City)    | One-Hot          | No order            |
| Ordinal (Low/Medium/High) | Label Encoding   | Order exists        |
| Tree-based model          | Label or One-Hot | Tree handles splits |
| Linear / Distance-based   | One-Hot          | Avoid fake order    |
| Text data                 | Count / TF-IDF   | Frequency-based     |

📌 **Never use LabelEncoder for nominal data in regression**

---

# 🧠 ONE-LINE DECISION RULES (MEMORIZE THESE)

- **Regression → MAE, RMSE, R²**
    
- **Classification → Accuracy + F1**
    
- **Imbalanced data → Never trust accuracy**
    
- **KNN / SVM / MLP → Always scale**
    
- **Trees → Never scale**
    
- **Nominal data → One-Hot**
    
- **Ordinal data → LabelEncoder**
    

---

# 🎓 EXAM READY ANSWER (IF PROF ASKS)

> “Metric selection depends on the task. Regression models are evaluated using error-based metrics like MAE, RMSE, and R², while classification models use accuracy, precision, recall, and F1-score. Encoding depends on feature type—one-hot encoding for nominal variables and label encoding for ordinal variables.”

---
