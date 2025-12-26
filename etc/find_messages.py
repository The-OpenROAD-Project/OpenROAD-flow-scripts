#!/usr/bin/env python3

############################################################################
##
## Copyright (c) 2021, The Regents of the University of California
## All rights reserved.
##
## BSD 3-Clause License
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
## * Redistributions of source code must retain the above copyright notice, this
##   list of conditions and the following disclaimer.
##
## * Redistributions in binary form must reproduce the above copyright notice,
##   this list of conditions and the following disclaimer in the documentation
##   and/or other materials provided with the distribution.
##
## * Neither the name of the copyright holder nor the names of its
##   contributors may be used to endorse or promote products derived from
##   this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
## AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
## ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
## LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
## CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
## SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
## INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
## CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
## ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
## POSSIBILITY OF SUCH DAMAGE.
##
############################################################################

# Usage:
# cd src/<tool>
# ../../etc/FindMessages.py > messages.txt

import argparse
import glob
import os
import re
import sys
from collections import defaultdict

# AT module uses tab size 4.
TAB_SIZE = 4


def parse_args():
    parser = argparse.ArgumentParser(
        description="""
          Find logger calls and report sorted message IDs.
          Also checks for duplicate message IDs.
        """,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "-d",
        "--dir",
        default=os.getcwd(),
        help="Directory to start the search for messages from",
    )
    parser.add_argument(
        "-l",
        "--local",
        action="store_true",
        help="Look only at the local files and don't recurse",
    )
    args = parser.parse_args()

    return args


# The three capture groups are tool, id, and message.
warn_regexp_py = re.compile(
    r"""
      \[(?P<type>ERROR|INFO|WARNING)      # type
      \s+                                 # white-space
      (?P<tool>\w+)-(?P<id>\d+)\]         # tool-id 
      \s+                                 # white-space
      (?P<message>.+?)\)                  # message (ended with a closing parenthesis)
    """,
    re.VERBOSE | re.MULTILINE,
)

warn_regexp_py_lines = re.compile(
    r"""
      \[(?P<type>ERROR|INFO|WARNING)      # type
      \s+                                 # white-space
      (?P<tool>\w+)-(?P<id>\d+)\]         # tool-id 
      \s+                                 # white-space
      (?P<message>.+)                     # message (end on line)
    """,
    re.VERBOSE | re.MULTILINE,
)


def scan_file(path, file_name, msgs):
    # Grab the file contents as a single string
    with open(os.path.join(path, file_name), encoding="utf-8") as file_handle:
        lines = file_handle.read()

    # Preprocess
    original_lines = str(lines)
    lines = lines.replace("\n", " ")
    lines = re.sub(rf"\s{TAB_SIZE,}", " ", lines)
    match = None
    res, res2 = [], []

    for match in re.finditer(warn_regexp_py, lines):
        tool = match.group("tool").strip('"')
        msg_id = int(match.group("id"))
        key = "{} {:04d}".format(tool, msg_id)

        # remove quotes and join strings
        message = match.group("message")
        message = re.sub(r"\s+", " ", message).strip()
        message_type = match.group("type").upper()
        res.append([key, message, message_type])

    for match in re.finditer(warn_regexp_py_lines, original_lines):
        # Count the newlines before the match starts
        line_num = original_lines[0 : match.start()].count("\n") + 1
        position = "{}:{}".format(file_name, line_num)
        file_link = os.path.join(path, file_name).strip("../").replace("\\", "/")
        file_link = "https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/tree/master/{}#L{}".format(
            file_link, line_num
        )
        res2.append([position, file_link])

    if res and res2:
        for i, (key, message, message_type) in enumerate(res):
            position, file_link = res2[i]
            value = "{:25} {} {} {}".format(position, message, message_type, file_link)
            msgs[key].add(value)


def scan_dir(path, files, msgs):
    for file_name in files:
        if re.search(r"\.(c|cc|cpp|cxx|h|hh|yy|ll|i|tcl|py)$", file_name):
            scan_file(path, file_name, msgs)


def main():
    args = parse_args()

    # "tool id" -> "file:line message"
    msgs = defaultdict(set)

    if args.local:  # no recursion
        files = [
            os.path.basename(file) for file in glob.glob(os.path.join(args.dir, "*"))
        ]
        scan_dir(args.dir, files, msgs)
    else:
        for path, _, files in os.walk(args.dir):
            scan_dir(path, files, msgs)

    # Group numbers by set name
    set_numbers = defaultdict(set)
    for key in msgs:
        set_name, number = key.split()
        set_numbers[set_name].add(int(number))

    has_error = False
    for key in sorted(msgs):
        count = len(msgs[key])
        if count > 1:
            set_name, number = key.split()
            next_free_integer = int(number) + 1
            while next_free_integer in set_numbers[set_name]:
                next_free_integer += 1
            print(
                "Error: {} used {} times, next free message id is {}".format(
                    key, count, next_free_integer
                ),
                file=sys.stderr,
            )
            for idloc in sorted(msgs[key]):
                fileloc, *_ = idloc.split()
                file, line = fileloc.split(":")
                print(
                    "  Appears in {} on line {} ".format(file, line),
                    file=sys.stderr,
                )
            has_error = True

    for key in sorted(msgs):
        for msg in sorted(msgs[key]):
            print(key, msg)

    if has_error:
        sys.exit(1)


if __name__ == "__main__":
    main()
