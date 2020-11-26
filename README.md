# Sync files action

This action syncs a repository with another repository.


```
  git-author-email:
    description: 'email of the commiter'
    required: true
  git-author-name:
    description: 'name of the commiter'
    required: true
  git-author-token:
    description: 'github token of the commiter'
    required: true
  src-repository:
    description: 'source repository'
    required: true
  dst-repository:
    description: 'destination repository'
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

### `git-author-token`

**Required** The GitHub token of the committer.

### `src-repository`

**Required** The GitHub source repository.

### `dst-repository`

**Required** The GitHub destination repository.

### `allow-files-pattern`

The regex pattern for files that allowed to update. By default all files.

### `branch-name`

The branch of the source repository to sync. By default master.

### `exclude-files`

Space-separated paths of files that should be excluded from sync.


## Example usage
```
uses: actions/sync-files@v1
with:
  git-author-email: 'octocat@email'
  git-author-name: 'Mona the Octocat'
  git-author-token: ${ SECRETS_TOKEN }
  src-repository: organization2/repo2
  dst-repository: organization1/repo1
 ```