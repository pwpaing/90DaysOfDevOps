#!/bin/bash

# createDirectories.sh - Creates a series of numbered directories
#
# Usage: ./createDirectories.sh <dir_name> <start_num> <end_num>
#
# Example: ./createDirectories.sh day 1 90
#   Creates: day1 day2 day3 ... day90
#
# Example: ./createDirectories.sh Movie 20 50
#   Creates: Movie20 Movie21 Movie22 ... Movie50

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <dir_name> <start_num> <end_num>"
    echo "Example: $0 day 1 90"
    exit 1
fi

dir_name=$1
start_num=$2
end_num=$3

for (( i=start_num; i<=end_num; i++ )); do
    mkdir -p "${dir_name}${i}"
done

echo "Created directories ${dir_name}${start_num} to ${dir_name}${end_num}"
