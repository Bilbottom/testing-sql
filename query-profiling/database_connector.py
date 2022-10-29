"""
Connect to a database with a method to execute SQL files against it.
"""
import sqlite3


class DatabaseConnector:
    """Implements the `execute_file` method on a SQLite3 connection."""
    def __init__(self, database: str):
        self.connection = sqlite3.connect(database)

    def run_query_from_file(self, filepath: str) -> sqlite3.Cursor:
        """Open a file and execute the query inside it."""
        with open(filepath, 'r') as f:
            return self.connection.execute(f.read())
