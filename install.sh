#!/usr/bin/env bash

# This script can be called from the home directory if you wish.
# It can also be called from within its own directory.

# The script will first attempt to rename its directory to .dotfiles.
# This will only be done if it is not already called that, and when
# a directory with that name doesn't already exists.

# Then it will start overwriting the original dotfiles with symbolic
# links to the dotfiles in this directory.

# Then it will attempt to create 3 common directories in the user's
# home directory.

# Then it will create symbolic links in the ~/bin directory pointing
# to the scripts in the bin directory.

# Author: San Bergmans
# Date  : 2015

set -e

# Don't install these on FreeBSD either
if [ $(uname) == "FreeBSD" ]
then
	IGNORES="bashrc nanorc"
fi

# cd to directory holding this script
HERE="$(dirname "$0")"
cd "$HERE"
HERE=$(pwd)

# See if the directory is already called .dotfiles
# If not rename it to .dotfiles unless there's
# already a directory called .dotfiles.
if [ $(basename "$(pwd)") != ".dotfiles" ]
then
	echo
    if [ -d "../.dotfiles" ]
    then
        echo "Directory .dotfiles already exists. My directory not renamed."
    else
        echo "Renaming directory to .dotfiles."
		HERE="$(dirname $(pwd))/.dotfiles"
        mv $(pwd) "$HERE"
    fi
	echo
fi

# Install the dot files by making symbolic links
cd dots
for FILE in ./* ; do
  NAME="$(basename "$FILE")"
  DOTNAME=".${NAME}"
  # Only if it's not in the ingore list of course
  if [[ !( ${IGNORES} =~ $NAME ) ]]; then
    ln -sfv "$HERE/dots/$NAME" "${HOME}/${DOTNAME}"
  fi
done
cd ..

# Update permissions
chmod 755 ../.dotfiles

# Create some directories if they don't exist yet
mkdir -p "${HOME}/bin" "${HOME}/src" "${HOME}/tmp"


