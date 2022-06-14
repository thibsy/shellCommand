#!/usr/bin/env bash

# the IFS is a constant used by bash to explode output into arrays.
# this assignment changes the default-behaviour to only split strings
# into arrays on linebreaks instead of (almost) all whitespace chars.
IFS=$'\n'

# DESC: this function will be called by the `complete` command when 'thibsy'
#		followed by a tab-character is entered. It must set the COMPREPLY
#		variable to an array of options that should be offered during the
#		autocompletion.
#
# OUTS: -
#
# ARGS:	-
function _thibsy_autocomplete()
{
	# if the thibsy command cannot be called it wasn't installed properly and
    # the script is halted.
    if ! [ $(which thibsy) ]; then
    	return 1
    fi

    # we can use $(which thibsy) if the command has been installed properly to
    # avoid complicatedly determining the installation directory again.
    # since the command will be symlinked, we must also use readlink here.
    local thibsy_install_dir=$(dirname $(readlink -f $(which thibsy)))

    # include the command helper and gather all the files within this repo.
    source "${thibsy_install_dir}/util/command-helper.sh"
    local thibsy_command_files=($(_thibsy_get_command_files ${thibsy_install_dir}))

	# if the command hasn't been chosen yet we can simply reply a
	# list of possible commands.
	if [ 2 -gt ${COMP_CWORD} ]; then
		COMPREPLY=($(thibsy help --list))
		return 0
	fi

	local command="${COMP_WORDS[1]}"

	# check if one of the commands matches the provided one.
    for file_path in ${thibsy_command_files[@]}; do
    	local file_name="$(_thibsy_get_command_name ${file_path})"

    	# if a command matches, the file can be included and "completed".
    	if [ "${command}" == "${file_name}" ]; then
    		source "${file_path}"
    		# apparently we cannot use 'type' command here, but this does the same.
    		if typeset -f _thibsy_complete > /dev/null; then
				COMPREPLY=($(_thibsy_complete "${COMP_WORDS[@]}"))
            	return "${?}"
            fi
    	fi
    done

    return 0
}

# register the autocomplete function for the 'thibsy' command.
complete -F _thibsy_autocomplete thibsy
