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
  src-repository:
    description: 'The GitHub repository with which synchronizing.'
    required: true
  allow-files-pattern:
    description: 'The regex pattern for files that allowed to update. By default all files.'
    default: '.*'
  src-branch-name:
    descripion: 'The branch of the source repository to sync. By default main.'
    default: 'main'
  direcotory:
    descripion: 'The working directory.'
    default: ''
  exclude-files:
    default: ''
    description: 'Space-separated paths of files that should be excluded from sync.'
```

## Inputs

### `git-author-email`

**Required** The email of the committer.

### `git-author-name`

**Required** The name of the committer.

### `src-repository`

**Required** The GitHub repository with which synchronizing.

### `allow-files-pattern`

The regex pattern for files that allowed to update. By default all files.

### `branch-name`

The branch of the source repository to sync. By default main.

### `exclude-files`

Space-separated paths of files that should be excluded from sync.


### `directory`

The working directory.


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
