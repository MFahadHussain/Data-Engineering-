# etl/transform.py

import pandas as pd

def transform_data(df):
    try:
        # Convert 'Date' to datetime
       
        df['Date'] = pd.to_datetime(df['Date'])  # convert to datetime
        df['Date'] = df['Date'].dt.strftime('%Y-%m-%d')  # now apply the formatting


        # Remove rows with missing values
        df = df.dropna()

        # Add a new column: TotalAmount = Quantity × Price
        df['TotalAmount'] = df['Quantity'] * df['Price']

        print("✅ Data transformed successfully")
        return df
    except Exception as e:
        print("❌ Error during transformation:", e)
        return None


