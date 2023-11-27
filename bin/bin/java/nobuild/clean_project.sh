#!/bin/bash

log_prefix="[java/nobuild/clean_project.sh]"

java_workspace=$JAVA_WORKSPACE
project_name=$1
project_path="$java_workspace/$project_name"

if [ -z $project_name ]; then
	project_path=$(pwd)
fi

output_path="$project_path/bin"

if [ ! -d $project_path ]; then
	echo "$log_prefix [ERROR] Project_doesn't exit : $project_path" >&2
	exit 1
fi

if [ ! -d $output_path ]; then
	echo "$log_prefix [ERROR] Output folder doesn't exist : $output_path" >&2
	exit 1
fi

echo "$log_prefix Cleaning output path : $output_path ..."
rm -r $output_path

if [ $? -eq 0 ]; then
	mkdir $output_path
	if [ $? -eq 0 ]; then
		echo "$log_prefix Successfully cleaned output path."
		exit 0
	fi
fi

echo "$log_prefix [ERROR] Failed to clean output path." >&2
exit 1
