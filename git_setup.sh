#!/bin/bash

# Global user settings }
  git config --global user.email "stanley.wux@gmail.com"
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
