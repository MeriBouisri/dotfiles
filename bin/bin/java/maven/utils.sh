#!/bin/bash

file_exists() {
	if [ -f $1 ]; then
		exit 0
	fi
	exit 1
}

dir_exists() {
	if [ -d $1 ]; then
		exit 0
	fi
	exit 1
}

if declare -f "$1" > /dev/null
then
	"$@"
else
	echo "'$1' is not a known function name" >&2
	exit 1
fi

