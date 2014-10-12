# --                                                            ; {{{1
#
# File        : eft.bash
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-10-12
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

set -e

# --

# NB: dialog works as well as whiptail, but these options will be
# incompatible: --*-button (is: --*-label), --scrolltext

_eft_whiptail=whiptail
_eft_exit_ok_yes=0 _eft_exit_cancel_no=1 _eft_exit_esc=255
_eft_lambda=0                                                   # TODO

_eft_show_info=--infobox       _eft_show_msg=--msgbox
_eft_show_text=--textbox            _eft_ask=--inputbox
 _eft_ask_pass=--passwordbox  _eft_ask_yesno=--yesno
     _eft_menu=--menu             _eft_check=--checklist
    _eft_radio=--radiolist        _eft_gauge=--gauge

# --

# TODO {

# CHECK_OPTS  = ['--separate-output']
# local _eft_opts=() _eft_optvals=() _eft_whip_opts=()

# } TODO

# --

# Usage: _eft_expect_args <#expect> <#got>
_eft_expect_args () {
  local expect="$1" got="$2"
  (( got >= expect )) || { echo WTF >&2; exit 1; }              # TODO
}

# Usage: _eft_opts_parse <arg(s)>
# Parses options; stops at items or choices.
# Modifies $_eft_opt{{,val}s,__*}.
# NB: shift actual args after parsing.
_eft_opts_parse () {                                            # {{{1
  local k v
  while (( $# > 0 )); do
    if [ "$1" = item -o "$1" = choice ]; then
      return 0
    elif [[ "$1" =~ [a-z]+=(.*) ]]; then
      k=( "${BASH_REMATCH[1]}" ) v=( "${BASH_REMATCH[2]}" )
      eval "\$_eft_opt__$k=\$v"
      _eft_opts+=( "$k" ); _eft_optvals+=( "$v" )
      shift
    else
      echo WTF >&2; exit 1                                      # TODO
    fi
  done
}                                                               # }}}1

# Usage: TODO
_eft_items_parse () {
  echo TODO
  # item <tag> <item> <handler>
}

# Usage: TODO
_eft_choices_parse () {
  echo TODO
  # choice <tag> <item> [true]
}

# --

# Uses $_eft_opt__*; modifies $_eft_whip_opts.
_eft_opts_all () {                                              # {{{1
  [ -z "$_eft_opt__title" ] || \
    _eft_whip_opts+=( --title "$_eft_opt__title" )
  [ -z "$_eft_opt__backtitle" ] || \
    _eft_whip_opts+=( --backtitle "$_eft_opt__backtitle" )
  [ "$_eft_opt__scroll" != true ] || \
    _eft_whip_opts+=( --scrolltext  )
}                                                               # }}}1

# Uses $_eft_opt__*; modifies $_eft_whip_opts.
_eft_opts_ok () {
  [ -z "$_eft_opt__ok_button" ] || \
    _eft_whip_opts+=( --ok-button "$_eft_opt__ok_button" )
}

# Uses $_eft_opt__*; modifies $_eft_whip_opts.
_eft_opts_cancel () {
  [ -z "$_eft_opt__cancel_button" ] || \
    _eft_whip_opts+=( --cancel-button "$_eft_opt__cancel_button" )
  [ "$_eft_opt__no_cancel" != true ] || \
    _eft_whip_opts+=( --nocancel  )
}

# Uses $_eft_opt__*; modifies $_eft_whip_opts.
_eft_opts_yes () {
  [ -z "$_eft_opt__yes_button" ] || \
    _eft_whip_opts+=( --yes-button "$_eft_opt__yes_button" )
}

# Uses $_eft_opt__*; modifies $_eft_whip_opts.
_eft_opts_no () {
  [ -z "$_eft_opt__no_button" ] || \
    _eft_whip_opts+=( --no-button "$_eft_opt__no_button" )
  [ "$_eft_opt__default_no" != true ] || \
    _eft_whip_opts+=( --default-no  )
}

# Uses $_eft_opt__*; modifies $_eft_whip_opts.
_eft_opts_menu () {
  [ -z "$_eft_opt__selected" ] || \
    _eft_whip_opts+=( --default-item "$_eft_opt__selected" )
}

# --

# Usage: eft_show_info <text> [<opt(s)>]
# show message w/o buttons, don't clear screen
eft_show_info () {
  echo Not Implemented Yet
}

# Usage: eft_show_msg <text> [on_{esc,ok}=<handler>] [<opt(s)>]
# show message w/ OK button
eft_show_msg () {
  echo Not Implemented Yet
}

# Usage: eft_show_text { file=<file> | text=<text> |
#                        text_var=<text_var_name> }
#                      [on_{esc,ok}=<handler>] [<opt(s)>]
# show file contents or text w/ OK button
eft_show_text () {
  echo Not Implemented Yet
}

# --

# Usage: eft_ask <text> [on_{esc,ok,cancel}=<handler>] [<opt(s)>]
# ask for input w/ OK/Cancel buttons (and default)
eft_ask () {
  echo Not Implemented Yet
}

# Usage: TODO
# ask for password w/ OK/Cancel buttons
eft_ask_pass () {
  echo Not Implemented Yet
}

# Usage: TODO
# ask w/ Yes/No buttons
eft_ask_yesno () {
  echo Not Implemented Yet
}

# --

# Usage: TODO
# choose from menu w/ OK/Cancel buttons
eft_menu () {
  echo Not Implemented Yet
}

# --

# Usage: TODO
# choose checkboxes w/ OK/Cancel buttons
eft_check () {
  echo Not Implemented Yet
}

# Usage: TODO
# choose radiobutton w/ OK/Cancel buttons
eft_radio () {
  echo Not Implemented Yet
}

# --

# Usage: TODO
# show gauge; call the function whose name is passed to the on_start
# handler to move it forward by passing it `percent[, message]`
eft_gauge () {
  echo Not Implemented Yet
}

# --

# Usage: TODO
_eft_whip () {
  local _eft_whip_exit _eft_whip_lines

  echo TODO

  # ...
}

# Usage: _eft_run_whip <arg(s)>
# Modifies $_eft_whip_{exit,lines}
_eft_run_whip () {                                              # {{{1
  local tempdir="$( mktemp -d )" pid
  mkfifo -m 700 "$tempdir/fifo"
  "$_eft_whiptail" "$@" > "$tempdir/fifo" & pid=$!
  _eft_whip_lines=()
  while read -r; do
    _eft_whip_lines+=( "$REPLY" )
  done < "$tempdir/fifo"
  set +e; wait "$pid"; _eft_whip_exit=$?; set -e
  rm -fr "$tempdir"
}                                                               # }}}1

# --

# Usage: TODO
_eft_file_or_temp () {
  echo TODO
}

# Usage: _eft_lambda <code>
# Modifies $_eft_lambda.
_eft_lambda () {
  local f="_eft_lambda_$_eft_lambda"
  eval "function $f () { $1; }"
  (( _eft_lambda += 1 ))
  echo "$f"
}

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
