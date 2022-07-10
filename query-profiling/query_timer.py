from timeit import timeit
from functools import partial

from utils import database_connector as dc


def run_original(conn: dc.DatabaseConnector):
    conn.run_query_from_file('queries/Original.sql')


def run_refactor(conn: dc.DatabaseConnector):
    conn.run_query_from_file('queries/Refactor.sql')


def time_refactor_queries(repeat: int):
    """How do we get around SQL storing temp tables?"""
    db_conn = dc.DatabaseConnector(config_filepath='config-prod.yaml')

    """Set the 'temp' tables"""
    run_original(db_conn)
    run_refactor(db_conn)

    print('Original:', timeit(partial(run_original, db_conn), number=repeat))
    print('Refactor:', timeit(partial(run_refactor, db_conn), number=repeat))


def run_normal(conn: dc.DatabaseConnector):
    conn.run_query_from_file('indexes/Normal Tables/CM - Repayment Schedule - Live Loans.sql')


def run_indexed(conn: dc.DatabaseConnector):
    conn.run_query_from_file('indexes/Indexed Tables/CM - Repayment Schedule - Live Loans.sql')


def time_reindex_queries(repeat: int):
    db_conn = dc.DatabaseConnector(config_filepath='config-nonprod.yaml')

    """Set the 'temp' tables"""
    run_normal(db_conn)
    run_indexed(db_conn)

    print('Normal:', timeit(partial(run_normal, db_conn), number=repeat))
    print('Indexed:', timeit(partial(run_indexed, db_conn), number=repeat))
