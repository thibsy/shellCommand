# `thibsy` Command

## Installation

```bash
git clone git@github.com:thibsy/shellCommand.git ~/.thibsy
cd ~/.thibsy 
./install.sh
```

### Requirements

Since I was developing this with zsh (not bash) I currently require it. 

- zsh >= 5.8 (https://ohmyz.sh/)

### Usage

```bash
thibsy [command-name] [...args]
```

## Development guidlines

new (and existing) commands must follow these rules, at least the **must**-stated ones:

- all functions **must** start with `_thibsy`-prefix, otherwise functions might collide
- all global variables **must** start with `_thibsy`-prefix, otherwise they might collide
- all string-outputs **must** end with a linebreak character (`\n`).
- all commands **must** be named with `.cmd.sh` extension.
- all commands **must** refer to the installation dir via `${THIBSY_INSTALL_DIR}`.
- all commands **must** be located within `./src` (any nesting is allowed).
- all commands **must** not use reserved variable or function names, regardless the case (if unsure,
  run `which var|func` to check).
- all commands **must** at least implement a `_thibsy_main` function.
- all commands _should_ implement an `_thibsy_description` function for better help.
- all commands _should_ implement an `_thibsy_complete` function for better autocomplete.
- all commands _should_ use variables like `${this}`.
- all commands _should_ use `printf` over `echo`.
- all scripts (other than commands) _should_ be named with `.sh` extension.
- all functions _should_ at least document a brief description and what arguments they accept.

## Example

you can have a look at a sample command located in [`example.cmd.sh`](example.cmd.sh).

you'll find there are three essential functions called:

### `_thibsy_description`

this function will be called by the help command (`thibsy help`). it should print at least one string (describing the
command) if implemented.

it is possible to use indentation with `\t` and multiple lines with `\n` (or multiple print statements). note that each
output line must end with a trailing newline (`\n`).

### `_thibsy_complete`

this function will be called by the auto-completion of this command (or `complete`). it should return an array of
possible options for the command by printing it with `printf "${options[*]}"`.

as arguments, the function will receive all words of the current input line (provided by `${COMP_WORDS}` of
the `complete` command)

### `_thibsy_main`

this function is the actual implementation of the command and the only required one. all arguments which are provided
after the command name when calling `thibsy` will be passed along.
