import datetime
import sqlite3
from dataclasses import dataclass
from functools import partial
from timeit import timeit
from os import listdir
from os.path import isfile, join
from typing import Generator, Callable

from tqdm import trange


class DbConnection:
    """Implements the `execute_file` method on a SQLite3 connection."""
    def __init__(self, database: str):
        self.connection = sqlite3.connect(database)

    def execute_file(self, filepath: str) -> sqlite3.Cursor:
        """Open a file and execute the query inside it."""
        with open(filepath, 'r') as f:
            return self.connection.execute(f.read())


def get_query_filepaths(directory: str = 'queries') -> Generator:
    """Generator of query filepaths."""
    # sourcery skip: instance-method-first-arg-name
    for path in listdir(directory):
        full_path = join(directory, path)
        if isfile(full_path):
            yield full_path


@dataclass
class Runner:
    runner: Callable
    filepath: str
    repeat: int = 0
    total_time: float = 0.0

    def __call__(self):
        self.runner()

    @property
    def average_time(self):
        return self.total_time / self.repeat

    @property
    def file(self):
        return self.filepath[1 + self.filepath.rfind('\\'):]


def time_queries(repeat: int):
    db_conn = DbConnection('../db-creation/customer-db/customer.db')
    runners: list[Runner] = [
        Runner(
            runner=partial(db_conn.execute_file, filepath=query_filepath),
            filepath=query_filepath
        ) for query_filepath in get_query_filepaths()
    ]
    print('Start time:', datetime.datetime.now())

    # Set the 'temp' tables
    for runner in runners:
        runner()

    # We want to keep running them 'side-by-side' to account for busy periods in the DB
    for _ in trange(repeat):
        for runner in runners:
            runner.repeat += 1
            runner.total_time += timeit(runner, number=1)

    total_avg_time = sum(runner.average_time for runner in runners)
    for runner in runners:
        print(f'{runner.file}: {runner.average_time:.8f} ({runner.average_time/total_avg_time:.1%})', )

    print('End time:', datetime.datetime.now())
