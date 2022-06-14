#!/usr/bin/env bash

# the ${IFS} is a constant used by bash to explode output into arrays.
# this assignment changes the default-behaviour to only split strings
# into arrays on linebreaks instead of (almost) all whitespace chars.
IFS=$'\n'

# abort if this script is not called within the repository.
if ! [ $(find $(pwd) -name "thibsy.sh") ]; then
    printf "you must call this script within it's directory.\n"
    exit 1
fi

# abort if zsh hasn't been installed yet.
if ! [ $(which zsh) ]; then
    printf "Error: we use zsh (https://ohmyz.sh) as our internal shell, please install and set it up first.\n"
    exit 1
fi

# create a zsh-profile if it doesn't already exist.
if ! [ -f "${HOME}/.zshrc" ]; then
    # oh-my-zsh normally creates a template, if it exists we can use it.
    if [ -f "${HOME}/.zshrc.example" ]; then
        cp "${HOME}/.zshrc.example" "${HOME}/.zshrc"
    else
        touch "${HOME}/.zshrc"
    fi
fi

zshrc_entries=(
    # necessary for autocompletion
    "source $(pwd)/completion.sh"
    # might need some more in the future ...
)

# add all lines to the .zshrc profile if it doesn't already exist.
for entry in ${zshrc_entries[@]}; do
    grep -qxF "${entry}" "${HOME}/.zshrc" || echo "${entry}" >> "${HOME}/.zshrc"
done

# install thibsy if it wasn't already installed beforehand.
if ! [ $(which thibsy) ]; then
    # create a symlink to the ./thibsy.sh script that is located within the
    # users local bin and mark the script as an executable.
    ln -s "$(pwd)/thibsy.sh" /usr/local/bin/thibsy
    chmod +x "$(pwd)/thibsy.sh"
fi

printf "Success: command was installed, try 'thibsy help' for possibilities.\n"
exit 0
