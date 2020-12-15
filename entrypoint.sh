#!/bin/bash

STATUS=0

# remember last error code
trap 'STATUS=$?' ERR

# problem matcher must exist in workspace
cp /error-matcher.json $HOME/file-sync-error-matcher.json
echo "::add-matcher::$HOME/file-sync-error-matcher.json"

echo "Repository: [$GITHUB_REPOSITORY]"

# log inputs
echo "Inputs"
echo "---------------------------------------------"
RAW_REPOSITORIES="$INPUT_REPOSITORIES"
RAW_USERS="$INPUT_USERS"
GITHUB_TOKEN="$INPUT_TOKEN"
REPOSITORIES=($RAW_REPOSITORIES)
echo "Repositories    : $REPOSITORIES"
USERS=($RAW_USERS)
echo "Users           : $USERS"

# set temp path
TEMP_PATH="/ghaacc/"
cd /
mkdir "$TEMP_PATH"
cd "$TEMP_PATH"
echo "Temp Path       : $TEMP_PATH"
echo "---------------------------------------------"

echo " "

# find username and repo name
REPO_INFO=($(echo $GITHUB_REPOSITORY | tr "/" "\n"))
USERNAME=${REPO_INFO[0]}
echo "Username: [$USERNAME]"

echo " "

# get all repos, if specified
if [ "$REPOSITORIES" == "ALL" ]; then
    echo "Getting all repositories for [${USERNAME}]"
    REPOSITORIES_STRING=$(curl -X GET -H "Accept: application/vnd.github.v3+json" -u ${USERNAME}:${GITHUB_TOKEN} --silent ${GITHUB_API_URL}/users/${USERNAME}/repos | jq '.[].full_name')
    readarray -t REPOSITORIES <<< "$REPOSITORIES_STRING"
fi

# loop through all the repos
for repository in "${REPOSITORIES[@]}"; do
    echo "::group::$repository"

    # trim the quotes
    repository="${repository//\"}"

    echo "Repository name: [$repository]"

    echo " "

    # loop through all users
    for user in "${USERS[@]}"; do
        echo "Inviting ${user} to ${REPO_NAME}"

        curl -d @- \
            -X PUT \
            -H "Accept: application/vnd.github.v3+json" \
            -H "Content-Type: application/json" \
            -u ${USERNAME}:${GITHUB_TOKEN} \
            --silent \
            ${GITHUB_API_URL}/repos/${repository}/collaborators/${user}
    done
    echo "Completed [${REPO_NAME}]"
    echo "::endgroup::"
done

exit $STATUS