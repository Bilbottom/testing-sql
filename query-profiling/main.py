"""
Time the queries in the ``queries`` directory.
"""
import sqlite3

import db_query_profiler


def main() -> None:
    """Time the queries in the ``queries`` directory."""
    db_query_profiler.time_queries(
        conn=sqlite3.connect('../db-creation/customer-db/customer.db'),
        repeat=10_000,
        directory="queries",
    )


if __name__ == '__main__':
    main()
