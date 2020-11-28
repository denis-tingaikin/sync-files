getDeletedFiles() {
    addedFiles=$(git log source/${SRC_BRANCH_NAME} --pretty=format: --name-only --diff-filter=AR | sort -u)
    currentFiles=$(git ls-files)
    deletedFiles=""
    for addedFile in $addedFiles; do 
        match="false"
        for currentFile in $currentFiles; do
            if [ "${addedFile}" = "${currentFile}" ]; then
                match="true"
                break
            fi
        done
        if [ "${match}" = "false" ]; then
            deletedFiles="${deletedFiles} ${addedFile}"
        fi
    done
    echo $deletedFiles
}

checkOrAddSyncIgnore() {
    if [ ! -f .syncignore ]; then
        touch .syncignore
        git add .syncignore
    fi
}

createCommitMessage() {
    echo "Sync files with ${SRC_REPOSITORY}" > /tmp/commit-message
    echo "" >> /tmp/commit-message
    echo "This PR syncs files with ${GITHUB_SERVER_URL}/${SRC_REPOSITORY}" >> /tmp/commit-message
    echo "" >> /tmp/commit-message
    echo "Revision: ${GITHUB_SERVER_URL}/${SRC_REPOSITORY}/commits/$(git rev-parse HEAD)" >> /tmp/commit-message 
    echo "" >> /tmp/commit-message
    git log -1 >> /tmp/commit-message
}

main() {
    git config --global user.email ${AUTHOR_EMAIL}
    git config --global user.name ${AUTHOR_NAME}
    currentBranch=$(git branch --show-current)
    git remote add source ${GITHUB_SERVER_URL}/${SRC_REPOSITORY}.git
    git fetch source
    git checkout source/${SRC_BRANCH_NAME}
    deletedFiles=$(getDeletedFiles)
    createCommitMessage
    git checkout $currentBranch
    checkOrAddSyncIgnore
    git diff source/${SRC_BRANCH_NAME} -R | git apply
    git add $(git ls-tree --name-only -r source/${SRC_BRANCH_NAME} | grep -E "${REGEX}")
    git restore -- .syncignore
    for deletedFile in $deletedFiles; do
        {
            rm -f $deletedFile
            git add $deletedFile
        } || {
            echo $deletedFile is already deleted
        }
    done
    while read -r path || [[ -n "$path" ]]; do
        git restore --staged -- $path
        git restore -- $path
    done < .syncignore
    for path in $EXCLUDE_FILES; do
        git restore --staged -- $path
        git restore -- $path
    done
    if ! [ -n "$(git diff --cached --exit-code)" ]; then
        exit 0;
    fi
    git commit -s -F /tmp/commit-message
    git checkout -b sync/${SRC_REPOSITORY}
    git push -f origin sync/${SRC_REPOSITORY}
    git checkout $currentBranch
}

main