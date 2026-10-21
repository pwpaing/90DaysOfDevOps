# Day 4: Basic Linux Shell Scripting for DevOps Engineers

## What is Shell Scripting for DevOps?

Shell scripting is the practice of writing a series of commands in a file (called a shell script) so that they can be executed automatically by the shell. Instead of typing commands one by one in a terminal, you put them in a `.sh` file and run the whole file at once.

For DevOps engineers, shell scripting is invaluable because it allows you to:

- **Automate repetitive tasks** - for example, backing up log files every night without manual intervention
- **Configure servers** - install packages, set environment variables, and start services all in a single script
- **Build CI/CD pipelines** - many pipeline steps (running tests, building Docker images, deploying applications) are written as shell scripts
- **Monitor systems** - check disk usage, CPU load, or running processes and alert if thresholds are crossed

Example use case: Instead of manually SSHing into 10 servers to update a config file, you write a shell script that does it for all of them in one go.

---

## What is `#!/bin/bash`? Can we write `#!/bin/sh` instead?

The line `#!/bin/bash` at the top of a script is called a **shebang** (or hashbang). It tells the operating system which interpreter to use when running the script.

- `#!/bin/bash` - run this script using **Bash** (Bourne Again Shell)
- `#!/bin/sh` - run this script using the **POSIX sh** shell (a more minimal, portable shell)

**Can you use `#!/bin/sh`?** Yes, but with important differences:

| Feature | `#!/bin/bash` | `#!/bin/sh` |
|---|---|---|
| Arrays | ✅ Supported | ❌ Not supported |
| `[[ ]]` conditionals | ✅ Supported | ❌ Not supported |
| String manipulation | ✅ Extended support | ⚠️ Limited |
| Portability | Works on Linux/macOS with Bash | Works on almost any Unix system |

**Rule of thumb:** Use `#!/bin/bash` when you want Bash-specific features (most DevOps scripts). Use `#!/bin/sh` when you need maximum portability across different Unix systems.

---

## Script 1: Print the Challenge

**File:** `print_challenge.sh`

This is the simplest type of shell script - it just runs the `echo` command to print a message to the terminal.

```bash
#!/bin/bash

echo "I will complete #90DaysOofDevOps challenge"
```

**How to run it:**
```
bash print_challenge.sh
```

**Output:**
```
I will complete #90DaysOofDevOps challenge
```

---

## Script 2: User Input and Command-Line Arguments

**File:** `user_input.sh`

This script demonstrates two ways to get data into a shell script:

1. **Interactive input** - using `read` to prompt the user while the script runs
2. **Command-line arguments** - values passed in when you invoke the script (`$1`, `$2`, etc.)

```bash
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
```

**How to run it:**
```
bash user_input.sh Hello World
```

**Example session:**
```
Enter your name:
Alice
Interactive input - Name: Alice
Command-line argument 1: Hello
Command-line argument 2: World
```

**Key concepts:**
- `read user_name` - pauses the script and waits for the user to type something, then stores it in the variable `user_name`
- `$1` and `$2` - special variables that hold the first and second arguments passed on the command line
- `$variable_name` - how you reference (use) a variable's value in Bash

---

## Script 3: If/Else - Comparing Two Numbers

**File:** `compare_numbers.sh`

This script shows how to use `if/elif/else` to make decisions. It accepts two numbers as command-line arguments and compares them. It also validates the inputs before doing the comparison, so the user gets a clear error message instead of a cryptic shell error.

```bash
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
```

**How to run it:**
```
bash compare_numbers.sh 10 5
bash compare_numbers.sh 3 7
bash compare_numbers.sh 4 4
```

**Example output:**
```
10 is greater than 5
3 is less than 7
4 is equal to 4
```

**Example with invalid arguments:**
```
bash compare_numbers.sh
# Usage: compare_numbers.sh <num1> <num2>

bash compare_numbers.sh abc 5
# Error: 'abc' is not a valid integer
```

**Key concepts:**
- `-gt` means **greater than**
- `-lt` means **less than**
- For equality, the `else` branch catches the remaining case (both are equal)
- `fi` closes an `if` block in Bash (it's `if` spelled backwards)
- Always quote variables (`"$num1"`) inside `[ ]` to handle edge cases safely
- `[[ "$1" =~ ^-?[0-9]+$ ]]` uses a regex match to confirm the argument is a valid integer (including optional leading `-` for negatives)
