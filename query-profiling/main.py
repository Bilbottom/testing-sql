"""
Time the queries in the `queries` directory.
"""
from database_connector import DatabaseConnector
from query_timer import time_queries


def main() -> None:
    """Entry point."""
    db_conn = DatabaseConnector('../db-creation/customer-db/customer.db')
    time_queries(repeat=10000, conn=db_conn)


if __name__ == '__main__':
    main()
