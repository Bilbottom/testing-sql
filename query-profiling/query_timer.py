import sqlite3
from timeit import timeit
from functools import partial


class DbConnection:
    """Implements the `execute_file` method on a SQLite3 connection."""
    def __init__(self, database: str):
        self.connection = sqlite3.connect(database)

    def execute_file(self, filepath: str) -> sqlite3.Cursor:
        """Open a file and execute the query inside it."""
        with open(filepath, 'r') as f:
            return self.connection.execute(f.read())


def run_query_1(conn: DbConnection):
    conn.execute_file('queries/query-1.sql')


def run_query_2(conn: DbConnection):
    conn.execute_file('queries/query-2.sql')


def time_queries(repeat: int):
    db_conn = DbConnection('../db-creation/customer-db/customer.db')

    # Set the 'temp' tables
    run_query_1(conn=db_conn)
    run_query_2(conn=db_conn)

    # Query stats
    query_1_avg_time = timeit(partial(run_query_1, db_conn), number=repeat) / repeat
    query_2_avg_time = timeit(partial(run_query_2, db_conn), number=repeat) / repeat
    total_avg_time = query_1_avg_time + query_2_avg_time

    print(f'Query 1: {query_1_avg_time:.8f} ({query_1_avg_time/total_avg_time:.1%})', )
    print(f'Query 2: {query_2_avg_time:.8f} ({query_2_avg_time/total_avg_time:.1%})', )
