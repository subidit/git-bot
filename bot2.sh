#!/usr/bin/bash

# Input start and end dates
read -p "Enter start date (yyyy-mm-dd): " START_DATE
read -p "Enter end date (yyyy-mm-dd): " END_DATE

# Extracting year, month, and day from the input
START_Y=$(date -d "$START_DATE" +"%Y")
END_Y=$(date -d "$END_DATE" +"%Y")
START_M=$(date -d "$START_DATE" +"%-m")
END_M=$(date -d "$END_DATE" +"%-m")

# Function to get the number of days in a month
get_days_in_month() {
    local year=$1
    local month=$2
    cal "$month" "$year" | awk 'NF {DAYS = $NF}; END {print DAYS}'
}

for Y in $(eval "echo {$START_Y..$END_Y}"); do
    for ((M = START_M; M <= END_M; M++)); do
        # Get the number of days in the current month and year
        DAYS_IN_MONTH=$(get_days_in_month "$Y" "$M")
        
        # Calculate the day range for the current month
        START_D=1
        if [[ $Y -eq $START_Y && $M -eq $START_M ]]; then
            START_D=$(date -d "$START_DATE" +"%-d")
        fi
        
        END_D=$DAYS_IN_MONTH
        if [[ $Y -eq $END_Y && $M -eq $END_M ]]; then
            END_D=$(date -d "$END_DATE" +"%-d")
        fi
        
        for ((D = START_D; D <= END_D; D++)); do
            # Generate a random number between 0 and 9
            RANDOM_COUNT=$((RANDOM % 10))
            
            # Loop to perform random commits
            for ((i = 0; i < RANDOM_COUNT; i++)); do
                HOUR=$((RANDOM % 24))
                GIT_AUTHOR_DATE="$Y-$(printf %02d $M)-$(printf %02d $D) $HOUR:00:00" GIT_COMMITTER_DATE="$Y-$(printf %02d $M)-$(printf %02d $D) $HOUR:00:00" git commit --allow-empty -m "$i on $(printf %02d $M) $(printf %02d $D) $Y"
            done
        done
    done
done
git push origin master
