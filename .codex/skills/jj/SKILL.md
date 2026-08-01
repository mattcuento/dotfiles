---
name: jj
description: |
    Use Jujutsu (jj) as the default version-control front end instead of raw git. Trigger this for ANY version-control operation - committing, branching, viewing history/diffs/status, pushing, updating a PR, rebasing onto master, resolving conflicts, undoing a mistake, or "how do I <git thing>". The repos here are jj-colocated (both .jj and .git exist), so jj is the driver and git is only the transport/PR plumbing.
metadata:
    author: matt
    version: 1.0
---

# jj (Jujutsu) as the default VCS front end

Drive version control with `jj`, not `git`, in any repo that has a `.jj/` directory. Fall back to git only for things jj delegates to git anyway (the network transport, and `gh` for PRs).

Quick check that a repo is jj-managed:

```bash
test -d .jj && echo jj || echo "no jj - use git"
```

If there's no `.jj/`, this skill doesn't apply. Do not run `jj git init` to convert a repo unless the user explicitly asks.

## Mental model (why jj is different from git)

Internalize these four things; most confusion comes from applying git assumptions.

1. **The working copy IS a commit.** `@` is the current working-copy commit. Every file edit is auto-snapshotted into `@` on the next `jj` command. There is no "unstaged/uncommitted" state and **no staging area** - `git add` has no equivalent and is not needed.
2. **Change ID vs commit ID.** Each change has a stable *change ID* (the left-hand 8-letter word in `jj log`, e.g. `wrtwlpuo`) that survives amends/rebases, plus a git *commit ID* (hex) that changes when the content changes. Refer to commits by change ID; it won't move under you.
3. **Editing history is normal and safe.** Amending, reordering, and rebasing are routine because `jj undo` reverses the last operation and `jj op log` is a full undo history. You don't need to be careful the way `git rebase` demands.
4. **Bookmarks, not branches.** jj's named pointers are "bookmarks". They do NOT auto-advance when you commit on top of them - you move them explicitly. A bookmark is what becomes a PR branch on push.

## Agent rules (READ FIRST)

You are a non-interactive agent. Follow these or commands will hang or misfire.

1. **Never trigger an editor.** Always pass `-m "message"` to `jj describe` / `jj commit`, and `--no-edit` where relevant. A bare `jj describe` opens `$EDITOR` and hangs.
2. **Don't hand-edit history the user pushed for review without saying so.** Rewriting a change that's already a shared PR changes its commit IDs; that's fine for your own PRs (it's how you update them) but call it out.
3. **`jj` commits with the local `user.email`** (here: `cuentomr17@gmail.com`), which may differ from the git-config email. Don't "fix" it unless asked.
4. **In a colocated repo, prefer jj for everything and avoid `git commit`/`git checkout`/`git add`.** Mixing raw git writes with jj works (jj re-imports on the next command) but creates surprising extra changes. Read-only git (`git show`, `gh`) is fine.
5. **`trunk()` here resolves to `master@origin`.** Use `trunk()` in revsets rather than hardcoding `master`.
6. **After any surprising result, `jj undo` reverses the last op.** Reach for it instead of trying to manually repair state.

## git → jj command map

| Intent | git | jj |
|---|---|---|
| Status | `git status` | `jj st` |
| Log (graph) | `git log --oneline --graph` | `jj log` |
| Diff of working copy | `git diff` | `jj diff` |
| Diff of a commit | `git show <sha>` | `jj diff -r <change>` |
| Stage + commit | `git add -A && git commit -m` | `jj commit -m "msg"` |
| Amend current commit's message | `git commit --amend` | `jj describe -m "msg"` |
| Fold working changes into current commit | (amend) | just keep editing - `@` already holds them |
| Start a fresh commit on top | `git commit` then keep going | `jj new` |
| Create branch | `git branch x` / `git checkout -b x` | `jj bookmark create x -r @` |
| Move branch to here | `git branch -f x` | `jj bookmark set x -r @` |
| Switch to a commit | `git checkout <sha>` | `jj edit <change>` (edit it) or `jj new <change>` (build on it) |
| Fetch | `git fetch` | `jj git fetch` |
| Push a branch | `git push -u origin x` | `jj git push -b x` |
| Rebase | `git rebase master` | `jj rebase -d trunk()` |
| Undo last action | `git reflog` + reset | `jj undo` |
| Discard a commit | `git reset --hard` | `jj abandon <change>` |
| Revert file to a rev | `git checkout <sha> -- f` | `jj restore --from <change> f` |

## Core workflows

### Make a commit
Files are already snapshotted into `@`. Just describe it:
```bash
jj describe -m "engine: add foo"     # set message on the working-copy commit
jj new                                # (optional) start the next commit on top
```
Or do both at once - `jj commit -m` describes `@` and opens a fresh `@` on top:
```bash
jj commit -m "engine: add foo"
```

### Start work from latest master
```bash
jj git fetch
jj new trunk()        # new working-copy commit on top of master@origin
```

### Put up a PR
```bash
jj commit -m "engine: add foo"        # or jj describe -m ... if you'll keep editing @
jj bookmark create mc/add-foo -r @-   # name the branch; @- is the described commit if you ran `jj new`/`commit`
jj git push -b mc/add-foo             # first push of a new bookmark works directly in jj 0.43
gh pr create --fill --head mc/add-foo # PRs go through gh, base defaults to master
```
Use the `mc/` prefix to match the user's existing bookmark convention (e.g. `mc/rrf-support-for-comp-attr`).

### Update an existing PR
Edit the change, then re-point the bookmark and push:
```bash
jj edit <change>                      # or just edit files if @ is already the PR commit
# ...make edits (auto-snapshotted)...
jj bookmark set mc/add-foo -r @       # move the bookmark to the updated commit
jj git push -b mc/add-foo             # jj rewrites the branch; force-push is implicit and safe here
```

### Rebase your work onto latest master
```bash
jj git fetch
jj rebase -d trunk()                  # rebases @ (and its descendants) onto master@origin
```
To rebase a specific change and its stack: `jj rebase -s <change> -d trunk()`.

### Split one commit into two
```bash
jj split -r <change>                  # interactive picker; for agents prefer path form:
jj split -r <change> path/to/file.rs  # first commit gets the named paths, rest stays in the second
```

### Squash a commit into its parent
```bash
jj squash -r <change>                 # fold <change> into its parent
jj squash                             # fold @ into @-
```

## Stacked PRs

jj is well suited to stacks: make a chain of commits, put a bookmark on each, push all. Each bookmark's PR base is the bookmark below it.
```bash
jj log                                # see the chain; @ at top
jj bookmark create mc/layer-1 -r <change-1>
jj bookmark create mc/layer-2 -r <change-2>
jj git push --all                     # or -b each bookmark
```
The repo also has the `gh-stack` skill for managing the PR side; prefer it when the user talks about stacked/dependent PRs. Reorder a stack with `jj rebase -r <change> --before/--after <other>`.

## Conflicts

jj records conflicts *in the commit* rather than blocking you - a rebase/squash always completes, and conflicted commits are marked in `jj log`. Resolve when convenient:
```bash
jj log                                # look for "conflict" markers
jj resolve                            # opens configured merge tool (interactive - avoid as agent)
# Agent-friendly: edit the files with conflict markers directly, save; jj clears the conflict on snapshot
jj st                                 # confirm no remaining conflicts
```
Bookmarks can also be "conflicted" (point two ways after divergent updates); fix with `jj bookmark set <name> -r <rev>`.

## Inspecting and recovering

```bash
jj log -r 'trunk()..@'                # commits between master and here
jj diff -r <change>                   # what a change touches
jj op log                             # every operation (the real undo history)
jj undo                               # reverse the last operation
jj op restore <op-id>                 # jump the whole repo back to an earlier operation
```

## Useful revsets

- `@` working copy, `@-` its parent
- `trunk()` = `master@origin` here
- `trunk()..@` your unpushed stack
- `mine()` your commits, `bookmarks()` all bookmarked commits
- `heads(::@)` the tip(s) leading to `@`

## Gotchas

- **A bookmark does not follow new commits.** After `jj new` on top of a bookmarked commit, the bookmark stays put - `jj bookmark set` to advance it before pushing.
- **`jj new` vs `jj edit`:** `new` creates a child to build on top; `edit` makes an existing commit the working copy so edits amend it. Use `edit` to fix a PR commit, `new` to add a follow-up.
- **Empty commits are fine** and common (`@` is often "(empty) (no description set)"). Not an error.
- **Immutable commits:** jj refuses to rewrite commits at/under `trunk()`. If you must, that's a signal you're editing the wrong thing - re-check the revision.
- **Don't `git commit` in a colocated repo** during a jj task; let jj own the working copy.
