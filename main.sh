getDeletedFiles() {
    addedFiles=$(git log source/${SYNC_BRANCH_NAME} --pretty=format: --name-only --diff-filter=AR | sort -u)
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
    if [ ! -f ${SYNC_IGNORE_FILE_NAME} ]; then
        touch ${SYNC_IGNORE_FILE_NAME}
        git add ${SYNC_IGNORE_FILE_NAME}
    fi
}

createCommitMessage() {
    echo "Sync files with ${SYNC_REPOSITORY}" > /tmp/commit-message
    echo "" >> /tmp/commit-message
    echo "This PR syncs files with ${GITHUB_SERVER_URL}/${SYNC_REPOSITORY}" >> /tmp/commit-message
    echo "" >> /tmp/commit-message
    echo "Revision: ${GITHUB_SERVER_URL}/${SYNC_REPOSITORY}/commits/$(git rev-parse HEAD)" >> /tmp/commit-message 
    echo "" >> /tmp/commit-message
    git log -1 >> /tmp/commit-message
}

main() {
    pushd "${WORKING_DIRECTORY}"
    git config --global user.email ${AUTHOR_EMAIL}
    git config --global user.name ${AUTHOR_NAME}
    currentBranch=$(git branch --show-current)
    git remote add source ${GITHUB_SERVER_URL}/${SYNC_REPOSITORY}.git
    git fetch source
    git checkout source/${SYNC_BRANCH_NAME}
    deletedFiles=$(getDeletedFiles)
    createCommitMessage
    git checkout $currentBranch
    checkOrAddSyncIgnore
    git diff source/${SYNC_BRANCH_NAME} -R | git apply
    git add $(git ls-tree --name-only -r source/${SYNC_BRANCH_NAME} | grep -E "${REGEX}")
    git restore -- ${SYNC_IGNORE_FILE_NAME}
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
    done < ${SYNC_IGNORE_FILE_NAME}
    for path in $EXCLUDE_FILES; do
        git restore --staged -- $path
        git restore -- $path
    done
    if ! [ -n "$(git diff --cached --exit-code)" ]; then
        exit 0;
    fi
    git commit -s -F /tmp/commit-message
    git checkout -b ${RESULT_BRANCH_NAME}
    git push -f origin ${RESULT_BRANCH_NAME}
    git checkout $currentBranch
    popd
}

main