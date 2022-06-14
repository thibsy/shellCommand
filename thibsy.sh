#!/usr/bin/env bash

# the ${THIBSY_VERSION} is a constant that holds the current version of
# this command. it will be used when calling the '--version' flag.
# please increase this according to https://semver.org/.
THIBSY_VERSION="1.0.0"

# if the thibsy command cannot be called it wasn't installed properly and
# the script is halted.
if ! [ $(which thibsy) ]; then
    printf "Error: you haven't properly installed this command yet, try running './install.sh' first.\n"
    exit 1
fi

# the ${IFS} is a constant used by bash to explode output into arrays.
# this assignment changes the default-behaviour to only split strings
# into arrays on linebreaks instead of (almost) all whitespace chars.
IFS=$'\n'

# the ${THIBSY_INSTALL_DIR} is a constant that must be used by included
# commands when referencing files within this repository.
THIBSY_INSTALL_DIR=$(dirname $(readlink -f $(which thibsy)))

# all helper functions should be sourced here if they are used in more
# than one command.
source "${THIBSY_INSTALL_DIR}/util/command-helper.sh"
# ...

# the ${THIBSY_COMMAND_FILES} is a constant that should be used when
# searching for something in the command files.
THIBSY_COMMAND_FILES=($(_thibsy_get_command_files ${THIBSY_INSTALL_DIR}))

# DESC: this function can be considered the bootloader of all commands
#		within this repository. it checks if the given command exists,
#		then loads and executes it. any further arguments will be passed
#		along (starting at $1 again).
#
# ARGS: [<string>] name of the command that should be executed.
#       [...<string>] further arguments for the command
#       [-v|--version] to display the current version of the command.
function _thibsy_dispatch() {
    local command="${1}"

    # shift the argument-list so that other commands can normally access it again.
    shift 2>/dev/null

    if [ -z "${command}" ]; then
        printf "Error: you must specify a command, try 'thibsy help' for possible options.\n"
        exit 1
    fi

    # print the version and author if the according flag has been provided.
    if [ "--version" == "${command}" ] || [ "-v" == "${command}" ]; then
        printf "version ${THIBSY_VERSION} by thibeau fuhrer <fuhrer@thibeau.ch>\n"
        exit 0
    fi

    # loop over each file path and check if the provided command
    # matches one of the basenames (without suffix).
    for file_path in ${THIBSY_COMMAND_FILES[@]}; do
        local command_name="$(_thibsy_get_command_name "${file_path}")"
        if ! [ "${command}" == "${command_name}" ]; then
            continue
        fi

        source "${file_path}"

        # call the main function if it exists, otherwise abort.
        if [[ function == $(type -t _thibsy_main) ]]; then
            _thibsy_main "${@}"
            exit "${?}"
        else
            printf "internal error: '${file_path}' does not implement a _thibsy_main function.\n"
            exit 1
        fi
    done

    printf "the command '${command}' wasn't found, try 'thibsy help' for possible options.\n"
    exit 1
}

# call the dispatch function with all provided arguments.
_thibsy_dispatch "${@}"
