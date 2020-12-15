<h1 align="center">github-action-auto-create-collabs</h1>


<div align="center">

<b>Github Action to auto create collaboration invites across repositories</b>

[![version](https://img.shields.io/github/v/release/kbrashears5/github-action-auto-create-collabs)](https://img.shields.io/github/v/release/kbrashears5/github-action-auto-create-collabs)
[![Build Status](https://dev.azure.com/kbrashears5/github/_apis/build/status/kbrashears5.github-action-auto-create-collabs?branchName=master)](https://dev.azure.com/kbrashears5/github/_build/latest?definitionId=32&branchName=master)

</div>


# Use Cases
Auto create collaboration invites to the users specified to any new or old repositories. Useful for managing a team or for managing a second bot account

# Setup
Create a new file called `/.github/workflows/auto-create-collabs.yml` that looks like so:
```yaml
name: Auto Create Collabs

on:
  push:
    branches:
      - master
  schedule:
    - cron: 0 0 * * *

jobs:
  file_sync:
    runs-on: ubuntu-latest
    steps:
      - name: Fetching Local Repository
        uses: actions/checkout@master
      - name: Auto Create Collabs
        uses: kbrashears5/github-action-auto-create-collabs@v2.0.0
        with:
          REPOSITORIES: |
            username/repo@master
          USERS: |
            octocat
          TOKEN: ${{ secrets.ACTIONS }}
```
## Parameters
| Parameter | Required | Description |
| --- | --- | --- |
| REPOSITORIES | true | List of repositories to create invites for. Blank will be all public repositories |
| USERS | true | List of users to invite |
| TOKEN | true | Personal Access Token with Repo scope |