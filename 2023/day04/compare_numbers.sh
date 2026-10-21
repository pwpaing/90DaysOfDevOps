#!/bin/bash

# compare_numbers.sh - Compares two numbers passed as command-line arguments
#
# Usage: ./compare_numbers.sh <num1> <num2>

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <num1> <num2>"
    echo "Example: $0 10 5"
    exit 1
fi

# Validate that both arguments are integers
if ! [[ "$1" =~ ^-?[0-9]+$ ]]; then
    echo "Error: '$1' is not a valid integer"
    exit 1
fi

if ! [[ "$2" =~ ^-?[0-9]+$ ]]; then
    echo "Error: '$2' is not a valid integer"
    exit 1
fi

# Accept two numbers as command-line arguments
num1=$1
num2=$2

if [ "$num1" -gt "$num2" ]; then
    echo "$num1 is greater than $num2"
elif [ "$num1" -lt "$num2" ]; then
    echo "$num1 is less than $num2"
else
    echo "$num1 is equal to $num2"
fi
