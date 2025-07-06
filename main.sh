#!/bin/bash

if git rev-parse --is-inside-work-tree &>/dev/null; then
    if git diff --quiet --cached &>/dev/null && git diff --quiet &>/dev/null; then
        if git stash list &>/dev/null && [[ -z $(git stash list) ]]; then
            branch_status=$(git status --porcelain=2 --branch)

            if [[ "$branch_status" == *"branch.ab"* ]]; then
                ahead_count=$(echo "$branch_status" | grep -Eo 'branch.ab \+([0-9]+)' | awk '{print $2}')
                behind_count=$(echo "$branch_status" | grep -Eo 'branch.ab -([0-9]+)' | awk '{print $2}')

                # Set default values if variables are empty
                ahead_count=${ahead_count:-0}
                behind_count=${behind_count:-0}

                if [ "$ahead_count" -gt 0 ]; then
                    echo green
                elif [ "$ahead_count" -eq 0 ] && [ "$behind_count" -eq 0 ]; then
                    echo magenta
                else
                    echo green
                fi
            else
                echo magenta
            fi
        else
            echo green
        fi
    elif git diff --quiet &>/dev/null; then
        echo yellow
    else
        echo red
    fi
else
    echo "#444"
fi
