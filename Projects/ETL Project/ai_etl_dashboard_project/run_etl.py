from etl.extract import extract_data
from etl.transform import transform_data
from etl.load_mysql import load_data_to_mysql

data = extract_data('data/sales_data.csv')
print("✅ Data extracted successfully")

df = transform_data(data)
if df is None:
    print("❌ Transformation failed")
    exit()
print("✅ Data transformed successfully")

# ✅ Define DB config here
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'JamilHussain1',
    'database': 'sales_data'
}

# ✅ Load to MySQL
load_data_to_mysql(
    df,
    host=db_config['host'],
    user=db_config['user'],
    password=db_config['password'],
    database=db_config['database'],
    table_name='sales_table'
)


