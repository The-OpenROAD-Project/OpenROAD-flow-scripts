#!/bin/bash
# Copyright (c) 2024 Antmicro <www.antmicro.com>
# SPDX-License-Identifier: Apache-2.0

# Try to kill pid based on name
kill_pid()
{
PIDS_TO_KILL=$(ps axjf | grep $1 | awk '{print $2}')
for PID in ${PIDS_TO_KILL[@]}; do
    echo "Attempting to kill $PID"
    kill -9 $PID
done
}

kill_pid vnc
kill_pid novnc
kill_pid tigervncserver
