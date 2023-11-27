#!/bin/bash

log_prefix="[create_project]"
antshell="$JAVA_WORKSPACE/.sim/ant/antshell/antshell.sh"
sim_dir="$JAVA_WORKSPACE/.sim"
eclipse_template_path="$sim_dir/ant/templates/eclipse"

if [ ! -d $sim_dir ]; then
	echo "[ERROR] Failed to load .sim directory in workspace : $JAVA_WORKSPACE"
	exit 1
fi

project_name=$1
project_path=$JAVA_WORKSPACE/$project_name

if [ -z $project_name ]; then
	project_path=$(pwd)
fi

if [ ! -d $project_path ]; then
	cp -r $eclipse_template_path $project_path

	if [ $? -eq 1 ]; then
		echo "[ERROR] Failed to copy project template to new project" >&2
		exit 1
	fi

	xmlproject_name=".project"

	xmlstarlet ed -L -u "/projectDescription/name" -v "$project_name" "$project_path/$xmlproject_name"
fi

$antshell init $project_name

exit 0

 
xmlbuild_name="build.xml"
xmlbuild_template="$sim_dir/ant/templates/build.xml"
xmlbuild_path="$project_path/$xmlbuild_name"

cp $xmlbuild_template $xmlbuild_path

if [ $? -eq 1 ]; then
	echo "[ERROR] Error while copying build.xml template" >&2
	exit 1
fi

xmlstarlet ed -L -u "/project/@name" -v "$project_name" "$xmlbuild_path"

if [ $? -eq 1 ]; then
	echo "[ERROR] Error while updating build.xml file" >&2
	exit 1
fi

echo "Successfully created project : $project_path"
exit 0




