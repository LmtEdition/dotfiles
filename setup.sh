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


# OSX - Homebrew, Homebrew Cask, iTerm2, MacVim {
# Add this to ~/.bash_profile:
#   if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
# b/c OSX treats interactive shells as login shell.
  # Turn off system sound at startup
  if [ "$FRESH_INSTALL" = true ]; then
    if [ $(uname) == "Darwin" ]; then
      mkdir ~/homebrew && curl -L https://github.com/Homebrew/homebrew/tarball/master | tar xz --strip 1 -C ~/homebrew
      sudo nvram SystemAudioVolume=%80
    elif [ $(uname) == "Linux" ]; then
      # Linuxbrew: http://brew.sh/linuxbrew/
      # Installs to ~/.linuxbrew
      sudo apt-get install build-essential curl git m4 ruby texinfo libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
      sudo apt-get install build-essential
    fi
  fi
# }


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

  # Neovim config.
  ln -sv $DOT_PATH/.vimrc ~/.nvimrc
# }


# Fish Shell {
  # http://www.fishshell.com
  # Nightly builds - latest version https://github.com/fish-shell/fish-shell/wiki/Nightly-builds
  if [ "$FRESH_INSTALL" = true ]; then
    if [ $(uname) == "Darwin" ]; then
      # NOTE: Add $HOME/homebrew/bin/fish to /etc/shells
      brew install fish --HEAD
      chsh -s $HOME/homebrew/bin/fish
    elif [ $(uname) == "Linux" ]; then
      # NOTE: Add $HOME/.linuxbrew/bin/fish to /etc/shells
      brew install fish --HEAD
      chsh -s $HOME/.linuxbrew/bin/fish
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
  # $ fish_update_completions to add manpage completions.

  # Download z.fish for smarter change directory
  # https://github.com/roryokane/z-fish to ~/.config/fish/functions/z.fish
  # fish function files
  for full_file in $DOT_PATH/fish/functions/*.fish; do
    filename=$(basename "$full_file")
    ln -sv "$full_file" ~/.config/fish/functions/$filename
  done
# }


# Terminals {
  # Gnome terminal {
    # Fullscreen: set the Default terminal size in Profile Preferences go
    # something very large.

    # Font: Droid Sans Mono for Powerline
  # }
# }


# Solarized Colorscheme {
  # https://github.com/altercation/solarized
  # Solarized dark for Gnome terminal {
    # Create a new user profile named 'solarized'.
    # Select the dark theme.
    # https://github.com/Anthony25/gnome-terminal-colors-solarized
    if [ "$FRESH_INSTALL" = true ] && [ $(uname) == "Linux" ]; then
      GNOME_SOLARIZED_DIR="$HOME/gnome-terminal-colors-solarized"
      git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git "$GNOME_SOLARIZED_DIR"
      sudo apt-get install dconf-cli
      cd "$GNOME_SOLARIZED_DIR" && ./install.sh
    fi
  # }

  # Solarized for GNU ls {
    # NOTE: gnome-terminal-colors-solarized install.sh includes dircolors,
    # so no need for this step on Ubuntu.
    # https://github.com/seebi/dircolors-solarized
    # Download the dircolors.ansi-dark by seebi
    # Link the file to ~/.dir_colors and include the following line in
    # your ~/.profile (bash) or ~/.zshrc (zsh)
    # eval `dircolors ~/.dir_colors/dircolors.ansi-dark`
  # }

  # Solarized for OSX {
    # https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized
  # }

  # Solarized for tmux {
    # https://github.com/altercation/solarized/tree/master/tmux
    # NOTE: Included in my .tmux.conf file.
  # }

  # Solarized for vim {
    # https://github.com/altercation/solarized/blob/master/vim-colors-solarized/
    # NOTE: Included in my .vimrc plugin manager.
  # }
# }


# Tmux {
  if [ "$FRESH_INSTALL" = true ]; then
    brew install tmux
  fi
# }


# [Neo]vim {
  # Install Neovim.
  if [ "$FRESH_INSTALL" = true ]; then
    if [ $(uname) == "Linux" ]; then
      sudo apt-get install python-setuptools libtool
    fi
    brew tap neovim/homebrew-neovim
    brew install --HEAD neovim

    # Python 2 support for neovim.
    sudo apt-get install python-dev python-pip
    sudo pip install neovim
  fi

  # Use vim-plug manager https://github.com/junegunn/vim-plug.
  if [ "$FRESH_INSTALL" = true ]; then
    curl -fLo ~/.nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  # Create undodir if it doesn't exist.
  mkdir -p ~/.vim/undodir
  mkdir -p ~/.nvim/undodir

  # Run ctags -R to create tags file.
  if [ "$FRESH_INSTALL" = true ]; then
    brew install ctags-exuberant
  fi

  # Ag - faster grep.
  if [ "$FRESH_INSTALL" = true ]; then
    brew install the_silver_searcher
  fi

  # Powerline fonts for vim-airline.
  # Run the install.sh script and set the terminal's profile to use
  # the powerline font.
  if [ "$FRESH_INSTALL" = true ]; then
    git clone https://github.com/powerline/fonts.git ~/fonts.git
    cd ~/fonts.git && ./install.sh
  fi
# }
