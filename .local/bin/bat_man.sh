#!/bin/sh
col -bx < "$1" | bat --language man --style plain
