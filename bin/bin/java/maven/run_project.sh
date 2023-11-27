#!/bin/bash

project_name=$1
entry_point=$2

java_workspace=$JAVA_WORKSPACE
maven_classpath="target/classes"
project_path="$java_workspace/$project_name"

exit_code=$?

if [ $exit_code -eq 1 ]; then
	exit 1
fi

entry_point=$( $HOME/bin/java/find_entry_point.sh $project_name)

if [ -d $project_path ]; then
	cd $project_path
	mvn compile
	java -cp $maven_classpath $entry_point 
	exit 0
else
	echo "[ERROR] project doesnt exit"
	exit 1
fi


