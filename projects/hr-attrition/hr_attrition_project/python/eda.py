"""HR Attrition EDA — generates eda_charts.pdf
Usage: python eda.py ../data/hr_employees.csv
"""
import sys, pandas as pd, matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

src = sys.argv[1] if len(sys.argv)>1 else "../data/hr_employees.csv"
df = pd.read_csv(src)
print("Rows:", len(df), "Attrition rate %:", round((df.Attrition=="Yes").mean()*100,2))

def rate(col):
    return df.groupby(col).Attrition.apply(lambda s:(s=="Yes").mean()*100).sort_values(ascending=False)

with PdfPages("eda_charts.pdf") as pdf:
    for col in ["Department","JobRole","OverTime","WorkLifeBalance","JobSatisfaction"]:
        g = rate(col)
        fig, ax = plt.subplots(figsize=(8,4.5))
        ax.bar(g.index.astype(str), g.values, color="#2E75B6")
        ax.set_title(f"Attrition Rate by {col}"); ax.set_ylabel("%")
        plt.xticks(rotation=30); plt.tight_layout(); pdf.savefig(fig); plt.close(fig)
print("wrote eda_charts.pdf")
