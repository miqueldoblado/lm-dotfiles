# GitHub publisher

The publisher module for GitHub. Implements the three publisher verbs. Requires
`gh auth status` to pass.

## publish

Open the change as a draft:

```sh
gh pr create --draft --title "[AI-DRAFT] <subject>" --body "$(cat body.md)"
```

## merge

```sh
gh pr merge <url> --<method> --match-head-commit <sha> --delete-branch
```

`<method>` is the first the repo allows of squash, merge, rebase.

## state

```sh
gh pr view <url> --json state,mergedAt,isDraft,headRefOid
```

Read `isDraft: false`, or a title without the `[AI-DRAFT]` prefix, as a write
error to fix before the change counts as open.
