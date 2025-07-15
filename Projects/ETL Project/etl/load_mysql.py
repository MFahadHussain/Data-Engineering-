import mysql.connector

# Connect to MySQL
conn = mysql.connector.connect(
    host="localhost",
    user="your_username",
    password="your_password",
    database="sales_data"
)

# Create a cursor
cursor = conn.cursor()

# Execute SQL
cursor.execute("""
    CREATE TABLE IF NOT EXISTS sales (
        Date DATE,
        Product VARCHAR(10),
        Quantity INT,
        Price FLOAT,
        TotalAmount FLOAT
    )
""")

# Insert one row (example)
cursor.execute("""
    INSERT INTO sales (Date, Product, Quantity, Price, TotalAmount)
    VALUES (%s, %s, %s, %s, %s)
""", ('2024-05-01', 'A', 2, 300, 600))

# Commit changes
conn.commit()

# Close cursor and connection
cursor.close()
conn.close()
