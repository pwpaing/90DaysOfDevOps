#!/bin/bash

# Reading user input interactively
echo "Enter your name:"
read user_name

# Reading from command-line arguments
arg1=$1
arg2=$2

# Print both variables with clear labels
echo "Interactive input - Name: $user_name"
echo "Command-line argument 1: $arg1"
echo "Command-line argument 2: $arg2"
