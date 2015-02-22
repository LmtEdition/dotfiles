#!/bin/bash

if [ -z "$1" ]; then
  echo "Invalid command: too few arguments supplied."
  echo "Usage: $ ./git_setup.sh \"user.email\""
  exit 1
fi


# Global user settings }
  git config --global user.email "$1"
  git config --global user.name "Stanley Xu"
# }
# Global ignore {
  mkdir -p ~/.config/git
  cp ignore ~/.config/git/ignore

  git config --global core.excludesfile '~/.config/git/ignore'
# }

# Global hooks for auto ctags
  # See http://tbaggery.com/2011/08/08/effortless-ctags-with-git.html
  if [ ! -d ~/.git_template ]; then
      mkdir ~/.git_template
  fi

  cp -r ./hooks/ ~/.git_template/

  git config --global init.templatedir '~/.git_template'
# }
