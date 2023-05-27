#!/bin/sh

# Set the starting and ending commit IDs or revision references
START_COMMIT=2953d2d50cb74f4eeffef3e12fc9e0ecc50d6e02
END_COMMIT=70b18add479881d184154c9ac3b9261c0c8eb93a

# Create an empty array to hold the commit objects
commits="[]"

# Loop through each pair of consecutive commits
git rev-list --reverse --ancestry-path $START_COMMIT..$END_COMMIT | while read commit; do
    # Get the parent commit ID for the current commit
    parent=$(git rev-list --parents -n 1 $commit | cut -d ' ' -f 2)

    # Skip merge commits
    if [ "$(git rev-list --count --parents $commit)" != "1" ]; then
        continue
    fi

    # Get the diff between the current commit and its parent
    diff=$(git diff --no-prefix --unified=10 $parent $commit)

    # Add the commit object to the array
    commit_object=$(echo "{ \"prev\": \"$parent\", \"curr\": \"$commit\", \"diff\": \"$diff\" }" | jq -c .)
    commits=$(echo $commits | jq ". += [$commit_object]")
done

# Output the array of commit objects to a JSON file
echo $commits > commits.json
