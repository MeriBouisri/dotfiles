#!/bin/bash

jrunner_path=$HOME/bin/java

project_name=$2
buildtype="nobuild"

#while getopts "p:" opt; do
#	case "${opt}" in
#		p)
#			project_name="$OPTARG"
#			;;
#	esac
#done

init() {
	local script="$jrunner_path/$buildtype/init_project.sh"
	$script $project_name

	exit $?
}

compile() {
	local script="$jrunner_path/$buildtype/compile_project.sh"
	$script $project_name

	exit $?
}

run() {
	local script="$jrunner_path/$buildtype/run_project.sh"
	$script $project_name

	exit $?
}

entry() {
	local script="$jrunner_path/$buildtype/entry_project.sh"
	$script $project_name

	exit $?
}

create() {
	local script="$jrunner_path/$buildtype/create_project.sh"
	$script $project_name

	exit $?
}

clean() {
	local script="$jrunner_path/$buildtype/clean_project.sh"
	$script $project_name

	exit $?
}

update() {
	local script="$jrunner_path/$buildtype/update_project.sh"
	$script $project_name

	exit $?
}

if declare -f "$1" > /dev/null
then
	"$@"
else
	echo "'$1' is not a known function name" >&2
	exit 1
fi







