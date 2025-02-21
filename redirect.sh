#!/bin/bash

assert() {
  expected="$1"
  input="$2"

  t=$(mktemp) || exit
  trap "rm -f -- '$t'" EXIT
  curl -s -D $t $input >/dev/null
  actual="$(grep '^Location:' $t | cut -d ' ' -f 2 | tr -d '\r\n')"
  rm -f -- "$t"
  trap - EXIT

  if [ "$actual" = "$expected" ]; then
    echo "$input => $actual"
  else
    echo "$input => $expected expected, but got $actual"
    exit 1
  fi
}

assert http://localhost/item1/index.html localhost/product/item1/view
assert http://localhost/assert/failed localhost/product/item1/view

echo OK

