#!/bin/zsh

set -eu

script_directory="${0:A:h}"
prefix="${PREFIX:-}"

if [[ -z "$prefix" ]]; then
  if [[ -d /opt/homebrew/bin ]]; then
    prefix="/opt/homebrew"
  else
    prefix="/usr/local"
  fi
fi

destination="$prefix/bin"

if [[ ! -d "$destination" ]]; then
  print -u2 "Destination does not exist: $destination"
  print -u2 "Create it first or set PREFIX to another location."
  exit 1
fi

if [[ ! -w "$destination" ]]; then
  print -u2 "Destination is not writable: $destination"
  print -u2 "Run this installer with suitable privileges or choose a writable PREFIX."
  exit 1
fi

/usr/bin/install -m 755 "$script_directory/bin/mi-ez-a-hatterkep" "$destination/mi-ez-a-hatterkep"
print "Installed: $destination/mi-ez-a-hatterkep"
