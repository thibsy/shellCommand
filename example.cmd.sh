#!/usr/bin/env bash

# DESC: this function will be called by the help command or if appended
#       by the --help flag (automatically). it should describe the command
#       and it's options briefly.
#
# ARGS:	none
function _thibsy_description() {
    printf "this is just an example command, it prints what you enter (and optionally pre- or appends some other strings).\n"
    printf "options:\n"
    printf "\t[<string>]\t\tto display this in the terminal.\n"
    printf "\t[-a|--append <string>]\tto append something to the given string.\n"
    printf "\t[-p|--prepend <string>]\tto prepend something to the given string.\n"
    printf "\t[-h|--help <string>]\tto display this info (again).\n"
}

# DESC: this function will be called by completion.sh and sets the
# 		autocompletion reply if this command has been chosen.
#
# ARGS:	[...<string>] the current bash-words of the input line (${COMP_WORDS}).
function _thibsy_complete() {
    local arguments=()

    if ! [[ "${@}" =~ "-a" ]] || ! [[ "${@}" =~ "--append" ]]; then
        arguments+=("--append")
    fi

    if ! [[ "${@}" =~ "-p" ]] || ! [[ "${@}" =~ "--prepend" ]]; then
        arguments+=("--prepend")
    fi

    if ! [[ "${@}" =~ "-h" ]] || ! [[ "${@}" =~ "--help" ]]; then
        arguments+=("--help")
    fi

    printf "${arguments[*]}"
    return "${?}"
}

# DESC: this function will be called by the main command (or function).
#       it accepts a few arguments and prints the given string.
#
# ARGS:	[<string>] any text that should be displyed
#       [-a|--append <string>] appends a string to the one to be displayed.
#       [-p|--prepend <string>] prepends a string to the one to be displayed.
#       [-h|--help] will display the help instead of executing the command.
function _thibsy_main() {
    # display the command description if one of the arguments is '-h|--help'.
    if [[ "${*}" =~ "-h" ]] || [[ "${*}" =~ "--help" ]]; then
        _thibsy_description
        return "${?}"
    fi

    while [ 1 -le ${#} ]; do
        case "${1}" in
        -a | --append)
            local append="${2}"
            shift 2>/dev/null
            ;;
        -p | --prepend)
            local prepend="${2}"
            shift 2>/dev/null
            ;;
        *) output="${1}" ;;
        esac

        shift 2>/dev/null
    done

    local output="${prepend}${output}${append}"

    if [ -z "${output}" ]; then
        printf "you must enter a string to be printed.\n"
    else
        printf "%q\n" "${output}"
    fi

    return "${?}"
}
