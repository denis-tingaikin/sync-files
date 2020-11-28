# Sync files action

**Required** actions/checkout@v2 with passed token.

This action syncs repository files with another repository.


```yaml
  git-author-email:
    description: 'email of the commiter'
    required: true
  git-author-name:
    description: 'name of the commiter'
    required: true
  src-repository:
    description: 'source repository'
    required: true
  allow-files-pattern:
    description: 'regex pattern for files that allowed to update'
    default: ".*"
  branch-name:
    descripion: 'name of branch to get updates'
    default: master
  exclude-files:
    description: 'space-separated paths of files that should be excluded'
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

The branch of the source repository to sync. By default master.

### `exclude-files`

Space-separated paths of files that should be excluded from sync.


## Example usage
```yaml
    - name: Checkout files
      uses: actions/checkout@v2
      with:
        repository: octocat/dst-repsotiory
        token: ${{ secrets.octocat_token }}
    - name: Sync files with dst-octocat-repsotiory!
      uses: actions/sync-files@main
      with:
        git-author-email: 'octocat@github.com'
        git-author-name: 'Octocat'
        src-repository: octocat/src-repsotiory
 ```