from etl.extract import extract_data

df = extract_data("data/sales_data.csv")
print(df.head())
