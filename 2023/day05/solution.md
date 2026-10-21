# Day 5: Advanced Linux Shell Scripting with User Management

---

## Task 1: createDirectories.sh - Creating Numbered Directories with a Loop

### The Problem

The `2023/` directory of this repo contains 90 sub-directories (`day1` through `day90`). Creating them one by one would be tedious. The quick one-liner to do it is:

```bash
mkdir day{1..90}
```

But what if you need a reusable, flexible script that accepts the name prefix and the number range as arguments? That is what `createDirectories.sh` does.

### Approach

The script uses three command-line arguments:

1. `dir_name` - the prefix for every directory name (e.g. `day` or `Movie`)
2. `start_num` - the number to start from
3. `end_num` - the number to finish at

It validates that exactly three arguments were passed, then uses a `for` loop to create each directory.

### The Script

**File:** `createDirectories.sh`

```bash
#!/bin/bash

# createDirectories.sh - Creates a series of numbered directories
#
# Usage: ./createDirectories.sh <dir_name> <start_num> <end_num>

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
```

### Usage Examples

**Example 1** - create 90 directories named `day1` through `day90`:

```
./createDirectories.sh day 1 90
```

Creates: `day1 day2 day3 ... day90`

**Example 2** - create 31 directories named `Movie20` through `Movie50`:

```
./createDirectories.sh Movie 20 50
```

Creates: `Movie20 Movie21 Movie22 ... Movie50`

### Key Concepts

- `$#` - the number of arguments passed to the script
- `$1`, `$2`, `$3` - the first, second, and third arguments
- `for (( i=start; i<=end; i++ ))` - a C-style arithmetic `for` loop in Bash
- `mkdir -p` - creates the directory and does not error if it already exists

---

## Task 2: backup.sh - Backing Up Your Work

### Why Backups Matter for DevOps Engineers

Data loss can happen at any time - accidental deletion, disk failure, a bad deployment overwriting files. DevOps engineers are responsible for both application code and infrastructure configuration. Losing either can mean hours of recovery work. Automating backups ensures that a recent copy always exists without relying on anyone remembering to do it manually.

### The Script

**File:** `backup.sh`

```bash
#!/bin/bash

# backup.sh - Creates a timestamped backup of the 2023/ directory

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$(cd "${SCRIPT_DIR}/../../" && pwd)/2023"

# Backup destination is at the repository root level (outside 2023/) to
# prevent self-inclusion: if backups landed inside 2023/, every subsequent
# run would bundle all prior archives into the new one.
BACKUP_DIR="${SCRIPT_DIR}/../../backups"

mkdir -p "${BACKUP_DIR}"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz"

tar -czf "${BACKUP_FILE}" -C "$(dirname "${SOURCE_DIR}")" "$(basename "${SOURCE_DIR}")"

echo "Backup saved to: ${BACKUP_FILE}"
```

### How It Works

| Part | What It Does |
|---|---|
| `SCRIPT_DIR` | Finds the directory the script lives in, so paths work from any location |
| `SOURCE_DIR` | Points to the `2023/` folder two levels above the script |
| `BACKUP_DIR` | A `backups/` folder two levels above the script, at the repo root — outside `2023/` so archives are never included in a later backup of the same source tree |
| `mkdir -p` | Creates `backups/` if it does not exist yet (no error if it already exists) |
| `date +%Y%m%d_%H%M%S` | Produces a timestamp like `20240115_143022` - year, month, day, hour, minute, second |
| `tar -czf` | **c** = create archive, **z** = compress with gzip, **f** = write to a file |
| `-C` | Changes to the given directory before archiving, so paths inside the archive are relative |

A sample backup filename looks like: `backup_20240115_143022.tar.gz`

---

## Task 3: Cron and Crontab - Automating the Backup

### What is Cron?

**Cron** is a time-based job scheduler built into Linux. It runs in the background and checks every minute whether any scheduled jobs are due to run. It is the standard way to automate recurring tasks such as backups, log rotation, or health checks.

### What is Crontab?

**Crontab** (cron table) is the configuration file where you define your scheduled jobs. Each user on the system has their own crontab. You manage it with the `crontab` command:

| Command | What It Does |
|---|---|
| `crontab -e` | Open your crontab in a text editor to add or edit jobs |
| `crontab -l` | List (print) all your current cron jobs |
| `crontab -r` | Remove (delete) your entire crontab - use with care |

### Cron Syntax

Each line in a crontab has 5 time fields followed by the command to run:

```
* * * * *  /path/to/command
| | | | |
| | | | └── Day of week  (0-7, Sunday is 0 or 7)
| | | └──── Month        (1-12)
| | └────── Day of month (1-31)
| └──────── Hour         (0-23)
└────────── Minute       (0-59)
```

A `*` in a field means "every" - every minute, every hour, every day, and so on.

### Example Crontab Entries

**Run `backup.sh` every day at 2:00 AM:**

```
0 2 * * * /path/to/2023/day05/backup.sh
```

- `0` in the minute field - at minute 0 (the top of the hour)
- `2` in the hour field - at 2 AM
- `*` in day, month, weekday - every day of every month

**Run a script every minute (useful for testing):**

```
* * * * * /path/to/script.sh
```

**Run a script every Monday at midnight:**

```
0 0 * * 1 /path/to/script.sh
```

**To add the daily backup job to your own crontab:**

```bash
crontab -e
```

Then add this line (adjust the path to where your script lives):

```
0 2 * * * /home/youruser/90DaysOfDevOps/2023/day05/backup.sh >> /home/youruser/backup.log 2>&1
```

The `>> /home/youruser/backup.log 2>&1` part appends all output (including errors) to a log file so you can check if the backup ran successfully.

---

## Task 4: User Management in Linux

### What is a User?

A **user** in Linux is an account that can log in, own files, and run processes. Every user has a unique numeric **user ID (UID)**. The root user always has UID 0. System accounts (used by services like `www-data` or `sshd`) typically have UIDs 1-999. Regular human users start at UID 1000.

### Key User Management Commands

| Command | What It Does | Example |
|---|---|---|
| `useradd` | Create a new user account | `sudo useradd alice` |
| `usermod` | Modify an existing user account | `sudo usermod -aG sudo alice` |
| `userdel` | Delete a user account | `sudo userdel alice` |
| `passwd` | Set or change a user's password | `sudo passwd alice` |
| `id` | Show the UID, GID, and groups for a user | `id alice` |
| `getent passwd` | Look up a user in the system database | `getent passwd alice` |

### The /etc/passwd File

The file `/etc/passwd` stores basic information about every user on the system. Each line represents one user and has 7 fields separated by colons:

```
username:password_placeholder:UID:GID:comment:home_dir:shell
```

Example line:

```
alice:x:1001:1001:Alice Smith:/home/alice:/bin/bash
```

- `alice` - the username
- `x` - password is stored securely in `/etc/shadow` (not here)
- `1001` - user ID (UID)
- `1001` - primary group ID (GID)
- `Alice Smith` - a comment or full name (called the GECOS field)
- `/home/alice` - the user's home directory
- `/bin/bash` - the shell that opens when this user logs in

### Checking User Information

**Show all details for a user:**

```bash
id alice
```

Output:

```
uid=1001(alice) gid=1001(alice) groups=1001(alice),27(sudo)
```

**Look up a user with getent:**

```bash
getent passwd alice
```

Output:

```
alice:x:1001:1001:Alice Smith:/home/alice:/bin/bash
```

---

## Task 5: Create 2 Users and Display Their Usernames

The following commands are run directly in your terminal (they are not part of a script file).

### Step 1: Create the two users

```bash
sudo useradd user1
sudo useradd user2
```

Each `useradd` command creates a new account. `sudo` is needed because adding users requires root privileges.

### Step 2: Display their usernames

**Option A - use `id` for each user:**

```bash
id user1
id user2
```

Example output:

```
uid=1001(user1) gid=1001(user1) groups=1001(user1)
uid=1002(user2) gid=1002(user2) groups=1002(user2)
```

**Option B - use `getent` to display just the usernames:**

```bash
getent passwd user1 user2 | cut -d: -f1
```

Example output:

```
user1
user2
```

`getent passwd user1 user2` fetches the `/etc/passwd` entries for both users. Piping to `cut -d: -f1` extracts only the first field (the username) from each line.

**Option C - check the end of /etc/passwd directly:**

```bash
tail -2 /etc/passwd
```

This shows the last two lines added to `/etc/passwd`, which will be the two users you just created (assuming they were the most recently added accounts).
