
import pandas as pd
from sqlalchemy import create_engine

#to connect python to mssql to establish connections to ms sql server
conn_string = 'mssql://BHUVI-HP\SQLEXPRESS/Bhuvi_Portfolio?driver=ODBC+DRIVER+17+FOR+SQL+SERVER'
db = create_engine(conn_string)
conn = db.connect()

# we can load the data one by one for each file into db or we can loop through the statements for creating all files
#method - 1 
files =['artist','canvas_size','image_link','museum_hours', 'museum','product_size','subject','work']

for file in files:
    df = pd.read_csv(f'C:/Bhuvi/Portfolio_Projects/SQL Project/artist_dataset_kaggle/{file}.csv')
    df.to_sql(file, con= conn, if_exists = 'replace', index= False)

#load the data from excel 
# method 2 
# df = pd.read_csv('C:/Bhuvi/Portfolio_Projects/SQL Project/artist_dataset_kaggle/artist.csv')
# df.to_sql('artist', con= conn, if_exists = 'replace', index= False)
