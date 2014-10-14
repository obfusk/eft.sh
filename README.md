[]: {{{1

    File        : README.md
    Maintainer  : Felix C. Stegerman <flx@obfusk.net>
    Date        : 2014-10-14

    Copyright   : Copyright (C) 2014  Felix C. Stegerman
    Version     : v0.1.0

[]: }}}1

[![GitHub Version](https://badge.fury.io/gh/obfusk%2Feft.sh.svg)](https://github.com/obfusk/eft.sh)

## Description
[]: {{{1

  eft.sh - bash + whiptail

  Eft.sh is a bash dsl that wraps `whiptail` [1] to display dialog
  boxes; see `example.bash` for examples.

```bash
say_hi () { echo "Hello, $1!"; }
eft_ask 'What is your name?' on_ok=say_hi
```

  See also eft for ruby [2].

[]: }}}1

## TODO

  * make cleanup error-resistant
  * nicer errors

## License

  LGPLv3+ [3].

## References

  [1] Newt (and whiptail)
  --- http://en.wikipedia.org/wiki/Newt_(programming_library)

  [2] eft - ruby + whiptail
  --- https://github.com/obfusk/eft

  [3] GNU Lesser General Public License, version 3
  --- http://www.gnu.org/licenses/lgpl-3.0.html

[]: ! ( vim: set tw=70 sw=2 sts=2 et fdm=marker : )
