{ pkgs, ... }:

let
    ponytail_version = "v5.3.2";
    ponytail_hash = "sha256-IJlhfkdXI6pMZZCZO7XBRg88LBiNfzc5Gnm4ofGybL8=";
in {
    programs.claude-code = {
        enable = true;
        package = pkgs.unstable.claude-code;
        settings.enabledPlugins = {
            "superpowers@claude-plugins-official" = true;
            "context7@claude-plugins-official" = true;
            "modern-web-guidance@claude-plugins-official" = true;
            "ponytail@ponytail" = true;
            # LSPs
            "typescript-lsp@claude-plugins-official" = true;
            "rust-analyzer-lsp@claude-plugins-official" = true;
        };

        marketplaces = {
            ponytail = pkgs.fetchFromGitHub {
                owner = "dietrichgebert";
                repo = "ponytail";
                rev = ponytail_version;
                hash = ponytail_hash;
            };
        };

        skills.git-workflow = ''
---
name: git-workflow
description: Rules for working with git in any coding session. Use this skill whenever you are about to touch a git repository, including creating branches, staging files, committing, or writing commit messages, even if the user only asks you to "make a change", "fix a bug", or "save your work" without mentioning git. Every session starts on its own new branch, commits stay small and easy to review, and every commit message states the context and the reason for the change.
---

# Git Workflow

Three rules govern all git work:

1. Every session gets its own new branch.
2. Every commit is small and easy to review.
3. Every commit message states the **context** and the **reason**, both short.

The goal is a history a reviewer can read commit by commit and understand quickly: what situation prompted each change, and why it was made.

## 1. Start every session on a new branch

Never work directly on `main`, `master`, or any shared branch, and never reuse a branch from an earlier session. A fresh branch keeps each session's work isolated, easy to review as one unit, and easy to discard if needed.

At the start of the session, before editing any file:

```bash
git status                      # make sure the working tree is clean
git fetch origin
git switch <default-branch>     # usually main
git pull --ff-only
git switch -c <type>/<short-description>
```

If the working tree is not clean, stop and ask the user what to do with the existing changes rather than carrying them onto the new branch or discarding them.

Branch naming: `<type>/<short-kebab-description>`, for example `fix/login-timeout`, `feat/csv-export`, `refactor/user-service`, `docs/setup-guide`, `chore/bump-deps`. Keep it under about 40 characters. If the name already exists, add a short suffix (`fix/login-timeout-2`) instead of reusing the old branch.

## 2. Keep commits small and easy to review

A commit should contain one logical change: one fix, one refactor step, one new function with its tests. A reviewer should be able to understand it in a minute or two.

Guidelines:

- Commit as you go, not all at once at the end of the session.
- Separate kinds of change. Formatting, renames, and moves go in their own commits, never mixed with behavior changes, because they bury the meaningful lines.
- Split refactoring from the feature or fix that depends on it: refactor first, then build on it.
- Keep tests with the code they test, in the same commit.
- As a rough guide, aim for under ~100 changed lines. Larger is fine only when the change truly cannot be split (e.g. generated files, a single large rename).
- Each commit should leave the project in a working state (builds, tests pass) where practical.

Stage deliberately, never with a blanket `git add .` or `git commit -a`:

```bash
git add -p                 # review and stage hunks one by one
git diff --staged          # confirm exactly what will be committed
```

Before each commit, ask: "Does this diff do exactly one thing?" If the honest answer needs the word "and", split it.

## 3. Commit message: context and reason

Every commit message has a subject line plus two short labeled fields.

```
<type>: <what changed, imperative, ≤ 50 chars>

Context: <the situation that prompted the change, one short sentence>
Reason: <why this change is the right response, one short sentence>
```

Rules:

- **Subject**: imperative mood ("Add", "Fix", "Remove"), no trailing period, 50 characters or fewer. Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `style`, `perf`.
- **Context**: what was true before, or what problem or request triggered the change. One sentence, ideally under ~15 words.
- **Reason**: why this change was made and what it achieves. One sentence, ideally under ~15 words.
- Do not restate the diff. The code shows *what*; the message explains *where it came from* and *why*.
- Do not pad with filler ("This commit...", "In order to..."). Short and concise wins.

Commit with both fields as separate paragraphs:

```bash
git commit -m "fix: retry token refresh on 401" \
           -m "Context: Sessions expired mid-request when tokens lapsed." \
           -m "Reason: A single retry keeps users logged in without a reload."
```

### Examples

Good:

```
fix: handle empty CSV upload

Context: Uploading an empty file crashed the import worker.
Reason: Rejecting it early gives users a clear error instead.
```

```
refactor: extract price calculation into helper

Context: Checkout and invoice duplicated the same pricing logic.
Reason: One shared helper prevents the two from drifting apart.
```

```
chore: pin eslint to 8.57

Context: CI broke after eslint 9 changed its config format.
Reason: Pinning restores CI until the config is migrated.
```

Bad, and why:

```
update stuff
```
No context, no reason, vague subject.

```
fix: change timeout from 30 to 60 and also rename vars and update README

Context: The timeout was 30 seconds and I changed it to 60 seconds in config.ts.
Reason: Because it needed to be changed.
```
Three changes in one commit, the context restates the diff, and the reason explains nothing.

## Session checklist

- [ ] Clean working tree confirmed, default branch updated
- [ ] New branch created for this session
- [ ] Each commit does one thing and is staged with `git add -p`
- [ ] Each message has a ≤ 50-char subject, a one-line Context, and a one-line Reason
- [ ] No commits made to the default branch 
            '';
    };

    home.packages = [
        pkgs.typescript-language-server
        pkgs.nodejs
    ];
}
