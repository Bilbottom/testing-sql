"""
Query profiling
"""
from datetime import datetime
from dataclasses import dataclass
from functools import partial, wraps
from timeit import timeit
from os import listdir
from os.path import isfile, join
from typing import Generator, Callable, Any, Protocol

from tqdm import trange
from rich import print as rprint


class DbConnector(Protocol):
    """Database connector to run SQL against the database."""
    def run_query_from_file(self, filepath: str) -> Any:
        """Open a file and execute the query inside it."""
        ...


@dataclass
class Runner:
    """Callable object representing a function.

    Wrapped into an object rather than left as a function to assign additional properties to the functions, making them
    easier to monitor and summarise their statistics.
    """
    runner: Callable
    filepath: str
    repeat: int = 0
    total_time: float = 0.0

    def __call__(self, time_it: bool = True):
        if time_it:
            self.repeat += 1
            self.total_time += timeit(self.runner, number=1)
        else:
            self.runner()

    @property
    def average_time(self) -> float:
        """The average time that this function has taken to run."""
        return self.total_time / self.repeat

    @property
    def file_name(self) -> str:
        """The name of the file containing the code to run."""
        return self.filepath[1 + self.filepath.rfind('\\'):]


def get_query_filepaths(directory: str) -> Generator:
    """Return the full file_name paths of the files at `directory`."""
    for path in listdir(directory):
        full_path = join(directory, path)
        if isfile(full_path):
            yield full_path


def execute_query(query_filepath: str, conn: DbConnector) -> None:
    """Run a SQL query from a file_name."""
    conn.run_query_from_file(query_filepath)


def create_query_runners(query_filepath: str, conn: DbConnector) -> list[Runner]:
    """Create a list of Runners each corresponding to the queries in the query filepath."""
    return [
        Runner(
            runner=partial(execute_query, query_filepath=query_filepath, conn=conn),
            filepath=query_filepath
        ) for query_filepath in get_query_filepaths(query_filepath)
    ]


def print_runner_stats(list_of_runners: list[Runner]) -> None:
    """Print the average run times of the runners."""
    total_avg_time = sum(runner.average_time for runner in list_of_runners)
    for runner in list_of_runners:
        print(f'{runner.file_name}: {runner.average_time:.8f} ({runner.average_time / total_avg_time:.1%})', )


def print_times() -> Callable:
    """Decorator to print the start and end times of the wrapped function."""
    def decorator(func: Callable) -> Callable:
        @wraps(func)
        def wrapper(*args, **kwargs) -> Any:
            rprint(f'[blue]Start time: {datetime.now()}[/blue]')
            func(*args, **kwargs)
            rprint(f'[blue]End time: {datetime.now()}[/blue]')
        return wrapper
    return decorator


@print_times()
def time_queries(repeat: int, conn: DbConnector) -> None:
    """Time the queries."""
    runners: list[Runner] = create_query_runners(query_filepath='queries', conn=conn)

    # Set the 'temp' tables
    for runner in runners:
        runner(time_it=False)

    # We want to keep running them 'side-by-side' to account for busy periods in the DB
    for _ in trange(repeat):
        for runner in runners:
            runner()

    print_runner_stats(list_of_runners=runners)
