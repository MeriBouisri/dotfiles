#!/bin/bash

log_prefix="[antshell/entry.sh]"

workspace=$JAVA_WORKSPACE
utils="$workspace/.sim/ant/antshell/scripts/utils.sh"

project_name=$1
project_path="$workspace/$project_name"
mainclass=$2
echo $@
main_func_str="public static void main(java.lang.String[])"

if [ -z $project_name ]; then
	project_path="$(pwd)"
fi

if [ ! -d $project_path ]; then
	echo "$log_prefix Java project doesn't exist in workspace : $project_path" >&2
	exit 1
fi

xmlbuild_name="build.xml"
xmlbuild_path="$project_path/$xmlbuild_name"

if [ ! -f $xmlbuild_path ]; then
	echo "$log_prefix [ERROR] Build.xml file not found." >&2
	echo "$log_prefix [ERROR] Try running the ant init target or antshell init command." >&2
	exit 1
fi

srcdir_property="src.dir"
destdir_property="build.dir"
entry_property="jar.main.class"

destdir="$($utils get_xml_property_attribute $destdir_property "value" $xmlbuild_path)/"
destdir_path="$project_path/$destdir"

if [ -z $mainclass ]; then
	echo "$log_prefix Parsing project for main class ..."
	class_files=($(find $destdir_path -type f -name "*.class"))
	for file in "${class_files[@]}"
	do
		class_contents=$(javap $file)
		if [[ $class_contents == *"$main_func_str"* ]]; then
			mainclass=$file
			break
		fi
	done

	if [ -z $mainclass ]; then
		echo "$log_prefix [ERROR] No main class found : $project_path" >&2
		exit 1
	fi

	echo "$log_prefix Successfully detected main class : $mainclass"

	# trying to get correct format
	# /path/to/output/package/mainclass.class -> package.mainclass
	mainclass=${mainclass##$destdir_path}
	mainclass=${mainclass%.*}
	mainclass=${mainclass#"$destdir"}
	mainclass=${mainclass##"bin/"}
	echo "$log_prefix Successfully detected main class : $mainclass"
fi

#echo "$log_prefix Checking validity ..."
#$utils check_valid_java_main $mainclass "$destdir_path/" 

#if [ $? -eq 1 ]; then
#	echo "$log_prefix [ERROR] Invalid main class ($mainclass) for project : $project_path" >&2
#	exit 1
#fi

$utils set_xml_property_attribute $entry_property "value" $mainclass $xmlbuild_path
if [ $? -eq 1 ]; then
	echo "$log_prefix [ERROR] Failed to modify property '$entry_property' to '$mainclass' in $xmlbuild_path" >&2
	exit 1
fi

echo "$log_prefix Successfully updated project's entry point : $mainclass"
exit 0


