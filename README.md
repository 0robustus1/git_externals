# git-externals

There is just some stuff git does not do for me. One of these
things is setting user/email according to the directory the
git-repository is in.

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
