#!/bin/bash

log_prefix="[init.sh]"

workspace=$JAVA_WORKSPACE
project_name=$1
sim_dir="$workspace/.sim"
project_path="$workspace/$project_name"

xmlproject_name=".project"
xmlproject_path="$project_path/$xmlproject_name"

if [ -z $project_name ]; then
	project_path="$(pwd)"
	project_name=$(basename $project_path)
fi

if [ ! -d $project_path ]; then
	echo "$log_prefix [ERROR] Project doesnt exist : $project_path" >&2
fi

xmlbuild_name="build.xml"
xmlbuild_template="$sim_dir/ant/templates/$xmlbuild_name"
xmlbuild_path="$project_path/$xmlbuild_name"

if [ -f "$xmlbuild_path" ]; then
	echo "$log_prefix build.xml already exists : $xmlbuild_path"

	while true; do
		echo "$log_prefix Overwrite existing build.xml file? (y/n) "
		read yn

		case $yn in
			[Yy]* ) 
				break
				;;

			[Nn]* ) 
				exit 1
				;;

		esac
	done
	echo "$log_prefix Deleting old build.xml ..."
	rm $xmlbuild_path	

	if [ $? -eq 1 ]; then
		echo "$log_prefix [ERROR] Failed to delete : $xmlbuild_path" >&2
		echo "$log_prefix [ERROR] Please delete manually and try again" >&2
		exit 1
	fi

	echo "$log_prefix Successfully deleted : $xmlbuild_path"
fi

cp $xmlbuild_template $xmlbuild_path


if [ $? -eq 1 ]; then
	echo "$log_prefix [ERROR] Failed to copy build.xml template to new location" >&2
	exit 1
fi

xmlstarlet ed -L -u "/project/@name" -v "$project_name" "$xmlbuild_path"

if [ -f $xmlproject_path ]; then
	xmlstarlet ed -L -u "/projectDescription/name" -v "$project_name" "$xmlproject_path"
fi


if [ $? -eq 1 ]; then
	echo "$log_prefix Error while updating build.xml file" >&2
	exit 1
fi

echo "$log_prefix Successfully initialized build.xml : $xmlbuild_path"
exit 0











