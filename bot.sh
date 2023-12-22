#!/usr/bin/bash

START_Y=2012
END_Y=2020

for Y in $(eval "echo {$START_Y..$END_Y}"); do
    for M in {01..12}; do
        for D in {01..31}; do
            for i in {01..12}; do
                GIT_AUTHOR_DATE="$Y-$M-$D $i:00:00" GIT_COMMITTER_DATE="$Y-$M-$D $i:00:00" git commit --allow-empty -m "$i on $M $D $Y"
            done
        done
    done
done
git push origin master