#!/bin/bash
# Set up dot files on ~/ directory.
FRESH_INSTALL=false
if [ "$1" == "new" ]; then
  FRESH_INSTALL=true
elif [ ! -z "$1" ]; then
  echo "Usage: ./setup.sh [new]...............[new] if you want fresh install"
  exit
fi

DOT_PATH=$(pwd)

# Dot files {
  # bashrc file
  if [ $(uname) == "Darwin" ]; then
    # Mac OS X platform
    full_file=$DOT_PATH/_osxbashrc
  elif [ $(uname) == "Linux" ]; then
    # Linux platform
    full_file=$DOT_PATH/_linuxbashrc
  fi
  ln -sv "$full_file" ~/.bashrc

  # Symlink dot files, excluding the .git repo
  for full_file in $DOT_PATH/.[^.]*; do
    filename=$(basename "$full_file")
    if [ "$filename" != ".git" ]; then
      ln -sv "$full_file" ~/
    fi
  done
# }


# Fish Shell {
  # http://www.fishshell.com
  # Nightly builds - latest version https://github.com/fish-shell/fish-shell/wiki/Nightly-builds
  if [ "$FRESH_INSTALL" = true ]; then
    if [ $(uname) == "Darwin" ]; then
      brew install fish --HEAD
      chsh -s $HOME/homebrew/bin/fish
    elif [ $(uname) == "Linux" ]; then
      sudo add-apt-repository ppa:fish-shell/nightly-master
      sudo apt-get update
      sudo apt-get install fish
      chsh -s /usr/bin/fish
    fi
  fi

  # Create fish config directories
  mkdir -p ~/.config/fish/functions

  # fish config files
  for full_file in $DOT_PATH/fish/*.fish; do
    filename=$(basename "$full_file")
    ln -sv "$full_file" ~/.config/fish/$filename
  done

  # $ fish_config to set classic+git prompt and solarized dark theme

  # Download z.fish for smarter change directory
  # https://github.com/roryokane/z-fish to ~/.config/fish/functions/z.fish
  # fish function files
  for full_file in $DOT_PATH/fish/functions/*.fish; do
    filename=$(basename "$full_file")
    ln -sv "$full_file" ~/.config/fish/functions/$filename
  done
# }


# OSX - Homebrew, Homebrew Cask, iTerm2, MacVim {
  # Turn off system sound at startup
  if [ "$FRESH_INSTALL" = true ]; then
    if [ $(uname) == "Darwin" ]; then
      sudo nvram SystemAudioVolume=%80
    fi
  fi
# }


# Solarized Colorscheme {
  # https://github.com/altercation/solarized
  # Solarized dark for Gnome terminal {
    # Create a new user profile named 'solarized'.
    # Select the dark theme.
    # https://github.com/Anthony25/gnome-terminal-colors-solarized
    if [ "$FRESH_INSTALL" = true ] && [ $(uname) == "Linux" ]; then
      git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git
      sudo apt-get install dconf-cli
      cd ~/gnome-terminal-colors-solarized/ && ./install.sh
    fi
  # }

  # Solarized for GNU ls {
    # https://github.com/seebi/dircolors-solarized
    # Download the dircolors.256dark by seebi
    # Link the file to ~/.dir_colors and include the following line in
    # your ~/.profile (bash) or ~/.zshrc (zsh)
    # eval `dircolors ~/.dir_colors/dircolors.256dark`
    # Note: I now include the file in my dotfiles repo and symlink it.
  # }

  # Solarized for OSX {
    # https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized
  # }

  # Solarized for tmux {
    # https://github.com/altercation/solarized/tree/master/tmux
    # Included in my .tmux.conf file.
  # }

  # Solarized for vim {
    # https://github.com/altercation/solarized/blob/master/vim-colors-solarized/
    # Included in my .vimrc plugin manager.
  # }
# }


# Tmux {
  if [ $"FRESH_INSTALL" = true ]; then
    if [ $(uname) == "Darwin" ]; then
      brew install tmux
    elif [ $(uname) == "Linux" ]; then
      sudo apt-get install tmux
    fi
  fi
# }


# Vim {
  # Use vim-plug manager https://github.com/junegunn/vim-plug

  # Create undodir if it doesn't exist
  mkdir -p ~/.vim/undodir

  # Run ctags -R to create tags file.
  if [ $"FRESH_INSTALL" = true ]; then
    if [ $(uname) == "Darwin" ]; then
      brew install ctags-exuberant
    elif [ $(uname) == "Linux" ]; then
      sudo apt-get install exuberant-ctags
    fi
  fi

  # Powerline fonts for vim-airline
  # Run the install.sh script and set the terminal's profile to use
  # the powerline font.
  if [ $"FRESH_INSTALL" = true ]; then
    git clone https://github.com/powerline/fonts.git ~/fonts.git
    cd ~/fonts.git && ./install.sh
  fi

  # Ag - faster grep
  if [ $"FRESH_INSTALL" = true ]; then
    if [ $(uname) == "Darwin" ]; then
      brew install the_silver_searcher
    elif [ $(uname) == "Linux" ]; then
      sudo apt-get install silversearcher-ag
    fi
  fi
# }
