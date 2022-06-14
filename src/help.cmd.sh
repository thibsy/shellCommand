#!/usr/bin/env bash

# DESC: this function will print all possible commands nicely.
#
# ARGS: none
function _thibsy_help_formatted() {
    # create a temporary text file to store the content of this function.
    local tmp_file=$(mktemp /tmp/thibsy_help.txt)
    # create a file descriptor to enable writing to the file with >&3 even
    # after the file has been deleted.
    exec 3>"${tmp_file}"
    # create a file descriptor to enable reading from the file with <&4 even
    # after the file has been deleted.
    exec 4<"${tmp_file}"
    # deletes the file in the directory, since the descriptors still exist
    # the data stays allocated until the references are removed, which
    # happends automatically after the script halts.
    rm "${tmp_file}"

    # declare formatation variables
    local placeholder="$(printf "%-24s" "${commanad}")"
    local indentation=" "

    printf "\n" >&3
    printf "${indentation}$(printf "%-24s" "command:")description:\n" >&3
    printf "${indentation}\n" >&3

    for file_path in ${THIBSY_COMMAND_FILES[@]}; do
        local command_name="$(_thibsy_get_command_name ${file_path})"

        # if the list should be formatted this command can be skipped,
        # listing it when calling it makes no sense.
        if [ "help" == "${command_name}" ]; then
            continue
        fi

        # fill up the command-name with spaces, so the appended description
        # will always be starting at the same character position.
        local formatted_command_name="$(printf "%-24s" "${command_name}")"

        source "${file_path}"

        # process the commands description, otherwise add an "empty" string.
        if [[ function == $(type -t _thibsy_description) ]]; then
            # it's possible there are multi-line comments, therefore
            # we split up the lines into an array.
            local command_description=($(_thibsy_description))
            local counter=0

            # loop each line and add it "formatted" to the output.
            for line in ${command_description[@]}; do
                # the first line must also contain the command name, every
                # other line afterwards shouldn't.
                if [ 0 -eq ${counter} ]; then
                    printf "${indentation}${formatted_command_name}${line}\n" >&3
                else
                    printf "${indentation}${placeholder}${line}\n" >&3
                fi

                counter=$((${counter} + 1))
            done
        else
            printf "${indentation}${formatted_command_name}-\n" >&3
        fi

        printf "${indentation}\n" >&3
    done

    less <&4
}

# DESC: this function will print all possible commands unfmroatted.
#
# ARGS: none
function _thibsy_help_unformatted() {
    local output=()
    for file_path in ${THIBSY_COMMAND_FILES[@]}; do
        output+=("$(_thibsy_get_command_name ${file_path})")
    done

    printf "${output[*]}\n"
    return "${?}"
}

# DESC: this function will list all commands within this repository and
#		list a brief description, if provided by the command_name itself.
#
# ARGS: [--list] indicates that the list must not be formatted.
function _thibsy_main() {
    local flag="${1}"

    if [ "--list" == "${flag}" ]; then
        _thibsy_help_unformatted
        return "${?}"
    fi

    _thibsy_help_formatted
    return "${?}"
}
