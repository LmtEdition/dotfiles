#!/bin/bash
# Set up dot files on ~/ directory.

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
      ln -sv "$full_file" ~/$filename
    fi
  done
# }


# Fish Shell {
  # http://www.fishshell.com
  # Nightly builds - latest version https://github.com/fish-shell/fish-shell/wiki/Nightly-builds
  if [ $(uname) == "Darwin" ]; then
    brew install fish --HEAD
    chsh -s $HOME/homebrew/bin/fish
  elif [ $(uname) == "Linux" ]; then
    sudo add-apt-repository ppa:fish-shell/nightly-master
    sudo apt-get update
    sudo apt-get install fish
    chsh -s /usr/bin/fish
  fi

  if [ ! -d ~/.config ]; then
      mkdir ~/.config
  fi
  if [ ! -d ~/.config/fish ]; then
      mkdir ~/.config/fish
  fi
  if [ ! -d ~/.config/fish/functions ]; then
      mkdir ~/.config/fish/functions
  fi

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
  if [ $(uname) == "Darwin" ]; then
    sudo nvram SystemAudioVolume=%80
  fi
# }


# Solarized Colorscheme {
  # https://github.com/altercation/solarized
  # Solarized dark for Gnome terminal {
    # Create a new user profile named 'solarized'.
    # https://github.com/Anthony25/gnome-terminal-colors-solarized
    # $ git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git
    # $ sudo apt-get install dconf-cli
    # $ cd gnome-terminal-colors-solarized/
    # $ ./install.sh
  # }

  # Solarized for GNU ls {
    # https://github.com/seebi/dircolors-solarized
    # Download the dircolors.256dark by seebi
    # Link the file to ~/.dir_colors and include the following line in
    # your ~/.profile (bash) or ~/.zshrc (zsh)
    # eval `dircolors ~/.dir_colors/dircolors.256dark`
  # }

  # Solarized for OSX {
    # https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized
  # }

  # Solarized for tmux {
    # https://github.com/altercation/solarized/tree/master/tmux
  # }

  # Solarized for vim {
    # https://github.com/altercation/solarized/blob/master/vim-colors-solarized/
  # }
# }


# Tmux {
  if [ $(uname) == "Darwin" ]; then
    brew install tmux
  elif [ $(uname) == "Linux" ]; then
    sudo apt-get install tmux
  fi
# }


# Vim {
  # Use vim-plug manager https://github.com/junegunn/vim-plug

  # Create undodir if it doesn't exist
  if [ ! -d ~/.vim/undodir ]; then
      mkdir ~/.vim/undodir
  fi

  # Run ctags -R to create tags file.
  if [ $(uname) == "Darwin" ]; then
     brew install ctags-exuberant
  elif [ $(uname) == "Linux" ]; then
    sudo apt-get install exuberant-ctags
  fi

  # Powerline fonts for vim-airline
  # Run the install.sh script and set the terminal's profile to use
  # the powerline font.
  #git clone https://github.com/powerline/fonts.git ~/fonts.git

  # Ag - faster grep
  if [ $(uname) == "Darwin" ]; then
    brew install the_silver_searcher
  elif [ $(uname) == "Linux" ]; then
    sudo apt-get install silversearcher-ag
  fi
# }
