#!/usr/bin/env bash

# file extension that is used to determine or distinguish commands
# within this repository from other scripts.
SUB_COMMAND_SUFFIX=".cmd.sh"

# DESC: prints the paths of all files that match the ${SUB_COMMAND_SUFFIX}
#		file extension within the given directory.
#
# ARGS: [<string>] path to directory
function _thibsy_get_command_files() {
    local directory="${1}"

    # abort if the argument is invalid.
    if [ -z "${directory}" ] || ! [ -d "${directory}" ]; then
        printf "internal error: '${directory}' does not exist or isn't a directory.\n"
        exit 1
    fi

    # search files (type f) that end with the ${SUB_COMMAND_SUFFIX}.
    local files=$(find "${directory}" -type f -name "*${SUB_COMMAND_SUFFIX}" 2>/dev/null)

    if [ 0 -eq ${#files[@]} ]; then
        printf "internal error: '${directory}' does not contain any commands ('*${SUB_COMMAND_SUFFIX}').\n"
        exit 1
    fi

    printf "${files[@]}"
    return "${?}"
}

# DESC: prints the basename of the given path without the ${SUB_COMMAND_SUFFIX}.
#
# ARGS: [<string>] path to command
function _thibsy_get_command_name() {
    local file_path="${1}"

    # abort if the argument is invalid.
    if [ -z "${file_path}" ] || ! [[ ${file_path} == *${SUB_COMMAND_SUFFIX} ]]; then
        printf "internal error: '${file_path}' have ${SUB_COMMAND_SUFFIX} file extension.\n"
        exit 1
    fi

    printf "$(basename -s "${SUB_COMMAND_SUFFIX}" "${file_path}")"
    return "${?}"
}
