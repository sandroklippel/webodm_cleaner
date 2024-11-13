#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# MIT License

# Copyright (c) 2024 Sandro Klippel

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

""" Clears old webodm tasks, freeing up disk space.
"""

import sys
import json
import logging
import argparse

from pywebodm import WebODM
from pywebodm.utils import fmt_size


__author__ = "Sandro Klippel"
__copyright__ = "Copyright 2024, Sandro Klippel"
__license__ = "MIT"
__version__ = "0.1.0"
__maintainer__ = "Sandro Klippel"
__email__ = "sandroklippel at gmail.com"
__status__ = "Production"


def read_config(s):
    """reads the configuration file."""
    with open(s, "r") as jsonfile:
        return json.load(jsonfile)


def cli():
    """parse command line options"""
    parser = argparse.ArgumentParser(
        description="Clears old webodm tasks, freeing up disk space.",
        epilog=__copyright__,
    )
    parser.add_argument(
        "--config",
        dest="config_fn",
        metavar="file",
        required=True,
        type=str,
        help="json config file",
    )
    parser.add_argument("--version", action="version", version=__version__)

    args = parser.parse_args()
    return args.config_fn


def get_old_tasks(server, days):
    """Returns a list of tasks that are more than x 'days' old."""
    all_projects = server.list_projects()
    all_tasks = []
    for p in all_projects:
        all_tasks.extend(server.list_project_tasks(p.id))
    return [x for x in all_tasks if x.age.days > days]


def delete_tasks(server, tasks):
    """Delete tasks and record the result."""
    removed = []
    for task in tasks:
        task_deleted = server.delete_task(task.project, task.id)
        if task_deleted:
            removed.append(task)
        else:
            logging.error(
                "error deleting task {} from project {}".format(task.id, task.project)
            )
    return removed


def webodm_cleaner():
    """main function to clears old webodm tasks"""

    fn = cli()

    try:
        settings = read_config(fn)
        username = settings["username"]
        password = settings["password"]
        url = settings["url"]
        days = settings["days"]
    except KeyError as k:
        logging.error(f"Invalid config file: {fn}. The '{k}' was not found.")
        return 1
    except json.JSONDecodeError:
        logging.error(f"Invalid config file: {fn}. Malformed JSON file.")
        return 1
    except FileNotFoundError:
        logging.error(f"The file {fn} was not found.")
        return 1

    try:
        with WebODM(url, username, password) as server:
            old_tasks = get_old_tasks(server, days)
            removed_tasks = delete_tasks(server, old_tasks)
            if removed_tasks:
                num_tasks = len(removed_tasks)
                total_size = fmt_size(sum(task.size for task in removed_tasks))
                logging.info(
                    "deleted {} old tasks, freeing up {} of disk space".format(
                        num_tasks, total_size
                    )
                )
        return 0
    except Exception as err:
        logging.exception(err)
        return 1


if __name__ == "__main__":

    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )

    sys.exit(webodm_cleaner())
