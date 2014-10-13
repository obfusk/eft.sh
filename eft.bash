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

_eft_opts=() _eft_check_opts=( --separate-output )

# --

# Usage: eft_show_info <text> [<opt(s)>]
# show message w/o buttons, don't clear screen
eft_show_info () {
  local text="$1"; _eft_expect_args 1 $#; shift 1
  _eft_opts_parse _eft_show_info_cont "$@"
}
_eft_show_info_cont () {
  _eft_whip '' "$_eft_show_info" "$text" no
}

# Usage: eft_show_msg <text> [<opt(s)>] [on_{esc,ok}=<handler>]
# show message w/ OK button
eft_show_msg () {
  local text="$1"; _eft_expect_args 1 $#; shift 1
  _eft_opts_parse _eft_show_msg_cont "$@"
}
_eft_show_msg_cont () {
  _eft_whip _eft_show_msg_ok "$_eft_show_msg" "$text" no
}
_eft_show_msg_ok () {
  _eft_call "$_eft_opt__on_ok"
}

# Usage: eft_show_text [<opt(s)>]
#        { file=<file> | text=<text> } [on_{esc,ok}=<handler>]
# show file contents or text w/ OK button
eft_show_text () {
  _eft_opts_parse _eft_show_text_cont "$@"
}
_eft_show_text_cont () {
  _eft_file_or_temp _eft_show_text_w_file
}
_eft_show_text_w_file () {
  _eft_whip _eft_show_text_ok "$_eft_show_text" "$1" no
}
_eft_show_text_ok () {
  _eft_call "$_eft_opt__on_ok"
}

# --

# Usage: eft_ask <text> [<opt(s)>] [on_{esc,ok,cancel}=<handler>]
# ask for input w/ OK/Cancel buttons (and default)
eft_ask () {
  local text="$1"; _eft_expect_args 1 $#; shift 1
  _eft_opts_parse _eft_ask_cont "$@"
}
_eft_ask_cont () {
  local a=()
  [ -z "$_eft_opt__default" ] || a+=( "$_eft_opt__default" )
  _eft_whip _eft_ask_ok "$_eft_ask" "$text" no "${a[@]}"
}
_eft_ask_ok () {
  _eft_call "$_eft_opt__on_ok" "$1"
}

# Usage: eft_ask_pass <text> [<opt(s)>] [on_{esc,ok,cancel}=<handler>]
# ask for password w/ OK/Cancel buttons
eft_ask_pass () {
  local text="$1"; _eft_expect_args 1 $#; shift 1
  _eft_opts_parse _eft_ask_pass_cont "$@"
}
_eft_ask_pass_cont () {
  _eft_whip _eft_ask_pass_ok "$_eft_ask_pass" "$text" no
}
_eft_ask_pass_ok () {
  _eft_call "$_eft_opt__on_ok" "$1"
}

# Usage: eft_ask_yesno <text> [<opt(s)>] [on_{esc,yes,no}=<handler>]
# ask w/ Yes/No buttons
eft_ask_yesno () {
  local text="$1"; _eft_expect_args 1 $#; shift 1
  _eft_opts_parse _eft_ask_yesno_cont "$@"
}
_eft_ask_yesno_cont () {
  _eft_whip _eft_ask_yesno_yes "$_eft_ask_yesno" "$text" no
}
_eft_ask_yesno_yes () {
  _eft_call "$_eft_opt__on_yes"
}

# --

# Usage: eft_menu <text> [<opt(s)>]
#        [on_{esc,ok,cancel}=<handler>] <item(s)>
# choose from menu w/ OK/Cancel buttons
eft_menu () {
  local text="$1"; _eft_expect_args 1 $#; shift 1
  _eft_opts_parse _eft_menu_cont "$@"
}
_eft_menu_cont () {
  local _eft_opt__selected_="$_eft_opt__selected"
  local _eft_opt__subheight="$_eft_opt__menu_height"
  _eft_items_parse _eft_menu_w_items "$@"
}
_eft_menu_w_items () {
  _eft_whip _eft_menu_ok "$_eft_menu" "$text" yes \
    "${_eft_menu_args[@]}"
}
_eft_menu_ok () {                                               # {{{1
  local tag="$1" n="${#_eft_menu_tags[@]}" i
  for (( i = 0; i < n; ++i )); do
    if [ "$tag" = "${_eft_menu_tags[$i]}" ]; then
      _eft_call "${_eft_menu_handlers[$i]}" "$tag"
      return
    fi
  done
  _eft_die TAG_WTF                                              # TODO
}                                                               # }}}1

# --

# Usage: eft_check <text> [<opt(s)>]
#        [on_{esc,ok,cancel}=<handler>] <choice(s)>
# choose checkboxes w/ OK/Cancel buttons
eft_check () {
  local text="$1"; _eft_expect_args 1 $#; shift 1
  _eft_opts_parse _eft_check_cont "$@"
}
_eft_check_cont () {
  local _eft_opt__subheight="$_eft_opt__list_height"
  _eft_check_choices_parse _eft_check_w_choices "$@"
}
_eft_check_w_choices () {
  _eft_whip _eft_check_ok "$_eft_check" "$text" yes \
    "${_eft_check_args[@]}"
}
_eft_check_ok () {
  _eft_call "$_eft_opt__on_ok" "$@"
}

# Usage: eft_radio <text> [<opt(s)>]
#        [on_{esc,ok,cancel}=<handler>] <choice(s)>
# choose radiobutton w/ OK/Cancel buttons
eft_radio () {
  local text="$1"; _eft_expect_args 1 $#; shift 1
  _eft_opts_parse _eft_radio_cont "$@"
}
_eft_radio_cont () {
  local _eft_opt__subheight="$_eft_opt__list_height"
  _eft_radio_choices_parse _eft_radio_w_choices "$@"
}
_eft_radio_w_choices () {
  _eft_whip _eft_radio_ok "$_eft_radio" "$text" yes \
    "${_eft_radio_args[@]}"
}
_eft_radio_ok () {
  _eft_call "$_eft_opt__on_ok" "$1"
}


# --

# Usage: TODO
# show gauge; call the function whose name is passed to the on_start
# handler to move it forward by passing it `percent[, message]`
eft_gauge () {
  echo Not Implemented Yet
}

# --

# Usage: _eft_expect_args <#expect> <#got>
_eft_expect_args () {
  local expect="$1" got="$2"
  (( got >= expect )) || _eft_die EXPECT_WTF                    # TODO
}

# Usage: _eft_opts_parse <handler> <arg(s)>
# parse options; stop at items or choices;
# modifies $_eft_{{,whip_}opts,opt__*}
_eft_opts_parse () {                                            # {{{1
  _eft_opts_clean
  local handler="$1" k v _eft_opts=() _eft_whip_opts=(); shift
  while (( $# > 0 )); do
    if [ "$1" = item -o "$1" = choice ]; then
      break
    elif [[ "$1" =~ ^([a-z_]+)=(.*)$ ]]; then
      k=( "${BASH_REMATCH[1]}" ) v=( "${BASH_REMATCH[2]}" )
      local "_eft_opt__$k=$v"; _eft_opts+=( "$k" ); shift
    else
      _eft_die PARSE_WTF                                        # TODO
    fi
  done
  "$handler" "$@"
}                                                               # }}}1

_eft_opts_clean () {
  local k; for k in "${_eft_opts[@]}"; do unset "_eft_opt__$k"; done
}

# Usage: _eft_items_parse <handler> <arg(s)>
# parse items; modifies $_eft_menu_{arg,tag,handler}s
_eft_items_parse () {                                           # {{{1
  local handler="$1"; shift
  local _eft_menu_args=() _eft_menu_tags=() _eft_menu_handlers=()
  while (( $# > 0 )); do
    # item <tag> <item> <handler>
    [ "$1" = item ] || _eft_die ITEM_NO_ITEM_WTF                # TODO
    [ "$#" -ge 4 ] || _eft_die ITEM_MISSING_WTF                 # TODO
    _eft_menu_args+=(     "$2" "$3" )
    _eft_menu_tags+=(     "$2"      )
    _eft_menu_handlers+=( "$4"      )
    shift 4
  done
  "$handler"
}                                                               # }}}1

# Usage: _eft_check_choices_parse <handler> <arg(s)>
# parse choices; modifies $_eft_check_args
_eft_check_choices_parse () {                                   # {{{1
  local handler="$1" _eft_check_args=() n s; shift
  while (( $# > 0 )); do
    # choice <tag> <item> [true]
    [ "$1" = choice ] || _eft_die CHOICE_NO_CHOICE_WTF          # TODO
    [ "$#" -ge 3 ] || _eft_die CHOICE_MISSING_WTF               # TODO
    if [ "$4" = true ]; then n=4; s=on; else n=3; s=off; fi
    _eft_check_args+=( "$2" "$3" "$s" )
    shift "$n"
  done
  "$handler"
}                                                               # }}}1

# Usage: _eft_radio_choices_parse <handler> <arg(s)>
# parse choices; modifies $_eft_radio_args
_eft_radio_choices_parse () {                                   # {{{1
  local handler="$1" _eft_radio_args=() s; shift
  while (( $# > 0 )); do
    # choice <tag> <item>
    [ "$1" = choice ] || _eft_die CHOICE_NO_CHOICE_WTF          # TODO
    [ "$#" -ge 3 ] || _eft_die CHOICE_MISSING_WTF               # TODO
    if [ "$_eft_opt__selected" = "$2" ]; then s=on; else s=off; fi
    _eft_radio_args+=( "$2" "$3" "$s" )
    shift 3
  done
  "$handler"
}                                                               # }}}1

# --

# uses $_eft_opt__*; modifies $_eft_whip_opts
_eft_opts_process () {                                          # {{{1
  [ -z "$_eft_opt__title" ] || \
    _eft_whip_opts+=( --title "$_eft_opt__title" )
  [ -z "$_eft_opt__backtitle" ] || \
    _eft_whip_opts+=( --backtitle "$_eft_opt__backtitle" )
  [ "$_eft_opt__scroll" != true ] || \
    _eft_whip_opts+=( --scrolltext  )

  [ -z "$_eft_opt__ok_button" ] || \
    _eft_whip_opts+=( --ok-button "$_eft_opt__ok_button" )

  [ -z "$_eft_opt__cancel_button" ] || \
    _eft_whip_opts+=( --cancel-button "$_eft_opt__cancel_button" )
  [ "$_eft_opt__no_cancel" != true ] || \
    _eft_whip_opts+=( --nocancel  )

  [ -z "$_eft_opt__yes_button" ] || \
    _eft_whip_opts+=( --yes-button "$_eft_opt__yes_button" )

  [ -z "$_eft_opt__no_button" ] || \
    _eft_whip_opts+=( --no-button "$_eft_opt__no_button" )
  [ "$_eft_opt__default_no" != true ] || \
    _eft_whip_opts+=( --default-no  )

  [ -z "$_eft_opt__selected_" ] || \
    _eft_whip_opts+=( --default-item "$_eft_opt__selected_" )
}                                                               # }}}1

# --

# Usage: _eft_whip <handler> <what> <text> <subh> <arg(s)>
_eft_whip () {                                                  # {{{1
  local handler="$1" what="$2" text="$3" subh="$4" h w s z; shift 4
  local _eft_whip_exit _eft_whip_lines
  _eft_opts_process
  [ "$what" != "$_eft_check" ] || \
    _eft_whip_opts+=( "${_eft_check_opts[@]}" )
  h="${_eft_opt__height:-$(( $(_eft_lines) - 4 ))}"
  w="${_eft_opt__width:-$((  $(_eft_cols ) - 4 ))}"
  s="${_eft_opt__subheight:-$(( h          - 8 ))}"
  z=$( [ "$subh" != yes ] || echo "$s" )
  _eft_run_whip "${_eft_whip_opts[@]}" "$what" -- \
    "$text" "$h" "$w" $z "$@"
  case "$_eft_whip_exit" in
    $_eft_exit_ok_yes)    _eft_call "$handler" \
                            "${_eft_whip_lines[@]}"         ;;
    $_eft_exit_cancel_no) _eft_call "$_eft_opt__on_cancel"
                          _eft_call "$_eft_opt__on_no"      ;;
    $_eft_exit_esc)       _eft_call "$_eft_opt__on_esc"     ;;
    *)                    _eft_die EXIT_WTF                 ;;  # TODO
  esac
}                                                               # }}}1

# Usage: _eft_run_whip <arg(s)>
# modifies $_eft_whip_{exit,lines}
_eft_run_whip () {                                              # {{{1
  local tempdir="$( mktemp -d )" pid d e
  mkfifo -m 700 "$tempdir/fifo"
  "$_eft_whiptail" "$@" 2> "$tempdir/fifo" & pid=$!
  _eft_whip_lines=()
  d=n; while [ "$d" = n ]; do
    set +e; read -r; e=$?; set -e
    if [ $e != 0 ]; then d=y; [ -n "$REPLY" ] || break; fi
    _eft_whip_lines+=( "$REPLY" )
  done < "$tempdir/fifo"
  set +e; wait "$pid"; _eft_whip_exit=$?; set -e
  rm -fr "$tempdir"                                             # TODO
}                                                               # }}}1

# --

# Usage: _eft_file_or_temp <handler>
_eft_file_or_temp () {                                          # {{{1
  local handler="$1" file="$_eft_opt__file" text="$_eft_opt__text"
  [ -z "$file" -o -z "$text" ] || _eft_die BOTH_WTF             # TODO
  if [ -n "$file" ]; then
    "$handler" "$file"
  else
    local tempdir="$( mktemp -d )"
    printf %s "$text" > "$tempdir/eft"
    "$handler" "$tempdir/eft"
    rm -fr "$tempdir"                                           # TODO
  fi
}                                                               # }}}1

# Usage: _eft_lambda <code>
# modifies $_eft_lambda
_eft_lambda () {
  local f="_eft_lambda_$_eft_lambda"
  eval "function $f () { $1; }"
  (( _eft_lambda += 1 ))
  echo "$f"
}

# Usage: _eft_call { <cmd> | '' } <arg(s)>
_eft_call () { [ -z "$1" ] || "$@"; }

_eft_cols   () { TERM=${TERM:-dumb} tput cols ; }
_eft_lines  () { TERM=${TERM:-dumb} tput lines; }

_eft_die () { echo "$@" >&2; exit 1; }

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
