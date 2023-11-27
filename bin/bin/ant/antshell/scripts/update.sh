#!/bin/bash

workspace=$JAVA_WORKSPACE
utils="$workspace/.sim/ant/antshell/scripts/utils.sh"

project_name=$1
project_path=$JAVA_WORKSPACE/$project_name

if [ -z $project_name ]; then
	project_path=$(pwd)
fi

xmlbuild_name="build.xml"
xmlbuild=""

find_root() {
	local current_dir=$(pwd)
	local root_dir=""

	# check if the cwd is a project (one level away from workspace)
	if [[ $(dirname $current_dir) == $workspace ]]; then
		root_dir=$current_dir	
	else
		# Check if project inside workspace
		if [[ $current_dir == *"$workspace"* ]]; then
			while [[ $current_dir != $workspace ]]
			do
				if [ -f "$current_dir/$xmlbuild_name" ]; then
					root_dir=$current_dir
					break
				fi
				current_dir=$(dirname $current_dir)
			done
		fi
	fi
	echo $root_dir
}

copy_xmlbuild() {
	local source_xmlbuild=$1
	local target_xmlbuild=$2
	local query=$3

	copy_prop=$($utils get_xml_property_attribute "entry" "location" $source_xmlbuild)

	if [ $? -eq 1 ]; then
		return 0
	fi

	if [ -z $copy_prop ]; then
		return 0
	fi

	$utils set_xml_property_attribute "entry" "location" $copy_prop $target_xmlbuild

	return $?
}

generate_xmlbuild() {
	local project_name=$1
	local project_path=$JAVA_WORKSPACE/$project_name
	local xmlbuild_template="$JAVA_WORKSPACE/.sim/ant/templates/build.xml"
	cp $xmlbuild_template "$project_path/"

	if [ $? -eq 1 ]; then
		echo "[ERROR] Failed to generate template build.xml file" >&2
		exit 1
	fi

	xmlstarlet ed -L -u "/project/@name" -v "$project_name" $project_path/$xmlbuild_name

}

if [ -z $project_name ]; then
	project_path=$(find_root)

	if [ -z $project_path ]; then
		echo "[ERROR] Failed to find project root" >&2
		exit 1
	fi

	project_name=$(basename "$project_path")
fi

xmlbuild_path="$project_path/$xmlbuild_name"

if [ -f $xmlbuild_path ]; then
	temp_xmlbuild_path="$(dirname $xmlbuild_path)/temp-build.xml"
	mv $xmlbuild_path $temp_xmlbuild_path
fi

generate_xmlbuild $project_name

if [ -f $temp_xmlbuild_path ]; then
	entry_property="entry"
	copy_xmlbuild $temp_xmlbuild_path $xmlbuild_path 
	rm $temp_xmlbuild_path

	if [ $? -eq 1 ]; then
		echo "[ERROR] Failed to remove temp-build.xml" >&2
		exit 1
	fi
fi

echo "Successfully generated build.xml file"
exit 0










