import pandas as pd
import mysql.connector

conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='JamilHussain1',
    database='sales_data'
)

df = pd.read_sql("SELECT * FROM sales_table", conn)
df.to_csv("sales_data.csv", index=False)
