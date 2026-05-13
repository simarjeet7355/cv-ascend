"""Sales EDA + naive forecast → eda_forecast.pdf"""
import sys, pandas as pd, numpy as np, matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
src = sys.argv[1] if len(sys.argv)>1 else "../data/sales_transactions.csv"
df = pd.read_csv(src, parse_dates=["Date"])
m = df.groupby(df.Date.dt.to_period("M")).agg(Revenue=("Revenue","sum"), Profit=("Profit","sum"))
m.index = m.index.to_timestamp()
m["MA3"] = m.Revenue.rolling(3).mean()
# 6-month forecast: linear trend on last 12 months
last = m.tail(12).reset_index(drop=True)
slope, intercept = np.polyfit(last.index, last.Revenue, 1)
fc_idx = pd.date_range(m.index[-1] + pd.offsets.MonthBegin(), periods=6, freq="MS")
fc = pd.Series([intercept + slope*(len(last)+i) for i in range(6)], index=fc_idx)
with PdfPages("eda_forecast.pdf") as pdf:
    fig,ax=plt.subplots(figsize=(9,4.5))
    ax.plot(m.index, m.Revenue, label="Revenue"); ax.plot(m.index, m.MA3, label="3M MA")
    ax.plot(fc.index, fc.values, "--", label="Forecast (6M)")
    ax.set_title("Monthly Revenue + Forecast"); ax.legend(); plt.tight_layout(); pdf.savefig(fig); plt.close(fig)
    for col in ["Region","Channel","Category","Segment"]:
        g = df.groupby(col).Revenue.sum().sort_values(ascending=False)
        fig,ax=plt.subplots(figsize=(8,4.5))
        ax.bar(g.index.astype(str), g.values, color="#1F77B4")
        ax.set_title(f"Revenue by {col}"); plt.xticks(rotation=20); plt.tight_layout(); pdf.savefig(fig); plt.close(fig)
print("wrote eda_forecast.pdf")
