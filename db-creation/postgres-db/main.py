"""
https://datasets.imdbws.com/
"""
import os
import re
import csv

import pandas as pd
import sqlalchemy
import psycopg2
from psycopg2 import extensions as ext
from dotenv import load_dotenv


class DbConnector:
    """Connector for PostgreSQL database."""
    def __init__(self, database: str = None, connect_on_init: bool = True):
        load_dotenv()
        self._username = os.environ['USER']
        self._password = os.environ['PASSWORD']
        self._connection: psycopg2.connection | None = None
        self.database: str = database or 'postgres'

        if connect_on_init:
            self.connect_to_db()

    def connect_to_db(self) -> None:
        self._connection = psycopg2.connect(
            host='localhost',
            user=self._username,
            password=self._password,
            database=self.database
        )

    @property
    def connection(self) -> ext.connection:
        return self._connection

    @property
    def engine(self) -> sqlalchemy.engine.Engine:
        """Return the SQLAlchemy engine for the user credentials and database."""
        return sqlalchemy.create_engine(
            f'postgresql+psycopg2://{self._username}:{self._password}@localhost/{self.database}'
        )

    def cursor(self) -> ext.cursor:
        return self.connection.cursor()


def camel_to_snake(camel_case_text: str) -> str:
    """Convert all camelCase words into snake_case words for the given string.

    https://stackoverflow.com/a/1176023/8213085
    """
    return re.sub(r'(?<!^)(?=[A-Z])', '_', camel_case_text).lower()


def filepath_to_table(filepath: str) -> str:
    """Convert a filepath into a table name by keeping only the filename and removing the extension."""
    return '_'.join(filepath.split('/')[-1].split('.')[:-1])


def read_tsv(filepath: str) -> pd.DataFrame:
    """Read in a tab-separated file and reformat into a tidied dataframe."""
    return (
        pd.read_csv(
            filepath,
            # nrows=1000,
            # na_values='\\N',
            quoting=csv.QUOTE_NONE,
            delimiter='\t',
            low_memory=False
        ).rename(
            columns=camel_to_snake
        ).replace(['"'], '')
    )


def push_dataframe(connection: ext.connection, dataframe: pd.DataFrame, table_name: str) -> None:
    """Push the dataframe to the database using a bulk insert.

    https://naysan.ca/2020/05/09/pandas-to-postgresql-using-psycopg2-bulk-insert-performance-benchmark/
    """
    tmp_df = f'./{table_name}.csv'
    dataframe.to_csv(tmp_df, index=False, header=False, sep='\t')
    with open(tmp_df, 'r', encoding='utf-8') as f:
        with connection.cursor() as cursor:
            try:
                cursor.copy_from(f, table_name, sep='\t')
                connection.commit()
            except (Exception, psycopg2.DatabaseError) as error:
                print(f'Error: {error}')
                connection.rollback()
    os.remove(tmp_df)


def read_and_push(filepath: str, connection: ext.connection):
    """Read in a file, reformat the contents, and push to the database."""
    push_dataframe(
        connection=connection,
        dataframe=read_tsv(filepath),
        table_name='raw_' + filepath_to_table(filepath)
    )


def main():
    filepaths = [
        'data/name.basics.tsv',
        'data/title.akas.tsv',
        'data/title.basics.tsv',
        'data/title.crew.tsv',
        'data/title.episode.tsv',
        'data/title.principals.tsv',
        'data/title.ratings.tsv'
    ]
    conn = DbConnector()
    for fpath in filepaths:
        read_and_push(filepath=fpath, connection=conn.connection)


if __name__ == '__main__':
    main()
