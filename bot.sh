#!/usr/bin/env bash

# Input start date and number of days
read -p "Enter start date (yyyy-mm-dd): " START_DATE
read -p "Enter number of days: " NUM_DAYS

# Function to convert date to Unix timestamp (OS-independent)
get_unix_timestamp() {
    local input_date=$1
    local timestamp=$(date -d "$input_date" "+%s" 2>/dev/null)
    echo "${timestamp:-0}" # Return 0 if conversion fails
}

# Convert start date to Unix timestamp
START_UNIX=$(get_unix_timestamp "$START_DATE")

# Calculate the end timestamp
END_UNIX=$((START_UNIX + (NUM_DAYS - 1) * 86400)) # Increment by (number of days - 1) * 24 hours

# Loop through the timestamps and perform commits
for ((timestamp = START_UNIX; timestamp <= END_UNIX; timestamp += 86400)); do
    # Extract year, month, day from the current date
    YEAR=$(date -d "@$timestamp" "+%Y")
    MONTH=$(date -d "@$timestamp" "+%-m")
    DAY=$(date -d "@$timestamp" "+%-d")

    # Generate a random number between 1 and 10 for commit count
    RANDOM_COUNT=$((RANDOM % 5))

    # Loop to perform random commits
    for ((i = 1; i <= RANDOM_COUNT; i++)); do
        # Generate random hour, minute, and second for commit time
        HOUR=$((RANDOM % 24))
        MINUTE=$((RANDOM % 60))
        SECOND=$((RANDOM % 60))

        # Create a commit message with date and random time
        COMMIT_MESSAGE="Commit $i: on $(date -d "@$timestamp" "+%B %-d, %Y at $HOUR:$MINUTE:$SECOND") 🚀"

        GIT_AUTHOR_DATE="$YEAR-$(printf %02d $MONTH)-$(printf %02d $DAY) $HOUR:$MINUTE:$SECOND" GIT_COMMITTER_DATE="$YEAR-$(printf %02d $MONTH)-$(printf %02d $DAY) $HOUR:$MINUTE:$SECOND" git commit --allow-empty -m "$COMMIT_MESSAGE"
    done
done

git push origin master
