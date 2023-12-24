#!/usr/bin/env bash

# Input start and end dates
read -p "Enter start date (yyyy-mm-dd): " START_DATE
read -p "Enter end date (yyyy-mm-dd): " END_DATE

# Convert start and end dates to Unix timestamps using 'date' command (macOS compatible)
START_UNIX=$(date -jf "%Y-%m-%d" "$START_DATE" +%s)
END_UNIX=$(date -jf "%Y-%m-%d" "$END_DATE" +%s)

# Loop through the timestamps and perform commits
while [ "$START_UNIX" -le "$END_UNIX" ]; do
    # Extract year, month, and day from the current date
    CURRENT_DATE=$(date -r "$START_UNIX" "+%Y-%m-%d")
    YEAR=$(date -r "$START_UNIX" "+%Y")
    MONTH=$(date -r "$START_UNIX" "+%-m")
    DAY=$(date -r "$START_UNIX" "+%-d")

    # Generate a random number between 0 and 9 for commit count
    RANDOM_COUNT=$((RANDOM % 10))

    # Loop to perform random commits
    for ((i = 0; i < RANDOM_COUNT; i++)); do
        # Generate a random hour for commit time
        HOUR=$((RANDOM % 24))
        MIN=$((RANDOM % 60))
        SEC=$((RANDOM % 60))

        GIT_AUTHOR_DATE="$YEAR-$(printf %02d $MONTH)-$(printf %02d $DAY) $HOUR:$MIN:$SEC" GIT_COMMITTER_DATE="$YEAR-$(printf %02d $MONTH)-$(printf %02d $DAY) $HOUR:$MIN:$SEC" git commit --allow-empty -m "$i on $(printf %02d $MONTH) $(printf %02d $DAY) $YEAR"
    done

    # Move to the next day
    START_UNIX=$((START_UNIX + 86400)) # Increment by 24 hours (in seconds)
done

git push origin master
