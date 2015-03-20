#!/bin/bash

if [ -z "$1" ]; then
  echo "Invalid command: too few arguments supplied."
  echo "Usage: $ ./git_setup.sh \"user.email\""
  exit 1
fi


# Global user settings }
  git config --global user.email "$1"
  git config --global user.name "Stanley Xu"

  # Use vimdiff for merge conflicts.
  git config --global merge.tool vimdiff
  git config --global merge.conflictstyle diff3
  git config --global mergetool.prompt false
  git config --global mergetool.keepBackup false # Don't keep .orig files.
# }

# Global ignore {
  # ./setup.sh should symlink the file already
  #cp .gitignore_global ~/.gitignore_global

  git config --global core.excludesfile '~/.gitignore_global'
# }

# [DEPRECATED] - Using vim-gutentags now.
# Global hooks for auto ctags
  # See http://tbaggery.com/2011/08/08/effortless-ctags-with-git.html
  #mkdir -p ~/.git_template

  #cp -r ./hooks/ ~/.git_template/

  #git config --global init.templatedir '~/.git_template'
# }
