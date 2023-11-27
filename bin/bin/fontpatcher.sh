#!/bin/bash

is_file=0
is_dir=0

# fontforge path
FONTPATCHER_PATH="$HOME/bin/font-patcher/font-patcher"
fontpatcher_args=()

patch_file() {
  local input_path=$1
  
  if [ -d "$HOME/bin/font-patcher/" ]; then
   fontforge -script "$FONTPATCHER_PATH" "$input_path" ${fontpatcher_args[@]}
   return $?
  fi

  return 1
}

patch_source_path() {
  if [ $is_file -eq 1 ] && [ -f $source_path ]; then
    patch_file $source_path "${fontpatcher_args[@]}"

    if [ $? -eq 1 ]; then
      return 1
    fi

  elif [ $is_dir -eq 1 ] && [ -d $source_path ]; then
    for path in ${source_path}/*; do
      patch_file $path "${fontpatcher_args[@]}"

      if [ $? -eq 1 ]; then
	return 1
      fi
    done

  else
    patch_file "${fontpatcher_args[@]}"
  fi

  return 0
}


source_path=$1

while getopts ":f:d:-:" opt; do
  case "${opt}" in
    f)
      is_file=1
      source_path="$OPTARG"
      shift 
      shift
      ;;
    d)
      is_dir=1
      source_path="$OPTARG"
      shift
      shift
      ;;
  esac
done

if [ $is_file -eq 0 ] && [ $is_dir -eq 0 ]; then
  if [ -f $source_path ]; then
    is_file=1
    shift
  elif [ -d $source_path ]; then
    is_dir=1
    shift
  fi
  
fi

while [[ $# -gt 0 ]]; do

  fontpatcher_args+=("$1 $2")
  shift
  shift
done

patch_source_path

exit $?
  

