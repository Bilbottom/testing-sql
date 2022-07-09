"""
Reading webpages into DB from:
    * https://www.w3resource.com/sql-exercises/soccer-database-exercise/index.php

Note that this has to be done in stages -- that is, the `push_to_db` can't be run until the DDL has been written
and executed to create the DB.
"""
import warnings
import sqlite3
import json

import requests
import pandas as pd


def download_page_data(table_name: str, webpage_url: str):
    """
    Navigate to webpage_url, download its HTML, parse into a DataFrame, then save as a CSV.
        * https://stackoverflow.com/a/43590290/8213085
    """
    response = requests.get(webpage_url)
    if response.status_code != 200:
        warnings.warn('Unexpected HTTP response code')

    parsed_df = pd.read_html(response.text)
    if len(parsed_df) != 1:
        warnings.warn('Multiple DataFrames have been parsed where only 1 is expected')

    parsed_df[0].to_csv(f'data\\{table_name}.csv', index=False)


def generate_ddl_naive(table_name: str):
    """
    Read the CSVs and print some simple DDL to the console for creating the DB.
    Note that this still need to be tidied later by updating data types and adding key constraints.
    """
    data = pd.read_csv(f'data\\{table_name}.csv')
    print(f'\nDROP TABLE IF EXISTS {table_name};\nCREATE TABLE {table_name}(')
    for col in data.columns:
        print(f'    {col} INTEGER,')
    print(') --STRICT\n;')


def push_to_db(table_name: str, conn: sqlite3.Connection):
    """
    Read the CSVs and push to the DB.
    """
    data = pd.read_csv(f'data\\{table_name}.csv')
    cur = conn.cursor()

    cur.execute(f'DELETE FROM {table_name} WHERE True')  # Bad idea, but can't get normal parametrisation to work
    data.to_sql(table_name, conn, if_exists='append', index=False)


if __name__ == '__main__':
    con = sqlite3.connect('football.db')
    with open('data/links.json', 'r') as f:
        links = json.loads(f.read())

    con.execute('PRAGMA FOREIGN_KEYS = ON')
    for key in links:
        # download_page_data(table_name=key, webpage_url=links[key])
        generate_ddl_naive(table_name=key)
        # push_to_db(table_name=key, conn=con)
