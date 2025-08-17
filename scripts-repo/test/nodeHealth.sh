#!/bin/bash

###############################
# Author: ThaLT
# Date: 2023-10-01
# Description: Script to check node health
###############################

# Exit on error, print commands, and fail on pipe errors
set -x
set -e
set -o pipefail


df -h

free -h

nproc