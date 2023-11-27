#!/bin/bash

# AntShell is a group of functions and scripts allowing better interaction with the Ant build tool
script_dir="$(dirname $0)/scripts"
project_name=$2

_run_script() {
	local script_name=$1
	local script="$script_dir/$script_name"

	$script $project_name $extra_arg
	
	exit $?
}

# Initialize build.xml in existing project
init() {
	_run_script "init.sh" $project_name
}

# Create java project with build.xml
create() {
	_run_script "create.sh" $project_name
}

# Run java program
run() {
	_run_script "run.sh" $project_name
}

# Update build.xml of a project if template changes
update() {
	_run_script "update.sh" $project_name
}

# Find entry point of project and add to build.xml
entry() {
	_run_script "entry.sh" $project_name 
}

if declare -f "$1" > /dev/null
then
	[[ "$1" = _* ]] && exit 1
	"$@"
else
	echo "'$1' is not a known function name" >&2
	exit 1
fi

