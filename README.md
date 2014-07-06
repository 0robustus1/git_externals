# git-externals

There is just some stuff git does not do for me. One of these
things is setting user/email according to the directory the
git-repository is in.

## git rr-init/clone - initialize with user set

**Scriptfile:** *clone_init.rb*

For better illustration:
I have one directory which contains everything i do at the
university and one directory for everything i do privately.
I use different names and email-addresses for the git-repositories
which lie inside these directories.

This repository contains a script which will perform actions like
this with external commands for `git init` and `git clone`.

To set it up just symlink the `clone_init.rb` as `git-rr-init` and
`git-rr-clone` into your PATH. Now you'll need a config file.
The config is placed here: `~/gitconfs/users`
It looks somewhat like this:
```
[~/uni/]
  name  = Mr Somewhat
  email = somewhat@example.com
[~/projects/]
  name  = Full Name Somehwat
  email = somewhat@private_example.com
```

Now you just need to clone/init your repositories with `git rr-clone`
or `git rr-init`. Both take the same options as their git-core counterparts.

## git co-back

**Scriptfile:** *co_back.sh*

Do you know the situation, where you just want to jump into a branch check
some stuff, maybe perform a commit and then just want to jump back to the
branch you came from?

Well `git co-back` does just this. It jumps to the branch you came from.
This utilizes reflog so multiple `co-back` calls to get to the n-latest
checkout will *not* work.

## git history-files

**Scriptfile:** *history_files.sh*

Will list all files that were ever checked in to version control (read: part
of a commit). However this will only track the commits from the current
branch-HEAD to its first commit (which is probably what you want, since
deletion from history can only be achieved via rebasing/filter-branch).

## git latest-branches

**Scriptfile:** *latest_branches.sh*

Will list the latest *n*-branches you checked out. *n* will default to 10 but
can be adjusted via the `-l`-switch:
`git latest-branches -l 20`.

## git open-branches-i-contributed-to

**Scriptfile:** *open_branches_i_contributed_to.sh*

Lists all unmerged branches that *you* have commits in. You will
need to define a basebranch, which is the (hopefully) common basebranch
all your branches are based on. So it will only factor in commits that
are unique to this branch.

Usage: `git open-branches-i-contributed-to master`
