# Sync files action

This action syncs repository files with another repository.

Note: **Required** [actions/checkout@v2](https://github.com/actions/checkout) with passed access **token**.


```yaml
  git-author-email:
    description: 'The email of the committer.'
    required: true
  git-author-name:
    description: 'The name of the committer.'
    required: true
  sync-repository:
    description: 'The GitHub repository with which synchronizing.'
    required: true
  allow-files-pattern:
    description: 'The regex pattern for files that allowed to update. By default all files.'
    default: '.*'
  sync-branch-name:
    descripion: 'The branch of the source repository to sync. By default master.'
    default: 'main'
  working-directory:
    descripion: 'The working working-directory.'
    default: ''
  result-branch-name:
    descripion: 'The name of the branch that will be created on the action done.'
    default: sync/{{ inputs.sync-repository }}
  exclude-files:
    default: ''
    description: 'Space-separated paths of files that should be excluded from sync.'
  sync-ignore-file-name:
    default: '.syncignore'
    description: 'The path to file in the destination repository that contains space-separated paths to files that should be excluded from sync.'
```

## Inputs

### `git-author-email`

**Required** The email of the committer.

### `git-author-name`

**Required** The name of the committer.

### `src-repository`

**Required** The GitHub repository with which synchronizing.

### `allow-files-pattern`

**Optional** The regex pattern for files that allowed to update. By default all files.

### `branch-name`

**Optional** The branch of the source repository to sync. By default main.

### `exclude-files`

**Optional** Space-separated paths of files that should be excluded from sync. By default none.

### `result-branch-name`

**Optional** The name of the branch that will be created on the action done. By defaule sync/${{inputs.sync_repository}}

### `working-directory`

**Optional** The working directory. By default current action working-directory.

### `sync-ignore-file-name`

**Optional** The path to file in the destination repository that contains space-separated paths to files that should be excluded from sync. By defaule `.syncignore`

## Example usage
```yaml
    - name: Checkout files
      uses: actions/checkout@v2
      with:
        repository: octocat/dst-repsotiory
        token: ${{ secrets.octocat_token }}
    - name: Sync files with dst-octocat-repsotiory!
      uses: denis-tingajkin/sync-files@main
      with:
        git-author-email: 'octocat@github.com'
        git-author-name: 'Octocat'
        src-repository: octocat/src-repsotiory
 ```
