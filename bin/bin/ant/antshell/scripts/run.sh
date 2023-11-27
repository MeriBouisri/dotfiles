#!/bin/bash

workspace=$JAVA_WORKSPACE
utils="$workspace/.sim/ant/antshell/scripts/utils.sh"
antshell="$workspace/.sim/ant/antshell/antshell.sh"
project_name=$1

project_path="$JAVA_WORKSPACE/$project_name"

if [ -z $project_name ]; then
	project_path="$(pwd)"
fi

if [ ! -d $project_path ]; then
	echo "[ERROR] Java project doesn't exist in workspace : $project_path"
	exit 1
fi

xmlbuild_name="build.xml"
xmlbuild_path="$project_path/$xmlbuild_name"
if [ ! -f $xmlbuild_path ]; then
	echo "[ERROR] Build.xml file not found. Run the ant init command."
	exit 1
fi

srcdir_property="src"
destdir_property="output"
entry_property="entry"

destdir="$($utils get_xml_property_attribute $destdir_property "location" $xmlbuild_path)/"

for i in 0 1
do
	entry="$($utils get_xml_property_attribute $entry_property "value" $xmlbuild_path)"
	
	if [ ! -z $entry ]; then
		break
	fi
	
	if [ $i -eq 0 ]; then
		echo "$log_prefix [ERROR] Project's entry point not configured in build.xml" >&2
		echo "$log_prefix Configuring entry point ..."
		
		$antshell entry $(basename $project_path)

	else
		echo "$log_prefix [ERROR] No entry point has been set. Please run 'antshell entry <projectname>' or manually set entry point in build.xml" >&2
		exit 1
	fi
done


cd $destdir
java $entry
