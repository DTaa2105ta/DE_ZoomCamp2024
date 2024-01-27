#!/usr/bin/env python
# coding: utf-8
import os
import pandas as pd
from sqlalchemy import create_engine

#url = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"
'''
This Python script is designed to create a main function that can be executed in a Bash environment. 
The script prompts the user for input, allowing them to efficiently ingest data into a PostgreSQL database.
'''

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url

    csv_name = "output.csv"

    # download the csv
    os.system(f"wget {url} -O {csv_name}")
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
    #engine.connect()
    df = pd.read_csv(url, nrows=1)
    df_iter = pd.read_csv(url, iterator=True, chunksize=100000, low_memory=False)
    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')
    
    from time import time

    for df in df_iter:
        t_start = time()
        df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
        df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

        df.to_sql(name=table_name, con=engine, if_exists='append')
        t_end = time()
        print("Inserted another chunk..., took %.3f second" % (t_end - t_start))


import argparse
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='ingest CSV data to Postgres')

    parser.add_argument('--user', help="user name for postgres") #help: Help message for an argument
    parser.add_argument('--password', help="password for postgres")
    parser.add_argument('--host', help="host for postgres")
    parser.add_argument('--port', help="port for postgres")
    parser.add_argument('--db', help="databae name for postgres")
    parser.add_argument('--table_name', help="name of the table where we will write the result to")
    parser.add_argument('--url', help="url of the csv file")

    args = parser.parse_args()

    main(args)
