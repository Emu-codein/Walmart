#Python

import psycopg2
import pandas as pd
from sqlalchemy import create_engine, text
from sqlalchemy.types import String, Numeric, Integer, Float, Date, DateTime
# Define the database connection parameters
db_params = {
    'host': 'localhost',
    'database': 'aymanahmed',
    'user': 'aymanahmed',
    'password': 'admin'
}
# Create a connection to the PostgreSQL server
conn = psycopg2.connect(
    host=db_params['host'],
    database=db_params['database'],
    user=db_params['user'],
    password=db_params['password']
)

# Create a cursor object
cur = conn.cursor()

# Set automatic commit to be true, so that each action is committed without having to call conn.committ() after each command
conn.set_session(autocommit=True)

# Create the 'soccer' database
cur.execute("CREATE DATABASE walmart")

# Commit the changes and close the connection to the default database
conn.commit()
cur.close()
conn.close()
# Connect to the 'famouspainting' database
db_params['database'] = 'walmart'
engine = create_engine(f'postgresql://{db_params["user"]}:{db_params["password"]}@{db_params["host"]}/{db_params["database"]}')

df =pd.read_csv('/Users/aymanahmed/Documents/Data Science Projects/SQL/Walmart/WalmartSalesData.csv')
print(df.isnull().sum())
# Specifying SQLAlchemy types
dtype = {
    'invoice_id': String(30),
    'branch': String(5),
    'city': String(30),
    'customer_type': String(30),
    'gender': String(10),
    'product_line': String(100),
    'unit_price': Numeric(10, 2),
    'quantity': Integer(),
    'VAT': Float(6, 4),
    'total': Numeric(10, 2),
    'date': Date(),
    'time': DateTime(),
    'payment_method': Numeric(10, 2),
    'cogs': Numeric(10, 2),
    'gross_margin_percentage': Float(11, 9),
    'gross_income': Numeric(10, 2),
    'rating': Float(2, 1)
}
# Loop through the CSV files and import them into PostgreSQL
for table_name, file_path in csv_files.items():
    df = pd.read_csv(file_path)
    df.to_sql(table_name, engine, if_exists='replace', index=False, dtype=dtype)
# Import data to the SQL database
df.to_sql('sales_data', con=engine, if_exists='append', index=False, dtype=dtype)
