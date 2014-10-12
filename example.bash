source ./eft.bash

do_cancel () { echo 'Not interested.'; }
do_esc    () { echo 'Escaped!'; }

do_foo_welcome () {
  local foo_secret="$1"
  eft_show_msg "Welcome $foo_name, your secret is $foo_secret"
}
do_foo_ask () {
  local foo_name="$1"
  eft_ask_pass 'Secret?' ok_button='Go!' on_ok=do_foo_welcome
}
do_foo () {
  eft_ask 'What is your name?' ok_button=Next default=Anonymous \
    on_ok=do_foo_ask
}

do_bar_yes  () { echo 'Nice!'; }
do_bar_no   () { echo 'Too bad!'; }
do_bar () {
  eft_ask_yesno 'Is everything going well?' on_yes=do_bar_yes \
    on_no=do_bar_no
}

do_baz_start () {
  local baz_mv="$1" i
  for (( i=0; i < 100; ++i )); do
    if (( i % 5 == 0 )); then
      "$baz_mv" "$i" "We're at #$i ..."
    else
      "$baz_mv" "$i"
    fi
    sleep 0.05
  done
}
do_baz () {
  eft_gauge '...' 0 title=Progress on_start=do_baz_start
}

do_qux  () { eft_show_info 'Hi!'; }
do_quux () { eft.show_text file=/etc/services scroll=true; }

do_quuux_ok () {
  local choices=( "$@" ) multi_choices='' n="$#" i j
  for (( i=0; i < n * 10; ++i )); do
    j=$(( i % n )); multi_choices+="${choices[$j]}"$'\n'
  done
  eft_show_text text_var=multi_choices title='Multiplied!'
}
do_quuux () {
  eft_check 'Which ones?' on_ok=do_quuux_ok \
    choice 1 One      \
    choice 2 Two true \
    choice 3 Three
}

do_almost_ok () { echo "You chose: ${1:-'none!?'}"; }
do_almost () {
  eft_radio 'One or none' on_ok=do_almost_ok \
    choice 1 One \
    choice 2 Two
}

do_last_ok () { echo "You chose: $1"; }
do_last () {
  eft_radio 'Which one?' selected=2 on_ok=do_last_ok \
    choice 1 One    \
    choice 2 Two    \
    choice 3 Three
}

eft_menu Choices: selected=bar title=Menu backtitle='Choose!' \
  on_cancel=do_cancel on_esc=do_esc                           \
  item foo              'Do The Foo'          do_foo          \
  item bar              'Do Bar!'             do_bar          \
  item baz              'Baz!?'               do_baz          \
  item qux              'Quixotic?'           do_qux          \
  item quux             'Quixotic!'           do_quux         \
  item quuux            "There's more ..."    do_quuux        \
  item 'almost there'   'Just one more'       do_almost       \
  item 'last one'       'Really! I promise.'  do_last
