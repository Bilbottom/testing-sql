"""
Reading Metabase's sample database:
    * https://www.metabase.com/glossary/sample_database
"""
from os import listdir
import sqlite3

import pandas as pd


def push_to_db(table_name: str, conn: sqlite3.Connection):
    """Read the CSVs and push to the DB."""
    cur = conn.cursor()
    data = (
        pd.read_excel(f'data\\{table_name}.xlsx', 'Query result')
          .rename(columns=lambda s: s.lower().replace(' ', '_'))
    )

    cur.execute(f'DELETE FROM {table_name} WHERE True')  # Bad idea, but can't get normal parametrisation to work
    data.to_sql(table_name, conn, if_exists='append', index=False)


if __name__ == '__main__':
    con = sqlite3.connect('metabase.db')
    # con.execute('PRAGMA FOREIGN_KEYS = ON')
    for file in listdir('data'):
        push_to_db(table_name=file.split(sep='.')[0], conn=con)
