#!/bin/bash
# Set up dot files on ~/ directory.

DOT_PATH=$(pwd)

# Dot files {
  for full_file in $DOT_PATH/.[^.]*; do
      filename=$(basename "$full_file")
      echo "Linking $full_file to ~/$filename"
      ln -s "$full_file" ~/$filename
  done
# }


# Fish Shell {
  # http://www.fishshell.com
  for full_file in $DOT_PATH/fish/*.fish; do
    filename=$(basename "$full_file")
    echo "Linking $full_file to ~/.config/fish/$filename"
    ln -s "$full_file" ~/.config/fish/$filename
  done
# }


# OSX - Homebrew, iTerm2, MacVim {
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

  # Solarized for tmux {
    # https://github.com/altercation/solarized/tree/master/tmux
  # }

  # Solarized for vim {
    # https://github.com/altercation/solarized/blob/master/vim-colors-solarized/colors/solarized.vim
  # }
# }


# Tmux {
  # $ sudo apt-get install tmux
# }


# Vim {
    # Run ctags -R to create tags file.
    #$ sudo apt-get install exuberant-ctags

    # Powerline fonts for vim-airline
    # Run the install.sh script and set the terminal's profile to use
    # the powerline font.
    #git clone https://github.com/powerline/fonts.git ~/fonts.git

    # Ag - faster grep
    # $ sudo apt-get install silversearcher-ag

    # Symlink colorschemes to ~/.vim/colors
    full_file="$DOT_PATH/vim/colors"
    echo "Linking $full_file to ~/.vim/colors"
    ln -s "$full_file" ~/.vim/
# }
