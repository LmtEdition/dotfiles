#!/bin/bash
# Set up dot files on ~/ directory.

DOT_PATH=$(pwd)

# Dot files {
  if [ $(uname) == "Darwin" ]; then
    # Mac OS X platform
    full_fille=$DOT_PATH/_osxbashrc
  elif [ $(uname) == "Linux" ]; then
    # Linux platform
    full_file=$DOT_PATH/_linuxbashrc
  fi
  ln -sv "$full_file" ~/.bashrc

  for full_file in $DOT_PATH/.[^.]*; do
    filename=$(basename "$full_file")
    if [ "$filename" != ".git" ]; then
      ln -sv "$full_file" ~/$filename
    fi
  done
# }


# Fish Shell {
  # http://www.fishshell.com
  if [ ! -d ~/.config ]; then
      mkdir ~/.config
  fi
  if [ ! -d ~/.config/fish ]; then
      mkdir ~/.config/fish
  fi
  if [ ! -d ~/.config/fish/functions ]; then
      mkdir ~/.config/fish/functions
  fi

  for full_file in $DOT_PATH/fish/*.fish; do
    filename=$(basename "$full_file")
    ln -sv "$full_file" ~/.config/fish/$filename
  done

  # $ chsh -s /usr/bin/fish
  # $ fish_config to set classic+git prompt and solarized dark theme

  # Download z.fish for smarter change directory
  # https://github.com/roryokane/z-fish to ~/.config/fish/functions/z.fish
  for full_file in $DOT_PATH/fish/functions/*.fish; do
    filename=$(basename "$full_file")
    ln -sv "$full_file" ~/.config/fish/functions/$filename
  done
# }


# OSX - Homebrew, Homebrew Cask, iTerm2, MacVim {
  # Turn off system sound at startup
  # sudo nvram SystemAudioVolume=%80
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
  # $ sudo apt-get install tmux
# }


# Vim {
  # Use vim-plug manager https://github.com/junegunn/vim-plug

  # Run ctags -R to create tags file.
  #$ sudo apt-get install exuberant-ctags

  # Powerline fonts for vim-airline
  # Run the install.sh script and set the terminal's profile to use
  # the powerline font.
  #git clone https://github.com/powerline/fonts.git ~/fonts.git

  # Ag - faster grep
  # $ sudo apt-get install silversearcher-ag
# }
