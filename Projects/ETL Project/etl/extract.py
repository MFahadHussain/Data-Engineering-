# etl/extract.py

import pandas as pd

def extract_data(file_path):
    try:
        df = pd.read_csv(file_path)
        print("✅ Data extracted successfully")
        return df
    except Exception as e:
        print("❌ Error during extraction:", e)
        return None
