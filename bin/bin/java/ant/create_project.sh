#!/bin/bash

log_prefix="[create_project]"

sim_dir="$JAVA_WORKSPACE/.sim"

if [ ! -d $sim_dir ]; then
	echo "[ERROR] Failed to load .sim directory in workspace : $JAVA_WORKSPACE"
	exit 1
fi

project_name=$1
project_path=$JAVA_WORKSPACE/$project_name

mkdir $project_path

if [ $? -eq 0 ]; then
	cp -r $eclipse_template_path $project_path

	if [ $? -eq 1 ]; then
		echo "[ERROR] Failed to copy project template to new project" >&2
		exit 1
	fi

	xmlproject_name=".project"

	xmlstarlet ed -L -u 
		\ "/projectDescription/name" 
		\ -v "$project_name"
		\ "$project_path/$xmlproject_name"
fi

 
xmlbuild_name="build.xml"
xmlbuild_path="$project_path/$xmlbuild_name"

xmlstarlet ed -L -u 
	\ "/project/@name" 
	\ -v "$project_name" 
	\ "$xmlbuild_path"

exit 0




