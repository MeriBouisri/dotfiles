#!/bin/bash

log_prefix="[$0]"
java_workspace=$JAVA_WORKSPACE

project_name=$1
project_path="$java_workspace/$project_name"

if [ -z $project_name ]; then
	project_path=$(pwd)
fi

classpath_name='bin/'
classpath_path="$project_path/$classpath_name"

if [ ! -d $project_path ]; then
	echo "$log_prefix [ERROR] Java project not found : $project_path" >&2
	exit 1
fi

entry_point_script=$HOME/bin/java/nobuild/entry_project.sh
entry_point=$($entry_point_script $project_name)

cd $project_path
java -cp $classpath_name $entry_point
exit 0
