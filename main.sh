getDeletedFiles() {
    addedFiles=$(git log --all --pretty=format: --name-only --diff-filter=A | sort -u)
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

checkOrAddTemplateIgnore() {
    if [ ! -f .templateignore ]; then
        touch .templateignore
        git add .templateignore
    fi
}

createCommitMessage() {
    echo "Sync files with ${GITHUB_SERVER_URL}/${{ intputs.src-repository }}" >> /tmp/commit-message
    echo "" >> /tmp/commit-message
    echo "Version: $(git rev-parse HEAD)"   
    echo "" >> /tmp/commit-message
    git log -1 >> /tmp/commit-message
}

main() {
    git config --global user.email ${{ inputs.git-author-email }}
    git config --global user.name ${{ inputs.git-author-name }}

    currentBranch=$(git branch --show-current)
    git stash
    git remote add source ${GITHUB_SERVER_URL}/${{ intputs.src-repository }}.git
    git fetch source
    git checkout source/${{ inputs.branch-name }}
    deletedFiles=$(getDeletedFiles)
    createCommitMessage
    git checkout $currentBranch
    checkOrAddTemplateIgnore
    git diff source/${{ inputs.branch-name }} -R | git apply
    git add $(git ls-tree --name-only -r source/${{ inputs.branch-name }} | grep "${{ exclude-files.allow-files-pattern }}")
    git restore -- .templateignore
    while read -r path || [[ -n "$path" ]]; do
        git restore --staged -- $path
        git restore -- $path
    done < .templateignore
    for path in ${{ inputs.exclude-files }}; do
        git restore --staged -- $path
        git restore -- $path
    done
    for deletedFile in ${DELETED_FILES_BY_TEMPLATE}; do
        rm -f $deletedFile
        git add $deletedFile
    done
    if ! [ -n "$(git diff --cached --exit-code)" ]; then
        exit 0;
    fi
    git commit -s -F /tmp/commit-message
    git checkout -b sync/${{ intputs.src-repository }}
    git push -f origin sync/${{ intputs.src-repository }}
    git checkout $currentBranch
    git stash pop
}

main